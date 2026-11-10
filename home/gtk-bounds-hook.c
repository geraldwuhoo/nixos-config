#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <wayland-client.h>

/* xdg_toplevel events in wayland-protocols 1.48, in order:
   configure, close, configure_bounds, wm_capabilities.
   GTK4 keeps the first configure_bounds as a hard maximum. KWin sends
   that event only for the monitor where the window was mapped, so a
   window opened on a landscape output cannot grow onto the portrait
   one. Raise the ceiling above any single output. */
enum { BOUNDS_FLOOR = 16384 };

struct toplevel_listener {
    void (*configure)(void *, void *, int32_t, int32_t, struct wl_array *);
    void (*close)(void *, void *);
    void (*configure_bounds)(void *, void *, int32_t, int32_t);
    void (*wm_capabilities)(void *, void *, struct wl_array *);
};

/* GTK4 has one static listener for every toplevel. */
static void (**gtk_impl)(void);
static struct toplevel_listener hooked;
static void (*real_bounds)(void *, void *, int32_t, int32_t);

static void bounds_hook(void *data, void *toplevel, int32_t width, int32_t height)
{
    int32_t nw = width < BOUNDS_FLOOR ? BOUNDS_FLOOR : width;
    int32_t nh = height < BOUNDS_FLOOR ? BOUNDS_FLOOR : height;
    real_bounds(data, toplevel, nw, nh);
}

/* Loaded into every app, so leave listeners from other toolkits alone. */
static int from_gtk4(void (**implementation)(void))
{
    Dl_info info;
    return dladdr((void *)implementation, &info) && info.dli_fname &&
           strstr(info.dli_fname, "/libgtk-4.so");
}

int wl_proxy_add_listener(struct wl_proxy *proxy, void (**implementation)(void), void *data)
{
    static int (*real_add)(struct wl_proxy *, void (**)(void), void *) = NULL;
    if (!real_add)
        real_add = dlsym(RTLD_NEXT, "wl_proxy_add_listener");

    const char *cls = wl_proxy_get_class(proxy);
    if (!cls || strcmp(cls, "xdg_toplevel") != 0)
        return real_add(proxy, implementation, data);

    if (!gtk_impl && from_gtk4(implementation)) {
        memcpy(&hooked, implementation, sizeof hooked);
        real_bounds = hooked.configure_bounds;
        hooked.configure_bounds = bounds_hook;
        gtk_impl = implementation;
    }
    if (implementation == gtk_impl)
        return real_add(proxy, (void (**)(void))&hooked, data);
    return real_add(proxy, implementation, data);
}
