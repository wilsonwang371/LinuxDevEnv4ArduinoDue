# Arduino Due Linux Develop Environment

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
$ ./new_project.sh
New project directory name:test
$ cd test
$ cmake .
$ make
```
If you want to upload code to Arduino Due, run this second step
```bash
$ make upload
```

If you want verbose output, use
```bash
$ cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON .
```


## Source Files Organizations in Project Template

```
.
├── cmake_include
│   ├── header_inc.cmake
│   ├── libraries.cmake
│   ├── toolchain.cmake
│   └── uploader.cmake
├── CMakeLists.txt
├── inc               <- !Put your header files here!
│   ├── due_sam3x.h
│   └── due_sam3x.init.h
├── includes.list     <- !Path included while building the project!
├── libraries.list    <- !Libraries included!
├── scripts
│   ├── find_file.sh
│   ├── find_inc.sh
│   └── find_src.sh
└── src               <- !Put your source files here!
    └── main.cpp
```

## Reference

* http://www.atwillys.de/content/cc/using-custom-ide-and-system-library-on-arduino-due-sam3x8e/?lang=en

## Issues

Please let me know if you experience issues with this.
