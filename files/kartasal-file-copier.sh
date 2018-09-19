#!/bin/bash

SRC=/scratch/kartasal
DST=/tmp/kartasal
LOG=/tmp/kartasal-file-copy.log

# Stamp contains the "real" path which we are supposed to copy
STAMP=datacopy.txt

#for Debug uncomment
set -x 

# Let's check if we have new stamp
if [[ -r "${SRC}/${STAMP}" ]]
then
	if [[ ${SRC}/${STAMP} -nt ${DST}/${STAMP} ]]
	then 
		# At very first we'll remote the logfile
		rm -rf ${LOG}
		# Ok so newer stamp found, let's empty the destination dir first
		rm -rf "${DST}" && mkdir "${DST}" && chown kartasal:kartasal ${DST} 2>&1 >> ${LOG}
		# At first we'll create temporary stamp to tell that we are already copying
		touch ${DST}/${STAMP}
		# Now read wanted src dir
		SRCDIR=`cat ${SRC}/${STAMP}`
		echo Now we are supposed to copy ${SRCDIR} to ${DST}
		cp -a "${SRCDIR}" "${DST}" 2>&1 >> ${LOG}
		# We'll need to copy the stamp to be able to compare dates
		cp "${SRC}/${STAMP}" "${DST}" 2>&1 >> ${LOG} 
		
		# let's tell that we are finished
		touch "${SRC}/`hostname -s`-finished" 2>&1 >> ${LOG}
		echo "Copy-job finished at `date`" 2>&1 >> ${LOG}
	fi
	# Nothing to do here, we have most likely done this already or cp is already running
		echo "Already copied or copying" 2>&1 >> ${LOG}
fi
# No stamp file found doing nothing.
exit
