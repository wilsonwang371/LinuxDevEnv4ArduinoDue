# LinuxDevEnv4ArduinoDue

This is a repository which helps you to build your Arduino Due code without using Arduino IDE.

## Features

* Based on CMake
* Build your Arduino code without Arduino IDE
* Added FreeRTOS support

## Install Arduino IDE

1. Download Arduino for Linux
2. Run Arduino IDE and download Arduino Due in board manager. (This will download SAM libraries and toolchains)


## Try Example

```bash
mkdir build
cd build
cmake ../project_template/
make
```
If you want to upload code to Arduino Due, run this second step
```bash
make upload
```

If you want verbose output, use
```bash
cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ../project_template/
```


## Reference
* http://www.atwillys.de/content/cc/using-custom-ide-and-system-library-on-arduino-due-sam3x8e/?lang=en
