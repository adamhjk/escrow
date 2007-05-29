#
# Escrow/Loader.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/23/2006 01:21:19 PM PDT
#
# $Id: Loader.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Loader;

use strict;
use warnings;

use Moose;
use Escrow::Exception;
use Exception::Class::TryCatch;
use Module::Pluggable
  search_path => 'Escrow::Loader',
  require     => 1,
  sub_name    => 'loader_plugins';
use Module::Pluggable
  search_path => 'Escrow::Store',
  require     => 1,
  sub_name    => 'store_plugins';

has 'store'  => ( is => 'ro', isa => 'HashRef' );
has 'load'   => ( is => 'ro', isa => 'HashRef' );
has 'loader' => ( is => 'ro', isa => 'Object' );
has 'storer' => ( is => 'ro', isa => 'Object' );
has 'data'   => ( is => 'rw', isa => 'HashRef' );

with 'Escrow::Role::Log';

sub BUILD {
    my ( $self, $params ) = @_;
    my @loaders = $self->loader_plugins;
    my @stores  = $self->store_plugins;
    if ( exists( $params->{'load'} ) ) {
        my $loadpackage = 'Escrow::Loader::' . $params->{'load'}->{'backend'};
        $self->log->debug("Loading Loader $loadpackage");
        my $loader = $loadpackage->new( $params->{'load'}->{'config'} );
        $self->{'loader'} = $loader;
    }
    my $storepackage = 'Escrow::Store::' . $params->{'store'}->{'backend'};
    $self->log->debug("Loading Store $storepackage");
    my $store = $storepackage->new( $params->{'store'} );
    $self->{'storer'} = $store;
}

sub parse_data {
    my $self = shift;

    if ( defined( $self->loader ) ) {
        my $data = $self->loader->parse_data(@_);
        $self->data($data);
        return 1;
    } else {
        return 1;
    }
}

sub save {
    my $self = shift;

    Escrow::Exception::Loader::Save->throw(
        'You have not set data directly or through parse_data!')
      unless defined( $self->data );
    $self->storer->txn_begin;
    my $rc;
    eval { $rc = $self->storer->set( data => $self->data ); };
    if ( catch my $err ) {
        $self->storer->txn_rollback;
        $err->rethrow;
    }
    $self->storer->txn_commit;
    return $rc;
}

1;

