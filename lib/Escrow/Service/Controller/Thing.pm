package Escrow::Service::Controller::Thing;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Exception::Class::TryCatch;

=head1 NAME

Escrow::Service::Controller::Thing - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 get_thing 

Called as "/*', it will return the data for the thing you asked, or it will return
no data.

=cut

sub get_thing : PathPart('') Chained('/') Args(1) {
    my ( $self, $c, $thing_id ) = @_;

    my $thing;
    eval { $thing = $c->model('Escrow')->get_thing( thing => $thing_id ); };
    if ( catch my $err ) {
        $c->log->info( $err->error );
        $c->detach('/no_data');
    } else {
        $c->stash($thing);
    }
}

=head2 get_key

Called as "/thing/*", it will return the data for the key you ask for.

=cut

sub get_key : PathPart('') Chained('/') Args(2) {
    my ( $self, $c, $thing_id, $key ) = @_;

    my $thing;
    eval {
        $thing = $c->model('Escrow')->get_key(
            thing => $thing_id,
            key   => $key,
        );
    };
    if ( catch my $err ) {
        $c->detach('/no_data');
    } else {
        $c->stash->{$key} = $thing;
    }
}

=head1 AUTHOR

Adam Jacob

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
