#
# Catalyst/Model/Escrow/Store/DBIC.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/23/2006 03:59:34 PM PDT
#
# $Id: DBIC.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Catalyst::Model::Escrow::Store::DBIC;

use strict;
use warnings;

use NEXT;
use Escrow::Store::DBIC;
use base 'Catalyst::Model';

our $VERSION = '0.01';

__PACKAGE__->config( 'backend' => 'DBIC', );

sub new {
    my ( $self, $c, $config ) = @_;
    $self = $self->NEXT::new(@_);

    $self->{'store'} = Escrow::Store::DBIC->new(
        backend => $self->{'backend'},
        config  => $self->{'config'},
    );

    return $self;
}

sub _execute {
    my ( $self, $method, @args ) = @_;

    my $store = $self->{'store'};
    if ( scalar(@args) ) {
        $store->$method(@args);
    } else {
        $store->$method;
    }
}

sub get {
    my ( $self, $c ) = @_;
    $self->_execute('get');
}

sub AUTOLOAD {
    my ( $self, @args ) = @_;

    my ($method) = ( our $AUTOLOAD =~ /([^:]+)$/ );
    return if $method eq 'DESTROY';

    return $self->_execute( $method, @args );
}

1;

