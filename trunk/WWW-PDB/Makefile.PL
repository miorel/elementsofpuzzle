use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'WWW::PDB',
	ABSTRACT_FROM    => 'lib/WWW/PDB.pm',
	VERSION_FROM     => 'lib/WWW/PDB.pm',
	AUTHOR           => 'Miorel-Lucian Palii <mlpalii@gmail.com>',
	LICENSE          => 'perl',
	META_MERGE       => {resources =>
		{
			repository => 'http://elementsofpuzzle.googlecode.com/',
		}},
	MIN_PERL_VERSION => '5.006',
	PREREQ_PM        =>
		{
			Carp                   => 0,
			Exporter               => 0,
			Fcntl                  => 0,
			File::Path             => 0,
			File::Spec             => 0,
			IO::File               => 0,
			IO::Uncompress::Gunzip => 0,
			Net::FTP               => 0,
			SOAP::Lite             => 0,
		},
);
