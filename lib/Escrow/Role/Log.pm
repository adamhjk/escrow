#
# Escrow::Role::Log.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:10:38 PM PDT
#
# $Id: Log.pm,v 1.1 2006/09/24 09:25:22 adam Exp $

package Escrow::Role::Log;

use strict;
use warnings;
use Log::Log4perl;
use Moose::Role;

has 'logconfig' => ( is => 'rw', isa => 'Str' );
has 'logger'    => ( is => 'ro', isa => 'Object' );

sub log4perl_init {
    my ( $self, $params ) = @_;

    unless ( Log::Log4perl->initialized ) {
        if ( exists( $params->{'logconfig'} ) ) {
            die "Cannot find " . $params->{'logconfig'}
              unless -f $params->{'logconfig'};
            Log::Log4perl::init( $params->{'logconfig'} );
        } else {
            my $conf = q(
              log4perl.logger.Escrow=DEBUG, Screen
              log4perl.appender.Screen=Log::Log4perl::Appender::Screen
              log4perl.appender.Screen.layout=Log::Log4perl::Layout::PatternLayout
              log4perl.appender.Screen.stderr=1
              log4perl.appender.Screen.layout.ConversionPattern=[%d] [%C (%L)] [%p] %m%n
            );
            Log::Log4perl::init( \$conf );
        }
    }
    $self->{'logger'} = Log::Log4perl::get_logger( $self->blessed );
}

sub log {
    my $self = shift;

    $self->log4perl_init unless defined( $self->logger );
    return $self->logger;
}

1;

