use inc::Module::Install;
include 'Module::AutoInstall';

name     'Perl-Tools';
all_from 'lib/Kit/Script.pm';
author   q{Vince Veselosky <vince@control-escape.com>};
license  'mit';

# For Kit::Script
requires 'Config::Find';
requires 'Config::General';
requires 'Getopt::Long';
requires 'Log::Any';
requires 'Log::Any::Adapter::Log4perl';
requires 'Log::Log4perl';
requires 'Pod::Usage';

test_requires 'Test::More';

# For bin/archive_nom
requires 'XML::Feed';
requires 'Net::Delicious';
requires 'Path::Class';
requires 'DateTime::Format::HTTP';

# For bin/tweetlinks
requires 'Net::Twitter';
requires 'DBD::SQLite';


auto_install;

WriteAll;

