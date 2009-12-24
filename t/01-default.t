#!/usr/bin/perl -w
use Kit::Script;

use Test::More tests =>
11;
use Test::Output;
use Test::Exception;
use Data::Dumper;

my %config = auto_configure(options => ['x']);

lives_ok( sub {say "This is Perl!"}, 'say() imported');

# Default log level is WARN
stderr_is( sub {DEBUG "debug";}, "", 'debug');
stderr_is( sub {INFO "info";}, "", 'info');
stderr_like( sub {WARN "warn";}, qr"warn\n", 'warn');
stderr_like( sub {ERROR "error";}, qr"error\n", 'error');
stderr_like( sub {FATAL "fatal";}, qr"fatal\n", 'fatal');

stderr_is( sub {DEBUG "debug %s", \%config;}, "", 'debug');
stderr_is( sub {INFO "info %s", \%config;}, "", 'info');
stderr_like( sub {WARN "warn %s", \%config;}, qr"warn {}\n", 'warn');
stderr_like( sub {ERROR "error %s", \%config;}, qr"error {}\n", 'error');
stderr_like( sub {FATAL "fatal %s", \%config;}, qr"fatal {}\n", 'fatal');


__END__

