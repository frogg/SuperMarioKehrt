![SuperMarioKehrt Banner](https://raw.githubusercontent.com/frogg/SuperMarioKehrt/master/SuperMarioKehrt.png)

# SuperMarioKehrt
Kärcher SpriteKit Game for iPad, Hackathon Stuttgart 2016

# Technologies
- Kärcher Sweeper offers SSH via WiFi.
- iPad connects via SSH and sends commands to read sensor data
- steering wheel, accelerator
- additional tinkerforge sensors (e.g. proximity sensor) send data via TCP to iPad to prevent crashes with ostacles

## Boring Job? Use SuperMarioKehrt!
![Boring Gif](https://raw.githubusercontent.com/frogg/SuperMarioKehrt/master/boring_job.gif)

# Instructions 
When connecting to a Kärcher Kehrmaschine via WiFi, make sure that your iPad uses a static ip address, preferrably: 
`192.168.100.42` (TinkerBoard sensor sends TCP messages to this ip-address, and Kärcher expects ip address in this range).
