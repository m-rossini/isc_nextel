#!/bin/bash

echo
echo \#\#
echo \#\# Copyright 2006 Auster Solutions do Brasil
echo \#\#
echo \#\#  --- \(ISC\) Invoice Smart Center v1.0.3 ---
echo \#\#
echo

export JAVA_HOME=/usr/java5
export ANT_HOME=/aplic02/isc/ant-1.6.5


function checkAnt {
	if [[ -z ${ANT_HOME} || ! ( -r ${ANT_HOME}/lib/ant.jar ) ]]
	then
		echo ANT_HOME is set incorrectly or Ant could not be located. Please set ANT_HOME.
		exit 66
	fi
}

function checkJava {
	if [[ -z ${JAVA_HOME} || ! ( -r ${JAVA_HOME}/bin/java ) ]]
	then
		echo JAVA_HOME is set incorrectly or java could not be located. Please set JAVA_HOME.
		exit 66
	fi
}

function printUsage {
	echo 'Usage: run-isc.sh -x|-t|-b|-f|-p|-c|-a|-r [-i <INPUT_FILES>]'
	echo
	echo '  ISC MODE - one of:'
	echo '    -x   generate XML and FLAT files'
	echo '    -t   generate TXT files'
	echo '    -b   generate FEBRABAN files'
	echo '    -f   generate FUNCIONARIOS files'
	echo '    -p   generate PDF files'
	echo '    -c   generate CONTROLGROUP files'
	echo '    -a   generate ALL files (test mode)'
	echo '    -r   generate BRAILLE files'        
	echo
	echo '  INPUT_FILES   input file pattern that will be used to process XML files to other formats'
	echo
	exit 66
}

function checkMode {
	if [[ -n $MODE ]]
	then
		echo "[ERROR] MODE was already set to $MODE"
		exit 66
	fi
}

# Getting ISC_HOME absolute path
ORIGINAL_PATH=${PWD}
ISC_HOME=$( dirname $0 )
cd $ISC_HOME
ISC_HOME=${PWD%%"/bin"}
cd ${ORIGINAL_PATH}

# Script invoked with no command-line args?
if [[ $# -eq 0 ]]
then
	printUsage
fi

# Help is needed?
if [[ -z "$1" || "$1" = "-help" || "$1" = "--help" ]]
then 
	printUsage
fi

CONFIG_FILENAME=
INPUT_FILES=

while getopts "i:xtbfpcar" OPTION
do
	case $OPTION in
	    i ) INPUT_FILES="$OPTARG";;
		x ) checkMode;MODE=xml;;
		t ) checkMode;MODE=txt;;
		b ) checkMode;MODE=feb;;
		f ) checkMode;MODE=fcn;;
		p ) checkMode;MODE=pdf;;
		c ) checkMode;MODE=cg;;
		a ) checkMode;MODE=all;;
		r ) checkMode;MODE=brl;;		
		[?] ) printUsage;;
	esac
done
shift $(($OPTIND - 1))

if [[ -z $MODE ]]
then
	echo "[ERROR] MODE was not set"
	exit 66
else
	CONFIG_FILENAME=${MODE}-config.xml
fi

# used as input for all formats except XML
if [[ $MODE != "xml" && \
      $MODE != "cg" && \
      $MODE != "all" && \
      -z $INPUT_FILES ]];
then
	INPUT_FILES='[%OUTPUT_DIR%]/**/*.xml'
fi

checkAnt
checkJava

echo
echo [ Starting ISC ]
echo
${JAVA_HOME}/bin/java \
  -cp ${ANT_HOME}/lib/ant-launcher.jar \
  -Dant.home=$ANT_HOME \
  -Dbasedir=[%BASE_DIR%] \
  -Dwork.dir=[%WORK_DIR%] \
  -Doutput.dir=[%OUTPUT_DIR%] \
  -Dtransaction.id=[%TRANSACTION_ID%] \
  -Dcycle=[%CYCLE%] \
  -Dmode=$MODE \
  -Dconfig.filename="$CONFIG_FILENAME" \
  -Dinput.file.path="$INPUT_FILES" \
  -Dsecret.key=${ISC_SECRETKEY} \
  org.apache.tools.ant.launch.Launcher \
  -file ${ISC_HOME}/bin/run-isc.xml

if [[ $? -ne 0 ]]
    then 
    echo [ERRO IRRECUPERAVEL] Ocorreu um erro durante a execucao do ISC.
    exit 66
fi

echo
echo [ Finished ]
echo
