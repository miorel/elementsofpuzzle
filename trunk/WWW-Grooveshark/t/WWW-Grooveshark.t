use Test::More tests => 32;

my $config_file;
BEGIN {
	$config_file = 'config';
	diag(<<"NOTE");


NOTE: This test takes additional configuration to run all tests.
See $config_file.example for details.


NOTE
	use_ok('WWW::Grooveshark')
};

my $gs;
ok($gs = WWW::Grooveshark->new, 'new() returns true value');

SKIP: {
	# configurable values
	our($api_key);

	# grab the config file
	if(-e $config_file) {
		require $config_file;
	}

    my $conn_ok;
    eval 'use Net::Config qw(%NetConfig); $conn_ok = $NetConfig{test_hosts}';
    skip 'Net::Config needed for network-related tests', 30 if $@;
    skip 'No network connection', 30 unless $conn_ok;

	my $r;

	# test sessionless service_ping()
	ok($gs->service_ping, 'sessionless service_ping() returns true value');

	diag_skip('API key not defined, skipping remaining tests', 29)
		unless defined $api_key;

	# test session_start()
	ok($r = $gs->session_start(apiKey => $api_key),
		'session_start() returns true value');

	diag_skip('Problem starting session: ' . $r->fault_line, 28)
		if $r->is_fault;

	# test service_ping()
	ok($gs->service_ping, 'service_ping() returns true value');
	
	# test session_id()
	ok($gs->sessionID, 'sessionID() returns true value');
	is($r->sessionID, $gs->sessionID, 'sessionID() returns expected value');
	
	# test session_get()
	ok($r = $gs->session_get, 'session_get() returns true value');
	is($r->sessionID, $gs->sessionID, 'session_get() returns expected value');
	
	my %search = (query => 'The Beatles', limit => 1);
	my($album_id, $artist_id, $playlist_id, $song_id);

	# test search_albums()
	ok($gs->search_albums(%search)->albums,
		'search_albums() returns expected structure');

	# test popular_getAlbums()
	$r = $gs->popular_getAlbums(limit => 1);
	ok($r->albums, 'popular_getAlbums() returns expected structure');
	$album_id = ($r->albums)[0]->{albumID};

	# test album_about()
	ok($r = $gs->album_about(albumID => $album_id),
		'album_about() returns true value');
	is($r->albumID, $album_id, 'album_about() returns expected value');

	# test album_getSongs()
	ok($r = $gs->album_getSongs(albumID => $album_id, limit => 1),
		'album_getSongs() returns true value');
	is(($r->songs)[0]->{albumID}, $album_id,
		'album_getSongs() returns expected value');

	# test search_artists()
	ok($gs->search_artists(%search)->artists,
		'search_artists() returns expected structure');

	# test popular_getArtists()
	$r = $gs->popular_getArtists(limit => 1);
	ok($r->artists, 'popular_getArtists() returns expected structure');
	$artist_id = ($r->artists)[0]->{artistID};

	# test artist_about()
	ok($r = $gs->artist_about(artistID => $artist_id),
		'artist_about() returns true value');
	is($r->artistID, $artist_id, 'artist_about() returns expected value');

	# test artist_getAlbums()
	ok($r = $gs->artist_getAlbums(artistID => $artist_id, limit => 1),
		'artist_getAlbums() returns true value');
	is(($r->albums)[0]->{artistID}, $artist_id,
		'artist_getAlbums() returns expected value');

	# test artist_getSongs()
	ok($r = $gs->artist_getSongs(artistID => $artist_id, limit => 1),
		'artist_getSongs() returns true value');
	is(($r->songs)[0]->{artistID}, $artist_id,
		'artist_getSongs() returns expected value');

	# test artist_getSimilar()
	ok($gs->artist_getSimilar(artistID => $artist_id, limit => 1)->artists,
		'artist_getSimilar() returns expected structure');

	# test search_playlists()
	$r = $gs->search_playlists(%search);
	ok($r->playlists, 'search_playlists() returns expected structure');
	$playlist_id = ($r->playlists)[0]->{playlistID};

	# test playlist_about()
	ok($r = $gs->playlist_about(playlistID => $playlist_id),
		'playlist_about() returns true value');
	is($r->playlistID, $playlist_id,
		'playlist_about() returns expected value');

	# test search_songs()
	ok($gs->search_songs(%search)->songs,
		'search_songs() returns expected structure');

	# test popular_getSongs()
	$r = $gs->popular_getSongs(limit => 1);
	ok($r->songs, 'popular_getSongs() returns expected structure');
	$song_id = ($r->songs)[0]->{songID};

	# test song_about()
	ok($r = $gs->song_about(songID => $song_id),
		'song_about() returns true value');
	is($r->song->{songID}, $song_id, 'song_about() returns expected value');
	
	# test session_destroy()
	ok(!$gs->session_destroy->is_fault, 'session_destroy() succeeds');
}

sub diag_skip {
	my $msg = shift;
	diag($msg);
	skip $msg, @_;
}
