[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/CiscoTestAutomation/CL-DevNet-2595)

# Cisco Live! DEVWKS-2595: Stateful Network Validation using pyATS/Genie

This repository contains the files required for the participants of 
[Cisco Live!](https://www.ciscolive.com/us.html?zid=cl-global) workshop
**DEVWKS-2595: Stateful Network Validation using pyATS/Genie.**

> Note: This workshop can be completed at home.
> 
> All files required are included in this repository. You do not need physical
> devices - mock devices are provided.
> 
## General Information

- Cisco Live! Webpage: https://www.ciscolive.com/us.html?zid=cl-global
- pyATS/Genie Portal: https://cs.co/pyats
- Documentation Central: https://developer.cisco.com/docs/pyats/
  - Getting Started: https://developer.cisco.com/docs/pyats-getting-started/
  - API Browser: https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/
- RobotFramework Keywords: 
  - pyATS Core Framework: https://pubhub.devnetcloud.com/media/pyats/docs/robot/native.html
  - Genie Framework: https://pubhub.devnetcloud.com/media/genie-docs/docs/userguide/robot.html
  - Genie APIs: https://pubhub.devnetcloud.com/media/genie-docs/docs/userguide/robot.html
  - Unicon APIs: https://pubhub.devnetcloud.com/media/unicon/docs/robot.html
- Support Email: pyats-support-ext@cisco.com

## Requirements

- Mac OSX, Linux or Windows 10 [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- Python 3.5, 3.6 or 3.7
- Network connectivity (for downloading PyPI packages)
- Working knowledge of Python is a plus, but not required.

## Preparation Instructions

> **Note:**
> 
> For those attending Cisco Live! Workshop in person, these instructions
> have already been performed on the laptop you are using in front of you.

**Step 1: Create a Python Virtual Environment**

In a new terminal window:

```bash
# go to your workspace directory
# (or where you typical work from)
cd ~/workspace

# create python virtual environment
python3 -m venv devwks-2595

# activate virtual environment
cd devwks-2595
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools
```

**Step 2: Install pyATS & Genie**

```bash
# install our packages 
pip install pyats[full]
```

> Note:
>
> The install target `pyATS[full]` performs a *full* installation, that is, 
> including the core framework pyATS, the standard libraries Genie, and 
> additional components such as RobotFramework support etc.

**Step 3: Clone This Repository**

```bash
# clone this repo
git clone https://github.com/CiscoTestAutomation/CL-DevNet-2595.git workshop

# cd to the directory
cd workshop
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
