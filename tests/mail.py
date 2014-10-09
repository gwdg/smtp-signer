#!/usr/bin/env python

import os, smtplib

T_HOST = os.environ['T_HOST']
T_USER = os.environ['T_USER']
T_PASS = os.environ['T_PASS']
T_FROM = os.environ['T_FROM']
T_TO   = os.environ['T_TO']

T_PORT = 25
smtp = smtplib.SMTP(T_HOST, T_PORT)

smtp.set_debuglevel(10)
smtp.ehlo()
smtp.starttls()
# smtp.login(T_USER,T_PASS)
smtp.sendmail(T_FROM, T_TO, """Subject: smtp-signer test mail | Python (mail.py)
From: %(T_FROM)s
To: %(T_TO)s

This test mail should have been signed.

""" % locals() )

smtp.quit()

