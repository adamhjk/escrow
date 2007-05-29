#
# Template.pm
#
# Created by Adam Jacob <adam@stalecoffee.org>
# Created on Sat Sep 23 22:39:07 PDT 2006
#
# $Id: Template.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Template;

use strict;
use warnings;
use Moose;
use IO::File;
use File::Temp;
use Escrow::Exception;
use Params::Validate qw(:all);

with 'Escrow::Role::Log';

has 'stash'  => ( is => 'rw', isa => 'HashRef' );
has 'tmpdir' => ( is => 'rw', isa => 'Str', required => 1 );

sub do {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            file     => { type => SCALAR, },
            destfile => { type => SCALAR, },
        }
    );

    Escrow::Exception::Template::File->throw(
        "Template file $p{'file'} does not exist")
      unless -f $p{'file'};
    my $tmpfile = $self->get_tmp;
    my $fh = IO::File->new( "$p{'file'}", "r" );
    while ( my $line = $fh->getline ) {
        my @keywords = ( $line =~ /!!!(\w+?)!!!/g );
        my %seen;
        $self->log->debug($line) if scalar(@keywords);
      KEYWORD: foreach my $key (@keywords) {
            if ( exists( $self->stash->{$key} ) ) {
                next KEYWORD if exists $seen{$key};
                my $value = $self->stash->{$key};
                $line =~ s/!!!$key!!!/$value/g;
                $seen{$key} = 1;
            } else {
                Escrow::Exception::Template::Unknown->throw(
                    "Unknown keyword $key in $p{'file'}!");
            }
        }
        $self->log->debug($line) if scalar(@keywords);
        $tmpfile->print($line);
    }
    $fh->close;
    system( "cp", $tmpfile->filename, $p{'destfile'} ) == 0
      or Escrow::Exception::Template::File->throw($!);
    return 1;
}

sub get_tmp {
    my $self = shift;
    umask( oct(0077) );
    return File::Temp->new( DIR => $self->tmpdir );
}

1;
