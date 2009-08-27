#!/usr/bin/perl

use warnings;
use strict;

use WWW::Grooveshark;

# specify an API key to try this example or pass in on the command line
my $api_key = shift || 'deadbeef';

my $gs = WWW::Grooveshark->new;

my $r;
$r = $gs->session_start(apiKey => $api_key) or do {
	printf STDERR "ERROR: " . $r->fault_line;
	exit(1);
};

try_use(qw(Net::Twitter Term::ReadKey));

my($twitter_user, $twitter_pass, $tweet_count);

print STDERR "Twitter username: ";
chomp($twitter_user = <STDIN>);

print STDERR "Twitter password: ";
ReadMode('noecho');
chomp($twitter_pass = ReadLine(0));
ReadMode('restore');
print STDERR "\n";

print STDERR "Tweet count: ";
chomp($tweet_count = <STDIN>);

my $t = Net::Twitter->new(
	traits   => [qw/API::REST/],
	username => $twitter_user,
	password => $twitter_pass,
);

for(@{$t->user_timeline({since_id => 1, count => $tweet_count})}) {
	my $text = $_->{text};
	for($text =~ /\bhttp:\/\/tinysong.com\/[a-z0-9]+/ig) {
		my $r = $gs->tinysong_getExpandedUrl(tinySongUrl => $_);
		if($r) {
			$r = $gs->song_about(songID => $r->songID);
			printf("\"%s\" by %s", $r->song->{songName}, $r->song->{artistName}) if $r;
		}
		print "[Error looking at $_]" unless $r;
		print " ($text)\n";
	}
}

sub try_use {
	for(@_) {
		eval "use $_";
		if($@) {
			printf STDERR "Problem using $_\n";
			exit(1);
		}
	}
}
