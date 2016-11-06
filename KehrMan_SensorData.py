#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
HOST1 = "192.168.100.54"
HOST_S = "192.168.100.48"
PORT = 4223
PORT_S = 4242
UID = "62CHqu" # Change XXYYZZ to the UID of your Master Brick
UIDa = "v8q"
UIDd = "w3t"

import socket
import sys
from tinkerforge.ip_connection import IPConnection
from tinkerforge.brick_master import BrickMaster
from tinkerforge.bricklet_accelerometer import BrickletAccelerometer
from tinkerforge.bricklet_distance_ir import BrickletDistanceIR

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (HOST_S, PORT_S)
print >>sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)

if __name__ == "__main__":
    
    ipcon = IPConnection() # Create IP connection
    master = BrickMaster(UID, ipcon) # Create device object
    a = BrickletAccelerometer(UIDa, ipcon)
    dir = BrickletDistanceIR(UIDd, ipcon)
    
    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected
    
    # Display master status and LED blink    
    master.enable_status_led()
    print(master.get_identity())
    
    # Get current stack voltage (unit is mV)
    stack_voltage = master.get_stack_voltage()
    print("Stack Voltage: " + str(stack_voltage/1000.0) + " V")

    # Get current stack current (unit is mA)
    stack_current = master.get_stack_current()
    print("Stack Current: " + str(stack_current/1000.0) + " A")
    
    # get wifi status    
    iswifi = master.is_wifi2_present()
    print ("wifi:" + str(iswifi))
    
    # Get current acceleration (unit is g/1000)
    x, y, z = a.get_acceleration()
    print("Acceleration[X]: " + str(x/1000.0) + " g")
    print("Acceleration[Y]: " + str(y/1000.0) + " g")
    print("Acceleration[Z]: " + str(z/1000.0) + " g")
    
    # Get current distance (unit is mm)
    distance = dir.get_distance()
    print("Distance: " + str(distance/10.0) + " cm")
    
    try:
    
        # Send data
        message = 'This is the message.  It will be repeated.'
        print >>sys.stderr, 'sending "%s"' % message
        sock.sendall(message)
    
        # Look for the response
        amount_received = 0
        amount_expected = len(message)
        
        while amount_received < amount_expected:
            data = sock.recv(16)
            amount_received += len(data)
            print >>sys.stderr, 'received "%s"' % data
            
    finally:
        print >>sys.stderr, 'closing socket'
        sock.close()
    
    raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
