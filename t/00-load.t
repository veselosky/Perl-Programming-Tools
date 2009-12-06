#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'Kit::Script' );
    use_ok('Kit::Types');
}

diag( "Testing Kit::Script $Kit::Script::VERSION, Perl $], $^X" );
