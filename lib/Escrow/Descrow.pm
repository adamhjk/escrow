#
# Descrow.pm
#
# Created by Adam Jacob <adam@stalecoffee.org>
# Created on Sun Sep 24 00:24:46 PDT 2006
#
# $Id: Descrow.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Descrow;

use strict;
use warnings;

use Escrow::Template;
use Escrow::Service::Client;
use Params::Validate qw(:all);
use Moose;
use YAML::Syck;

has 'template'   => ( is => 'ro', isa => 'Object' );
has 'client'     => ( is => 'ro', isa => 'Object' );
has 'server'     => ( is => 'rw', isa => 'Str', required => 1 );
has 'configfile' => ( is => 'rw', isa => 'Str', required => 1 );
has 'tmpdir'     => ( is => 'rw', isa => 'Str', required => 1 );

sub BUILD {
    my ( $self, $params ) = @_;

    my $client = Escrow::Service::Client->new(
        server     => $params->{'server'},
        configfile => $params->{'configfile'},
    );
    $self->{'client'} = $client;

    my $template = Escrow::Template->new( tmpdir => $params->{'tmpdir'} );
    $self->{'template'} = $template;
}

sub descrow {
    my $self = shift;
    my %p    = validate(
        @_,
        {
            thing    => { type => SCALAR },
            file     => { type => SCALAR },
            destfile => { type => SCALAR },
        }
    );

    my $data = $self->client->get_thing( thing => $p{'thing'} );
    $self->template->stash($data);
    return $self->template->do(
        file     => $p{'file'},
        destfile => $p{'destfile'},
    );
}

sub raw {
    my $self = shift;
    my %p = validate(@_,
        {
            thing => { type => SCALAR, },
        },
    );
    
    my $data = $self->client->get_thing(thing => $p{'thing'});
    return Dump($data);
}

1;
