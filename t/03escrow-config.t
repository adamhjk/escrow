use Test::More tests => 3; 
use FindBin;

use lib ("$FindBin::Bin/../lib");

use strict;
use warnings;

BEGIN {
    use_ok('Escrow::Config');
}

my $ecfg = Escrow::Config->new(
    file => "$FindBin::Bin/test-data/config-general.data" );
isa_ok( $ecfg, 'Escrow::Config' );
my $data = $ecfg->config;
is( ref($data), 'HASH', "Escrow::Config config returns a hashref" );

