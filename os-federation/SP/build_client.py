import os

from keystoneclient import session as ksc_session  
from keystoneclient.auth.identity import v3  
from keystoneclient.v3 import client as keystone_v3

def client_for_admin_user():  
    auth = v3.Password(auth_url="http://128.52.183.216:5000/v3",
                       user_id="aa43b03c0d3740418d7d785e504a9fcc",
                       password="nomoresecrete",
                       project_id="dc00b3b49b444c35aca7c174e2774b23")
    session = ksc_session.Session(auth=auth)
    return keystone_v3.Client(session=session)

# Used to execute all admin actions
client = client_for_admin_user()  
print client.users.list()
auth = v3.Password(auth_url="http://128.52.183.216:5000/v3",
                   user_id="aa43b03c0d3740418d7d785e504a9fcc",
                   password="nomoresecrete",
                   project_id="dc00b3b49b444c35aca7c174e2774b23")
session = ksc_session.Session(auth=auth)


