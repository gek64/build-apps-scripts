#!/bin/bash

PROGRAM_NAME="gps-sdr-sim"

function init() {
  sudo apt -y update
  sudo apt -y install build-essential

  # windows x86 x64
  sudo apt -y install binutils-mingw-w64
  sudo apt -y install gcc-mingw-w64 g++-mingw-w64
  sudo apt -y install gcc-mingw-w64-i686 g++-mingw-w64-i686
  x86_64-w64-mingw32-gcc -v
  x86_64-w64-mingw32-g++ -v
  i686-w64-mingw32-gcc -v
  i686-w64-mingw32-g++ -v

  # linux arm64
  sudo apt -y install binutils-aarch64-linux-gnu
  sudo apt -y install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
  aarch64-linux-gnu-gcc -v
  aarch64-linux-gnu-g++ -v

  # linux x86 x64
  sudo apt -y install binutils-i686-linux-gnu binutils-x86-64-linux-gnu
  sudo apt -y install gcc-i686-linux-gnu g++-i686-linux-gnu
  sudo apt -y install gcc g++
  i686-linux-gnu-gcc -v
  i686-linux-gnu-g++ -v
  x86_64-linux-gnu-gcc -v
  x86_64-linux-gnu-g++ -v
}

function build() {
  # linux
  x86_64-linux-gnu-gcc gpssim.c -lm -O3 -o bin/${PROGRAM_NAME}-linux-x86_64
  i686-linux-gnu-gcc gpssim.c -lm -O3 -o bin/${PROGRAM_NAME}-linux-x86
  aarch64-linux-gnu-gcc gpssim.c -lm -O3 -o bin/${PROGRAM_NAME}-linux-arm64
  # windows
  x86_64-w64-mingw32-gcc gpssim.c -lm -O3 -o bin/${PROGRAM_NAME}-windows-x86_64
  i686-w64-mingw32-gcc gpssim.c -lm -O3 -o bin/${PROGRAM_NAME}-windows-x86
}

init
build
