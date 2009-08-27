package Twitter::Bot::PDB;

use 5.006;
use strict;
use warnings;

=head1 NAME

Twitter::Bot::PDB - Do something interesting

=head1 VERSION

This document describes "Twitter::Bot::PDB" version 0.01 (August 2, 2009).

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.

=cut

our $VERSION = '0.01';
$VERSION = eval $VERSION;

=head1 SYNOPSIS

  use Twitter::Bot::PDB;
  
  # something interesting happens

=head1 DESCRIPTION

Some module is a wonderful piece of software.

=cut

use Carp;
use Exporter;

our @EXPORT_OK = ();
our @ISA       = qw(Exporter);

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

Create an issue at L<http://elementsofpuzzle.googlecode.com/> or drop me an
e-mail.

=head1 AUTHOR

Miorel-Lucian Palii E<lt>mlpalii@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.  See
L<perlartistic>.

=cut
