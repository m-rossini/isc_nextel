echo
echo \#\#
echo \#\# Copyright 2004-2005 Auster Solutions do Brasil
echo \#\#
echo \#\#  --- BillCheckout Tool v3.0.0 ---
echo \#\#
echo

function checkAnt {
	if [[ -z "${ANT_HOME}" || ! ( -r ${ANT_HOME}/lib/ant.jar ) ]]; then
		echo ANT_HOME is set incorrectly or Ant could not be located. Please set ANT_HOME.
		exit 1
	fi
}

function checkJava {
	if [[ -z "${JAVA_HOME}" || ! ( -r ${JAVA_HOME}/bin/java ) ]]; then
		echo JAVA_HOME is set incorrectly or java could not be located. Please set JAVA_HOME.
		exit 1
	fi
}


checkAnt
checkJava


# Getting ISC_HOME absolute path
ORIGINAL_PATH=${PWD}
ISC_HOME=$( dirname $0 )
cd $ISC_HOME
ISC_HOME=${PWD%%"/bin"}
cd ${ORIGINAL_PATH}


${JAVA_HOME}/bin/java \
  -cp ${ANT_HOME}/lib/ant-launcher.jar \
  -Dant.home=${ANT_HOME} \
  -Dbasedir=${ISC_HOME} \
  -Dsecret.key="${ISC_SECRETKEY}" \
  -Dalgorithm.name="AES" \
  -Dalgorithm.mode="CBC" \
  -Dalgorithm.padding="PKCS5Padding" \
  -Dcmdline.args="1 $*" \
  org.apache.tools.ant.launch.Launcher \
  -file ${ISC_HOME}/bin/crypt.xml

echo
echo [ Finished ]
echo
