#!/usr/bin/env python

# Script takes usename and vlan as arguments then inserts
# the following feilds to the person's LDAP entery:
#
#    objectClass: radiusprofile
#    radiusTunnelMediumType: "IPv4"
#    radiusTunnelPrivateGroupId: 41
#    radiusTunnelType: GRE
#

import os
import sys
import ldap
import ldap.modlist as modlist

#NEED REAL SETTINGS!
LDAP_SERVER_URL="ldap://ldap.example.net/"
BIND_PATH="cn=root,dc=example,dc=net"

def getUser(username):
	searchScope = ldap.SCOPE_SUBTREE
	retrieveAttributes = None 
	searchFilter = "cn="+username
	

if __name__ == '__main__':
	if len(sys.argv) < 3:
                print "Usage:\n\t %s username vlan\n" % sys.argv[0]
		print "This will add the VLAN settings to the users LDAP entry."
                sys.exit(1)

	if "LDAP_PASS" not in os.environ:
		print "You need the LDAP password in your environment"
		print "Set with `LDAP_PASSWORD=changeme`"
		sys.exit(1)

	username = sys.argv[1]
	vlan = sys.argv[2]
	password = os.environ['LDAP_PASS']

	# Open a connection
	try:
		directoryServer = ldap.initialize(LDAP_SERVER_URL)
		directoryServer.start_tls_s()
		directoryServer.simple_bind_s(BIND_PATH, password)
	except ldap.INVALID_CREDENTIALS:
		print "Username or Password incorrect."
	except ldap.LDAPError, e:
		print "Error connecting to LDAP server " + LDAP_SERVER_URL
		if type(e.message) == dict and e.message.has_key('desc'):
			print e.message['desc']
		else:
			print e
		sys.exit()

	dn="uid="+username+",ou=People,dc=base,dc=runtime-collective,dc=com"
	extra_values = [
		( ldap.MOD_ADD, 'objectClass', 'radiusProfile' ),
		( ldap.MOD_ADD, 'radiusTunnelMediumType', 'IPv4' ),
		( ldap.MOD_ADD, 'radiusTunnelPrivateGroupId', str(vlan) ),
		( ldap.MOD_ADD, 'radiusTunnelType', 'GRE' )
	] 
	
	try:	
		print "Applying change to " + dn
		directoryServer.modify_s(dn, extra_values)
	except ldap.LDAPError, e:
		print "Error while appliying modification"
		print e

	directoryServer.unbind()


