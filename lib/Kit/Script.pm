package main;
use Getopt::Long;
use Log::Any;
use Pod::Usage;

package Kit::Script;
use strict;
use warnings;
use Config::Find;
use Config::General qw(ParseConfig);
use Log::Any::Adapter;
use Log::Log4perl ();
use Log::Log4perl::Level;
Log::Log4perl::Config->allow_code(0);

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(auto_configure DEBUG INFO WARN ERROR FATAL);
our $VERSION = '0.002';
our %Logger_for_package;

sub import {
    my $caller = caller();
    die 'Using Kit::Script from a package other than "main" is not supported'
        unless $caller eq 'main';
    warnings->import();
    strict->import();
    if ($]>=5.010000) {
        require feature;
        feature->import(':5.10');
    }
    __PACKAGE__->export_to_level(1,@_);
}

sub auto_configure {
    my %args = @_;
    my ($logging, %options);
    my $calling_package = caller();
    
    # Parse command line options
    Getopt::Long::Configure('bundling');
    my @getopt = ('configfile|C:s','help|?','verbose|v+');
    if ($args{options}) {
        push @getopt, @{$args{options}};
    } elsif ($args{getopt}) {
        @getopt = @{$args{getopt}};
    }
    main::GetOptions(\%options,@getopt);
    main::pod2usage(1) if $options{help};
    $options{verbose} ||= 0;

    # Find the configuration file
    my %find = ();
    $find{file} = $options{configfile} if $options{configfile};
    $find{name} = $args{name} if $args{name};
    my $config_file = Config::Find->find(%find);
    # Parse the configuration file
    my %config = $args{'Config::General'} ? %{$args{'Config::General'}} : ();
    $config{'-ConfigFile'} = $config_file if $config_file;
    my %script_config = ParseConfig(%config);

    # Initialize logging
    if ($logging = $script_config{'Log::Log4perl'}) {
        Log::Log4perl->init($logging);
    } else {
        Log::Log4perl->easy_init( ($WARN,$INFO,$DEBUG,$TRACE)[$options{verbose}]  );
    }
    Log::Any::Adapter->set('Log4perl');
    $Logger_for_package{$calling_package} = Log::Any->get_logger(category=>$calling_package);

    # Command line options override config values
    return (%script_config, %options);
}

# These subs emulate Log::Log4perl ':easy', but enhanced with Log::Any
# sprintf behavior.
sub DEBUG {
    return unless my $L = $Logger_for_package{scalar(caller())};
    return @_ > 1 ? $L->debugf(@_) : $L->debug(@_);
}

sub INFO {
    return unless my $L = $Logger_for_package{scalar(caller())};
    return @_ > 1 ? $L->infof(@_) : $L->info(@_);
}

sub WARN {
    return unless my $L = $Logger_for_package{scalar(caller())};
    return @_ > 1 ? $L->warnf(@_) : $L->warn(@_);
}

sub ERROR {
    return unless my $L = $Logger_for_package{scalar(caller())};
    return @_ > 1 ? $L->errorf(@_) : $L->error(@_);
}

sub FATAL {
    return unless my $L = $Logger_for_package{scalar(caller())};
    return @_ > 1 ? $L->fatalf(@_) : $L->fatal(@_);
}

1;
__END__

=head1 NAME

Kit::Script - Bootstrap a quickie script

=head1 SYNOPSIS

  use Kit::Script;
  my %config = auto_configure(options => [qw(whatever)]);
  DEBUG("Logging methods automatically imported");

=head1 DESCRIPTION

This library is a kit to help you bootstrap a quick command line script. When you use it:

=over

=item * It imports C<strict> semantics, just like C<use strict; use warnings;>

=item * If running under Perl 5.10, it enables 5.10 features (like "say").

=item * It imports L<Pod::Usage>, L<Log::Log4perl>, and L<Getopt::Long>

=item * It exports the Log::Log4perl "easy" logging functions: C<DEBUG>, C<INFO>, C<WARN>, C<ERROR>, C<FATAL>. (Note: you need to call C<auto_configure> to initialize the logger before calling them.)

=item * It exports the C<auto_configure> subroutine into the main package.

=back

=head1 PUBLIC METHODS/SUBROUTINES

=head2 C<auto_configure(options =E<gt> [@getopt_long_option_specs], configfile =E<gt> 'my.conf')>

Calling C<auto_configure> does the following:

=over

=item * Parses the command line for arguments by passing your options to L<Getopt::Long>

=item * Automatically checks for common command line options (see below).

=item * Finds (with L<Config::Find>) and parses (with L<Config::General>) an appropriate configuration file for your script. If given a "--configfile" or "-C" option, it will load that file.

=item * Initializes Log::Log4perl. If your config file contains a section called Log::Log4perl, that will be used to initialize the logger. Otherwise it will use a default "easy_init", with the log level based on the value of the "--verbose" or "-v" option (which may be given more than once to increase the logging level).

=item * If the "--help" or "-?" option is given, prints a usage message with L<Pod::Usage> and exits.

=item * RETURNS a hash of configuration options parsed from your configuration file and the command line, with command line options overriding options from the config file.

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION

=head1 DEPENDENCIES 

=over

=item L<Getopt::Long> (core)

=item L<Pod::Usage>

=item L<Log::Log4perl>

=item L<Config::Find>

=item L<Config::General>

=back

=head1 TODO
 
=over

=item Use Log::Any to get a much nicer log interface super-cheap.

=back

=head1 BUGS AND LIMITATIONS

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Vince Veselosky.

This program is distributed in the hope that it will be
useful, but without any warranty; without even the implied
warranty of merchantability or fitness for a particular purpose.

This program is free software; you
can redistribute it and/or modify it under the same terms
as Perl 5.10.0. For more details, see the full text of the
licenses in the directory LICENSES.

This program is free software; you can redistribute it and/or
modify it under the terms of either:

=over 4

=item * the GNU General Public License as published by the Free
Software Foundation; either version 2 <http://www.gnu.org/licenses/gpl-2.0.html>, 
or (at your option) any later version, or

=item * the Artistic License version 2.0 <http://www.perlfoundation.org/artistic_license_2_0>.

=back

