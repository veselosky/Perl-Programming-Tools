#!/usr/bin/perl -w
use Kit::Script;

use Test::More tests =>
11;
use Test::Output;
use Data::Dumper;

my %config = auto_configure();

stdout_is( sub {say "This is Perl!"}, "This is Perl!\n", 'say() imported');

# verbose flag bumps level to INFO
stderr_is( sub {DEBUG "debug";}, "", 'debug');
stderr_like( sub {INFO "info";}, qr"info\n", 'info');
stderr_like( sub {WARN "warn";}, qr"warn\n", 'warn');
stderr_like( sub {ERROR "error";}, qr"error\n", 'error');
stderr_like( sub {FATAL "fatal";}, qr"fatal\n", 'fatal');

my $expected_config = '{verbose => \'1\',x => \'Forty Two\'}';

stderr_is( sub {DEBUG "debug %s", \%config;}, "", 'debug');
stderr_like( sub {INFO "info %s", \%config;}, qr"info $expected_config\n", 'info');
stderr_like( sub {WARN "warn %s", \%config;}, qr"warn $expected_config\n", 'warn');
stderr_like( sub {ERROR "error %s", \%config;}, qr"error $expected_config\n", 'error');
stderr_like( sub {FATAL "fatal %s", \%config;}, qr"fatal $expected_config\n", 'fatal');


__END__

