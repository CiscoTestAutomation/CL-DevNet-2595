# Cisco Live Europe 2019: DevNet-2595 Workshop Material

This repository contains the files required for the participants of [Cisco Live Europe 2019](https://ciscolive.cisco.com/emea/)
workshop:

> DevNet-2595: Stateful Network Validation using pyATS+Genie and Robot Framework.

This workshop can be completed at home; as all devices are included in this workshop.

## General Information

- Cisco Live Europe: https://ciscolive.cisco.com/emea/
- pyATS/Genie Portal: https://developer.cisco.com/pyats/
- Genie Documentation: https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/index.html
  - Genie CLI: https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html
  - RobotFramework Keywords: https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot.html
  - Triggers, Verifications, Models: https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/genie_libs/index.html
- pyATS Documentation: https://developer.cisco.com/docs/pyats/
  - RobotFramework Keywords: https://pubhub.devnetcloud.com/media/pyats/docs/robot.html
- Community: https://communities.cisco.com/community/developer/pyats
- Support Email: pyats-support-ext@cisco.com


## Requirements

- Mac OSX, Linux or Windows 10 [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- Python 3.4, 3.5 or 3.6
- Network connectivity (for downloading PyPI packages)
- Working knowledge of Python is a plus, but not required.

All Cisco devices are provided! We are providing mocked devices which are
sufficient for this workshop.

## Preparation Instructions

> These preparations will have been already done on the laptop you use in
> Cisco Live. If you are doing this on your own times, you'll need these steps.

#### Step 1. Create a Python virtual environment

In a new shell window:

```bash
# create a development directory
cd ~/workspace
mkdir ~/devnet-2595
cd devnet-2595

# create python virtual environment
python3 -m venv .

# activate virtual environment
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools
```

#### Step 2. Install Genie, pyATS, and Robot Framework

Installing `genie` and `genie.libs.robot` will automatically install all required
dependencies, including `pyats` and `pyats.robot` Robot Framework keyword support.

```bash
# install genie and genie robot library
pip install genie genie.libs.robot
```

#### Step 3. Clone this repository

```bash
# clone this repo
git clone https://github.com/CiscoTestAutomation/CL-DevNet-2595.git workshop
```

and now you should be ready to get going!

**Head to the >[Main Workshop](workshop.md)< to start!**


--------------------------------------------------------------------------------


## Repository Content

```text
    testbed.yaml                      testbed YAML file to connect to our devices
    robot_initial_snapshot/           Directory with RobotFramework script to gather the first snapshot
    robot_compare_snapshot/           Directory with RobotFramework script to collect the second snapshot and compare with the initial snapshot
    mocked_devices/                   Data for the mocked devices.
    README.md                         Introduction text for this Workshop
    workshop.md                       Workshop instruction
```
