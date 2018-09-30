#!perl

use strict;
use warnings;

use Test::Most;    # plan is down at bottom
my $deeply = \&eq_or_diff;

use Math::Random::PCG32;

can_ok( 'Math::Random::PCG32',
    qw(new irand irand64 irand_in rand rand_elm rand_idx) );

my $rng = Math::Random::PCG32->new( 42, 54 );

# these at least agree with the "pcg32-demo" output compiled from
# https://github.com/imneme/pcg-c-basic as of commit bc39cd7
$deeply->(
    [ map $rng->irand, 1 .. 6 ],
    [ 0xa15c02b7, 0x7b47f409, 0xba1d3330, 0x83d2f293, 0xbfa4784b, 0xcbed606e ]
);

# another way to call the function is with the seed "object" as and
# argument which is faster than the OO form but risky (segfault) should
# the wrong thing get passed to a method of this module. so let's not
# advertise this in the docs...
#use Math::Random::PCG32 qw(irand);
#diag Math::Random::PCG32::irand( $rng );
#diag irand( $rng );
#diag $rng->irand;

my @letters = qw(a b c d e f g);
is( $rng->rand_idx( \@letters ), 5,   'rand_idx' );
is( $rng->rand_elm( \@letters ), 'b', 'rand_elm' );

is( sprintf( "%.2f", $rng->rand ),       '0.90',   'rand' );
is( sprintf( "%.2f", $rng->rand(1000) ), '973.52', 'rand x1000' );

is( $rng->irand64, 3664671147774981625, 'irand64' );

# floating point should be converted to int via truncate; if not, test
# should fail as 4..6 is different than 4..5
$deeply->(
    [ map $rng->irand_in( 4, 11.999 / 2 ), 1 .. 7 ],
    [ 4, 5, 5, 5, 4, 5, 4 ], 'irand_in'
);

is( $rng->irand_way( 42, 640, 42, 640 ), undef, 'irand_way same point' );
# forced X and Y axis moves
$deeply->( [ $rng->irand_way( 0, 0, int( 1 + rand 100 ), 0 ) ], [ 1, 0 ] );
$deeply->( [ $rng->irand_way( 0, 0, 0, int( 1 + rand 100 ) ) ], [ 0, 1 ] );
# negative should do the same, only negative
$deeply->( [ $rng->irand_way( 0, 0, -int( 1 + rand 100 ), 0 ) ], [ -1, 0 ] );
$deeply->( [ $rng->irand_way( 0, 0, 0, -int( 1 + rand 100 ) ) ], [ 0, -1 ] );

my @path;
my ( $x, $y ) = ( 0, 0 );
while (1) {
    ( $x, $y ) = $rng->irand_way( $x, $y, 5, 5 );
    last unless defined $x;
    push @path, [ $x, $y ];
}
$deeply->(
    \@path,
    [   [ 1, 0 ], [ 2, 0 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 3, 3 ],
        [ 4, 3 ], [ 4, 4 ], [ 5, 4 ], [ 5, 5 ]
    ],
    'irand_way path positive'
);

@path = ();
( $x, $y ) = ( 3, 3 );
while (1) {
    ( $x, $y ) = $rng->irand_way( $x, $y, 0, 0 );
    last unless defined $x;
    push @path, [ $x, $y ];
}
$deeply->(
    \@path,
    [ [ 2, 3 ], [ 1, 3 ], [ 1, 2 ], [ 1, 1 ], [ 0, 1 ], [ 0, 0 ] ],
    'irand_way path negative'
);

$deeply->(
    [ map $rng->dice( 3, 6 ), 1 .. 6 ],
    [ 11, 10, 8, 12, 12, 11 ], 'dice'
);

is( $rng->decay( 0, 1, 10 ), 10, 'decay min odds' );
is( $rng->decay( 2**32, 1, 1 ), 1, 'decay max odds' );

done_testing 18
