#
# Escrow::Config.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:10:38 PM PDT
#
# $Id: Config.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Config;

use strict;
use warnings;
use Config::General;
use Escrow::Exception;
use Params::Validate qw(:all);
use Moose;

has 'configobj' => ( is => 'rw', isa => 'Object' );
has 'file'      => ( is => 'rw', isa => 'Str' );
has 'config'    => ( is => 'rw', isa => 'HashRef' );

sub BUILD {
    my ( $self, $params ) = @_;
    if ( exists( $params->{'file'} ) ) {
        $self->parse_config;
    }
}

sub parse_config {
    my $self = shift;
    my %p    = validate( @_,
        { 'file' => { 'type' => SCALAR, 'default' => $self->file }, } );
    $self->file( $p{'file'} );
    my $configobj = new Config::General(
        -ConfigFile       => $p{'file'},
        -UseApacheInclude => '1',
        -IncludeRelative  => '1',
        -ExtendedAccess   => 1,
    );
    $self->configobj($configobj);
    my %confighash = $configobj->getall;
    $self->config( \%confighash );
    return \%confighash;
}

1;

