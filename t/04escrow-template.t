use Test::More tests => 6; 
use FindBin;

use lib ("$FindBin::Bin/../lib");

use strict;
use warnings;

use Exception::Class::TryCatch;

BEGIN {
    use_ok('Escrow::Template');
}

my $data = {
    ROBOT  => 'is a robot',
    MONKEY => 'is a monkey',
};

my $template = Escrow::Template->new(
    stash  => $data,
    tmpdir => "$FindBin::Bin/test-tmp",
);
isa_ok( $template, 'Escrow::Template' );

my $result = $template->do(
    file     => "$FindBin::Bin/test-data/template-file.txt",
    destfile => "$FindBin::Bin/test-tmp/template-file.out",
);
ok( $result, "Template for file with good data" );
ok( -f "$FindBin::Bin/test-tmp/template-file.out", "Created output file" );
unlink("$FindBin::Bin/test-tmp/template-file.out");

my $ukerr = 0;
eval {
    $template->do(
        file     => "$FindBin::Bin/test-data/template-uk.txt",
        destfile => "$FindBin::Bin/test-tmp/template-uk.out",
      ),
      ;
};

if ( catch my $err ) {
    if ( $err->error =~ /^Unknown keyword/ ) {
        $ukerr = 1;
    } else {
        diag( $err->error );
    }
}
is( $ukerr, 1, "Exception thrown for unknown keys" );
ok( !-f "$FindBin::Bin/test-tmp/template-uk.txt",
    "Did not create output file" );
