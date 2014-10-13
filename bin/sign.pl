#!/usr/bin/env perl
use strict;
use warnings;
use Crypt::SMIME;
use Email::MIME;
use Log::Log4perl qw(:easy);

#Paths
my $sign_dir="/var/spool/sign";
my $cert_dir="/opt/smtp-signer/certs";
my $sendmail="/usr/sbin/sendmail -G -i";
my $openssl="/usr/bin/openssl";

#Error exit codes
my $E_TEMPFAIL=75;
my $E_UNAVAILABLE=69;
my $E_NOMAILADDRESS=71;
my $E_MISSINGPARAMETERS=89;

#Setup logging service
my $log_config = "/opt/smtp-proxy/bin/log4perl.conf";
Log::Log4perl->init($log_config);
my $logger =  Log::Log4perl->get_logger();

#Check if target dir exists
if( ! -d $sign_dir ) {
	$logger->error("GURU MEDITADION: $sign_dir does not exist");
	exit($E_TEMPFAIL);	
}


my @input=<STDIN>;
my $parsed = Email::MIME->new(join("",@input));
my $from = "";
my $to = "";
$logger->info("Number of parameters:" . scalar(@ARGV));
if(scalar(@ARGV) >3) {
	$from = $ARGV[1];
	$to = $ARGV[3];
}
else{
	exit($E_MISSINGPARAMETERS);
}
#if($from !~ m/^.+@.+\..+}$/) {
#	exit($E_NOMAILADDRESS);
#	
#}

my $cert_file="$cert_dir" . "/" .$from . "_cert.pem";
my $key_file ="$cert_dir" . "/" .$from . "_key.pem";
my $key ="";
my $cert = "";
my $password ="siehabenpost";
my $keycerterror = 0;
if ( -f "$cert_file" and -f "$key_file") {
	if(open(KEY,"<$key_file")) {
		my @keyinput = <KEY>;
		$key = join("",@keyinput);
		close(KEY);
	}
	else {
		$keycerterror = 1;
	}
	if(open(CERT,"<$cert_file")) {
		my @certinput = <CERT>;
		$cert = join("",@certinput);
		close(CERT);
	}
	else {	
		$keycerterror = 2;
	}
}
else
{	
	$keycerterror = 3;
}

if(!$keycerterror) {
	my $smime = Crypt::SMIME->new();
	$smime->setPrivateKey($key,$cert,$password);
	my $signed = $smime->sign(join("",@input));
	$logger->info($signed);
	open(PIPE,"|$sendmail -f $from -- $to");
	print PIPE ($signed);
	close(PIPE);
}
else {
	$logger->error("Error $keycerterror with certificates\n$cert_file\n$key_file\n");
}




