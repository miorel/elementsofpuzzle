package WWW::SPOJ;

=head1 NAME

WWW::SPOJ - Extract data from Sphere Online Judge (SPOJ)

=head1 SYNOPSIS

  use WWW::SPOJ;

  my $ua = WWW::SPOJ::ua();
  $ua->timeout(10);
  $ua->env_proxy;
  
  my $user = new WWW::SPOJ::User('john_jones');


=head1 DESCRIPTION AND MOTIVATION

The Sphere Online Judge, better known by its acronym, SPOJ, is an online
archive of programming problems complete with a judge program that receives
and checks submissions. Common utilities requested by users of this site
include a user head-to-head comparer, a programming language preference
analyzer, a user activity grapher, etc. This distribution aims to simplify
building those and similar tools by providing modules and functions that
retrieve and parse data from SPOJ.

=cut

use 5.006;
use strict;
use warnings;

use Carp;

use WWW::SPOJ::User;

our $VERSION = '0.00_01';
$VERSION     = eval $VERSION;

my $ua;
my $service = 'http://www.spoj.pl/';

=head1 FUNCTIONS

=over 4

=item WWW::SPOJ::ua( [ USER_AGENT ] )

Returns the user agent object used for all retrievals, first setting
it to USER_AGENT if it's specified. Defaults to a C<new> L<LWP::UserAgent>.
You can customize this object as in the L</SYNOPSIS>.

If you decide to replace the user agent altogether, you don't have to use
a L<LWP::UserAgent>: the only requirement is that the object you use can
C<get> a URL and return a response object.

=cut

sub ua {
    if(@_) {
        $ua = shift;
    }
    elsif(!defined($ua)) {
        eval {
            require LWP::UserAgent;
            $ua = new LWP::UserAgent;
        };
    }
    defined($ua) or carp 'Problem setting user agent';
    return $ua;
}

=item WWW::SPOJ::service( [ URL ] )

Returns the web address of the service used by this module, first setting
it to URL if it's specified. Defaults to L<http://www.spoj.pl/>.

=back

=cut

sub service {
    $service = shift if @_;
    return $service;
}

1;

__END__

=head1 BE NICE TO THE SERVERS

Please don't abuse the servers. If you anticipate making a large number of
requests, don't make them too frequently. There are several CPAN modules
that can help you make sure your code is nice. Try, for example,
L<LWP::RobotUA> as the user agent:

  use WWW::SPOJ;
  use LWP::RobotUA;
  
  my $ua = LWP::RobotUA->new('my-nice-robot/0.1', 'me@example.org');
  
  WWW::SPOJ::ua($ua);
  
  # WWW::SPOJ and related modules should now be well-behaved

=head1 SEE ALSO

L<http://www.spoj.pl/>, L<LWP::UserAgent>, L<LWP::RobotUA>

=head1 BUGS

Please report them:
L<http://rt.cpan.org/Public/Dist/Display.html?Name=WWW-SPOJ>

=head1 AUTHOR

Miorel-Lucian Palii, E<lt>mlpalii@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
