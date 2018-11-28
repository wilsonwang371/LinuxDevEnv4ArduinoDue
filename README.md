# LinuxDevEnv4ArduinoDue

## Clone

Use this command to check out all the code including submodules
```bash
git clone --recursive https://github.com/wilsonwang371/LinuxDevEnv4ArduinoDue.git
```

## Install Dependencies

```bash
sudo apt install gcc-arm-none-eabi libwxgtk3.0-dev libreadline-dev 
```

## Build BOSSA

```bash
pushd BOSSA
make
make install
popd
```


## Try Example
```bash
cd resources/example
make
```
