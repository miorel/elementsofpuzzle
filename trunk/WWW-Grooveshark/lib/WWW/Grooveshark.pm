package WWW::Grooveshark;

=head1 NAME

WWW::Grooveshark - Perl wrapper for the Grooveshark API

=head1 SYNOPSIS

  use WWW::Grooveshark;

  # something interesting happens

=head1 DESCRIPTION

Some module is a wonderful piece of software.

=cut

use 5.006;
use strict;
use warnings;

use Carp;
use Digest::MD5 qw(md5_hex);
use JSON::Any;

use WWW::Grooveshark::Response qw(:fault);

our @ISA = ();

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;

=head1 CONSTRUCTOR

Description of reason for constructor

=over 4

=item WWW::Grooveshark->new( %OPTIONS )

Prepares a new L<WWW::Grooveshark> object with the specified options, which are
passed in as key-value pairs, as in a hash.  Accepted options are:

=over 4

=item I<service>

The hostname to use for the Grooveshark API service.  Defaults to
"api.grooveshark.com".

=item I<path>

Path (relative to the hostname) to request for API calls.  Defaults to "ws".

=item I<api_version>

Version of the Grooveshark API you plan on using.  Defaults to 1.0.

=item I<https>

Whether or not to use HTTPS for API calls.  Defaults to false, i.e. just use
HTTP.

=item I<agent>

Value to use for the C<User-Agent> HTTP header.  Defaults to
"WWW::Grooveshark/### libwww-perl/###", where the "###" are substituted with
the appropriate versions.  This is provided for convenience: the user-agent
string can also be set in the C<useragent_args> (see below).  If it's set in
both places, this one takes precedence.

=item I<useragent_class>

Name of the L<LWP::UserAgent> compatible class to be used internally by the 
newly-created object.  Defaults to L<LWP::UserAgent>.

=item I<useragent_args>

Hashref of arguments to pass to constructor of the aforementioned
C<useragent_class>.  Defaults to no arguments.

=back

Options not listed above are ignored.

=cut

sub new {
	my($pkg, %opts) = @_;

	# user-agent constructor args
	my $ua_args = $opts{useragent_args} || {};
	
	# user-agent string
	$ua_args->{agent} = $opts{agent} if defined $opts{agent};
	$ua_args->{agent} ||= __PACKAGE__  . "/$VERSION ";

	# prepare user-agent object
	my $ua_class = $opts{useragent_class} || 'LWP::UserAgent';
	eval "require $ua_class";
	croak $@ if $@;
	my $ua = $ua_class->new(%$ua_args);

	return bless({
		_ua          => $ua,
		_service     => $opts{service}     || 'api.grooveshark.com',
		_path        => $opts{path}        || 'ws',
		_api_version => $opts{api_version} || '1.0',
		_https       => $opts{https}       || '0',
		_session_id  => undef,
		_json        => new JSON::Any,
	}, $pkg);
}

=back

=head1 MANAGEMENT METHODS

=over 4

=item $gs->sessionID( )

=back

=cut

sub sessionID {
	return shift->{_session_id};
}

=head1 API METHODS

=head2 ALBUM

=over 4

=item $gs->album_about( )

=cut

sub album_about {
	my($self, %args) = @_;
	my $ret = $self->_call('album.about', %args);
	return $ret;
}

=item $gs->album_getSongs( )

=cut

sub album_getSongs {
	my($self, %args) = @_;
	my $ret = $self->_call('album.getSongs', %args);
	return $ret;
}

=back

=head2 ARTIST

=over 4

=item $gs->artist_about( )

=cut

sub artist_about {
	my($self, %args) = @_;
	my $ret = $self->_call('artist.about', %args);
	return $ret;
}

=item $gs->artist_getAlbums( )

=cut

sub artist_getAlbums {
	my($self, %args) = @_;
	my $ret = $self->_call('artist.getAlbums', %args);
	return $ret;
}

=item $gs->artist_getSimilar( )

=cut

sub artist_getSimilar {
	my($self, %args) = @_;
	my $ret = $self->_call('artist.getSimilar', %args);
	return $ret;
}

=item $gs->artist_getSongs( )

=cut

sub artist_getSongs {
	my($self, %args) = @_;
	my $ret = $self->_call('artist.getSongs', %args);
	return $ret;
}

=back

=head2 AUTOPLAY

=over 4

=item $gs->autoplay_frown( )

=cut

sub autoplay_frown {
	my($self, %args) = @_;
	my $ret = $self->_call('autoplay.frown', %args);
	return $ret;
}

=item $gs->autoplay_getNextSong( )

=cut

sub autoplay_getNextSong {
	my($self, %args) = @_;
	my $ret = $self->_call('autoplay.getNextSong', %args);
	return $ret;
}

=item $gs->autoplay_smile( )

=cut

sub autoplay_smile {
	my($self, %args) = @_;
	my $ret = $self->_call('autoplay.smile', %args);
	return $ret;
}

=item $gs->autoplay_start( )

=cut

sub autoplay_start {
	my($self, %args) = @_;
	my $ret = $self->_call('autoplay.start', %args);
	return $ret;
}

=item $gs->autoplay_stop( )

=cut

sub autoplay_stop {
	my($self, %args) = @_;
	my $ret = $self->_call('autoplay.stop', %args);
	return $ret;
}

=back

=head2 PLAYLIST

=over 4

=item $gs->playlist_about( )

=cut

sub playlist_about {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.about', %args);
	return $ret;
}

=item $gs->playlist_addSong( )

=cut

sub playlist_addSong {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.addSong', %args);
	return $ret;
}

=item $gs->playlist_create( )

=cut

sub playlist_create {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.create', %args);
	return $ret;
}

=item $gs->playlist_delete( )

=cut

sub playlist_delete {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.delete', %args);
	return $ret;
}

=item $gs->playlist_getSongs( )

=cut

sub playlist_getSongs {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.getSongs', %args);
	return $ret;
}

=item $gs->playlist_moveSong( )

=cut

sub playlist_moveSong {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.moveSong', %args);
	return $ret;
}

=item $gs->playlist_removeSong( )

=cut

sub playlist_removeSong {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.removeSong', %args);
	return $ret;
}

=item $gs->playlist_rename( )

=cut

sub playlist_rename {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.rename', %args);
	return $ret;
}

=item $gs->playlist_replace( )

=cut

sub playlist_replace {
	my($self, %args) = @_;
	my $ret = $self->_call('playlist.replace', %args);
	return $ret;
}

=back

=head2 POPULAR

=over 4

=item $gs->popular_getAlbums( )

=cut

sub popular_getAlbums {
	my($self, %args) = @_;
	my $ret = $self->_call('popular.getAlbums', %args);
	return $ret;
}

=item $gs->popular_getArtists( )

=cut

sub popular_getArtists {
	my($self, %args) = @_;
	my $ret = $self->_call('popular.getArtists', %args);
	return $ret;
}

=item $gs->popular_getSongs( )

=cut

sub popular_getSongs {
	my($self, %args) = @_;
	my $ret = $self->_call('popular.getSongs', %args);
	return $ret;
}

=back

=head2 SEARCH

=over 4

=item $gs->search_albums( )

=cut

sub search_albums {
	my($self, %args) = @_;
	my $ret = $self->_call('search.albums', %args);
	return $ret;
}

=item $gs->search_artists( )

=cut

sub search_artists {
	my($self, %args) = @_;
	my $ret = $self->_call('search.artists', %args);
	return $ret;
}

=item $gs->search_playlists( )

=cut

sub search_playlists {
	my($self, %args) = @_;
	my $ret = $self->_call('search.playlists', %args);
	return $ret;
}

=item $gs->search_songs( )

=cut

sub search_songs {
	my($self, %args) = @_;
	my $ret = $self->_call('search.songs', %args);
	return $ret;
}

=back

=head2 SERVICE

=over 4

=item $gs->service_ping( )

=cut

sub service_ping {
	my($self, %args) = @_;
	my $ret = $self->_call('service.ping', %args);
	return $ret;
}

=back

=head2 SESSION

=over 4

=item $gs->session_createUserAuthToken( )

=cut

sub session_createUserAuthToken {
	my($self, %args) = @_;
	
	# make hashpass, unless it already exists
	if(exists($args{hashpass})) {
		delete $args{pass};
	}
	else {
		if(exists($args{username}) && exists($args{pass})) {
			$args{hashpass} = md5_hex($args{username}, md5_hex($args{pass}));
			delete $args{pass};
		}
		else {
			carp 'Need username and pass to create authentication token';
		}
	}
	
	my $ret = $self->_call('session.createUserAuthToken', %args);		
	return $ret;
}

=item $gs->session_destroy( )

=cut

sub session_destroy {
	my($self, %args) = @_;
	my $ret = $self->_call('session.destroy', %args);
	
	# kill the stored session ID if destroying was successful
	$self->{_session_id} = undef unless $ret->is_fault;
		
	return $ret;
}

=item $gs->session_destroyAuthToken( )

=cut

sub session_destroyAuthToken {
	my($self, %args) = @_;
	my $ret = $self->_call('session.destroyAuthToken', %args);		
	return $ret;
}

=item $gs->session_get( )

=cut

sub session_get {
	my($self, %args) = @_;
	my $ret = $self->_call('session.get', %args);
	
	# save the session ID given in the response
	$self->{_session_id} = $ret->sessionID unless $ret->is_fault;
	
	return $ret;
}

=item $gs->session_getUserID( )

=cut

sub session_getUserID {
	my($self, %args) = @_;
	my $ret = $self->_call('session.getUserID', %args);		
	return $ret;
}

=item $gs->session_loginViaAuthToken( )

=cut

sub session_loginViaAuthToken {
	my($self, %args) = @_;
	my $ret = $self->_call('session.loginViaAuthToken', %args);		
	return $ret;
}

=item $gs->session_logout( )

=cut

sub session_logout {
	my($self, %args) = @_;
	my $ret = $self->_call('session.logout', %args);		
	return $ret;
}

=item $gs->session_start( )

=cut

sub session_start {
	my($self, %args) = @_;
	
	# remove a prior session ID, but store this value
	my $old_session_id = $self->{_session_id};
	$self->{_session_id} = undef;
	
	my $ret = $self->_call('session.start', %args);
	
	if($ret->is_fault) {
		# restore old session ID
		$self->{_session_id} = $old_session_id;
	}
	else {
		# save the session ID given in the response
		$self->{_session_id} = $ret->sessionID;
	}
	
	return $ret;
}

=back

=head2 SONG

=over 4

=item $gs->song_about( )

=cut

sub song_about {
	my($self, %args) = @_;
	my $ret = $self->_call('song.about', %args);
	return $ret;
}

=item $gs->song_favorite( )

=cut

sub song_favorite {
	my($self, %args) = @_;
	my $ret = $self->_call('song.favorite', %args);
	return $ret;
}

=item $gs->song_getSimilar( )

=cut

sub song_getSimilar {
	my($self, %args) = @_;
	my $ret = $self->_call('song.getSimilar', %args);
	return $ret;
}

=item $gs->song_getStreamKey( )

=cut

sub song_getStreamKey {
	my($self, %args) = @_;
	my $ret = $self->_call('song.getStreamKey', %args);
	return $ret;
}

=item $gs->song_getStreamUrl( )

=cut

sub song_getStreamUrl {
	my($self, %args) = @_;
	my $ret = $self->_call('song.getStreamUrl', %args);
	return $ret;
}

=item $gs->song_getStreamUrlEx( )

=cut

sub song_getStreamUrlEx {
	my($self, %args) = @_;
	my $ret = $self->_call('song.getStreamUrlEx', %args);
	return $ret;
}

=item $gs->song_getWidgetEmbedCode( )

=cut

sub song_getWidgetEmbedCode {
	my($self, %args) = @_;
	my $ret = $self->_call('song.getWidgetEmbedCode', %args);
	return $ret;
}

=item $gs->song_getWidgetEmbedCodeFbml( )

=cut

sub song_getWidgetEmbedCodeFbml {
	my $ret = shift->song_getWidgetEmbedCode(@_);

	unless($ret->is_fault) {
		my $code = $ret->{result}->{embed};
		$code =~ /<embed (.*?)>\s*<\/embed>/;		
		$code = "<fb:swf swf$1 />";
		$ret->{result}->{embed} = $code;	
	}

	return $ret;
}

=item $gs->song_unfavorite( )

=cut

sub song_unfavorite {
	my($self, %args) = @_;
	my $ret = $self->_call('song.unfavorite', %args);
	return $ret;
}

=back

=head2 USER

=over 4

=item $gs->user_getFavoriteSongs( )

=cut

sub user_getFavoriteSongs {
	my($self, %args) = @_;
	my $ret = $self->_call('user.getFavoriteSongs', %args);
	return $ret;
}

=item $gs->user_getPlaylists( )

=cut

sub user_getPlaylists {
	my($self, %args) = @_;
	my $ret = $self->_call('user.getPlaylists', %args);
	return $ret;
}

=back

=cut

################################################################################

sub _call {
	my($self, $method, %param) = @_;

	my $req = {
		header     => {sessionID => $self->sessionID},
		method     => $method,
		parameters => \%param,
	};

	my $json = $self->{_json}->encode($req);
	my $url = sprintf("%s://%s/%s/%s/", ($self->{_https} ? 'https' : 'http'),
		map($self->{$_}, qw(_service _path _api_version)));
	my $response = $self->{_ua}->post($url,
		'Content-Type' => 'text/json',
		'Content'      => $json,
	);

   	my $ret;
	if($response->is_success) {
		my $content = $response->decoded_content || $response->content;
		$ret = $self->{_json}->decode($content);
	}
	else {
    	$ret = {
    		header => {sessionID => $self->sessionID},
    		fault  => {
    			code    => INTERNAL_FAULT,
	    		message => $response->status_line,
	    	},
    	};
	}

	return WWW::Grooveshark::Response->new($ret);
}

1;

__END__

=head1 SEE ALSO

L<http://grooveshark.com/>, L<WWW::Grooveshark::Response>, L<WWW::TinySong>

=head1 BUGS

Please report them!  Create an issue at
L<http://elementsofpuzzle.googlecode.com/> or drop me an e-mail.

=head1 AUTHOR

Miorel-Lucian Palii, E<lt>mlpalii@gmail.comE<gt>

=head1 VERSION

This document describes C<WWW::Grooveshark> version 0.00_01 (July 4, 2009).

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
