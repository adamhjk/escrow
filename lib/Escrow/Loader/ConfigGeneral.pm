#
# Escrow::Loader::ConfigGeneral.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/23/2006 01:52:05 PM PDT
#
# $Id: ConfigGeneral.pm,v 1.1 2006/09/24 09:25:22 adam Exp $

package Escrow::Loader::ConfigGeneral;

use strict;
use warnings;
use Config::General;
use Escrow::Exception;
use Params::Validate qw(:all);
use Data::Dumper;

use Moose;

with 'Escrow::Role::Log';

has 'file' => ( is => 'rw', isa => 'Str' );

sub parse_data {
    my $self = shift;
    my %p    = validate( @_,
        { 'file' => { 'type' => SCALAR, default => $self->file }, } );
    my $configobj = new Config::General(
        -ConfigFile       => $p{'file'},
        -UseApacheInclude => '1',
        -IncludeRelative  => '1',
        -ExtendedAccess   => 1,
    );
    my %confighash = $configobj->getall;
    return \%confighash;
}

1;

