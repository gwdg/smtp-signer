#!/usr/bin/env perl
use strict;
use warnings;
use Crypt::SMIME;
use Log::Log4perl qw(:easy);
use Cwd 'abs_path';
use File::Basename;





my $wd = dirname(abs_path($0));
chdir($wd);

#Initialize config file
my %config = readConfig("../etc/smtp-signer.conf");

if(!%config) {
	die "Could not read config file";
}

#Paths
my $sign_dir   = $config{SIGN_DIR};
my $cert_dir   = $config{CERT_DIR};
my $sendmail   = $config{SENDMAIL};
my $log_config = $config{LOG_CONFIG};
my $password   = $config{PASSWORD};

#Error exit codes
my $E_TEMPFAIL=75;
my $E_UNAVAILABLE=69;
my $E_NOMAILADDRESS=71;
my $E_MISSINGPARAMETERS=89;

my $currentState;

#Setup logging service
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
	$logger->info("OK: signed from $from to $to");
        $output = $signed;
}
else {
	$logger->info("OK: unsigned from $from to $to");
        $output = join("",@input); 
}

if(open(PIPE,"|$sendmail @ARGV")) {
	print PIPE ($output);
	close(PIPE);
} else {
	$logger->error("FAIL: $!");
}



sub readConfig {
	my $filename = shift;
	my %result = ();
	if(open(CONFFILE,"<$filename")) {
		while(<CONFFILE>) {
			my $line = $_;
			next if ($line =~ m/\s*#/);
			chomp($line);
			my ($key,$value)=split(/=/,$line);
			$value =~ s/"//g;
			$result{$key} = $value;
		}
		return %result;
	}
	else {
		return undef;	
	}
}

