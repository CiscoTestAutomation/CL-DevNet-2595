# Workshop Steps

#### Part 1 - Without automation - Collect information

Congratulation, you are in charge of the following network!

![Topology](https://raw.githubusercontent.com/jeaubin/katacoda-scenarios/master/compare/topology.png)

The network is performing as expected. Your task is to make sure it remains up
and running. If the network has some issue you must react quickly and fix the issue! (Sounds familiar?)

##### Getting Ready

```bash
cd ~/devnet-2595
source bin/activate
cd workshop
```

##### Manual investigation

Let's connect to our device and send a few show commands to learn the topology and configuration.

We are using Mocked devices, which are devices which can be interacted like
normal devices however they have a limited amount of show command available.
To view the available command you can type help.

The below command is how to connect to the Nexus device.

```bash
mock_device_cli --os nxos --mock_data_dir mocked_device/initial_yamls/nxos --state execute
```

We can send a few show commands to understand the topology and configuration

`show running-config`
`show interface`
`show ip ospf vrf all`

**NOTE: Type Ctrl+d to get out of the device.**

The below command is how to connect to the Iosxe device.

```bash
mock_device_cli --os iosxe --mock_data_dir mocked_devices/initial_yamls/csr --state execute
```

#### Part 2 - Without automation - Catastrophe

**Oh no!**

![oh No!](ohNo.png)

All of sudden, the network is not operating as expected! Without any
automation, can you figure out what happened without going to the previous
step? 

```bash
mock_device_cli --os nxos --mock_data_dir mocked_devices/disaster_yamls/nxos --state execute
mock_device_cli --os iosxe --mock_data_dir mocked_devices/disaster_yamls/csr --state execute
```

**NOTE: Type Ctrl+d to get out of the device.**

This is not an easy task!

Let's see how we handle this in 2019 with Genie!


#### Part 3 - With Genie Cli - Collect information

[Genie has a Linux cli](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)
which allow to manage your network with the power of Genie Python libraries, without
even knowing Python or automation.

The first step is to learn the good state of the devices.

```bash

# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=mocked_devices/initial_recording
export unicon_speed=10

genie learn ospf interface bgp platform --testbed-file testbed.yaml --output learnt
```

Genie cli stores the device output and the parsed output for each feature and
device. The parsed outputs are common across all OS and are modeled on [Genie
Models](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/genie_libs/#/models).


With an editor open the two files:

* learnt/ospf_nxos_nx-osv-1_ops.txt

The ops file contains the structure information which was parsed from the show
commands for the feature Ospf on the nxos device.

* learnt/ospf_nxos_nx-osv-1_console.txt

The console file contains all the cli which were sent to learn Ospf on the nxos
device.

As each feature is parsed in structured data, we can now easily compare between


Thats it! We are now ready for our disaster to happen!


#### Part 4 - With Genie Cli - ...all is good

**Oh No**

![oh No!](ohNo.png)

All of sudden, the network is not operating as expected!  Can you figure out
what happened without going to the previous step?

**Yes!**

```bash

# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=mocked_devices/disaster_recording
genie learn ospf interface bgp platform --testbed-file testbed.yaml --output disaster
```

```bash
genie diff learnt disaster
```

We can see Ospf and interface operational state has changed.

With an editor open the two files:

* diff_ospf_nxos_nx-osv-1_ops.txt
* diff_interface_nxos_nx-osv-1_ops.txt

We can see right away that interface `Ethernet2/1` on the `nxos`
device is in `shutdown` mode and it is affected the protocolswhich is affecting
our Ospf neighbor. .

Once the problem is pinpointed its much easier to resolve.

[Genie
Cli]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html))
is ready for you to use on your own network. Repeat these same steps and you
are good to go!


#### Part 5 - With Genie Robot - Collect information

** TODO: better wording for this **

Another approach is to use [RobotFramework](https://robotframework.org) with [Genie robot
library]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html).

The script uses the same Genie library in the backend, this time in a Robot
environment.

The Robotscript will tackle the same challenge; learn the good state of the
network, then rerun as similar script periodically or when a disaster happen
figure out what has happened.

With an editor open the script and examine it's content:

`robot_initial_snapshot/robot_initial_snapshot.robot`

The Robot language is keyword based, which makes reading script quite easy to
understand. The script does the following:

* Load Genie Library
* Connect to the two devices
* Learn bgp, interface, platform, ospf and the device configuration and save it to file.

You can now start the script.

```bash

# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=mocked_devices/initial_recording
cd robot_initial_snapshot
robot --outputdir run robot_initial_snapshot.robot
```

Open the `run/log.html` with a web browser to view the log.

Our good snapshot was saved as file `robot_initial_snapshot/good_snapshot`; we
are now ready for a disaster to happen!


#### Part 6 - With Genie Robot - ...all is good

**Oh No**

![oh No!](ohNo.png)

All of sudden, the network is not operating as expected!  With automation, can
you figure out what happened without going to the previous step?

**Yes!**

In the previous step we've taken a snapshot of our Network when it was
performing as expected. We will take a new snapshot and compare with this
previous good snapshot.

With an editor open the script and examine it's content:

`robot_compare_snapshot/compare_snapshot.robot`

The script will:

* Load Genie Library
* Connect to the two devices
* Learn bgp, interface, platform, ospf and the device configuration and save it to file.
* And compare the new snapshot with the original snapshot!

You can now start the script.

```bash

# TODO MAKE THIS MESSAGE BETTER
# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=mocked_devices/disaster_recording

cd ../robot_compare_snapshot
robot --outputdir run compare_snapshot.robot
```
Open the `run/log.html` with a web browser to view the log.

We can see the robot script has failed. Open the log and you can see the
the interface `Ethernet2/1` on the `nxos` device is in `shutdown` mode and is
affecting the protocols.

We can now fix the issue and rerun our script to make sure we are back in
business!

