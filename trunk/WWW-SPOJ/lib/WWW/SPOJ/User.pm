package WWW::SPOJ::User;

=head1 NAME

WWW::SPOJ::User - Object representation of a SPOJ user

=head1 SYNOPSIS

  use WWW::SPOJ;
  
  my $user = new WWW::SPOJ::User('john_jones');

=head1 DESCRIPTION

See L<WWW::SPOJ> for a description of this project.

=cut

use 5.006;
use strict;
use warnings;

use Carp;
use Class::Accessor;
use HTML::TableExtract;

use WWW::SPOJ;

our @ISA = qw(Class::Accessor);

my @user_data = qw(name username country institution email motto);
__PACKAGE__->mk_ro_accessors(@user_data);

=head1 CONSTRUCTOR

This module declares one constructor:

=over 4

=item WWW::SPOJ::User->new( USERNAME )

Constructs a L<WWW::SPOJ::User> to represent the user with the specified
username. Returns C<undef> if such a user doesn't exist, so you can
assume that all L<WWW::SPOJ::User> objects are valid users.

=back

=cut

sub new {
    my($class, $username) = @_;
    my $self = undef;
    if($username =~ /^[a-z][a-z0-9_]+$/si) {
        $username = lc($username);
        my $response = WWW::SPOJ::ua()->get(sprintf('%susers/%s/',
            WWW::SPOJ::service(), $username));
        $response->is_success or croak $response->status_line;
        my $content = $response->decoded_content || $response->content
            or croak 'Problem reading page content';
        my $te = new HTML::TableExtract;
        $te->parse($content);
        eval {
            local %_ = map { $_->[0] =~ s/\/.*//; 
                lc(join('', $_->[0] =~ /[a-z]+/ig)) => $_->[1]
            } $te->table(1, 1)->rows;
            $_{name} = $1 if ($te->table(0, 0)->rows)[1]->[1]
                =~ /^\s(.*)\'s user data/s;
            $self = {map {$_ => $_{$_} || ''} @user_data}
                if defined $_{username} && $_{username} eq $username;
        };
        croak 'Problem parsing page content' if $@;
        $self->{email} =~ s/\[at\]/@/;
    }
    bless($self, $class) if $self;
    return $self;
}

=head1 METHODS

=over 4

=item $user->name( )

Returns the user's real name (what the user gave for the "Your name:" field
on the user data update page).

=item $user->username( )

Returns the user's username. Should be the same as what was passed to the
constructor when this object was created, except for possible differences
in case.

=item $user->country( )

Returns the country the user has chosen to represent.

=item $user->institution( )

Returns the user's institution or the empty string if the user didn't specify
anything.

=item $user->email( )

Returns the user's e-mail address. I hope you're not checking this so you
can spam. Probability suggests you'll get the empty string from this method
because most users will likely choose not to make their e-mail address
publicly visible.

=item $user->motto( )

Returns the user's motto or the empty string if the user didn't specify
anything. Many users put a URL here.

=back

=cut

1;

__END__

=head1 SEE ALSO

L<http://www.spoj.pl/>, L<WWW::SPOJ>

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
