use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'Some::Module',
	ABSTRACT_FROM    => 'lib/App/PDBCat.pm',
	VERSION_FROM     => 'lib/App/PDBCat.pm',
	AUTHOR           => 'Miorel-Lucian Palii <mlpalii@gmail.com>',
	LICENSE          => 'perl',
	META_MERGE       => {resources =>
		{
			repository => 'http://elementsofpuzzle.googlecode.com/',
		}},
	MIN_PERL_VERSION => '5.006',
	PREREQ_PM        =>
		{
			Carp => 0,
		},
	EXE_FILES        => ['bin/some_script'],
);
