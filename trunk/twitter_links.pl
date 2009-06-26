#!/usr/bin/perl

use warnings;
use strict;

use LWP::Simple;
use Net::Twitter;
use Term::ReadKey;

my($username, $password, $count, @users);

print STDERR "Username: ";
chomp($username = <STDIN>);

print STDERR "Password: ";
ReadMode('noecho');
chomp($password = ReadLine(0));
ReadMode('restore');
print STDERR "\n";

print STDERR "Count: ";
chomp($count = <STDIN>);

print STDERR "Users to analyze (space-separated): ";
$_ = <STDIN>;
chomp;
@users = split /\s+/;

my $t = Net::Twitter->new(
	traits   => [qw/API::REST/],
	username => $username,
	password => $password,
);

print "<html><head><title>Links</title></head><body>\n";
for(@users) {
	for(@{$t->user_timeline({id => $_, since_id => 1, count => $count})}) {
		$_ = $_->{text};
		for(/\bhttp:\/\/[a-z0-9\.\/\%]+/ig) {
			my $content = get($_);
			$content =~ /<title>(.*?)<\/title>/i;
			print "<p><a href=\"$_\">$1</a></p>\n";
		}
	}
}
print "</body></html>\n";
