use strict;
use warnings;
use Module::Build;

my $class = Module::Build->subclass(
    class => 'PGXN::Build',
    code => q{
        sub valid_licenses { { postgresql => 'PostgreSQL' } }
    },
);

my $build = $class->new(
    module_name        => 'PGXN::Site',
    license            => 'postgresql',
    script_files       => 'bin',
    configure_requires => { 'Module::Build' => '0.30', },
    build_requires     => {
        'Module::Build'        => '0.30',
        'Software::License'    => '0.102340',
        'Test::More'           => '0.70',
        'Test::MockModule'     => '0.05',
    },
    requires => {
        'Encode'                       => '2.40',
        'I18N::LangTags::Detect'       => '1.04',
        'Locale::Maketext'             => '1.13',
        'List::Util'                   => '1.20',
        'perl'                         => 5.012,
        'Plack'                        => '0.9956',
        'Plack::Builder'               => 0,
        'Plack::Request'               => '0.9956',
        'Plack::Response'              => '0.9956',
        'SemVer'                       => '0.2.0',
        'Template::Declare'            => '0.43',
        'Template::Declare::Tags'      => '0.43',
        'WWW::PGXN'                    => '0.10',
    },
    recommends => {
        'HTTP::Request::Common' => '5.824',
        'Test::Pod'             => '1.41',
        'Test::Pod::Coverage'   => '1.06',
        'Test::XML'             => '0.08',
        'Test::XPath'           => '0.13',
    },
    meta_merge => {
        resources => {
            homepage   => 'http://www.pgxn.org/',
            bugtracker => 'http://github.com/theory/pgxn/issues/',
            repository => 'http://github.com/theory/pgxn/tree/',
        },
    },
);

$build->add_build_element($_) for qw(css gif png jpg js);
$build->create_build_script;
