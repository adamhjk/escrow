#
# Makefile for Escrow Data
#
# $Id: Makefile,v 1.1 2006/09/26 03:45:14 adam Exp $
#

ESCROW = /usr/bin/escrow

DATAFILE_OWNER = root
DATAFILE_GROUP = root 
DATAFILE_PERMS = 600
DATAFILE = /etc/escrow/data/escrow 
OLDDATADIR = /etc/escrow/data/old

DBFILE_OWNER = root
DBFILE_GROUP = root 
DBFILE_PERMS = 640
DBFILE = /etc/escrow/db/escrow.db

SERVERS =  

all: rootcheck escrow setperms makeold distribute

rootcheck:
	@ if [ `id -u -n` \!= root ]; then \
		echo "*** You are not root... so I'm not doing it, hoser."; \
		exit 1; \
	fi

setperms:
	@ echo "Setting permissions on escrow data file"
	@ chown ${DATAFILE_OWNER} ${DATAFILE}
	@ chgrp ${DATAFILE_GROUP} ${DATAFILE}
	@ chmod ${DATAFILE_PERMS} ${DATAFILE}
	@ echo "Setting permissions on database file"
	@ chown ${DBFILE_OWNER} ${DBFILE}
	@ chgrp ${DBFILE_GROUP} ${DBFILE}
	@ chmod ${DBFILE_PERMS} ${DBFILE} 

escrow:
	@ echo "Running escrow"
	${ESCROW}
	
makeold:
	@ echo "Storing backup escrow file"
	@ olddata=${OLDDATADIR}/escrow.`date +%Y-%m-%d-%H-%M-%S`; \
	 cp ${DATAFILE} $$olddata; \
	 chown ${DATAFILE_OWNER} $$olddata; \
	 chgrp ${DATAFILE_GROUP} $$olddata; \
	 chmod ${DATAFILE_PERMS} $$olddata

distribute:
	@ echo "Distributing database"
	@ for x in ${SERVERS}; do \
		echo "Distributing ${DBFILE} to $$x"; \
		rsync -vaP ${DBFILE} root@$$x:${DBFILE}; \
	  done
