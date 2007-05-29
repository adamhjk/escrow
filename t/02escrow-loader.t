use Test::More tests => 6; 
use FindBin;

use lib ("$FindBin::Bin/../lib");

use strict;
use warnings;

BEGIN {
    use_ok('Escrow::Loader');
}

my $loader = Escrow::Loader->new(
    load => {
        backend => 'ConfigGeneral',
        config  => { file => "$FindBin::Bin/test-data/config-general.data", },
    },
    store => {
        backend => 'DBIC',
        config  => {
            'connect_config' => [
                "dbi:SQLite:dbname=$FindBin::Bin/test-db/escrow.db", '', '',
            ]
        },
    },
);
isa_ok( $loader, 'Escrow::Loader' );

my $parse_result = $loader->parse_data;
is( $parse_result, 1, "Loader parse_data was successful" );

my $data_template = {
    'boardwalk-legion' => {
        SOMETHING => "isn't right",
        BUDDHA    => 'is pissed',
        BECAUSE   => 'your dharma is poor',
    },
    'foo-fighters' => {
        HAVE  => 'many secrets',
        WHICH => 'they want to keep',
        AND   => 'who could blame them?',
    },
};
my $parsed_data = $loader->data;
is( ref($parsed_data), 'HASH', "Loader data returns a hashref" );
is_deeply( $parsed_data, $data_template,
    "Loader data returns the right data" );

my $save = $loader->save;
is( $save, 1, "Loader save was successful" );

