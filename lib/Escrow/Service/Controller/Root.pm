package Escrow::Service::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Escrow::Service::Controller::Root - Root Controller for Escrow::Service

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 default

=cut

sub default : Private {
    my ( $self, $c ) = @_;

    $c->detach('no_data');
}

sub index : Private {
    my ( $self, $c ) = @_;

    my $data = $c->model('Escrow')->get;
    $c->stash($data);
}

sub no_data : Private {
    my ( $self, $c ) = @_;

    $c->response->status(404);
    $c->response->body(
        'The Escrow Service Cannot Find What You Are Asking About.  It Also Likes Capitalizing Words.'
    );
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {
}

=head1 AUTHOR

Adam Jacob

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
