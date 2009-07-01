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

use WWW::Grooveshark::Response;

our @ISA     = ();
our $VERSION = '0.00_01';

$VERSION = eval $VERSION;

=head1 CONSTRUCTOR

Description of reason for constructor

=over 4

=item WWW::Grooveshark->new( %OPTIONS )

Prepares a new L<WWW::Grooveshark> object with the specified options, which are
passed in as key-value pairs, as in a hash.  Accepted options are:

=over 4

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
		_session_id  => '',
		_json        => new JSON::Any,
	}, $pkg);
}

=back

=head1 API METHODS

=over 4

=item $gs->session_start()

=cut

sub session_start {
	my($self, %args) = @_;
	my $ret = $self->_call('session.start', %args);
	use Data::Dumper;
	print STDERR Dumper($ret);
	return $ret;
}

=back

=cut

sub session_id {
	return shift->{_session_id};
}

################################################################################

sub _call {
	my($self, $method, %param) = @_;
	my $json = $self->{_json}->encode({
		header     => {sessionID => ''},
		method     => $method,
		parameters => \%param,
	});
	my $url = sprintf("%s://%s/%s/%s", ($self->{_https} ? 'https' : 'http'),
		map($self->{$_}, qw(_service _path _api_version)));
	print STDERR "JSON: $json\n";
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
    		header => {sessionID => $self->session_id},
    		fault  => {code => 512, message => $response->status_line},
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

Version 0.00_01  (July 1, 2009)

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
