#
# Escrow::Store::DBIC.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:08:43 PM PDT
#
# $Id: DBIC.pm,v 1.3 2006/09/29 00:08:05 adam Exp $

package Escrow::Store::DBIC;

use strict;
use warnings;
use Moose;
use Params::Validate qw(:all);
use Escrow::Store::DBIC::DB;
use Escrow::Exception;
use Exception::Class::TryCatch;

extends 'Escrow::Store';

has 'schema' => ( is => 'ro', isa => 'Object' );

sub BUILD {
    my ( $self, $params ) = @_;
    my $schema = Escrow::Store::DBIC::DB->connect(
        @{ $self->config->{'connect_config'} } );
    $self->{'schema'} = $schema;
}

sub txn_begin {
    my $self = shift;
    $self->schema->txn_begin;
    return 1;
}

sub txn_commit {
    my $self = shift;
    $self->schema->txn_commit;
    return 1;
}

sub txn_rollback {
    my $self = shift;
    $self->schema->txn_rollback;
    return 1;
}

sub _resultset {
    my $self  = shift;
    my $table = shift;
    return $self->schema->resultset($table);
}

sub set_key {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing => { type => SCALAR },
            key   => { type => SCALAR },
            value => { type => SCALAR },
        }
    );
    $self->log->debug(
        "Setting $p{'thing'} key '$p{'key'}' value '$p{'value'}'");
    my $escrow = $self->schema->resultset('Escrow')->update_or_create(
        {
            thing_id => $p{'thing'},
            key_id   => $p{'key'},
            value_id => $p{'value'},
        }
    );
    Escrow::Exception::Store::SetKey->throw(
        "Cannot set $p{'thing'} key '$p{'key'}' value $p{'value'}!")
      unless defined $escrow;
    return 1;
}

sub get_key {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing => { type => SCALAR },
            key   => { type => SCALAR },
        }
    );
    $self->log->debug("Getting $p{'thing'} key '$p{'key'}'");
    my $escrow = $self->schema->resultset('Escrow')->find(
        {
            thing_id => $p{'thing'},
            key_id   => $p{'key'},
        }
    );
    Escrow::Exception::Store::GetKey->throw(
        "Cannot find $p{'thing'} key '$p{'key'}'")
      unless defined $escrow;
    return $escrow->value_id;
}

sub list_keys {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing     => { type => SCALAR },
            return_as => {
                type     => SCALAR,
                optional => 1,
                default  => 'hash',
                regex    => qr/^(array|hash)$/
            },
        }
    );
    $self->log->debug("Getting list of keys for $p{'thing'}");
    my $list_rs = $self->schema->resultset('Escrow')
      ->search( { thing_id => $p{'thing'}, }, );
    my $return_data;
    while ( my $escrow = $list_rs->next ) {
        if ( $p{'return_as'} eq "hash" ) {
            $return_data->{ $escrow->key_id } = $escrow->value_id;
        } elsif ( $p{'return_as'} eq "array" ) {
            push( @{$return_data}, $escrow->key_id );
        }
    }
    Escrow::Exception::Store::ListKeys->throw(
        "Cannot find any key's for $p{'thing'}")
      unless defined $return_data;

    return $return_data;
}

sub delete_key {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing => { type => SCALAR },
            key   => { type => SCALAR },
        }
    );
    $self->log->debug("Deleting $p{'thing'} key '$p{'key'}'");
    my $escrow = $self->schema->resultset('Escrow')->find(
        {
            thing_id => $p{'thing'},
            key_id   => $p{'key'},
        }
    );
    Escrow::Exception::Store::DeleteKeys->throw(
        "Cannot find $p{'thing'} key '$p{'key'}'")
      unless defined $escrow;
    $escrow->delete;
    return 1;
}

sub delete_thing {
    my $self = shift;
    my %p    = validate( @_, { thing => { 'type' => SCALAR, }, }, );

    $self->log->debug("Deleting $p{'thing'}");
    my $delete_rs = $self->schema->resultset('Escrow')
      ->search( { thing_id => $p{'thing'}, } );
    Escrow::Exception::Store::DeleteThing->throw(
        "Cannot find $p{'thing'} to delete!")
      unless defined $delete_rs;
    Escrow::Exception::Store::DeleteThing->throw(
        "Cannot find $p{'thing'} to delete!")
      unless $delete_rs->count;
    $delete_rs->delete;
    return 1;
}

sub list_things {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            return_as => {
                type     => SCALAR,
                optional => 1,
                default  => 'hash',
                regex    => qr/^(array|hash)$/
            },
        }
    );
    my $return_data;
    my %seen;

    $self->log->debug("Listing All Things");
    my $escrow_rs = $self->schema->resultset('Escrow')
      ->search( {}, { order_by => [qw/thing_id/], } );
    Escrow::Exception::Store::ListThings->throw(
        "Cannot find anything in Escrow!" )
      unless defined $escrow_rs;
  ENTRY: while ( my $entry = $escrow_rs->next ) {
        if ( $p{'return_as'} eq "array" ) {
            next ENTRY if exists $seen{ $entry->thing_id };
            push( @{$return_data}, $entry->thing_id );
            $seen{ $entry->thing_id } = 1;
        } else {
            $return_data->{ $entry->thing_id }->{ $entry->key_id }
              = $entry->value_id;
        }
    }
    return $return_data;
}

1;

