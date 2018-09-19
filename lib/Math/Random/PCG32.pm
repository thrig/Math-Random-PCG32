# -*- Perl -*-
#
# minimal PCG random number generator
#
# run perldoc(1) on this file for additional documentation

package Math::Random::PCG32;

use warnings;
use strict;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load( 'Math::Random::PCG32', $VERSION );

1;
__END__

=head1 NAME

Math::Random::PCG32 - minimal PCG random number generator

=head1 SYNOPSIS

  use Math::Random::PCG32;
  # ideally use better seeds than this (see e.g. what
  # Math::Random::Secure does)
  my $rng = Math::Random::PCG32->new( 42, 54 );

  $rng->rand;

=head1 DESCRIPTION

This is a minimal PCG random number generator.

L<http://www.pcg-random.org/>

=head1 METHODS

=over 4

=item B<new> I<initstate> I<initseq>

Makes a new object. No peeking! The two seed values should be 64-bit
unsigned integers.

=item B<rand>

Returns a random number from an object constructed by B<new>. The return
value should be in the range of a 32-bit unsigned integer.

=back

=head1 BUGS

=head2 Reporting Bugs

Please report any bugs or feature requests to
C<bug-math-random-pcg32 at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Random-PCG32>.

Patches might best be applied towards:

L<https://github.com/thrig/Math-Random-PCG32>

=head2 Known Issues

New code, not many features, questionable XS. Probably needs a modern
compiler for the C<stdint> types. Untested on older versions of Perl.

=head1 SEE ALSO

L<https://github.com/imneme/pcg-c-basic>

L<Math::Random::MTwist> is very fast if more complicated.

L<Math::Random::Secure> for good seed choice and L<Math::Random::ISAAC>
which is not so fast.

=head1 A RANDOM BENCHMARK

This pits the (very bad) core C<rand> function against the C<rand> calls
from L<Math::Random::ISAAC>, L<Math::Random::MTwist>,
L<Math::Random::Xorshift>, and this module for C<cmpthese( -5, ...> via
the L<Benchmark> module on my somehow still functional 2009 macbook.

               Rate  isacc  xorsh    pcg mtwist   rand
  isacc    236759/s     --   -92%   -94%   -96%   -99%
  xorsh   3132085/s  1223%     --   -19%   -42%   -89%
  pcg     3847667/s  1525%    23%     --   -29%   -87%
  mtwist  5437236/s  2197%    74%    41%     --   -82%
  rand   29808447/s 12490%   852%   675%   448%     --

=head1 AUTHOR

thrig - Jeremy Mates (cpan:JMATES) C<< <jmates at cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Perl module copyright (C) 2018 by Jeremy Mates

Code under src/ directory mostly (c) 2014 M.E. O'Neill / pcg-random.org

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

    L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
