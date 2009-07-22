#!/usr/bin/perl

use warnings;
use strict;

use LWP::Simple;
use Net::Twitter;
use Term::ReadKey;

my($twitter_user, $twitter_pass, $tweet_count, @tweeps);

print STDERR "Twitter username: ";
chomp($twitter_user = <STDIN>);

print STDERR "Twitter password: ";
ReadMode('noecho');
chomp($twitter_pass = ReadLine(0));
ReadMode('restore');
print STDERR "\n";

print STDERR "Tweet count: ";
chomp($tweet_count = <STDIN>);

print STDERR "Tweeps to analyze (space-separated): ";
$_ = <STDIN>;
chomp;
@tweeps = split /\s+/;

my $t = Net::Twitter->new(
	traits   => [qw/API::REST/],
	username => $twitter_user,
	password => $twitter_pass,
);

for(sort {$a->{id} <=> $b->{id}} map {@{$t->user_timeline({id => $_, since_id => 1, count => $tweet_count})}} @tweeps) {
	my $url = $_->{text};
	for($url =~ /\bhttp:\/\/[a-z0-9\.\/\%]+/ig) {
		my $content = get($_);
		if($content =~ /<title>(.*?)<\/title>/i) {
			my $title = $1;
			print "$_ $title\n";
		}
	}
}
