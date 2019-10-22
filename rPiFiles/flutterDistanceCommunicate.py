'''
This is a python script which is run on a Raspberry pi (model 3B was used here), with a HC-05 distnce sensor attached.
Communication is done via websockets between the flutter application(client) and the RPi(server), so make sure you change
HOST to your particular IP address, and ensure both the Pi and the flutter mobile app are connected to the same network.
'''

#Libraries
import RPi.GPIO as GPIO
import time, socket
 
#GPIO Mode (BOARD / BCM)
GPIO.setmode(GPIO.BCM)
 
#set GPIO Pins
GPIO_TRIGGER = 18
GPIO_ECHO = 24
 
#set GPIO direction (IN / OUT)
GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)


def clientDataTransfer(sendData):
    HOST = '10.0.1.136'  # Standard loopback interface address (localhost)
    PORT = 65432     # Port to listen on (non-privileged ports are > 1023)

    dataFromClient = ""

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) # this will allow you to immediately restart a TCP server, even if it's already in use. We only give the server this priviledge
        s.bind((HOST, PORT))
        s.listen()
        conn, addr = s.accept()
        with conn:
            print('Connected by', addr)
            while True:
                conn.sendall(sendData)
                break
        s.close()
    return dataFromClient


def distance():
    # set Trigger to HIGH
    GPIO.output(GPIO_TRIGGER, True)
 
    # set Trigger after 0.01ms to LOW
    time.sleep(0.00001)
    GPIO.output(GPIO_TRIGGER, False)
 
    StartTime = time.time()
    StopTime = time.time()
 
    # save StartTime
    while GPIO.input(GPIO_ECHO) == 0:
        StartTime = time.time()
 
    # save time of arrival
    while GPIO.input(GPIO_ECHO) == 1:
        StopTime = time.time()
 
    # time difference between start and arrival
    TimeElapsed = StopTime - StartTime
    # multiply with the sonic speed (34300 cm/s)
    # and divide by 2, because there and back
    distance = (TimeElapsed * 34300) / 2
 
    return distance
 
if __name__ == '__main__':
    try:
        while True:
            dist = distance()
            clientDataTransfer(bytes(f'{dist}', 'utf-8'))
            print ("Measured Distance = %.1f cm" % dist)
            time.sleep(1)
 
        # Reset by pressing CTRL + C
    except KeyboardInterrupt:
        print("Measurement stopped by User")
        GPIO.cleanup()