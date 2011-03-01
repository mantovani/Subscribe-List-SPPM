#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Subscribe::List::SPPM' ) || print "Bail out!
";
}

diag( "Testing Subscribe::List::SPPM $Subscribe::List::SPPM::VERSION, Perl $], $^X" );
