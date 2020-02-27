#!/bin/python3
import subprocess as sp
import os

samba_dirs=[]
cmd = sp.check_output("smbd -b | egrep \"LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR\" | cut -d \":\" -f 2 | tr -d \" \"", shell=True).decode("utf-8")
for var in cmd.split('\n'):
    samba_dirs.append(var)
print(samba_dirs[1])
