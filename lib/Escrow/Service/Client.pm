#
# Escrow::Service::Client.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/23/2006 06:54:59 PM PDT
#
# $Id: Client.pm,v 1.1 2006/09/24 09:25:22 adam Exp $

package Escrow::Service::Client;

use strict;
use warnings;

use Moose;
use Escrow::Config;
use Data::Serializer;
use LWP::UserAgent;
use Escrow::Exception;
use Data::Dumper;
use Params::Validate qw(:all);

has 'ua'         => ( is => 'rw', isa => 'Object' );
has 'server'     => ( is => 'rw', isa => 'Str', required => 1 );
has 'configfile' => ( is => 'rw', isa => 'Str', required => 1 );
has 'config'     => ( is => 'ro', isa => 'HashRef' );
has 'serializer' => ( is => 'ro', isa => 'Object' );

with 'Escrow::Role::Log';

sub BUILD {
    my ( $self, $params ) = @_;

    Escrow::Exception::Config->throw("Escrow server must be an http url!")
      unless $params->{'server'} =~ /^http/;
    $self->{'server'} = $params->{'server'};

    my $ecfg = Escrow::Config->new( 'file' => $params->{'configfile'} );
    $self->{'config'} = $ecfg->config;

    my $serial = Data::Serializer->new( %{ $self->config->{'serializer'} } );
    $self->{'serializer'} = $serial;

    my $ua = LWP::UserAgent->new;
    $ua->agent('EscrowClient/0.1');
    $self->ua($ua);

}

sub get {
    my ($self) = shift;

    return $self->get_rest;
}

sub get_thing {
    my ($self) = shift;
    my %p = validate( @_, { thing => { type => SCALAR, }, } );

    return $self->get_rest( $p{'thing'} );
}

sub get_key {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing => { type => SCALAR, },
            key   => { type => SCALAR, },
        }
    );

    return $self->get_rest( $p{'thing'}, $p{'key'} );
}

sub get_rest {
    my ( $self, @parts ) = @_;

    my $url = $self->server;
    if ( scalar(@parts) ) {
        $url = $url . "/" . join( '/', @parts );
    }
    $self->log->debug("Loading $url");
    my $req = HTTP::Request->new( GET => $url );
    my $response = $self->ua->request($req);
    if ( !$response->is_success ) {
        Escrow::Exception::Service::Client::GetRest->throw(
            "Got a " . $response->status_line . " error doing $url" );
    }
    my $data = $self->serializer->deserialize( $response->content );
    if ( !defined $data ) {
        $self->log->debug( $response->content );
        Escrow::Exception::Service::Client::Data->throw(
            "I got undef back from trying to unserialize a request!  Might be bad secrets?"
        );
    }
    return $data;
}

1;

