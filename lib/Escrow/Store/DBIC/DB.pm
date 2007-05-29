#
# DB.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:07:23 PM PDT
#
# $Id: DB.pm,v 1.1 2006/09/24 09:25:23 adam Exp $

package Escrow::Store::DBIC::DB;

use strict;
use warnings;

use base qw(DBIx::Class::Schema);

__PACKAGE__->load_classes;

1;

