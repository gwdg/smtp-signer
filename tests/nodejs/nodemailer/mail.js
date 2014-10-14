#!/usr/bin/env node

var nodemailer = require('nodemailer')

var T_HOST = process.env.T_HOST
var T_USER = process.env.T_USER
var T_PASS = process.env.T_PASS
var T_FROM = process.env.T_FROM
var T_TO   = process.env.T_TO

var options = {
  host: T_HOST,
  secure: true,
  auth: {
    user: T_USER,
    pass: T_PASS
  }
}

var transporter = nodemailer.createTransport( options ); // smptTransport(options) );
transporter.sendMail({
  from: T_FROM,
  to:   T_TO,
  subject: "smtp-signer test mail | NodeJS (nodemailer/mail.js) ",
  text: "This test mail should have been signed.\n"
});

