## Overview

This is specifically for spinning up 2 ubuntu14.04 instances in csail environment, using my own keypair, instace with 4G RAM, 32G disk, and 1 core.  
This recipe installs devstack kilo with minimal configuration

In order to do K2K federation we need to set up keystone v3 endpoint
see [this link](http://www.symantec.com/connect/blogs/how-switch-keystone-v20-v3)

## Usage 

To change number of instances, at line 24, change 2 desired number of instances 

```
(1..2).each.do |i|
```

To change to your own setting of credential, set everything starts with `os.` accordingly

If using an none ubuntu image, change the following line accordingly

```
devstack.ssh.username = 'ubuntu'
```

