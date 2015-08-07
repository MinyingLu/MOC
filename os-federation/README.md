## Overview
This set up follows [rodrigods' tutorial](http://blog.rodrigods.com/it-is-time-to-play-with-keystone-to-keystone-federation-in-kilo/) of how to set up K2K for kilo. This is for Devstack environment in Kilo with Keystone v3

This is document is a side note of radrigod's tutorial. It is **not** a thorough explaination of everything. 

`keystone.sp` = IP address of sp + `:5000`

`keystone.idp` = IP address of idp + `:5000`

## **Automation** 

This is a kind of ugly way of automating but I guess it's better than nothing.

There are some very bad practices in here...remember [**Never use regex to to phars XML/HTML**](http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags)

**1.download this folder**

Make sure you have `auto-IdP`, `auto-SP` and `devstack-k2k`, in the same place. 

**2. vagrant up** 

```
cd devstack-k2k
vagrant up --no-provision
vagrant provision
```

Here I do `vagrant up` and `vagrant provision` seperately because I want two ip addresses that are right next to each other..If you don't care about that you can just run `vagrant up` which will bring up two vms sequentially.

If you are curious, the Vagrantfile is the recipe of automatically bring up two vms `k2k-idp` and `k2k-sp` note that the **name here does matter** so don't change it unless you know what you are doing. 

**3. ssh into the vms set up the environment**

First copy the openrc file for **both** idp and sp

```
cp ~/devstack/accrc/admin/admin ~
```

**IMPORTANT** you have to modify the accrc file to export OS_PROJECT_ID, OS_USER_ID and OS_AUTH_URL

* `OS_PROJECT_ID` and `OS_USER_ID` are commented out in the admin rc file, you just need to export it
* `OS_AUTH_URL` is set to /v2.0 right now, we want it to be /v3

Second set up k2k-sp

```
cd ~/SP
source ~/admin
./env.sh
```

Third set up k2k-idp

```
cd ~/IdP
./env.sh
```

And this will give you the scoped token

If you want more explainaion read through the rest of the README 

### Set up environment

`devstack-k2k` folder contains vagrant recipe to spin up 2 devstack kilo openstack environment on csail environment 

This in progress of automating the deployment of a pair of openstack with k2k setup

### Set up SP 
* `Attribute` in `/etc/shibboleth/attribute-map.xml` is use for mapping the incoming client from IdP. For example, remote client will be `"type": "openstack_user"`
* `idp_entity_id` in `keystone.conf` file has to match with `SSO entityID` in `/etc/shibboleth/shibboleth2.xml` 
* make sure to edit `[saml]` section in `keyston.conf` file in **both** IdP and SP
* The `build_client.py` script creates a client for admin user in SP
* The `setupk2k_sp.py` script sets up IdP in SP, it creates the client for admin user, domain, group, role and project for federatoin and assign roles to the group, it also creates mapping, idp and protocol.
  * Federated user and group1 has to be in the project that you are planning to do keystone federation with, i.e. the project the unscoped federated token will scope to
  * Federated user and group1 (i.e. user and group that has granted premission from IdP to get service from SP) will be mapped to `openstack_user` which is specified in `attributes` 
  * Federated user/group only have access to projects/domains that they have roles for. i.e. For a federated user/group to access a project in SP, we have to grant a role of the project to the federated user/group
  * The id for IdP (**idp_id** in the following document) is the id we specify in `create_idp` function 
  * THe id for protocal (**protocal_id**) and mapping (**mapping_id**) are also as we specified in `create_protocol` and `create_mapping` functions

### Set up IdP 
* `setupk2k_idp` script sets up SP in idp. 
  * `sp_url` = IP address for SP + `:5000` + `/Shibboleth.sso/SAML2/ECP`
  * `auth_url` = IP address for SP + `:5000` + `/v3/OS-FEDERATION/identity_providers/` + `idp_id` + `/protocols/` + `protocol_id` + `/auth`
  * Id for SP in IdP (**sp_id**) is specified in `create_sp` function.
  
* `k2kclient.py` script gets unscoped token from SP, list availiabe projects/domains for federated user/group, and get scoped token using the unscoped token and project/group id
  * Strange bug: header `X-Auth-Token` can't be processed, but `x-auth-token` works 
  * `client.scoped_token` is the full scoped token for the specific project/domain (str)
