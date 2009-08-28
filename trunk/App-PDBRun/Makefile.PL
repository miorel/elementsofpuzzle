use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'App::PDBRun',
	ABSTRACT_FROM    => 'lib/App/PDBRun.pm',
	VERSION_FROM     => 'lib/App/PDBRun.pm',
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
			File::HomeDir          => 0,
			File::Path             => 0,
			File::Spec             => 0,
			File::Temp             => 0,
			IO::File               => 0,
			IO::Uncompress::Gunzip => 0,
			Net::FTP               => 0,
		},
	EXE_FILES        => ['bin/pdbcat'],
);
