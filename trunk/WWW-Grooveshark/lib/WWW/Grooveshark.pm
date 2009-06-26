package WWW::Grooveshark;

=head1 NAME

WWW::Grooveshark - Do something interesting

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

our @EXPORT_OK = ();
our @ISA       = qw(Exporter);
our $VERSION   = '0.00_01';

my($ua, $service, $retries);

=head1 FUNCTIONS

Generic text about all the nifty things this module can do.

=over 4

=item Some::Module->do_something_awesome( @ARG )

=cut

sub do_something_awesome {
    my($pkg, @arg) = @_;
	# do something awesome
	return 0;
}
=back

=cut

################################################################################

sub _do_something_awesome_internally {
    my($pkg, @arg) = @_;
	# do something awesome
	return 0;
}

1;

__END__

=head1 SEE ALSO

L<http://www.google.com/>, L<Some::Other::Module>

=head1 BUGS

Please report them!  Create an issue at
L<http://elementsofpuzzle.googlecode.com/> or drop me an e-mail.

=head1 AUTHOR

Miorel-Lucian Palii, E<lt>mlpalii@gmail.comE<gt>

=head1 VERSION

Version 0.00_01  (June 26, 2009)

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
