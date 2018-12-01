# LinuxDevEnv4ArduinoDue

## Install Dependencies

```bash
sudo apt install cmake gcc-arm-none-eabi
```

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
