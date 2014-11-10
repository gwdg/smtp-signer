#!/usr/bin/env perl
use strict;
use warnings;
use Crypt::SMIME;
use Log::Log4perl qw(:easy);
use Config::IniFiles;

use Cwd 'abs_path';
use File::Basename;

my $wd = dirname(abs_path($0));
chdir($wd);

#Initialize config file
my %config;

tie %config, 'Config::IniFiles', ( -file => "../etc/smtp-signer.ini" );


#Paths
my $sign_dir=$config{pathes}{SIGN_DIR};
my $cert_dir=$config{pathes}{CERT_DIR};
my $sendmail=$config{pathes}{SENDMAIL};
my $openssl =$config{pathes}{PASSWORD};

#Error exit codes
my $E_TEMPFAIL=75;
my $E_UNAVAILABLE=69;
my $E_NOMAILADDRESS=71;
my $E_MISSINGPARAMETERS=89;

#Setup logging service
my $log_config = $config{pathes}{LOG_CONFIG};
Log::Log4perl->init($log_config);
my $logger =  Log::Log4perl->get_logger();

#Check if target dir exists
if( ! -d $sign_dir ) {
	$logger->error("GURU MEDITADION: $sign_dir does not exist");
	exit($E_TEMPFAIL);	
}


my @input=<STDIN>;
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

my $output="";
if(!$keycerterror) {
	my $smime = Crypt::SMIME->new();
	$smime->setPrivateKey($key,$cert,$password);
	my $signed = $smime->sign(join("",@input));
	$logger->info("Forwarding signed mail from $from to $to with $sendmail");
        $output = $signed;
}
else {
	$logger->error("No certificate found for $from. Sending unsigned.");
        $output = join("",@input); 
}

open(PIPE,"|$sendmail -f $from -- $to");
print PIPE ($output);
close(PIPE);



