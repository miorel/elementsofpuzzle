#!/usr/bin/perl

use warnings;
use strict;

use WWW::Grooveshark;

my $api_key = shift or do {
	print STDERR "You must specify a Grooveshark API key on the command line\n";
	exit 1;
};

my $gs = WWW::Grooveshark->new;
$gs->session_start(apiKey => $api_key) or die "Uh oh, couldn't start an API session";

while(<STDIN>) {
	chomp;
	my $query = $_;
	$query =~ s/(\s|\b)(?:youtube|\-|http\S*|video|song)(?=\s|\b)//ig;
	$query =~ s/^\s//;
	eval {
		my $song = $gs->search_songs(query => $query, limit => 1)->songs->[0];
		my $song_name = $song->{songName};
		my $artist_name = $song->{artistName};
		my $url = $gs->tinysong_create(songID => $song->{songID})->tinySongUrl;
		$_ = "$_ $url $song_name by $artist_name";
	};
	print "$_\n;";
}
