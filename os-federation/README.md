## Overview
This set up follows [rodrigods' tutorial](http://blog.rodrigods.com/it-is-time-to-play-with-keystone-to-keystone-federation-in-kilo/) of how to set up K2K for kilo. This is for Devstack environment in Kilo with Keystone v3

Things to do:
* solve the domain requirement in policy.json
* openrc file doesn't contain domain id by default 

This is document is a side note of radrigod's tutorial. It is **not** a thorough explaination of everything. 

`keystone.sp` = IP address of sp + `:5000`

`keystone.idp` = IP address of idp + `:5000`

### Set up environment

`devstack-os` folder contains vagrant recipe to spin up 3 devstack kilo openstack environment on csail environment 

Important thing is, by default devstack kilo has keystone v2, so to switch to keyston v3 we follow [this](http://www.symantec.com/connect/blogs/how-switch-keystone-v20-v3) tutorial

And then you can follow rodrigod's tutorial to setup keystone.conf and attribute and shibbothle xml files 

### Set up SP 
* `Attribute` in `/etc/shibboleth/attribute-map.xml` is use for mapping the incoming client from IdP. For example, remote client will be `"type": "openstack_user"`
* `idp_entity_id` in `keystone.conf` file has to match with `SSO entityID` in `/etc/shibboleth/shibboleth2.xml` 
* make sure to edit `[saml]` section in `keyston.conf` file in **both** IdP and SP
* The `build_client.py` script creates a client for admin user in SP
* The `setupk2k_sp.py` script sets up IdP in SP, it creates the client for admin user, domain, group, role and project for federatoin and assign roles to the group, it also creates mapping, idp and protocol.
  * Federated user and group1 (i.e. user and group that has granted premission from IdP to get service from SP) will be mapped to `openstack_user` which is specified in `attributes` 
  * Federated user/group only have access to projects/domains that they have roles for. i.e. For a federated user/group to access a project in SP, we have to grant a role of the project to the federated user/group
  * The id for IdPi (I call it **idp_id** in the following document) is the id we specify in `create_idp` function 
  * THe id for protocal (**protocal_id**) and mapping (**mapping_id**) are also as we specified in `create_protocol` and `create_mapping` functions

### Set up IdP 
* `setupk2k_idp` script sets up SP in idp. 
  * `sp_url` = IP address for SP + `:5000` + `/Shibboleth.sso/SAML2/ECP`
  * `auth_url` = IP address for SP + `:5000` + `/v3/OS-FEDERATION/identity_providers/` + `idp_id` + `/protocols/` + `protocol_id` + `/auth`
  * Id for SP in IdP (**sp_id**) is specified in `create_sp` function.
  
* `k2kclient.py` script gets unscoped token from SP, list availiabe projects/domains for federated user/group, and get scoped token using the unscoped token and project/group id
  * Strange bug: header `X-Auth-Token` can't be processed, but `x-auth-token` works 
  * `client.scoped_topen` is the full scoped token for the specific project/domain
  * `client.scoped_token_id` is the `X-Subject-Token` value
