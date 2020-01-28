# Take initial snapshot of the operational state of the device
# and save the output to a file

*** Settings ***
# Importing test libraries, resource files and variable files.
Library        genie.libs.robot.GenieRobot
Library        pyats.robot.pyATSRobot


*** Variables ***
# Define the pyATS testbed file to use for this run
${testbed}     disaster-tb.yaml 

*** Test Cases ***
# Creating test cases from available keywords.

Connect
    # Initializes the pyATS/Genie Testbed
    use genie testbed "${testbed}"

    # Connect to both device
    connect to device "nx-osv-1"
    connect to device "csr1000v-1"

Profile the devices
    Profile the system for "bgp;config;interface;platform;ospf;arp;vrf;vlan" on devices "nx-osv-1;csr1000v-1" as "./new_snapshot"

Compare snapshots
    Compare profile "./good_snapshot" with "./new_snapshot" on devices "nx-osv-1;csr1000v-1"
