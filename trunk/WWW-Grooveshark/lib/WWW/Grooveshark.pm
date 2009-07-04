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

=item I<path>

=item I<api_version>

=item I<https>

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
	my $ua_args = $opts{useragent_class} || {};
	
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

=item $gs->session_destroy( )

=cut

sub session_destroy {
	my($self, %args) = @_;	
	my $ret = $self->_call('session.destroy', %args);
	
	# kill the stored session ID if destroying was successful
	$self->{_session_id} = undef unless $ret->is_fault;
		
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

=back

=head2 USER

=over 4

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

	use Data::Dumper; print STDERR "REQUEST: ", Dumper($req);

	my $json = $self->{_json}->encode($req);
	my $url = sprintf("%s://%s/%s/%s", ($self->{_https} ? 'https' : 'http'),
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

	use Data::Dumper; print STDERR "RESPONSE: ", Dumper($ret);

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
