use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'WWW::Oyster',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/WWW/Oyster.pm',
    ABSTRACT_FROM => 'lib/WWW/Oyster.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'WWW-Oyster-*' },
    PREREQ_PM     => {
        'Crypt::SSLeay'    => '0.57',
        'Readonly'         => '1.03',
        'Test::More'       => 0,
        'HTML::TokeParser' => '2.37',
        'WWW::Mechanize'   => '1.60',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);