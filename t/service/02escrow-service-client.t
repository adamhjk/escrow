#use Test::More plan => 8; 

use Test::More skip_all => "Tests disabled";
use FindBin;

# use lib ("$FindBin::Bin/../../lib");
# 
# use strict;
# use warnings;
# use Exception::Class::TryCatch;
# 
# BEGIN {
#     use_ok('Escrow::Service::Client');
# }
# 
# my $ec = Escrow::Service::Client->new(
#     server     => 'http://localhost:3000',
#     configfile => "$FindBin::Bin/test-data/escrow-client.conf",
# );
# isa_ok( $ec, "Escrow::Service::Client" );
# 
# my $all_data_tmp = {
#     'foo-fighters' => {
#         'WHICH' => 'they want to keep',
#         'ROAD'  => 'hell yeah',
#         'HAVE'  => 'many secrets'
#     },
#     'nirvana' => {
#         'MONKEYS' => 'fly out',
#         'BUTTS'   => 'all the time'
#     },
#     'boardwalk-legion' => {
#         'BECAUSE'   => 'your dharma is poor',
#         'BUDDHA'    => 'is pissed',
#         'SOMETHING' => 'isn\'t right'
#       }
# 
# };
# 
# my $data = $ec->get;
# is_deeply( $data, $all_data_tmp,
#     "Service Client returns correct 'all' data" );
# 
# my $foo_data = $ec->get_thing( thing => 'foo-fighters' );
# is_deeply(
#     $foo_data,
#     $all_data_tmp->{'foo-fighters'},
#     "Service Client returns correct 'foo-fighters' data"
# );
# 
# my $road_data = $ec->get_key(
#     thing => 'foo-fighters',
#     key   => 'ROAD',
# );
# is_deeply(
#     $road_data,
#     { ROAD => 'hell yeah' },
#     "Service Client returns correct ROAD data"
# );
# 
# my $ecbad = Escrow::Service::Client->new(
#     server     => 'http://localhost:3000',
#     configfile => "$FindBin::Bin/test-data/escrow-client-broken.conf",
# );
# isa_ok( $ecbad, "Escrow::Service::Client" );
# 
# my $baddata;
# eval { $baddata = $ecbad->get; };
# my $ok = 0;
# if ( catch my $err ) {
#     $ok = 1;
# }
# ok( $ok, "Bad secrets cause an exception" );
# ok( !defined $baddata, "Bad secrets make the data undefined" );
# 