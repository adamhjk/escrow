#
# Escrow::Exception.pm
# Created by: Adam Jacob, Marchex, <adam@marchex.com>
# Created on: 09/21/2006 06:44:31 PM PDT
#
# $Id: Exception.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow::Exception;

use strict;
use warnings;
use Moose;

use Exception::Class (
    'Escrow::Exception::Store::Set' =>
      { description => 'Cannot set all data in Escrow for a given thing' },
    'Escrow::Exception::Store::SetKey' =>
      { description => 'Cannot set some data in Escrow for a given key' },
    'Escrow::Exception::Store::GetKey' =>
      { description => 'Cannot get some data in Escrow for a given key' },
    'Escrow::Exception::Store::ListKeys' =>
      { description => 'Cannot list the keys for a thing in Escrow', },
    'Escrow::Exception::Store::DeleteKeys' =>
      { description => 'Cannot delete a keys for a thing in Escrow', },
    'Escrow::Exception::Store::DeleteThing' =>
      { description => 'Cannot delete a thing in Escrow', },
    'Escrow::Exception::Store::ListThings' =>
      { description => 'Cannot list the things in Escrow', },
    'Escrow::Exception::Store::DBIC::Schema' =>
      { description => 'Cannot load Database Schema' },
    'Escrow::Exception::Config' =>
      { description => 'Had a configuration error', },
    'Escrow::Exception::Service::Client::GetRest' =>
      { description => 'Had an error getting data from the REST service', },

    'Escrow::Exception::Service::Client::Data' => {
        description =>
          'Had an error de-serializing data from the REST service',
    },
    'Escrow::Exception::Template::File' =>
      { description => 'Had an error dealing with a Template file', },
    'Escrow::Exception::Template::Unknown' => {
        description =>
          'Had a Key appear in a Template that is not in the Stash',
    },
    'Escrow::Exception::Loader::Save' =>
      { description => 'Had a problem saving your data to the store', },
);

1;

