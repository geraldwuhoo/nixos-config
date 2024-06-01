flashortho() {
	echo -e "\nPUT KEYBOARD INTO BOOTLOADER MODE NOW!\n"
	if [ -z $1 ];
	then
		i=3
	else
		i=$1
	fi
	while [ $i -gt 0 ]; do
		echo -n "$i..."
		sleep 1
		let i=i-1
	done
	avrdude -p atmega32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:orthodox_rev3_jerry.hex
}
flashsplit() {
	sudo sleep 0
	echo -e "\nPUT KEYBOARD INTO BOOTLOADER MODE NOW!\n"

	i=3
	while [ $i -gt 0 ]; do
		echo -n "$i..."
		sleep 1
		let i=i-1
	done
	sudo avrdude -p atmega32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:lets_split_rev2_jerry.hex
}
alias flashgherkin="sudo avrdude -p atmega32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:gherkin.hex;"
alias flashplanck="sudo dfu-programmer atmega32u4 erase;sudo dfu-programmer atmega32u4 flash .build/planck_rev5_jerry.hex"
settrackball() {
	if [ -z $1 ];
	then
		speed=0.50000
	else
		speed=$1
	fi
	xinput --set-prop "Primax Kensington Eagle Trackball" "Coordinate Transformation Matrix" $speed, 0.000000, 0.000000, 0.000000, $speed, 0.000000, 0.000000, 0.000000, $speed
	xinput --set-prop "Primax Kensington Eagle Trackball" "libinput Accel Speed" -0.75
}
