package Some::Module;

use 5.006;
use strict;
use warnings;

=head1 NAME

Some::Module - Do something interesting

=head1 VERSION

This document describes "Some::Module" version 0.01 (July 6, 2009).

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.  Significant changes are also
contributed to CPAN: L<http://search.cpan.org/dist/Some-Module/>.

=cut

our $VERSION = '0.01';
$VERSION = eval $VERSION;

=head1 SYNOPSIS

  use Some::Module;
  
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

Please report them!  The preferred way to submit a bug report for this module
is through CPAN's bug tracker:
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Some-Module>.  You may
also create an issue at L<http://elementsofpuzzle.googlecode.com/> or drop
me an e-mail.

=head1 AUTHOR

Miorel-Lucian Palii E<lt>mlpalii@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.  See
L<perlartistic>.

=cut
