#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST1 = "localhost"
HOST= "192.168.100.54"
HOST_S = "192.168.100.48"
PORT = 4223
PORT_S = 4242
UID = "62CHqu" # Change XXYYZZ to the UID of your Master Brick
UIDa = "v8q"
UIDd = "w3t"
UIDu = "zmF"

import socket
import sys
import time
from tinkerforge.ip_connection import IPConnection
from tinkerforge.brick_master import BrickMaster
from tinkerforge.bricklet_accelerometer import BrickletAccelerometer
from tinkerforge.bricklet_distance_ir import BrickletDistanceIR
from tinkerforge.bricklet_distance_us import BrickletDistanceUS

def interpDist(val):
    x0 = 91.0
    y0 = 50.0
    x1 = 2300.0
    y1 = 2200.0
    dist = (val - x0)*((y1-y0)/(x1-x0))
    return dist
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (HOST_S, PORT_S)
print >>sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)

if __name__ == "__main__":
    
    ipcon = IPConnection() # Create IP connection
    master = BrickMaster(UID, ipcon) # Create device object
    a = BrickletAccelerometer(UIDa, ipcon)
    #dir = BrickletDistanceIR(UIDd, ipcon)
    dir = BrickletDistanceUS(UIDu, ipcon)
    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected
    
    # Display master status and LED blink    
    master.enable_status_led()
    print(master.get_identity())
    cc = 0
    # Get current stack voltage (unit is mV)
    try:
        
        while True:
            cc = cc + 1
            stack_voltage = master.get_stack_voltage()
            #print("Stack Voltage: " + str(stack_voltage/1000.0) + " V")
        
            # Get current stack current (unit is mA)
            stack_current = master.get_stack_current()
            #print("Stack Current: " + str(stack_current/1000.0) + " A")
            
            # get wifi status    
            iswifi = master.is_wifi2_present()
            #print ("wifi:" + str(iswifi))
            
            # Get current acceleration (unit is g/1000)
            x, y, z = a.get_acceleration()
            #print("Acceleration[X]: " + str(x/1000.0) + " g")
            #print("Acceleration[Y]: " + str(y/1000.0) + " g")
            #print("Acceleration[Z]: " + str(z/1000.0) + " g")
            
            # Get current distance (unit is mm)
            raw_distance = dir.get_distance_value() #dir.get_distance()
            distmm = interpDist(raw_distance)
            
            
            #print("Distance: " + str(distance/10.0) + " cm")
            #attn_msg = ""
            #if (distmm < 1000):
                #print ("Achtung" + str(distmm) + " mm")
                #attn_msg = "Achtung" + str(distmm) + " mm"
            message = str(x/1000.0) + ";" + str(y/1000.0) +";" + str(z/1000.0) + ";" + str(distmm)
            print >>sys.stderr, 'sending "%s"' % message
            sock.sendall(message)
            data = sock.recv(2048)
            while data != "FAMOS":
                print "waiting for ack"
            print >>sys.stderr, 'received "%s"' % data
#            try:
#            
#                # Send data
#                message = str(x/1000.0) + ";" + str(y/1000.0) +";" + str(z/1000.0) + ";" + str(distmm)
#                print >>sys.stderr, 'sending "%s"' % message
#                sock.sendall(message)
#            
#                # Look for the response
#                amount_received = 0
#                amount_expected = len(message)
#                
#                while amount_received < amount_expected:
#                    data = sock.recv(16)
#                    amount_received += len(data)
#                    print >>sys.stderr, 'received "%s"' % data
#                    
#            finally:
#                print >>sys.stderr, 'closing socket'
#                sock.close()
            time.sleep(1)
    except socket.error as msg:
        sock.close()
        print msg
        
        #raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
