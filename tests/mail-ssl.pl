#!/usr/bin/env perl

use strict;
use warnings;

my $T_HOST = $ENV{'T_HOST'};
my $T_USER = $ENV{'T_USER'};
my $T_PASS = $ENV{'T_PASS'};
my $T_FROM = $ENV{'T_FROM'};
my $T_TO   = $ENV{'T_TO'};

use Net::SMTP::SSL;

my $smtp = Net::SMTP::SSL->new($T_HOST,
  Hello => $T_HOST,
  Debug => 1,
  SSL   => 1
);

print "UAH", $smtp, "\n";

$smtp->auth($T_USER,$T_PASS);

$smtp->mail($T_FROM);
if ($smtp->to($T_TO)) {
  $smtp->data();
  $smtp->datasend("To: $T_TO\n");
  $smtp->datasend("Subject: smtp-signer test mail | Perl (mail-ssl.pl)\n");
  $smtp->datasend("\n");
  $smtp->datasend("This test mail should have been signed.\n");
  $smtp->dataend();
} else {
  print "Error: ", $smtp->message();
}

$smtp->quit;

