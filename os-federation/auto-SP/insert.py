import sys, fileinput, re
idp_ip = sys.argv[1]

def modify_sp_keyconf(idp_ip):  
    fh=fileinput.input('/etc/keystone/keystone.conf',inplace=True)  
    for line in fh:  
        repl_auth=line + 'methods = external,password,token,oauth1,saml2' + '\n' + 'saml2 = keystone.auth.plugins.mapped.Mapped'  
        line=re.sub('\[auth\]', repl_auth, line)  
        sys.stdout.write(line) 
    fh.close()  

modify_sp_keyconf(idp_ip)

def modify_apache2_keyconf():
    fh=fileinput.input('/etc/apache2/site-available/keystone.conf', inplace=True)
    for line in fh:
        repl=line + '    WSGIScriptAliasMatch ^(/v3/OS-FEDERATION/identity_providers/.*?/protocols/.*?/auth)$ /var/www/keystone/main/$1'
        line=re.sub('\<VirtualHost \*\:5000\>', repl, line)
        sys.stdout.write(line)
    fh.close()

    text = '<Location /Shibboleth.sso>\n' + '    SetHandler shib\n' + '</Location>\n\n' + '<LocationMatch /v3/OS-FEDERATION/identity_providers/.*?/protocols/saml2/auth>\n' + '    ShibRequestSetting requireSession 1\n' + '    AuthType shibboleth\n' + '    ShibExportAssertion Off\n' + '    Require valid-user\n' + '</LocationMatch>'
    with open('/etc/apache2/site-available/keystone.conf', 'a') as file:
        file.write(text)

modify_apache2_keyconf()

#def modify_map_xml():
#    fh=fileinput.input('attribute-map.xml', inplace=True)
#    for line in fh:
#        repl=line + '    <Attribute name="openstack_user" id="openstack_user"/>\n' + '    <Attribute name="openstack_roles" id="Member"/>\n' + '    <Attribute name="openstack_project" id="fed-demo"/>'
#        line=re.sub('*XMLSchema\-instance\>', repl, line)
#        sys.stdout.write(line)
#    fh.close()
#
#modify_map_xml()
