#
# Escrow/Store/DBIC/DB/Escrow.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 05:56:05 PM PDT
#
# $Id: Escrow.pm,v 1.1 2006/09/24 09:25:23 adam Exp $

package Escrow::Store::DBIC::DB::Escrow;

use strict;
use warnings;

use base qw(DBIx::Class);

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('escrow');

__PACKAGE__->add_columns(
    'thing_id' => { data_type => 'TEXT', },
    'key_id'   => { data_type => 'TEXT', },
    'value_id' => { data_type => 'TEXT', },
);

__PACKAGE__->set_primary_key(qw/thing_id key_id/);

1;

