#! /bin/bash

# ------------------------------------------------------------------------------
#                                     Note
#
#   these instructions are used during CLUS for setting up the Macbooks.
#   wget -O - https://raw.githubusercontent.com/CiscoTestAutomation/CL-DevNet-2595/master/lab_setup.sh | bash
# ------------------------------------------------------------------------------

# install pyenv and python
brew install pyenv
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
pyenv install 3.6.8

# create a development directory
mkdir -p ~/workspace/devwks-2595
cd ~/workspace/devwks-2595

# create python virtual environment
~/.pyenv/versions/3.6.8/bin/python -m venv .

# activate virtual environment
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools

# install genie and genie robot library
pip install --pre genie genie.libs.robot tabulate

# clone this repo
git clone https://github.com/CiscoTestAutomation/CL-DevNet-2595.git workshop
