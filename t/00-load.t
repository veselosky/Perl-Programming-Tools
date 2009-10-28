#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Kit::Script' );
}

diag( "Testing Kit::Script $Kit::Script::VERSION, Perl $], $^X" );
