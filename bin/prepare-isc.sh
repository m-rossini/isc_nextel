#!/bin/bash

echo
echo \#\#
echo \#\# Copyright 2006 Auster Solutions do Brasil
echo \#\#
echo \#\#  --- \(ISC\) Invoice Smart Center v[%VERSION%] ---
echo \#\#
echo

function checkAnt {
	if [[ -z ${ANT_HOME} || ! ( -r ${ANT_HOME}/lib/ant.jar ) ]]; then
		echo ANT_HOME is set incorrectly or Ant could not be located. Please set ANT_HOME.
		exit 66
	fi
}

function checkJava {
	if [[ -z ${JAVA_HOME} || ! ( -r ${JAVA_HOME}/bin/java ) ]]; then
		echo JAVA_HOME is set incorrectly or java could not be located. Please set JAVA_HOME.
		exit 66
	fi
}

function printUsage {
	echo 'Usage: prepare-isc.sh -c CYCLE [-w <WORK_DIR>] [-g <GEL_FILENAME>] [-p <MONITORING_PORT>] [-t <TRANSACTION_ID>]'
	echo
	echo '  CYCLE            cycle number, with two digits'
	echo '  WORK_DIR         directory where ISC will be executed - files will be generated here'
	echo '  GEL_FILENAME     the path to the gel-t file that will be used'
	echo '  MONITORING_PORT  the port that will be used for JMX monitoring (default is 9876)'
	echo '  TRANSACTION_ID   any string that will be used to identify all generated invoices in the'
	echo '                   checkpoint database table'
	echo
	exit 66
}

# Script invoked with no command-line args?
if [[ $# -eq 0 ]]
then
	printUsage
fi

# Help is needed?
if [[ "$1" = "-help" || "$1" = "--help" ]]
then 
	printUsage
fi

# Getting ISC_HOME absolute path
ORIGINAL_PATH=${PWD}
ISC_HOME=$( dirname $0 )
cd $ISC_HOME
ISC_HOME=${PWD%%"/bin"}
cd ${ORIGINAL_PATH}

# Used to create an unique work directory
TIMESTAMP=`date +%Y%m%d.%H%M%S`

WORK_DIR=${ISC_HOME}/work/${TIMESTAMP}
#WORK_DIR=/pinvoice/${TIMESTAMP}
CYCLE=
GEL_FILE=
MONITOR_PORT=9876
TRANSACTION_ID=${TIMESTAMP}

while getopts "c:w:g:p:t:" OPTION
do
	case $OPTION in
	    c ) 
	      CYCLE="$OPTARG"
	   	echo $CYCLE | grep '^[0-9]\{2\}$' > /dev/null
	    if [[ $? -ne 0 ]]
	    then
	    	echo 'Invalid CYCLE: $CYCLE - must have two digits'
	    	exit 66
	    fi
	    ;;
		w ) 
		WORK_DIR=`echo "$OPTARG" | sed 's/\/$//'`;;
		g ) GEL_FILE="$OPTARG";;
		p ) 
	    MONITOR_PORT="$OPTARG"
	    echo $MONITOR_PORT | grep '^[0-9]\{1,\}$' > /dev/null
	    if [[ $? -ne 0 ]]
	    then
	    	echo 'Invalid PORT: $MONITOR_PORT - must be an integer.'
	    	exit 66
	    elif [[ $MONITOR_PORT -lt 0 || $MONITOR_PORT -gt 65535 ]]
	    then
	    	echo 'Invalid PORT: $MONITOR_PORT - valid range is [0-65535].'
	    	exit 66
	    fi
	    ;;
	    t ) 
	    # SQL table does not allow transaction-ids with more that 15 chars
        TRANSACTION_ID="${OPTARG:0:15}"
	    ;;
		[?] ) printUsage;;
	esac
done
shift $(($OPTIND - 1))

if [[ -z $CYCLE ]]
then
	echo 'CYCLE is mandatory'
	printUsage
fi

checkAnt
checkJava

${JAVA_HOME}/bin/java \
  -cp ${ANT_HOME}/lib/ant-launcher.jar \
  -Dant.home=$ANT_HOME \
  -Dbasedir=$ISC_HOME \
  -Dwork.dir=$WORK_DIR \
  -Dtransaction.id=$TRANSACTION_ID \
  -Dcycle=$CYCLE \
  -Dgel.file.path=$GEL_FILE \
  -Dmonitor.port=$MONITOR_PORT \
  -Dtransaction.id=$TRANSACTION_ID \
  org.apache.tools.ant.launch.Launcher \
  -file ${ISC_HOME}/bin/prepare-isc.xml
  
if [[ $? -ne 0 ]]
    then 
    echo [ERRO IRRECUPERAVEL] Ocorreu um erro durante a preparacao do ISC.
    exit 66
fi
  
echo
echo [ Finished ]
echo
