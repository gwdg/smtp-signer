#!/usr/bin/env perl

$T_HOST = $ENV{'T_HOST'};
$T_USER = $ENV{'T_USER'};
$T_PASS = $ENV{'T_PASS'};
$T_FROM = $ENV{'T_FROM'};
$T_TO   = $ENV{'T_TO'};

use Net::SMTP;

$smtp = Net::SMTP->new($T_HOST,
  Hello => $T_HOST,
  Debug => 10
);

if ($smtp->auth($T_USER,$T_PASS)) {
  $smtp->mail($T_FROM);
  if ($smtp->to($T_TO)) {
    $smtp->data();
    $smtp->datasend("To: $T_TO\n");
    $smtp->datasend("Subject: smtp-signer test mail | Perl (mail.pl)\n");
    $smtp->datasend("\n");
    $smtp->datasend("This test mail should have been signed.\n");
    $smtp->dataend();
  } else {
    print "Error: ", $smtp->message();
  }
} else {
  print "Error: ", $smtp->message();
}

$smtp->quit;

