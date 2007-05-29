#
# Escrow::Store.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:55:58 PM PDT
#
# $Id: Store.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Store;

use strict;
use warnings;

use Moose;
use Params::Validate qw(:all);
use Escrow::Exception;

with 'Escrow::Role::Log';

has 'config' => ( is => 'rw', isa => 'HashRef' );

sub set_thing {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing => { type => SCALAR, },
            data  => { type => HASHREF, },
        },
    );
    $self->log->debug("Setting data for $p{'thing'}");
    my %seen_keys;
    foreach my $key ( keys %{ $p{'data'} } ) {
        $self->log->debug( "Setting data for '$p{'thing'}' key '$key' value '"
              . $p{'data'}->{$key}
              . "'" );
        $self->set_key(
            'thing' => $p{'thing'},
            'key'   => $key,
            'value' => $p{'data'}->{$key},
        );
        $seen_keys{$key} = 1;
    }
    $self->log->debug("Checking for stale keys to delete for '$p{'thing'}'");
    my $has_keys = $self->list_keys(
        thing     => $p{'thing'},
        return_as => 'array',
    );
    foreach my $hkey ( @{$has_keys} ) {
        unless ( exists $seen_keys{$hkey} ) {
            $self->log->debug(
                "Deleting unused data for '$p{'thing'}' key '$hkey'");
            $self->delete_key(
                thing => $p{'thing'},
                key   => $hkey
            );
        }
    }
    return 1;
}

sub get_thing {
    my $self = shift;
    my %p = validate( @_, { thing => { 'type' => SCALAR, }, }, );
    return $self->list_keys( thing => $p{'thing'}, return_as => 'hash' );
}

sub delete_thing {
    my $self = shift;
    my %p = validate( @_, { thing => { 'type' => SCALAR, }, }, );
    $self->log->debug("Deleting $p{'thing'}");
    my $keys = $self->list_keys( thing => $p{'thing'}, return_as => 'array' );
    foreach my $key ( @{$keys} ) {
        $self->delete_key( thing => $p{'thing'}, key => $key );
    }
    return 1;
}

sub set {
    my $self = shift;
    my %p = validate( @_, { data => { type => HASHREF, }, }, );
    foreach my $thing ( keys %{ $p{'data'} } ) {
        $self->set_thing(
            thing => $thing,
            data  => $p{'data'}->{$thing}
        );
    }
    return 1;
}

sub get {
    my $self = shift;

    return $self->list_things;
}

sub delete {
    my $self = shift;

    my $list = $self->list_things( return_as => 'array' );
    foreach my $thing ( @{$list} ) {
        $self->delete_thing( thing => $thing, );
    }
    return 1;
}

1;
