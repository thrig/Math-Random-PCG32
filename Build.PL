use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Math::Random::PCG32',
    license            => 'apache',
    dist_author        => 'Jeremy Mates <jmates@cpan.org>',
    dist_version_from  => 'lib/Math/Random/PCG32.pm',
    dist_abstract      => 'minimal PCG random number generator',
    include_dirs       => [qw(. src)],
    c_source           => 'src',
    configure_requires => {
        'Module::Build' => '0.4004',    # test_requires
    },
    test_requires  => { 'Test::Most' => 0, },
    add_to_cleanup => ['Math-Random-PCG32-*'],
);

$builder->create_build_script();
