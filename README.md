[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/CiscoTestAutomation/CL-DevNet-2595)

# Cisco Live CLEUR 2020: DevNet-2595 Workshop Material

This repository contains the files required for the participants of [Cisco Live CLEUR 2020](https://www.ciscolive.com/)
workshop **DevNet-2595: Stateful Network Validation using pyATS+Genie and Robot Framework**

> Note: This workshop can be completed at home.
> 
> All files required are included in this repository. You do not need physical
> devices - mock devices are provided.


## General Information

- Cisco Live! Webpage: https://www.ciscolive.com/us.html?zid=cl-global
- pyATS/Genie Portal: https://cs.co/pyats
- Documentation Central: https://developer.cisco.com/docs/pyats/
  - Getting Started: https://developer.cisco.com/docs/pyats-getting-started/
  - API Browser: https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/
  - Genie CLI: https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli/index.html
  - RobotFramework Keywords: https://pubhub.devnetcloud.com/media/genie-docs/docs/userguide/robot/index.html
- Support Email: pyats-support-ext@cisco.com



## Requirements

- Mac OSX, Linux or Windows 10 [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- Python 3.5, 3.6 or 3.7
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
mkdir devnet-2595
cd devnet-2595

# create python virtual environment
python3 -m venv .

# activate virtual environment
source bin/activate

# update your pip/setuptools
pip install --upgrade pip setuptools
```

#### Step 2. Install Genie, pyATS, and Robot Framework

```bash
# install our packages
pip install genie[full]
```

> Note:
>
> The install target `pyATS[full]` performs a *full* installation, that is, 
> including the core framework pyATS, the standard libraries Genie, and 
> additional components such as RobotFramework support etc.


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
