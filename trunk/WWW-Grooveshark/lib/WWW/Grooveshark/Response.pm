package WWW::Grooveshark::Response;

=head1 NAME

WWW::Grooveshark::Response - Grooveshark API response message

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

use WWW::Grooveshark;

use constant {
	MALFORMED_REQUEST_ERROR             => 1,
	NO_METHOD_ERROR                     => 2,
	MISSING_OR_INVALID_PARAMETERS_ERROR => 4,
	SESSION_ERROR                       => 8,
	AUTHENTICATION_ERROR                => 16,
	AUTHENTICATION_FAILED_ERROR         => 32,
	STREAM_ERROR                        => 64,
	API_KEY_ERROR                       => 128,
	USER_BLOCKED_ERROR                  => 256,
	INTERNAL_ERROR                      => 512,
	SSL_ERROR                           => 1024,
};

our @ISA     = ();
our $VERSION = $WWW::Grooveshark::VERSION;

=head1 CONSTRUCTOR

Description of reason for constructor

=over 4

=item WWW::Grooveshark::Response->new( [ \%OBJECT | %OBJECT ] )

Builds a L<WWW::Grooveshark::Response> object from the given hashref or hash.

=cut

sub new {
	my $pkg = shift;
	my $self;
	if(1 == scalar(@_)) {
		$self = shift;
		my $ref = ref($self);
		croak "Non-hashref argument passed to one-arg $pkg constructor"
			unless $ref && ($ref eq 'HASH');
	}
	else {
		$self = {@_};
	}
	return bless($self, $pkg);
}

=back

=head1 METHODS

=over 4

=item $obj->is_fault( )

Checks whether this response object represents a fault.

=cut

sub is_fault {
	return exists(shift->{fault});	
}

=item $obj->header( $KEY )

Returns the header element corresponding to $KEY.

=cut

sub header {
	return shift->{header}->{shift};
}

=item $obj->session_id( )

Returns the ID of the session that created this response object.  This is a
shortcut for passing "sessionID" to the C<header> method.

=cut

sub session_id {
	return shift->header('sessionID');
}

=item $obj->result( $KEY )

Returns the result element corresponding to $KEY.  This will probably only give
a meaningful result if C<is_error> is false.

=cut

sub result {
	return shift->{result}->{shift};
}

=item $obj->fault( $KEY )

Returns the fault element corresponding to $KEY.  This will only give a
meaningful result if C<is_error> is true.

=cut

sub fault {
	return shift->{fault}->{shift};
}

=item $obj->fault_code( )

Returns the integer code of the fault represented by this response object.
This is a shortcut for passing "code" to the C<fault> method.  Check
Grooveshark's API for the most up-to-date information about fault codes.  The
standard set at the time of this writing was:

=over 4

=item 1 Malformed request

Some part of the request, most likely the parameters, was malformed.

=item 2 No method

The requested method does not exist.

=item 4 Missing or invalid parameters

Method parameters were missing or incorrectly formatted.

=item 8 Session

Most likely the session has expired, or it failed to start.

=item 16 Authentication

Authentication is required to access the invoked method.

=item 32 Authentication failed

The supplied user credentials were incorrect.

=item 64 Stream

There was an error creating a stream key, or returning a stream server URL.

=item 128 API key

The supplied API key is invalid, or is no longer active.

=item 256 User blocked

A user's privacy restrictions have blocked access to their account through the API.

=item 512 Internal

There was an error internal to the API while fulfilling the request.

=item 1024 SSL

SSL is required to access the requested method.

=item 2048 Access rights

Your API key does not have the proper access rights to invoke the requested method.

=item 4096 No resource

Something doesn't exist, perhaps a userID, artistID, etc.

=item 8192 Offline

The requested method is offline and is temporarily unavailable.

=back

=cut

sub fault_code {
	return shift->fault('code');
}

=item $obj->fault_message( )

Returns the contextually customized message of the fault represented by this
response object.  This is a shortcut for passing "message" to the C<fault>
method.

=cut

sub fault_message {
	return shift->fault('message');
}

=item $obj->fault_details( )

Returns the (possibly undefined) details of the fault represented by this
response object.  This is a shortcut for passing "details" to the C<fault>
method.

=cut

sub fault_details {
	return shift->fault('details');
}

=item $obj->fault_line( )

Returns an HTTP style status line, containing the fault code and message.

=cut

sub fault_line {
	my $self = shift;
	my $ret = $self->fault_code . ' ' . $self->fault_message;
	# add details here perhaps?
	return $ret;
}

=back

=cut

1;

__END__

=head1 SEE ALSO

L<WWW::Grooveshark>

=head1 BUGS

Please report them!  Create an issue at
L<http://elementsofpuzzle.googlecode.com/> or drop me an e-mail.

=head1 AUTHOR

Miorel-Lucian Palii, E<lt>mlpalii@gmail.comE<gt>

=head1 VERSION

This module is distributed with L<WWW::Grooveshark> and therefore takes its
version from that module.

The latest version of both components is hosted on Google Code as part of
<http://elementsofpuzzle.googlecode.com/>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
