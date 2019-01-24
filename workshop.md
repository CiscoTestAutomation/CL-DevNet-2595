# Workshop Steps

#### Part 1 - Without automation - Collect information

Congratulation, you are in charge of the following network!

![Topology](https://raw.githubusercontent.com/jeaubin/katacoda-scenarios/master/compare/topology.png)

The network is performing as expected. Your task is to make sure it remains up
and running. If the network has some issue you must react quickly and fix the
issue! (Sounds familiar?)

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
mock_device_cli --os nxos --mock_data_dir mocked_devices/initial_yamls/nxos --state execute
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
# a real device there is no need to have these environemnt variable.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/initial_recording
export unicon_speed=10

genie learn ospf interface bgp platform --testbed-file testbed.yaml --output learnt
```

Take a moment to look at the output.

Genie cli stores the device output and the parsed output for each feature and
device. The parsed outputs are common across all OS and are modeled based on [Genie
Models](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/genie_libs/#/models).


With an editor open the two files:

* learnt/ospf_nxos_nx-osv-1_ops.txt

The ops file contains the structure information which was parsed from the show
commands for the feature Ospf on the nxos device.

* learnt/ospf_nxos_nx-osv-1_console.txt

The console file contains all the cli and device output which were sent to the
device to learn Ospf on the nxos device.


Each feature relevant information is parsed into structured data. Having
structured data open many new possibilities which we will see.

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
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/disaster_recording

genie learn ospf interface bgp platform --testbed-file testbed.yaml --output disaster
```

```bash
genie diff learnt disaster
```

We can see Ospf and interface operational state has changed.

With an editor open the two files:

* diff_interface_nxos_nx-osv-1_ops.txt
* diff_ospf_nxos_nx-osv-1_ops.txt

```text

--- learnt/interface_nxos_nx-osv-1_ops.txt
+++ disaster/interface_nxos_nx-osv-1_ops.txt
info:
 Ethernet2/1:
+  duplex_mode: auto
-  duplex_mode: full
+  enabled: False    <---
-  enabled: True     <---
+  oper_status: down <---
-  oper_status: up   <---

```


As a normal linux diff:

* `-` means this key is now missing or has been modified and this was the old value.
* `+` means this key has been added or been modified and this is the current value.

We can see right away that interface `Ethernet2/1` on the `nxos` device is in
`shutdown` mode and it is affecting our Ospf neighbor. We lost the neighbor
`10.1.1.1`.

Once the problem is pinpointed, tackling the problem is now much easier to
resolve. Investigation will start on why this port is now shutdown and bring it
back up.

[Genie
Cli]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html))
is ready for you to use on your own network. Repeat these same steps and you
are good to go!

In the last part of this workshop we will try a few more Genie cli commands.


#### Part 5 - With Genie Robot - Collect information

[RobotFramework](https://robotframework.org) provides a great intermediate step
between no automation and full python. It is keywords driven and can
be extended with external libraries.

We've created [Genie robot library](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html) 
allowing to control your network in RobotFramework! The script uses the same
Genie library in the backend, this time in a Robot environment.


Our Workshop Robotscript tackles the same challenge as earlier; learn the good
state of the network, then rerun periodically or when a disaster happen to
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
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/initial_recording

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

# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/disaster_recording

cd ../robot_compare_snapshot
robot --outputdir run compare_snapshot.robot
```
Open the `run/log.html` with a web browser to view the log.

As a normal linux diff:

* `-` means this key is now missing or has been modified and this was the old value.
* `+` means this key has been added or been modified and this is the current value.

```text

Comparison between ../robot_initial_snapshot/good_snapshot and ./new_snapshot is different for feature 'interface' for device:

'nx-osv-1'
info:
 Ethernet2/1:
+  duplex_mode: auto
-  duplex_mode: full
+  enabled: False
-  enabled: True
+  oper_status: down
-  oper_status: up

```

We can see right away that interface `Ethernet2/1` on the `nxos` device is in
`shutdown` mode and it is affecting our Ospf neighbor. We lost the neighbor
`10.1.1.1`.

Once the problem is pinpointed, tackling the problem is now much easier to
resolve. Investigation will start on why this port is now shutdown and bring it
back up.


#### Part 7 - Bonus 

Genie Cli and Genie Robot library have tons of extra functionality; let's try a
few of them.


##### Parse cli command with Genie Cli

Devices output can be parsed into structure data with Genie Cli.

```bash

genie parse "show version" --testbed-file testbed.yaml --device nx-osv-1 --output initial_output
genie parse "show version" "show ip ospf interface vrf all" --testbed-file testbed.yaml --device nx-osv-1 --output initial_output
```

Visit our website to see all [available
parser](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/genie_libs/#/parsers).


Then you can take snapshot of the same command at different time and compare them

```bash

genie parse "show version" "show ip ospf interface vrf all" --testbed-file testbed.yaml --device nx-osv-1 --output current_output
```

And to compare them

```bash

genie diff initial_output current_output --output parser_diff
```

All others possibilities and arguments are discussed on our [Genie Cli
documentation](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)!


##### Genie Robot Library

So far we've created a very useful comparison script with our Robot keywords.

[Genie robot library]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html)
contains many keywords that you can use for writing your script.

The script : `bonus_robot/verify_count.robot` does the following:

* Load Genie Library
* Connect to the two devices
* Verify the number of Bgp neighbors
* Verify the number of Bgp routes
* Verify the number of Ospf neighbor
* Verify the number of up Interfaces

```bash

# This is needed as we are using our Mocked device. When Genie cli is used with
# a real device there is no need to have this environemnt variable.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/bonus_recording

cd bonus_robot
robot --outputdir run verify_count.robot
```

This style of testing is great to run periodically to make sure the state of
your device.


#### Conclusion

This conclude this workshop; we hope this session was inspirational and open
possibilities for your own Automation and NetDevOp.

To iterate a few points about pyATS and Genie:

* pyATS and Genie are developped and used as the de-facto testing library and solution in Cisco.
* Genie is the Python library to use to automate your network!
* It is **free** of use and all the libraries are [open source](https://github.com/CiscoTestAutomation).
* Internal and external version is exactly the same.
* New libraries and innovation are being released as we speak!
* Genie libraries can be used in many shapes:
    * With the [Genie cli](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)
    * RobotFramework [Genie library](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html)
    * As a pure [Python library](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/)


This workshop is an excellent starting point to automate your network; Genie
Cli is easy to use and very powerful, and requires no previous knowledge.
RobotFramework is a great step towards automation, but without focusing too
much on the language syntax. And for more advanced user, you can dig straight
into the documentation and the code and get started!
