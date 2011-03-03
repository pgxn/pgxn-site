use strict;
use warnings;
use Module::Build;

my $class = Module::Build->subclass(
    class => 'PGXN::Build',
    code => q{
        sub valid_licenses { { postgresql => 'PostgreSQL' } }
    },
);

$class->new(
    module_name        => 'PGXN::Site',
    license            => 'postgresql',
    configure_requires => { 'Module::Build' => '0.30', },
    build_requires     => {
        'Module::Build'        => '0.30',
        'Software::License'    => '0.102340',
        'Test::More'           => '0.70',
    },
    requires => {
        'perl'                         => 5.012,
    },
    recommends => {
        'Test::Pod'           => '1.41',
        'Test::Pod::Coverage' => '1.06',
    },
    meta_merge => {
        resources => {
            homepage   => 'http://www.pgxn.org/',
            bugtracker => 'http://github.com/theory/pgxn/issues/',
            repository => 'http://github.com/theory/pgxn/tree/',
        },
    },
)->create_build_script;
