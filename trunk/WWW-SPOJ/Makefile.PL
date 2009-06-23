use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'WWW::SPOJ',
    VERSION_FROM      => 'lib/WWW/SPOJ.pm',
    LICENSE           => 'perl',
    PREREQ_PM         => {
                            Carp               => 0,
                            Class::Accessor    => 0,
                            HTML::TableExtract => 0,
                            LWP::UserAgent     => 0,
                         },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/WWW/SPOJ.pm',
       AUTHOR         => 'Miorel-Lucian Palii <mlpalii@gmail.com>') : ()),
);
