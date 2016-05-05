#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import email
import smtplib
from string import Template


def sendUserDetailsEmail(toAddr, fromAddr, fullname, username, password):
        host = "mail.example.com"
        port = 465
        try:
                mailserver = smtplib.SMTP_SSL(host,port)
        except smtplib.SMTPException:
                print "Error connecting to server %s on port %d" % (host, port)
                sys.exit(1)


        toAddrLine = "To: "+toAddr+"\r\n"
        fromAddrLine = "From: "+fromAddr+"\r\n"
        date = "Date: Mon, 11 May 2015 12:30:00 +0100\r\n"
        subject = "Subject: Login details\r\n\r\n"
        body = '''
Hello %s,
Your account has just been setup. Your access details are:

Username: %s
Password: %s
URL: http://newservice.example.com

        ''' % (fullname, username, password)
        msg = toAddrLine + fromAddrLine + subject + body
        mailserver.sendmail(fromAddr, toAddr, msg)



#int main()
if __name__ == '__main__':
	if len(sys.argv) < 5:
                print "Usage:\n\t %s firstname lastname username password\n" % sys.argv[0]
                sys.exit(1)

	domain = "example.com"	
	fullname = sys.argv[1] + " " + sys.argv[2]
	username = sys.argv[3]
	toAddr = '%s@%s' % (username, domain)
	fromAddr = 'bob@example.com'
	password = sys.argv[4]
	
	print 'Emailing %s at %s from %s with Username: %s and Password: %s' % (fullname, toAddr, fromAddr, username, password)
	print "Not really you'll need to edit this script to make it work!"
	#sendUserDetailsEmail(toAddr, fromAddr, fullname, username, password)
	
