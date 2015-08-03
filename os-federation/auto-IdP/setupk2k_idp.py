import os

from keystoneclient import session as ksc_session
from keystoneclient.auth.identity import v3
from keystoneclient.v3 import client as keystone_v3

def client_for_admin_user():
    auth = v3.Password(auth_url="http://128.52.183.234:5000/v3",
                       user_id="caf9b2e813aa41f4b12eb6f46241828c",
                       password="nomoresecrete",
                       project_id="a0683f4059654c63ae4f1663b461088d")
    session = ksc_session.Session(auth=auth)
    return keystone_v3.Client(session=session)

# Used to execute all admin actions
client = client_for_admin_user()
print "print user list to verify client object"
print client.users.list()

SP_url="http://128.52.183.216:5000/Shibboleth.sso/SAML2/ECP"
AUTH_url="http://128.52.183.216:5000/v3/OS-FEDERATION/identity_providers/keystone-idp/protocols/saml2/auth"


def create_sp(client, sp_id, sp_url, auth_url):  
        sp_ref = {'id': sp_id,
                  'sp_url': sp_url,
                  'auth_url': auth_url,
                  'enabled': True}
        return client.federation.service_providers.create(**sp_ref)

print('\nCreate SP')  
create_sp(client,  
          'keystone-sp',
          SP_url,
          AUTH_url)
