# LinuxDevEnv4ArduinoDue

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


## Reference
* http://www.atwillys.de/content/cc/using-custom-ide-and-system-library-on-arduino-due-sam3x8e/?lang=en
