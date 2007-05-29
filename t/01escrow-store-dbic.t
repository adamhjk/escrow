use Test::More tests => 17;
use FindBin;

use lib ("$FindBin::Bin/../lib");
use strict;
use warnings;

BEGIN {
    use_ok('Escrow::Store::DBIC');
    use_ok('Exception::Class::TryCatch');
}

my $templatedata = {
    'bannana' => 'good',
    'fruit'   => 'tasty',
};

my $escrow = Escrow::Store::DBIC->new(
    'backend' => 'DBIC',
    'config'  => {
        'connect_config' =>
          [ "dbi:SQLite:dbname=$FindBin::Bin/test-db/escrow.db", '', '', ]
    },
);
isa_ok( $escrow, 'Escrow::Store::DBIC' );

$escrow->schema->deploy( { add_drop_table => 1, } );

my $result = $escrow->set_key(
    thing => 'monkeytest',
    key   => 'bannana',
    value => 'bad',
);
is( $result, 1, "Escrow set_key succeeded" );

my $check_value = $escrow->get_key(
    thing => 'monkeytest',
    key   => 'bannana',
);
is( $check_value, 'bad', "Escrow get_key has proper value" );

my $deleted = $escrow->delete_key(
    thing => 'monkeytest',
    key   => 'bannana',
);

is( $deleted, 1, "Escrow delete_key has taken your bannana" );

$result = $escrow->set_key(
    thing => 'monkeytest',
    key   => 'lou',
    value => 'is sleeping',
);
is( $result, 1, "Escrow set_key succeeded" );

$result = $escrow->set_thing(
    thing => 'monkeytest',
    data  => $templatedata,
);
is( $result, 1, "Escrow set_thing succeeded" );

my $data = $escrow->get_thing( thing => 'monkeytest' );
is_deeply( $data, $templatedata, "Escrow get_thing succeeded" );

my $listdata = { monkeytest => $templatedata };
my $rlistthings = $escrow->list_things;
is_deeply( $listdata, $rlistthings,
    "Escrow returned the right hash of things" );

my $ralistthings = $escrow->list_things( return_as => 'array' );
is_deeply( $ralistthings, ["monkeytest"],
    "Escrow returned the right array of things" );

my $gdata = $escrow->get;
is_deeply( $listdata, $gdata, "Escrow get returned the right things" );

delete( $gdata->{'monkeytest'}->{'bannana'} );
$gdata->{'the black crowes'} = {
    song   => 'zen',
    monkey => 'eats shoots and leaves',
};

my $sdata = $escrow->set( data => $gdata );
is( $sdata, 1, "Escrow set succeeded" );

my $fgdata = $escrow->get;
is_deeply( $fgdata, $gdata, "Escrow has set all the data properly" );

my $rdelthing = $escrow->delete_thing( thing => 'monkeytest' );
is( $rdelthing, 1, "Escrow delete_thing succeeded" );

my $failed = 0;
eval {
    my $fakething = $escrow->delete_thing( thing => 'monkeytest   war drums' );
};
if (catch my $err) {
    if ($err->error =~ /^Cannot find (.+) to delete!$/) {
        $failed = 1;
    }
}
is ($failed, 1, "Delete of non-existent thing throws exception");

my $alldead = $escrow->delete;
is( $alldead, 1, "Escrow is deleted" );

