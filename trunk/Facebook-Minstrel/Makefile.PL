use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'Facebook::Minstrel',
	ABSTRACT_FROM    => 'lib/Facebook/Minstrel.pm',
	VERSION_FROM     => 'lib/Facebook/Minstrel.pm',
	AUTHOR           => 'Miorel-Lucian Palii <mlpalii@gmail.com>',
	LICENSE          => 'perl',
	META_MERGE       => {resources =>
		{
			repository => 'http://elementsofpuzzle.googlecode.com/',
		}},
	MIN_PERL_VERSION => '5.006',
	PREREQ_PM        =>
		{
			Carp     => 0,
			Exporter => 0,
		},
);
