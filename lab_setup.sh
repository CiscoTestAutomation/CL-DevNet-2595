#! /bin/bash

# install pyenv and python
brew install pyenv
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
pyenv install 3.6.7

# create a development directory
mkdir -p ~/workspace/devnet-2595
cd ~/workspace/devnet-2595

# create python virtual environment
~/.pyenv/versions/3.6.7/bin/python -m venv .
#python3.4 -m venv .

# activate virtual environment
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools

# install genie and genie robot library
pip install genie genie.libs.robot

# clone this repo
git clone https://github.com/CiscoTestAutomation/CL-DevNet-2595.git workshop
