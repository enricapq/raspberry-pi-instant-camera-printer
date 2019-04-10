# start at system boot: sudo nano /etc/rc.local
# before exit 0:
# sudo -H -u pi sh /home/pi/raspberry-pi-instant-camera-printer/camera.sh

#!/bin/bash

# photos path dir
PHOTOS_DIR=/home/pi/raspberry-pi-instant-camera-printer/photos

# Assign GPIO pins
# Shutter: press to take a photo
SHUTTER=16
# Halt: press to turn off the Raspberry Pi
HALT=21
# LED_SHUTTER Blink when pressed
LED_SHUTTER=27
# LED_16 for photo taken
LED_HALT=5

# Initialize buttons GPIO states up (1) -> not pressed
gpio -g mode  $SHUTTER up
gpio -g mode  $HALT    up

# Initialize led GPIO states out -> led off, in -> led on
gpio -g mode  $LED_SHUTTER  out
gpio -g mode  $LED_HALT     in


# Flash LED_SHUTTER 20 times on startup to indicate ready state
for i in `seq 1 20`;
do
	gpio -g write $LED_SHUTTER 1
	sleep 0.2
	gpio -g write $LED_SHUTTER 0
	sleep 0.2
done   

# Keep monitoring the buttons
while :
do
        # keep the led on, not blinking, until the shutter is pressed
        gpio -g write $LED_SHUTTER 1
	# check when shutter button is pressed (0, not pressed 1)
	if [ $(gpio -g read $SHUTTER) -eq 0 ]; then
		ID_PHOTO=$PHOTOS_DIR/photo_$(date +%s).jpg
		# -co contrast -br brightness -ex exposure -sh sharpness 
		# -sa saturation -awb white balance -drc dark for low light
		# -n no preview -t time to shuts down
		raspistill -co 20 -br 60 -ex auto -sh 20 -sa 10 \
                           -awb auto -drc low -q 100 -n -t 100 \
                           -w 512 -h 384 -o - > $ID_PHOTO
		lp -d thermalprinter $ID_PHOTO >> /dev/null
		for i in `seq 1 15`;
                do
                        gpio -g write $LED_SHUTTER 1
                        sleep 0.5
                        gpio -g write $LED_SHUTTER 0
                        sleep 0.5
                done  
		# Wait for user to release button before resuming
		while [ $(gpio -g read $SHUTTER) -eq 0 ]; do continue; done
	fi

	# Check for halt button
	if [ $(gpio -g read $HALT) -eq 0 ]; then
                for i in `seq 1 6`; 
                do
                        gpio -g write $LED_SHUTTER 1
                        sleep 0.1
                        gpio -g write $LED_SHUTTER 0
                        sleep 0.1
                done 
		# Must be held for 2+ seconds before shutdown
		starttime=$(date +%s)
		while [ $(gpio -g read $HALT) -eq 0 ]; do
                        gpio -g write $LED_SHUTTER 0
			if [ $(($(date +%s)-starttime)) -ge 2 ]; then
				gpio -g write $LED_SHUTTER 0
				for i in `seq 1 6`; 
                                do
                                        gpio -g write $LED_HALT 1
                                        sleep 0.1
                                        gpio -g write $LED_HALT 0
                                        sleep 0.1
                                done
                                gpio -g mode  $LED_HALT out
                                sudo shutdown -h now
			fi
		done
	fi
done