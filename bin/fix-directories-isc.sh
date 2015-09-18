#!/bin/bash

echo Fixing file locations...
for xml in `find [%OUTPUT_DIR%] -name 'CUST*.xml'`
do
    DIRNAME=$( dirname $xml )
	FILENAME=`echo $xml | sed 's/.*\(CUST[0-9]*\)\.xml/\1/'`
	for EXT in `echo 'txt pdf' | cut -f1`
	do
		if [[ ! -f "${DIRNAME}/${FILENAME}.${EXT}" ]]
		then
			OLDFILE=`find [%OUTPUT_DIR%] -name "${FILENAME}.${EXT}"`
			echo $OLDFILE | grep -v funcionarios | grep -v febraban
			if [[ $? -eq 0 && -n $OLDFILE ]]
			then
				echo "Moving file $OLDFILE to $DIRNAME"
				mv $OLDFILE $DIRNAME
			fi
		fi
	done
done
echo Done fixing directories.

echo Deleting individual FLAT files...
find [%OUTPUT_DIR%] -name 'CUST*.flat' -exec rm -f {} {} \;
echo Done deleting FLAT files.
