package App::PDBCat;

use 5.006;
use strict;
use warnings;

=head1 NAME

App::PDBCat - Do something interesting

=head1 VERSION

This document describes "App::PDBCat" version 0.01 (August 27, 2009).

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.  Significant changes are also
contributed to CPAN: L<http://search.cpan.org/dist/App-PDBCat/>.

=cut

our $VERSION = '0.01';
$VERSION = eval $VERSION;

=head1 SYNOPSIS

  use App::PDBCat;
  
  # something interesting happens

=head1 DESCRIPTION

Some module is a wonderful piece of software.

=cut

use Carp;
use Exporter;
use Fcntl;
use File::Path;
use File::Spec;
use IO::File;
use IO::Uncompress::Gunzip;
use Net::FTP;

our @ISA       = ();
our @EXPORT_OK = ();

=head1 FUNCTIONS

Generic text about all the nifty things this module can do.

=over 4

=item $pdb_cat->run( $CMD, @ARGS )

Runs $CMD (by calling C<system>) with the specified @ARGS, first replacing any
argument that is (likely to be) a Protein Data Bank ID with a path where the
file corresponding to this ID is stored.

=cut

sub run {
	my($self, $cmd, @args) = @_;
	for(@args) {
		if(/\A[a-z0-9]{4}\z/i) {
			
		}
	}
	return system($cmd, @args);
}

=back

=cut

################################################################################

sub _get_file {
    my($class, @dir) = @_;
    my $file         = pop @dir;
    my($dir, $local_path, $store, $fh);
    if($class->cache) {
        $dir        = File::Spec->catfile($class->cache, @dir);
        $local_path = File::Spec->catfile($dir, $file);
    }
    unless($class->cache && ($store = new IO::File($local_path))) {
        my $ftp;
        if(   ($ftp = new Net::FTP($class->ftp, Debug => 0)) # connect
            && $ftp->login(qw(anonymous -anonymous@))        # login
            && $ftp->cwd(join('', map("/$_", @dir)))         # chdir
        ) {
            # store in temporary file unless there's a cache
            $store = IO::File->new_tmpfile unless $class->cache # cache exists
                && File::Path::mkpath($dir)                     # mkdir
                && ($store = new IO::File($local_path, '+>'));  # create file
            
            # seek to start if successful get otherwise delete file
            if($ftp->get($file => $store)) {
                seek($store, 0, SEEK_SET);
            }
            else {
                undef $store;
                $class->cache and unlink $local_path;
            }
            
            # clean up
            $ftp->quit;
        }
    }
    
    # if file stored, decompress it
    if($store) {
        $fh = IO::File->new_tmpfile;
        IO::Uncompress::Gunzip::gunzip($store => $fh);
        seek($fh, 0, SEEK_SET);
        close $store;
    }
    
    return $fh;
}

1;

__END__

=head1 SEE ALSO

L<http://www.google.com/>, L<WWW::PDB>

=head1 BUGS

Please report them!  The preferred way to submit a bug report for this module
is through CPAN's bug tracker:
L<http://rt.cpan.org/Public/Dist/Display.html?Name=App-PDBCat>.  You may
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
