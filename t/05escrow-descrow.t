use Test::More skip_all => 'Disabled until I get around to fixing it.'
# use Test::More tests => 4;
# use FindBin;
# 
# use lib ("$FindBin::Bin/../lib");
# 
# use strict;
# use warnings;
# 
# use Exception::Class::TryCatch;
# 
# BEGIN {
#     use_ok('Escrow::Descrow');
# }
# 
# my $data = {
#     ROBOT  => 'is a robot',
#     MONKEY => 'is a monkey',
# };
# 
# my $descrow = Escrow::Descrow->new(
#     server     => 'http://localhost:3000',
#     configfile => "$FindBin::Bin/service/test-data/escrow-client.conf",
#     tmpdir     => "$FindBin::Bin/test-tmp",
# );
# isa_ok( $descrow, "Escrow::Descrow" );
# 
# my $result = $descrow->descrow(
#     thing    => 'foo-fighters',
#     file     => "$FindBin::Bin/test-data/template-foo.txt",
#     destfile => "$FindBin::Bin/test-tmp/template-foo.out",
# );
# $result = 1;
# ok( $result, "Descrowed the Foo-Fighters" );
# ok( -f "$FindBin::Bin/test-tmp/template-foo.out",
#     "Descrow created the output file" );
# unlink("$FindBin::Bin/test-tmp/template-foo.out");
