#
# Escrow.pm
#
# Created by Adam Jacob <adam@stalecoffee.org>
# Created on Sun Sep 24 01:40:17 PDT 2006
#
# $Id: Escrow.pm,v 1.1 2006/09/24 09:25:21 adam Exp $

package Escrow;

our $VERSION = "0.1";

1;

__END__

=head1 NAME

Escrow - A simple password Escrow service.

=head1 SYNOPSIS

The Escrow service handles the task of providing a secure place to store
data (often passwords).  It works by creating a layer of obfuscation 
between the actual password and the user.  

=head1 INSTALL

  $ perl -MCPAN -e 'install Escrow'
  $ sudo mkdir -p /etc/escrow/data/old
  $ sudo mkdir -p /etc/escrow/db
  
You will then need to grab the files from the conf/ directory (in the
source distribution) and place them in /etc/escrow.  The Makefile should
go in /etc/escrow/data.

=head1 USAGE

Populate /etc/escrow/data/escrow with Config::General hashes, like this:

    <thing>
        one = two
        two = three
    </thing>

Then run "make", or "escrow".  Make will do some handy things for you,
like ensuring the permissions are set properly.

Finally, run the escrow service:

   $ sudo /usr/bin/escrow-service

And then ask for your data:

   $ descrow -s http://localhost:19999 -r -t thing

=head1 WARNING

You will want to change the configuration settings, since things will get
janky on you otherwise.  Specifically, you want to set your own secret
in both "escrow-service.conf" and "escrow-client.conf".  You also want
to make sure you set the permissions properly on escrow-client.conf and
escrow-service.conf. (They should be pretty restrictive)

In addition, make sure you have "astext" set to 0 when you are in 
production. :)

=head1 BUGS

Removing a thing from escrow does not delete it from the compiled database.
You can fix this by just rm-ing the actual database before running
"escrow".

=head1 EARLY

If you are going to be using this, you are an early adopter of the public
release.  This code has been in production for a while, but it's still
pretty early in it's community life.  Expect some jaggy edges in regards
to getting things set up.

=head1 LICENSE

All this code is Copyright 2006,2007 Adam Jacob and Marchex, Inc.

It is licensed under the same terms as Perl itself.

=head1 AUTHORS

    Adam Jacob - <adam@hjksolutions.com>

Marchex, Inc. was my employer when I wrote this code, and they graciously
open sourced it.  Thanks, Marchex!
