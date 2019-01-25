# Workshop Content

##### Background Settings

In an effort to limit the hardware requirement for this workshop, we are going
to be using **mocked devices**. They behave like *"simulated devices"*, but have
limited interactability.

Note that this workshop does work on actual live devices - as long as you have
the same topology and configuration.

In otherwords, consider all calls to `mock_device_cli` be what you would've
typically done to `telnet` or `ssh` to your device's console.

Type `help` in the device prompt to show the list of supported commands. Note
that only full-commands are accepted. Partial commands will be rejected with
help output. This is a limitation of the mock implementation.

### Step 1 - Without automation - Collect Information Manually

Congratulation, you are in charge of the following network!

![Topology](https://raw.githubusercontent.com/jeaubin/katacoda-scenarios/master/compare/topology.png)

The network is performing as expected. *Your task, should you choose to accept
it*, is to make sure it remains up and operational. If the network experiences
issues, you must react quickly and fix it! (Sounds familiar?)

##### Getting Ready

```bash
cd ~/devnet-2595
source bin/activate
cd workshop
```

#### Manual Investigation

Let's connect to our device and send a few show commands to learn the topology
and configuration.

First, connect to your NXOS device with the command below:

```bash
mock_device_cli --os nxos --mock_data_dir mocked_devices/initial_yamls/nxos --state execute
```

You can send a few show commands to better understand the topology and configuration

- `show running-config`
- `show interface`
- `show ip ospf vrf all`

> NOTE: use `Ctrl+D` to disconnect from the device.

Second, use the following command to connect to your IOSXE/CSR device.

```bash
mock_device_cli --os iosxe --mock_data_dir mocked_devices/initial_yamls/csr --state execute
```

### Step 2 - Without Automation - Catastrophe

**Oh no!**

![oh No!](ohNo.png)

All of sudden, the network is not operating as expected! Without any
automation, can you figure out what happened without going to the previous
step?

```bash
# connect to your NX device
mock_device_cli --os nxos --mock_data_dir mocked_devices/disaster_yamls/nxos --state execute

# connect to your XE device
mock_device_cli --os iosxe --mock_data_dir mocked_devices/disaster_yamls/csr --state execute
```

> Remember: use `Ctrl+D` to disconnect from the device.

This is not an easy task!

Let's see how we handle this in 2019 with Genie!

-------------------------------------------------------------------------------------------------------------

## Let's replay our disaster scenario, but this time using Genie CLI

### Step 3 - Using Genie CLI - Collect information

[Genie offers command line tools](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)
that allows the user to manage their network whilst leveraging the power of
Genie Python libraries, without prerequisite understanding in Python or
automation.

The first step is to learn the good state of the devices.

```bash

# these two environment variables are needed as we are using our Mocked Device.
# When Genie cli is used with real devices, these can be omitted.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/initial_recording
export unicon_speed=10

# run genie CLI
genie learn ospf interface bgp platform --testbed-file testbed.yaml --output learnt
```

Take a moment to look at the output.

Your call to this Genie CLI stores the device output and the parsed datastructure
into a folder called `learnt`.

*Consider this as the sane state snapshot for the testbed you are in charge of.*

Internally, Genie uses its [Models](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/genie_libs/#/models).
to decide which commands to issue, and what to store. Genie feature models
are agnostic across OS, platforms and management protocols (eg, CLI/NETCONF).

With an editor, you can open the two generated files:

* `learnt/ospf_nxos_nx-osv-1_ops.txt`
* `learnt/ospf_nxos_nx-osv-1_console.txt`

The `_ops` file contains the datastructure learnt/parsed from the show
commands for the feature OSPF on the nxos device.

The `_console` file contains all the cli and device output which were sent to the
device to learn OSPF on the nxos device.

Each feature's relevant information is parsed into structured data. Having
structured data open many new possibilities which we will see.

Thats it! We are now ready for our disaster to happen!

### Step 4 - Using Genie CLI - ...all is good

**Oh No**

![oh No!](ohNo.png)

When the same disaster occurs, **Genie to the rescue!**


```bash

# this environment variable is needed as we are using our Mocked Device.
# When Genie cli is used with real devices, these can be omitted.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/disaster_recording

# call genie CLI again
genie learn ospf interface bgp platform --testbed-file testbed.yaml --output disaster
```

You now have a new snapshot of of how your devices are behaving in its
disastrous state, under `disaster` folder.

Now, perform a diff of the states before and after disaster occurance.

```bash
genie diff learnt disaster
```

You can clearly see that the OSPF and interface operational state has changed.

With an editor, open the two files:

* `diff_interface_nxos_nx-osv-1_ops.txt`
* `diff_ospf_nxos_nx-osv-1_ops.txt`

You should see content like this:

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

Similar to typical Linux diff output:

* `-` means this key is now missing or has been modified and this was the old value.
* `+` means this key has been added or been modified and this is the current value.

Right away we see that interface `Ethernet2/1` on the `nxos` device is in
`shutdown` mode and it is affecting our OSPF neighbor. We lost the neighbor
`10.1.1.1`.

Once the problem is pin-pointed, tackling the problem is now much easier.
Investigation will start on why this port is now shutdown and bring it
back up.

[Genie CLI]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html))
is ready for you to use on your own network. Just repeat the same steps on your
network, whenever needed.

> In the last part of this workshop we will try a few more Genie CLI commands.

-----------------------------------------------------------------------------------------------

## Now,let's replay the disaster scenario again, but this time with some automation

### Step 5 - With Genie Robot - Collect information

[RobotFramework](https://robotframework.org) provides a great intermediate step
between no automation and full python. It writes like English text, is keywords
driven and can be extended with external libraries.

[Genie RobotFramework Libs](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html)
exists to allow you to control your network in RobotFramework using the full
power of Genie models.

Our Workshop Robot script tackles the same challenge as earlier:

- learn the good state of the network
- rerun periodically or when a disaster happen to figure out what has happened.

With an editor, open the script below and examine it's content:

- `robot_initial_snapshot/robot_initial_snapshot.robot`

The Robot language is keyword based, which makes reading this script quite easy.
Without much effort, you should see that this script does the following:

* Load Genie Library
* Connect to the two devices
* Learn bgp, interface, platform, ospf and the device configuration and save it to file.

Let's run the script

```bash

# this environment variable is needed as we are using our Mocked Device.
# When Genie cli is used with real devices, these can be omitted.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/initial_recording

# run robot script
cd robot_initial_snapshot
robot --outputdir run robot_initial_snapshot.robot
```

RobotFramework generates its own log files. You can open the `run/log.html` with a
web browser to view it.

Our good snapshot was saved as file `robot_initial_snapshot/good_snapshot`; we
are now ready for a disaster to happen!


### Step 6 - With Genie Robot - ...all is good

**Oh No**

![oh No!](ohNo.png)

**Disaster!**

In the previous step we've taken a snapshot of our network when it was
performing as expected. We will now take a new snapshot and compare with this
previous good snapshot.

With an editor open the script below, and examine it's content:

`robot_compare_snapshot/compare_snapshot.robot`

This is the 2nd RobotFramework based script, which upon running, will:

* Load Genie Library
* Connect to the two devices
* Learn bgp, interface, platform, ospf and the device configuration and save it to file.
* And compare the new snapshot with the original snapshot!

Let's start the script.

```bash

# this environment variable is needed as we are using our Mocked Device.
# When Genie cli is used with real devices, these can be omitted.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/disaster_recording

# run robot script
cd ../robot_compare_snapshot
robot --outputdir run compare_snapshot.robot
```

And again, open the `run/log.html` with a web browser to view the log.

Similar to typical Linux diff:

* `-` means this key is now missing or has been modified and this was the old value.
* `+` means this key has been added or been modified and this is the current value.

You should see the following in your log:

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

and this should allow us to arrive at the same conclusion easily, as with using
Genie CLI.

----------------------------------------------------------------------------------------

### Step 7 - Bonus

Genie CLI and Genie RobotFramework library have tons of extra functionality; let's try a
few of them.


#### Parse cli command with Genie CLI

Devices output can be parsed into structure data with Genie CLI.

```bash

cd ..
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

All others possibilities and arguments are discussed on our [Genie CLI
documentation](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)!


#### Genie Robot Library

So far we've created a very useful comparison script with our Robot keywords.

[Genie robot library]((https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html)
contains many keywords that you can use for writing your script.

The script : `bonus_robot/verify_count.robot` does the following:

* Load Genie Library
* Connect to the two devices
* Verify the number of Bgp neighbors
* Verify the number of Bgp routes
* Verify the number of OSPF neighbor
* Verify the number of up Interfaces

```bash

# this environment variable is needed as we are using our Mocked Device.
# When Genie cli is used with real devices, these can be omitted.
export unicon_replay=~/workspace/devnet-2595/workshop/mocked_devices/bonus_recording

cd bonus_robot
robot --outputdir run verify_count.robot
```

This style of testing is great to run periodically to make sure the state of
your device.


### Conclusion

This conclude this workshop; we hope this session was inspirational and open
possibilities for your own Automation and NetDevOp.

To iterate a few points about pyATS and Genie:

* pyATS and Genie is developed and used as the de-facto testing library and solution in Cisco.
* Genie is **THE** Python library to use to automate your network!
* It is **free** to use and all the libraries are [open source](https://github.com/CiscoTestAutomation).
* The Cisco internal and customer external version of pyATS/Genie is exactly the same.
* New libraries and innovation are being released as we speak!
* Genie libraries can be used in many ways:
    * With the [Genie cli](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/cli.html)
    * RobotFramework [Genie library](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/robot/index.html)
    * As a pure [Python library](https://pubhub.devnetcloud.com/media/pyats-packages/docs/genie/)


This workshop is an excellent starting point to automate your network; Genie
CLI is easy to use and very powerful, and requires no previous knowledge.
RobotFramework is a great step towards automation, but without focusing too
much on the language syntax. And for more advanced user, you can dig straight
into the documentation and the code and get started!
