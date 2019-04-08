import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
    
    input_state = GPIO.input(16)
    print(input_state)
    if input_state == False:
        print('Button pressed')
        time.sleep(0.2)