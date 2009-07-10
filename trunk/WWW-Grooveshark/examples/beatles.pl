#!/usr/bin/perl

use warnings;
use strict;

use WWW::Grooveshark;

# modify the following line to try this example
my $api_key = 'deadbeef';

my $gs = WWW::Grooveshark->new;

my $r;
$r = $gs->session_start(apiKey => $api_key) or do {
	printf STDERR "ERROR: " . $r->fault_line;
	exit(1);
};

for($gs->search_songs(query => "The Beatles", limit => 10)->songs) {
	printf("%s", $_->{songName});
	printf(" by %s", $_->{artistName});
	printf(" on %s", $_->{albumName});
	printf(" <%s>\n", $_->{liteUrl});
}
  
$gs->session_destroy;

