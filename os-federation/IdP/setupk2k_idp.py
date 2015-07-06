import os

from keystoneclient import session as ksc_session
from keystoneclient.auth.identity import v3
from keystoneclient.v3 import client as keystone_v3

try:
    # Used for creating the ADMIN user
    OS_PASSWORD = os.environ['OS_PASSWORD']
    #OS_USERNAME = os.environ['OS_USERNAME']
    OS_AUTH_URL = os.environ['OS_AUTH_URL']
    #OS_PROJECT_NAME = os.environ['OS_PROJECT_NAME']
    OS_DOMAIN_ID = os.environ['OS_DOMAIN_ID']
    OS_PROJECT_ID = os.environ['OS_PROJECT_ID']
    OS_USER_ID = os.environ['OS_USER_ID']

except KeyError as e:
    raise SystemExit('%s environment variable not set.' % e)

def client_for_admin_user():
    auth = v3.Password(auth_url=OS_AUTH_URL,
                       user_id=OS_USER_ID,
                       user_domain_name=OS_DOMAIN_ID,
                       password=OS_PASSWORDj,
                       #project_domain_name="default",
                       project_id=OS_PROJECT_ID)
    session = ksc_session.Session(auth=auth)
    return keystone_v3.Client(session=session)

# Used to execute all admin actions
client = client_for_admin_user()
print "print user list to verify client object"
print client.users.list()

SP_url="http://128.52.181.121:5000/Shibboleth.sso/SAML2/ECP"
AUTH_url="http://128.52.181.121:5000/v3/OS-FEDERATION/identity_providers/keystone-idp/protocols/saml2/auth"


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
