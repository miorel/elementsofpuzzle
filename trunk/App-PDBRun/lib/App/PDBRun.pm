package App::PDBRun;

use 5.006;
use strict;
use warnings;

=head1 NAME

App::PDBRun - Run commands with PDB IDs as arguments

=head1 VERSION

This document describes "App::PDBRun" version 0.00_01 (August 28, 2009).

The latest version is hosted on Google Code as part of
L<http://elementsofpuzzle.googlecode.com/>.

=cut

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;

=head1 SYNOPSIS

  use App::PDBRun;
  
  # something interesting happens

=head1 DESCRIPTION

Some module is a wonderful piece of software.

=cut

use Carp;
use Exporter;
use Fcntl;
use File::HomeDir;
use File::Path;
use File::Spec;
use File::Temp qw(tempdir);
use IO::File;
use IO::Uncompress::Gunzip;
use Net::FTP;

our @ISA       = ();
our @EXPORT_OK = ();

my $tmpdir = tempdir(CLEANUP => 1);

=head1 FUNCTIONS

Generic text about all the nifty things this module can do.

=over 4

=item App::PDBRun->config( [ $FILE ] )

Configuration.

=cut

sub config {
	my($pkg, $file) = @_;
	unless($file) {
		my $dir = File::Spec->catfile(File::HomeDir->my_home, '.pdb');
		File::Path::mkpath($dir);
		$file = File::Spec->catfile($dir, 'config.pl');
	}	
	unless(-e $file) {
		open my $fh, ">$file"
			or croak "$file doesn't exist and couldn't be opened for writing";
		printf($fh <<'EOF', map {"\Q$_\E"} ($pkg, $pkg->VERSION));
### BEGIN MAGIC ################################################################
# This code does some initialization work.  It should be safe to ignore.

use warnings;
use strict;

use File::Spec;

my $pkg = "%s";
my $observed = $pkg->VERSION;
my $expected = "%s";
my $file = (caller(0))[6];
my $dir = join('', (File::Spec->splitpath($file))[0..1]);
unless($observed eq $expected) {
	printf(STDERR "File %%s configured %%s %%s, but current version is %%s\n",
		$file, $pkg, $expected, $observed);
	exit(1);
}
### END MAGIC ##################################################################


### BEGIN CONFIG ###############################################################
# Do your configuration here!

# By default files are downloaded on each run, but if you can afford the space,
# you might save some time with a local cache:
#$pkg->cache('/some/directory/to/use/as/cache');

# The following line would store downloaded files in a directory called
# "cache" in the same part of the filesystem as this configuration file
# (probably the directory ".pdb" within your user's home directory):
#$pkg->cache(File::Spec->catfile($dir, 'cache'));

### END CONFIG #################################################################

1;
EOF
		close $fh;
	}
	require $file;
}

=item App::PDBRun->ftp( [ $FTP ] )

Returns the host name for the PDB FTP archive, first setting it to $FTP if
it's specified.  Default value is F<ftp.wwpdb.org>.

=cut

my $ftp;
sub ftp {
	my $pkg = shift;
	return $ftp = @_ ? shift : $ftp || 'ftp.wwpdb.org';
}

=item App::PDBRun->cache( [ $CACHE ] )

Returns the path used as cache by this package, first setting it to $CACHE, if
it's specified.  Default value is C<undef>.

=cut

my $cache;
sub cache {
	my $pkg = shift;
	return $cache = @_ ? shift : $cache || undef;
}

=item App::PDBRun->run( $CMD, @ARGS )

Runs $CMD (by calling C<system>) with the specified @ARGS.

=cut

sub run {
	my($pkg, $cmd, @args) = @_;
	for(@args) {
		if(/\A([a-z0-9]{4})\.pdb\z/i) {
			my $pdbid = lc($1);
			$pdbid =~ /.(..)./;
			$_ = $pkg->_get_file(
				"${pdbid}.pdb",
				qw(pub pdb data structures divided pdb),
				$1, "pdb${pdbid}.ent.gz"
			);
		}
	}
	return system($cmd, @args);
}

=back

=cut

################################################################################

sub _get_file {
	my($pkg, $filename, @dir) = @_;
	my($dir, $local_path, $store);
	my $file = pop @dir;
	if($pkg->cache) {
		$dir        = File::Spec->catfile($pkg->cache, @dir);
		$local_path = File::Spec->catfile($dir, $file);
	}
	unless($pkg->cache && ($store = new IO::File($local_path))) {
		my $ftp;
		if(   ($ftp = new Net::FTP($pkg->ftp, Debug => 0))
		    && $ftp->login(qw(anonymous -anonymous@))
		    && $ftp->cwd(join('', map("/$_", @dir)))
		) {
			$store = IO::File->new_tmpfile unless $pkg->cache
				&& File::Path::mkpath($dir)
				&& ($store = new IO::File($local_path, '+>'));
			if($ftp->get($file => $store)) {
				seek($store, 0, SEEK_SET);
			}
			else {
				undef $store;
				$pkg->cache and unlink $local_path;
			}
			$ftp->quit;
		}
	}
	if($store) {
		$filename = File::Spec->catfile($tmpdir, $filename);
		if(open my $fh, ">$filename") {
			IO::Uncompress::Gunzip::gunzip($store => $fh);
			close $store;
			close $fh;
			return $filename;
		}
	}
	return undef;
}

1;

__END__

=head1 SEE ALSO

L<pdbcat>, L<WWW::PDB>

=head1 BUGS

Please report them!  Create an issue at
L<http://elementsofpuzzle.googlecode.com/> or drop me an e-mail.

=head1 AUTHOR

Miorel-Lucian Palii E<lt>mlpalii@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Miorel-Lucian Palii

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.  See
L<perlartistic>.

=cut
