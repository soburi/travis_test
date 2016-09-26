#!/usr/bin/env bats


setup() {
	ADIR=~/arduino-1.6.12
}

teardown() {
	echo "teardown"
}


compile_example() {
		${ADIR}/arduino-builder	-hardware ${ADIR}/hardware/ \
								-tools ${ADIR}/tools-builder/ \
								-libraries ${ADIR}/libraries/ \
								-tools ${ADIR}/hardware/tools/avr \
								-fqbn arduino:avr:uno \
								${ADIR}/$1
}


@test "Compile examples/01.Basics/AnalogReadSerial/AnalogReadSerial.ino." {
    compile_example examples/01.Basics/AnalogReadSerial/AnalogReadSerial.ino
}

