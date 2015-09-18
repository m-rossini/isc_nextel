## Copyright 2006 Auster Solutions do Brasil
##
##  --- (ISC) Invoice Smart Center v[%VERSION%] ---
##


*******************************************************************************
*                                                                             *
*  IMPORTANT:                                                                 *
*                                                                             *
*   Before using ISC, you should read the license terms of all software       *
*   used by this tool. Please refer to the various license files located at   *
*   the Febraban "licenses" directory.                                        *
*                                                                             *
*******************************************************************************


Software Requirements:
- Java JDK 1.5.0 or above should be properly installed and the JAVA_HOME 
environment variable set (pointing to the Java SDK installation directory).
- Apache Ant 1.6.5 should be properly installed and the ANT_HOME environment 
variable set (pointing to the Ant installation directory).
- Apache Jakarta Commons Collections 3.1 (provided with ISC)
- Apache Jakarta Commons CLI 1.0 (provided with ISC)
- Apache Jakarta Commons IO 1.1 (provided with ISC)
- Apache Jakarta Commons Lang 2.1 (provided with ISC)
- Apache Logging Log4J 1.2.12 (provided with ISC)
- Apache XML Xalan-J 2.7.0 (provided with ISC)
- Apache XML Xerces-J 2.7.1 (provided with ISC)
- Apache XML xml-apis 1.3.02 (provided with ISC)
- GNU Trove 1.1b5 (provided with ISC)
- Sun JWSDP FastInfoset 1.0.1 (provided with ISC)
- biz.Minaret Dated File Appender 1.0.2 (provided with ISC)

Preparation:
- open a console terminal, go to the ISC installation directory and type:
  > bash bin/prepare-isc.sh <options>
  
ISC will create the work directory at the chosen location and copy all 
necessary files to it.
  
- to see what <options> are available, execute:
  > bash bin/prepare-isc.sh --help

Execution:
- open a console terminal, go to the prepared work directory and type:
  > bash bin/run-isc.sh <options>
  
- to see what <options> are available, execute:
  > bash bin/run-isc.sh --help

Log:
- all log files are created at the ISC 'log' directory

Standard Output:
- the standard output is stored at the 'log/{mode}-{date}_stdout.txt' directory
- the standard error is stored at the 'bin/{mode}-{date}_stderr.txt' directory
 where: 
   {date} is the processing date as 'YYYY-MM-DD'
   {mode} one of "xml", "txt", "pdf", "cg", "feb", "fcn" or "all"
