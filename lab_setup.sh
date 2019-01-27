#! /bin/bash

# create a development directory
mkdir -p ~/workspace/devnet-2595
cd ~/workspace/devnet-2595

# create python virtual environment
~/.pyenv/versions/3.6.4/bin/pyvenv .
#python3.4 -m venv .

# activate virtual environment
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools

# install genie and genie robot library
pip install genie genie.libs.robot

# clone this repo
git clone https://github.com/CiscoTestAutomation/CL-DevNet-2595.git workshop

