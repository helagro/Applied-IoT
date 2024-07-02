# How to build an automation system for IKEA Tradfri

**Author:** Henrik Lagrosen, (hl223qb)

**Overview:**

This tutorial will show you how to set up a Raspberry Pico W to provide more automation abilities to the Ikea Tradfri system. The resulting system will be able to automate Tradfri commands based on data from the sensors connected to one or more Pico W's. The available sensors to use are a temperature sensor, button, light sensor and a motion sensor.

![System Overview](res/img/IoT-diagram.jpg)

As shown above, it consists of one-to-many Raspberry Pico W's, a server and a Tradfri gateway. The Pico W is used to control the Tradfri devices and to send data to the server. The server is used to manage the data and to communicate with the Tradfri gateway. This is designed to be a fun hobby project, which could also result in an actually useful end-product. I think it is suitable for beginners in the field, but be careful with the hardware. **I claim no responsibility for any damages**

**Time investment:**

The hardware should not take long, as all it takes is to follow the wiring diagram. The time required to setup the software is depends a lot on experience and luck. I estimate that it would take 45 minutes to 2 hours to complete everything.


## Objective

**Project selection decision:**

I have some previous experience with developing software integrating with the IKEA Tradfri product line. I learned that it was both fun and easy to work with the Tradfri system and as it suited the requirements of the course, I decided to build a project that works as an extension to the Tradfri system.

**Purpose:**

This project aims to be a IoT project that other people can use or build upon. Being a popular product line, I can see others finding benefit in this project, both in learning and also for the practical use of the end product.

**Data Usage:**

The Pico W will send the sensor data to the server. The server will then use this data to trigger automations based on the data. For instance, if the motion sensor detects motion, the server could turn on a Tradfri light. The server will also store the data in a time series database, enabling visualisation of the data. Knowing what values the sensors produces in one day-cycle, could help the user create automations. The user might know that they want the light to turn on when it is as dark as it was at 6 PM yesterday, for instance. The data could also be useful for monitoring, increasing understanding and for debugging.

**Possible insights:**

There are some aspects of the project that are newer to me. I have not made tutorials of this kind and I think that some of the data-visualisation tools will be new to me as well. I expect to learn more about both areas and how to operate with them more efficiently. The data will both give insights to general metrics of the environment, aswell as the results and operations of the automations themselves.


## Material

|Image | Name | Info | Price |
| ---- | ---- | ---- | ----- |
| ![Tradfri Gateway](res/img/gateway.jpg) | Tradfri Gateway E1526 | The gateway used to control the Tradfri devices. **Other gateways might not work!** | Unavailable for new purchase, easy to find used. Around 400 SEK. |
| ![Pico W](res/img/pico-w.jpg) | Raspberry Pi Pico W | The microcontroller used for connecting the sensors to the application. Comes with a pre-soildered header and a built-in WiFi antenna. | 109 SEK at [Electrokit](https://www.electrokit.com/raspberry-pi-pico-wh) |
| ![Jumper Cables](res/img/cables.jpg) | Male to Male jumper cables | 10 cm long, male to male cables used to connect the sensors to the Pico W. | 39 SEK at [Electrokit](https://www.electrokit.com/labbsladdar-100mm-hane/hane-30-pack) |
| ![Jumper Cables](res/img/cables-2.jpg) | Male to female jumper cables | 15 cm long, male to female cables used to connect the sensors to the Pico W. | 29 SEK at [Electrokit](https://www.electrokit.com/labsladd-1-pin-hane-hona-150mm-10-pack) |
| ![Breadboard](res/img/breadboard.jpg) | Breadboard | A breadboard with 840 connections, used to connect the sensors to the Pico W. | 69 SEK at [Electrokit](https://www.electrokit.com/kopplingsdack-840-anslutningar)
| ![DHT11](res/img/dht11.jpg) | DHT11 | A digital temperature and humidity sensor which can be used with the dht library for easy reading. | 49 SEK at [Electrokit](https://www.electrokit.com/digital-temperatur-och-fuktsensor-dht11) |
| ![Light Sensor](res/img/light-sensor.jpg) | Light Sensor | An analog light sensor. Very easy to use because it has a seperate pin for reading and it does not need resistors for our application. | 39 SEK at [Electrokit](https://www.electrokit.com/ljussensor) |
| ![PIR Sensor](res/img/pir-sensor.jpg) | HC-SR501 | A motion sensor that can be used to detect movement. It has a digital output, high if motion is detected, low if not. | 49 SEK at [Electrokit](https://www.electrokit.com/pir-rorelsedetektor-hc-sr501) |
| ![Push Button](res/img/push-button.jpg) | Push Button | Simple push button with built-in resistors. It has one pin which will be high when the button is pushed. | 19 SEK at [Electrokit](https://www.electrokit.com/tryckknapp-momentan) |

> NOTE: Not all of the components I used were bought at the specified stores at the specified prices as already owned some of them.


## Computer setup

**My IDE choice:**

The IDE I chose for working with this project is Visual Studio Code. The most major factors behind the decision were the extendability of the code editor which allows for fine tuning the editor to my liking, and because I have previous experience with the editor. You can use different editors but the instructions will be for Visual Studio Code with the PyMakr plugin.

**Setting up Visual Studio Code:**

First, you need to install Node.js, using instructions available on [this page](https://nodejs.org/en/). This is needed for the PyMakr plugin to function. Then, you need to install Visual Studio Code from [this page](https://code.visualstudio.com/Download). After installing the editor, you can install the PyMakr plugin by searching for it in the extensions tab. 

**Setting up the Pico W:**

To be able to deploy MicroPython code on the the Pico W, you need to first flash the MicroPython firmware to the device. Start by connecting the Pico W to a micro USB cable. While holding the BOOTSEL button, connect the other end of the cable to your computer. After connected, you can release the BOOTSEL button and the Pico W should appear as a USB drive on your computer. You can then download the MicroPython firmware from [this](https://micropython.org/download/RPI_PICO_W/) page, and copy the .uf2 file onto the Pico W drive. After this, the Pico W should automatically install and disconnect from you computer, after which you can unplug the cable. The pico W is now ready to run MicroPython code, which can be done by connecting it to the computer again, opening the PyMakr menu in Visual Studio Code, selecting ADD DEVICES and then selecting the Pico W from the list of available devices. Then press the connect button on the device entry, and also the `Start Development Mode` button on the project. Everytime you save a file in the pico directory now, the code will be uploaded to the Pico W. You need to create a file in `Applied-IoT/pico/lib` called `env.py`. In this file, you need to add the following variables:
`
```python
WIFI_SSID="" # WiFi name
WIFI_PASS="" # WiFi password
BROKER_ADDRESS="" # IP of server device
BROKER_PORT=1883 # MQTT port of server, default is 1883
DEVICE_ID=1 # The unique identifier for the Pico W, MUST be a positive integer
DISABLED_SENSORS="" # A comma separated list of sensors not in use. The available sensors are "motion", "temperature", "light" and "button". For instance, "motion,light" would disable the motion and light sensors.
```

**Setting up the local server:**

The server is used to coordinate the Pico W devices (in case there are multiple in your setup), to communicate with the Tradfri gateway and to manage the data. In my case, I used a Raspberry Pi 4 running Raspbian, but any Linux/Mac should be fine. Windows could work too, but has not been tested. You need to install Docker Engine, Docker CLI and Docker Compose. You can install all of these at once by installing Docker Desktop, instructions can be found [here](https://docs.docker.com/desktop/). 

> The following commands will only work for Linux and Mac OS

To run the server, you need to download this repository to the server. Then, you need to navigate to the `server` directory:

```bash
cd FOLDER_YOU_DOWNLOADED_IT_TO/Applied-IoT/server
```

Set the tradfri gateway code which can be found on the bottom of your device (this step only needs to be included to setup and when your network configuration changes):

```bash
export TRADFRI_CODE="YOUR_CODE"
```

Then, you can start the server using the following commands:

```bash
export TRADFRI_ADDR="YOUR_GATEWAY_IP"
docker-compose up
```

The server should now be running on port 3000 of your device. You can access the frontend by going to `http://localhost:3000/static/index.html` in your browser. To access it from other devices on the same network, replace `localhost` with the IP address of the server.

## Putting everything together

![Wiring](res/img/Wiring.png)


**Electrics:**

Due to the choice of components, this entire setup require no additional resistors. The DHT11, button and light sensor all perform fine when powered with 3.3V. The DHT11, for instance, has a input power rating range of 3V - 5.5V. The motion sensor requires 5V power, but you can draw that from the USB input using the VBUS pin. This is not ideal as this bypasses features of the Pico W, like voltage regulation, overvoltage protection and backfeeding protection. An example of backfeeding is if you instead of drawing power from the VBUS, you accidentally power it. **This can cause damage to the device that the Pico is connected to (for instance, your expensive computer).**

**Power Consumption:**

The Pico W's power consumption with WiFi on is estimated as [45 mA](https://stfn.pl/blog/34-pico-power-consumption-solar-panels/). The DHT11 uses [1 mA](https://www.electrokit.com/upload/product/41015/41015728/DHT11.pdf) on average. The photoresistor has a total resistance of between [20 Ω and 5 MΩ, and an inline-resistor of 10 kΩ](https://abc-rc.pl/en/products/ky-018-light-sensor-photoresistor-light-sensor-module-for-arduino-16386.html). We will be conservative and calculate for 20 Ω. $10kΩ + 20Ω = 10020Ω$. $I=\frac{V}{R}$ gives $I=\frac{3.3V}{10020Ω} \approx 0.33 mA$. The pushbutton uses no power when not pressed, which will be too infrequent to consider. The motion sensor's power consumption proved too difficult to calculate given the complexity of the circuit and different phases of it. It is also highly influenced by user-settings, and would increase power consumption fairly significantly. Given that the software allows for disabling sensors, that sensor will not be used for this calculation. The total power consumption is then $45 mA + 1 mA + 0.33 mA = 46.33 mA$. Connected to a 10000 mAh power bank, the system would last for $\frac{10000 mAh}{46.33 mA} \approx 216 hours \approx 9 days$. Software tweaks could easily improve this, for instance by turning off the WiFi when not in use and putting it into deep sleep, but this is not that important for the intended use.

**Production:**

For a production setup, an external power module supply should be used, together more optimised wiring, pin usage and preferably a case of sorts. A case could quite easily be 3D printed, improving both looks, dust protection, ease of directing sensors and durability. 

**Color coding:**

The diagram's wires are color coded, which is recommended. Red means power, black means ground and yellow means signal, i.e. where the data is read from.


## Platform

This project does not use a cloud platform, instead it uses a local InfluxDB database. InfluxDB is a free time series database, although they have payed cloud options too. InfluxDB is specifically optimised for storing datapoints with a timestamp. It allows for tagging datapoints, and efficient filtering using those tags. Filtering by time is also highly optimised, given that it is a very common use-case for time-series databases. 

For visualisation, it uses a Flutter client application. In the repository, there is a uploaded web-build of it. The Flutter code in the repository has been built and tested on Web, Android and MacOS, iOS would require additional configuration. To make the graphs, the Flutter library [FL Chart](https://github.com/imaNNeo/fl_chart) is used.

**Platform choices:**

There were a few major factors influencing the choice of storage and visualisation solution. The choice was made rather late in the application's development, by then there already was on functioning client application. It made sense to use that for visualisation. The project already required a server for running the backend code, meaning installing a database on it as well would not add much extra complexity. The backend code already had code for recieving and interpreting sensor data sent from the Pico W, so it made sense to insert the data storage at the backend, rather than having a seperate module listening for mqtt messages. 

There were very few constraints on the project, performance would most likely not be an issue given that one server should easily be able to handle the load generated by quite a few Pico W's. Reliability was not a major concern either. The system is not crutial and it is very simple to restart. Therefore, ease of development and setup for the user could take more of a priority.

Using a platform like Adafruit, Ubidots or Node-Red would likely require more user setup, meaning making this README even longer and making more opportunities for errors. 

These factors all leaned towards installing a local database and using the Flutter client application for visualisation. The development would be easy, it would have a minimal impact on project complexity, it would not bottleneck the system in any significant manner, and the setup could be fully automated.

**Scaling:**

To allow for distributing the load to multiple servers, the broker, python server and database should be further separated. The client applications should connect to the InfluxDB directly, instead of having all data relayed through the Python server. The database should also be more directly connected to the MQTT broker, as it has to be separated from the Python server. Given that the system is not connected to the internet, no cloud scaling will ever be needed.

One alternate scaling solution could be to implement a full local TIG-stack. This means adding the programs Telegraf and Grafana to the system. Telegraf would be used to collect the data from the MQTT broker and send it to the InfluxDB database. Grafana would be used to visualise the data. This would allow for more advanced visualisations and more advanced data collection. This could be a more optimised setup as more under the hood optimisations have been made for these specialised programs. This could allow the system to process and visualise larger and more complex sets of data.

## The code

The code below is the main loop of the Pico W. It is responsible for polling the sensors at the specified intervals, and for sending the data to the server if a new value is registered. It uses the four polling functions `pollMotion`, `pollTemp`, `pollLight` and `pollBtn` to get the sensor data. The `MAIN_POLL_INTERVAL` is delay between each iteration of the loop. The button is polled at every iteration, as responsiveness is prioritised and no noise is expected. The other sensors are polled at a lower frequency, by using counter variables to keep track of how many iterations have passed since the last poll. If the counter reaches the specified maximum value, the sensor is polled and the counter is reset.

```python
while True:
    if(motionCounter >= motionCounterMax):
        pollMotion()
        motionCounter = 0

    if(tempCounter >= tempCounterMax):
        pollTemp()
        tempCounter = 0

    if(lightCounter >= lightCounterMax):
        pollLight()
        lightCounter = 0

    pollBtn()

    time.sleep(MAIN_POLL_INTERVAL)

    # Increment counters
    motionCounter += 1
    tempCounter += 1
    lightCounter += 1
```

The following code snippet shows one of the polling functions, `pollMotion`. It is responsible for polling the motion sensor and sending the data to the server if a new value is registered. The `prevMotion` variable is used to keep track of the previous value of the sensor, so that the server is not spammed with messages if the sensor value does not change. The `sensors.doesDetectMotion()` function is the function that actually reads the binary value of the associated pin. The data is published to the MQTT broker, under the topic `motion/<deviceID>`.

```python
def pollMotion() -> None:
    global prevMotion
    detectsMotion = sensors.doesDetectMotion()

    if prevMotion == detectsMotion: return

    if detectsMotion:
        client.publish(f"motion/{deviceID}", "1")
    else:
        client.publish(f"motion/{deviceID}", "0")

    prevMotion = detectsMotion
```

This code snippet shows the `getTemperature` function, which is used to poll the temperature sensor. The function first checks if the sensor is disabled, by checking if the sensor is in the list of disabled sensors. This list is specified in an environment file, and makes it easy for any user to only use a subset of the compatible sensors. If the sensor is not disabled, the function will attempt to measure the temperature. If the measurement is successful, the temperature is returned. If the measurement fails, the function will print an error message and return `None`.

```python
def getTemperature() -> float | None:
    if "temperature" in getDisabledSensors():
        return None
    try:
        tempSensor.measure()
        return tempSensor.temperature()
    except Exception as error:
        print("E-1", error)
        return None
```

## Transmitting the data / connectivity

**Wireless protocols and traffic:**

WiFi is used as the main wireless protocol for the system. The Pico W uses it to send new sensor data to the server, during the specific polling intervals used for each sensor, if a different value is registered. The shortest possible frequency data is sent is N timer per second, where N is the amount of Pico devices, and it could be an unlimited amount of time between messages if no new sensor data is recorded. 

**Transport protocols:**

MQTT is used as the transport protocol between the Pico W and the server. The server then uses the [pytradfri](https://github.com/home-assistant-libs/pytradfri) library to communicate with the Tradfri gateway using the CoAP protocol. The server also features a REST API to communicate with the frontend over HTTP. The server also hosts a web version of the client application, also served over HTTP.

**Wireless protocols:**

There was not a lot of constraints guiding which wireless protocol was to be used. All devices for the project are meant to be inside the users home, meaning that range was not an issue. The user would likely power the Pico W from the outlet directly, so power consumption was not a great concern either. Despite network speed or latency not being a high priority, WiFi still seemed like a great choice. The Pico W has built in WiFi capabilities, meaning that no extra antenna or similar equipment would be neccessary, reducing cost. Bluetooth could still have been an alternative but the range could have been an issue. Bluetooth would have required the server and Pico W to be close to eachother, but with WiFi, they could be far apart, as long as the WiFi has good enough range. This could be achieved with a Mesh network, for instance. Both Bluetooth Low Energy and LoRa can be configured to be very power efficient, but within a home setting, the power consumption of WiFi is not a big issue.

## Presenting the data

**Dashboard:**

![Dashboard](res/img/dashboard.png)

The dashboard is built in to the Flutter client application. It is built entirely in flutter, using the [FL Chart](https://github.com/imaNNeo/fl_chart) library. When loading data, a HTTP request is sent to the server, which loads it from the local InfluxDB database, and returns it. The data is then used to create the graphs. The data is stored in the database for one day. This is because the data is not very valuable after that, storing it further would cost more resources and it would require extra work to display that data effectively. The user can also filter which sensor device to display data from.

**Database details:**

How often the data is stored depends largely on how many Pico W's are connecting, and how often their sensor values change. The data is stored in the database when a new value is registered, meaning that if the sensor values do not change, no new data is stored. This means that the rate of incoming data can be anywhere from N times per second to never, where N is the number of Pico W's in the system.

Not too much thought was put into choosing which database to use, as the requirements on it are quite relaxed. I have previous experience with both SQL and NoSQL database like MongoDB, but I still decided to dive into time-series databases as it is clearly the best fit for the project. The course provided some information and tutorials on InfluxDB, and it is also very common in industry. This means that it is a good skill to have and that there will be a lot of resources available if I run into issues. The database is also free and open source, which is also good. 

**UI walk-through**

![Settings page](res/img/settings.png)

The settings screen is used for specifying the url of the server. It should be in the format http://YOUR_SERVER_IP:3000. You need to save the settings using the bottom right button.

![Automations page](res/img/automations.png)

The automations screen displays all created automations. Each item is clickable, and will take you to a page for editing them. There is also a plus button in the bottom right corner for creating a new automation.

![Automation editing page](res/img/automation-edit.png)

The automations editing screen is used to create or edit an automation. It has a number of fields for specifing the details of the automation. Most of them should be self-explanatory. The `Value` field is used to specify the value that the sensor value will be compared against. The input type is a decimal number. The `Button` and `Motion` sensors will produce a value of `1` when they are triggered and `0` when they are not.

There are three available actions to invoke on the chosen Tradfri device. The `SET_STATE` action is used to turn the device on or off (`Payload` `1` or `0`). The `TEMPORARY_ON` action is used to turn the device on for the amount of seconds entered in the `Payload` field. After that, it will turn off. Could be useful if you want a light to be on when motion has been detected the last five minutes, etc. Keep in mind that only changes of values will be recorded, meaning that to accomplish this function, two automations are needed. One that turns on the light when motion is detected, and one that turns it temporarily on for five minutes when no motion is detected. The `TOGGLE` action is used to toggle the state of the device. If the device is on, it will be turned off, and vice versa. The `Payload` value is ignored for this action.

The `Sensor Device` field is used to specify which sensor device the automation should apply to. The value should match the value entered into the `env.py` for the desired Pico W.

**Triggers of the data:**

When new sensor data is received, the server will execute any applicable automations and store it in the database.


## Finalizing the design

**Reflections:**

I think the project went well overall. I completed the MVP very early due to anticipated future time constraints. The main downside of this was low initial code quality, causing time expensive bugs and refactoring. The main improvement potential I noticed was to be more careful about data types in weakly typed languages. Python won't complain during runtime if a variable stores a value different to the one I described in the type hint. This caused some bugs and issues which took longer than it should have to solve. I ended up checking for data type in if-statements, scattered across the code. Ideally, I should have done this earlier and more delieratebly.

**Result:**


![result](res/img/result.jpeg)

> Please note that the wiring is messier than in the wiring diagram due to me not having the right type of wires.

[Video Presentation](https://youtu.be/vtmuhuVpsc0)

---
