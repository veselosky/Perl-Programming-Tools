use inc::Module::Install;

name     'Kit-Script';
all_from 'lib/Kit/Script.pm';
author   q{Vince Veselosky <vince@control-escape.com>};
license  'mit';

build_requires 'Test::More';

auto_install;

WriteAll;

