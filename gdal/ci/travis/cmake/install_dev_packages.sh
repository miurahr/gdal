#!/bin/sh

set -e

sudo apt-get update -qq
sudo apt-get install -y -q ninja-build cmake3 swig doxygen texlive-latex-base make cppcheck ccache g++

