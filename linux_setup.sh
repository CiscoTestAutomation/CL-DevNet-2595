#! /bin/bash

# ------------------------------------------------------------------------------
#                                     Note
#
#   these instructions are used during CLUS for setting up the Linux machines.
#   wget -O - https://raw.githubusercontent.com/CiscoTestAutomation/CL-DevNet-2595/master/linux_setup.sh | bash
# ------------------------------------------------------------------------------


# ensure dependencies
sudo apt-get install python3 python3-venv python3-pip

# create directories
mkdir -p ~/workspace/devwks-2595

# create virtual environment for workshop
cd ~/workspace/devwks-2595
python3 -m venv .

# activate virtual environment
source bin/activate

# update basic necessities
pip install --upgrade pip setuptools

# install pyATS
pip install pyats[full] 

# install optional dependencies for this workshop
pip install tabulate cryptography

# clone workshop
git clone https://github.com/CiscoTestAutomation/CL-DEVWKS-2808 workshop

