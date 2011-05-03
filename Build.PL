use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'WWW::Oyster',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/WWW/Oyster.pm',
    add_to_cleanup    => [ 'WWW-Oyster-*' ],
    build_requires    => {
        'Crypt::SSLeay'    => '0.57',
        'Readonly'         => 0,
        'Test::More'       => 0,
        'HTML::TokeParser' => '2.37',
        'WWW::Mechanize'   => '1.60',
    },
);

$builder->create_build_script();