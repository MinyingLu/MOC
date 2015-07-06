import os

from keystoneclient import session as ksc_session  
from keystoneclient.auth.identity import v3  
from keystoneclient.v3 import client as keystone_v3

#try:  
#    # Used for creating the ADMIN user
#    OS_PASSWORD = os.environ['OS_PASSWORD']
#    #OS_USERNAME = os.environ['OS_USERNAME']
#    # This will vary according to the entity:
#    # the IdP or the SP
#    OS_AUTH_URL = os.environ['OS_AUTH_URL']
#    #OS_PROJECT_NAME = os.environ['OS_PROJECT_NAME']
#    #OS_DOMAIN_NAME = os.environ['OS_DOMAIN_NAME']
#    OS_PROJECT_ID = os.environ['OS_PROJECT_ID']
#    OS_USER_ID = os.environ['OS_USER_ID']
#except KeyError as e:  
#    raise SystemExit('%s environment variable not set.' % e)

def client_for_admin_user():  
    auth = v3.Password(auth_url="http://128.52.181.124:5000/v3",
                       user_id="b647db0cbc694983908234b64ad2af4b",
		       user_domain_name="default",
                       password="nomoresecrete",
		       project_domain_name="default",
                       project_id="37c3b05f16d54d9f98fe4c626f01f9b6")
    session = ksc_session.Session(auth=auth)
    return keystone_v3.Client(session=session)

# Used to execute all admin actions
client = client_for_admin_user()
print client.users.list()
