use inc::Module::Install;

name     'Perl-Tools';
all_from 'lib/Kit/Script.pm';
author   q{Vince Veselosky <vince@control-escape.com>};
license  'mit';

requires 'Getopt::Long';
requires 'Log::Log4perl';
requires 'POD::Usage';
requires 'Config::Find';
requires 'Config::General';

build_requires 'Test::More';

auto_install;

WriteAll;

