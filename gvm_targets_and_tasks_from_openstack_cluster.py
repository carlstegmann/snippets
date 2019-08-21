#!/usr/bin/env python3

from gvm.connections import TLSConnection, DebugConnection
from gvm.protocols.latest import Gmp
from gvm.transforms import EtreeCheckCommandTransform
from gvm.errors import GvmError
from gvm.protocols.gmpv7.types import AliveTest

import getpass
import json
import subprocess

# this script is used to create scan targets associated with a scan task for each project with floating ips from openstack floating ip command
# the columns "floating ip address" and "project" will be used, sorted by project column
# tasks will be started manually

# requirements are python-gvm, python-openstackclient, a reachable gvm installation, a sourced openstack project file (*openrc.sh)

def load_json(fname):
    """function for loading json files"""
    with open(fname, 'r') as f:
        fcontent = json.load(f)
    return fcontent

def credentials():
    """function to read a password"""
    password = getpass.getpass(prompt='Please enter your password: ')
    return password

def connect_gvm(username, password):
    """connect via TLS and create a target for gvm this assumes you have connected to gvmd through local ssh forward, if not configure hostname to match hostname or ip address and change the port if needed, this will use the default port 9390"""
    transform = EtreeCheckCommandTransform()
    connection = TLSConnection()
    connection.hostname = '127.0.0.1'
    connection.port = '9390'
    gmp = Gmp(connection=connection, transform=transform)
    gmp.authenticate(username, password)
    return gmp

def create_target(tname, tcomment, thosts, talive, tportlistid):
    """this function is used to create a target inside the gvm"""
    with gmp:
        # create a target in gvm using target definition from above
        response = gmp.create_target(name=tname, hosts=thosts, comment=tcomment, alive_test=talive, port_list_id=tportlistid)
        targetid = response.get('id')
    return targetid

def create_task(tname, configid, targetid, scannerid, tcomment):
    """this function is used to create a task inside the gvm"""
    with gmp:
        # create a task in gvm for a target identified by targetid
        response = gmp.create_task(name=tname, config_id=configid, target_id=targetid, scanner_id=scannerid, comment=tcomment)
        taskid = response.get('id')
    return taskid

if __name__ == '__main__':
    # change the username if needed
    username = 'admin'
    password = credentials()
    # in gmp v7 you need to use talive = 'Consider Alive', in gmp v8 you need the AliveTest enumeration
    talive = AliveTest.CONSIDER_ALIVE
    # the portlistid can be changed if needed
    tportlistid = '4a4717fe-57d2-11e1-9a26-406186ea4fc5'
    # comment for target / task
    tcomment = "could be your clustername"
    # config id for full and fast daba56c8-73ec-11df-a475-002264764cea
    configid = 'daba56c8-73ec-11df-a475-002264764cea'
    # scanner id for openvas default 08b69003-5fc2-4037-a479-93b440211c73
    scannerid = '08b69003-5fc2-4037-a479-93b440211c73'
    # call openstack api and get floating ips, do not forget to source your openstack openrc.sh file before running this script
    # floating ips and project id will be saved in file openstack_ips.json in the working directory
    with open("openstack_ips.json", 'w') as os_json:
        subprocess.run(["openstack", "floating", "ip", "list", "-c", "Project", "-c", "Floating IP Address", "--sort-column", "Project", "-f", "json"], stdout=os_json)
    all_ips = load_json('openstack_ips.json')
    # create a floating ip list per project in a dictionary
    projects = {}
    for ips in all_ips:
        if not ips['Project'] in projects:
            projects[ips['Project']] = []
        projects[ips['Project']].append(ips['Floating IP Address'])
    # create a target for each project in gmp
    for key in projects:
        tname = key
        thosts = projects[key]
        gmp = connect_gvm(username, password)
        targetid = create_target(tname, tcomment, thosts, talive, tportlistid)
        print("Targetid: " + targetid + " for project: " + key)
    # create a task for each target in gmp
    try:
        targets = []
        with gmp:
            gmp.authenticate(username, password)
            targets = gmp.get_targets()
            for target in targets.xpath('target'):
                targetid = target.xpath('@id')
                for element in target.xpath("name"):
                    targetname = str(element.text)
                for element in target.xpath('comment'):
                    targetcomment = str(element.text)
                gmp.authenticate(username, password)
                response = create_task(targetname, configid, targetid[0], scannerid, targetcomment)
                print("Task ID: " + str(response))
    except:
        print("Skipped.")
