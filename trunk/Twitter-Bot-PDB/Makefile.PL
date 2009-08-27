use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'Twitter::Bot::PDB',
	ABSTRACT_FROM    => 'lib/Twitter/Bot/PDB.pm',
	VERSION_FROM     => 'lib/Twitter/Bot/PDB.pm',
	AUTHOR           => 'Miorel-Lucian Palii <mlpalii@gmail.com>',
	LICENSE          => 'perl',
	META_MERGE       => {resources =>
		{
#			bugtracker => 'http://rt.cpan.org/Public/Dist/Display.html?Name=Twitter-Bot-PDB',
			repository => 'http://elementsofpuzzle.googlecode.com/',
		}},
	MIN_PERL_VERSION => '5.006',
	PREREQ_PM        =>
		{
			Carp => 0,
		},
);
