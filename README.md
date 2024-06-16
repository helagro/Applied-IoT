## Tutorial on how to build a automation system for IKEA Tradfri
- [x] Title
- [x] Your name and student credentials (xx666x)
- [ ] Short project overview
- [ ] How much time it might take to do (approximation)

**Author:** Henrik Lagrosen, (hl223qb)

**Overview:**

This tutorial will show you how to set up a Raspberry Pico W to provide more automation abilities to the Ikea Tradfri system. The resulting system will be able to automate Tradfri commands based on data from the sensors connected to one or more Pico W's. The available sensors to use are a temperature sensor, a humidity sensor, a light sensor and a motion sensor.

<TODO: Import diagram>

As shown above, it consists of a Raspberry Pico W, a server running Python and a Tradfri gateway. The Pico W is used to control the Tradfri devices and to send data to the server. The server is used to manage the data and to communicate with the Tradfri gateway.

**Time Investment:**

> Give a short and brief overview of what your project is about.
> What needs to be included:


### Objective

> Describe why you have chosen to build this specific device. What purpose does it serve? What do you want to do with the data, and what new insights do you think it will give?

**Project Selection Decision:**
- [x] Why you chose the project

I have some previous experience with developing software integrating with the IKEA Tradfri product line. Those projects were aimed to 
extend the existing functionallity of the smart home system and were highly tailored to suit my own needs. I learned that it was both
fun and easy to work with the Tradfri system and as it fitted well with the requirements of the course, I decided to build a project
that works as an extension to the Tradfri system.

**Purpose:**
- [x] What purpose does it serve

This project aims to be a IoT project that other people can use or build upon. Being a popular product line, I can see others finding 
benefit in this project, both in learning and also for the practical use of the end product.

**Possible Insights:**
- [x] What insights you think it will give

There are some aspects of the project that are newer to me. I have not made tutorials of this kind and I think that some of the data-visualisation tools will be new to me as well. I expect to learn more about both areas and how to operate with them more efficiently.
I think I will learn more about how to convey the instructions in a clear and concise way, and also how to make the project more appealing and
understandable to the reader.



### Material

Explain all material that is needed. All sensors, where you bought them and their specifications. Please also provide pictures of what you have bought and what you are using.

- [ ] List of material
- [ ] What the different things (sensors, wires, controllers) do - short specifications
- [ ] Where you bought them and how much they cost


|Image | Name | Info | Price |
| ---- | ---- | ---- | ----- |
| <Image> | LED 5mm Red | A red led light used for indicating status | 0.5$ at <link> |


>In this project I have chosen to work with the Pycom LoPy4 device as seen in Fig. 1, it's a neat little device programmed by MicroPython and has several bands of connectivity. The device has many digital and analog input and outputs and is well suited for an IoT project.
>
>![LoPy!](https://pycom.io/wp-content/uploads/2018/08/lopySide-1.png =360x)
>Fig. 1. LoPy4 with headers. Pycom.io


### Computer setup

> How is the device programmed. Which IDE are you using. Describe all steps from flashing the firmware, installing plugins in your favorite editor. How flashing is done on MicroPython. The aim is that a beginner should be able to understand.

- [x] Chosen IDE
- [x] How the code is uploaded
- [x] Steps that you needed to do for your computer. Installation of Node.js, extra drivers, etc.

**My IDE choice:**

The IDE I chose for working with this project is Visual Studio Code. The most major factors behind the decision were the extendability of the code editor which allows for fine tuning the editor to my liking, and because I have a lot of previous experience with the editor. You can use whichever editor you prefer, but the instructions will be tailored to Visual Studio Code with the PyMakr plugin.

**Setting up Visual Studio Code:**

First, you need to install Node.js, using instructions available on [this page](https://nodejs.org/en/). This is needed for the PyMakr plugin to function. Then, you need to install Visual Studio Code from [this page](https://code.visualstudio.com/Download). After installing the editor, you can install the PyMakr plugin by searching for it in the extensions tab. 

**Setting up the Pico W:**

To be able to deploy MicroPython code on the the Pico W, you need to first flash the MicroPython firmware to the device. Start by connecting the Pico W to a micro USB cable. While holding the BOOTSEL button, connect the other end of the cable to your computer. After connected, you can release the BOOTSEL button and the Pico W should appear as a USB drive on your computer. You can then download the MicroPython firmware from [this](https://micropython.org/download/RPI_PICO_W/) page, and copy the .uf2 file onto the Pico W drive. After this, the Pico W should automatically install and disconnect from you computer, after which you can unplug the cable.

**Setting up the local server:**

The server is used to coordinate the Pico W devices (in case there are multiple in your setup), to communicate with the Tradfri gateway and to manage the data. The server needs to be Linux based, but it can be a laptop for instance. In my case, I used a Raspberry Pi 4 running Raspbian. To setup the server, you need to install Python 3, for instance from [here](https://www.python.org/downloads/). <TODO: pytradfri, other libs, flask>


### Putting everything together

How is all the electronics connected? Describe all the wiring, good if you can show a circuit diagram. Be specific on how to connect everything, and what to think of in terms of resistors, current and voltage. Is this only for a development setup or could it be used in production?

- [ ] Circuit diagram (can be hand drawn)
- [ ] *Electrical calculations

### Platform

Describe your choice of platform. If you have tried different platforms it can be good to provide a comparison.

Is your platform based on a local installation or a cloud? Do you plan to use a paid subscription or a free? Describe the different alternatives on going forward if you want to scale your idea.

- [ ] Describe platform in terms of functionality
- [ ] *Explain and elaborate what made you choose this platform 

### The code

Import core functions of your code here, and don't forget to explain what you have done! Do not put too much code here, focus on the core functionalities. Have you done a specific function that does a calculation, or are you using clever function for sending data on two networks? Or, are you checking if the value is reasonable etc. Explain what you have done, including the setup of the network, wireless, libraries and all that is needed to understand.


```python=
import this as that

def my_cool_function():
    print('not much here')

s.send(package)

# Explain your code!
```



### Transmitting the data / connectivity

How is the data transmitted to the internet or local server? Describe the package format. All the different steps that are needed in getting the data to your end-point. Explain both the code and choice of wireless protocols.


- [x] How often is the data sent? 
- [x] Which wireless protocols did you use (WiFi, LoRa, etc ...)?
- [x] Which transport protocols were used (MQTT, webhook, etc ...)
- [x] *Elaborate on the design choices regarding data transmission and wireless protocols. That is how your choices affect the device range and battery consumption.

**Wireless protocols and traffic:**

WiFi is used as the main wireless protocol for the system. The Pico W uses it to send new sensor data to the server, during the specific polling intervals used for each sensor, if a different value is registered. The shortest possible frequency data is sent is <TODO> and it could be an unlimited amount of time between messages if no new sensor data is recorded. 

**Transport protocols:**

MQTT is used as the transport protocol between the Pico W and the server. Given that the MQTT broker is running on the same device as the server, that end of the traffic never leaves the device. The server then uses the pytradfri library to communicate with the Tradfri gateway, which uses the CoAP protocol. The server also uses a REST API to communicate with the frontend over HTTP. The web API is built using the Python Flask library, communicating with the Flutter client application. The server also hosts a web version of the client application, also served over HTTP.

**Design choices:**

There was not a lot of constraints guiding which wireless protocol was to be used. All devices for the project are meant to be inside the users home, meaning that range was not an issue. The user would likely power the Pico W from the outlet directly, so power consumption was not a great concirn either. Despite network speed or latency not being a high priority, WiFi still seemed like a great choice. The Pico W has built in WiFi capabilities, meaning that no extra antenna or similar equipment would be neccessary, reducing cost. Bluetooth could still have been an alternative but the range could have been an issue. Bluetooth would have required the server and Pico W to be close to eachother, but with WiFi, they could be far apart, as long as the WiFi has good enough range. This could be achieved with a Mesh network, for instance. Both Bluetooth Low Energy and LoRa can be configured to be very power efficient, but within a home setting, the power consumption of WiFi is not a big issue.

### Presenting the data

Describe the presentation part. How is the dashboard built? How long is the data preserved in the database?

- [ ] Provide visual examples on how the dashboard looks. Pictures needed.
- [ ] How often is data saved in the database.
- [ ] *Explain your choice of database.
- [ ] *Automation/triggers of the data.


### Finalizing the design

Show the final results of your project. Give your final thoughts on how you think the project went. What could have been done in an other way, or even better? Pictures are nice!

- [ ] Show final results of the project
- [ ] Pictures
- [ ] *Video presentation

---
