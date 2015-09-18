<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
	xmlns:number="xalan://br.com.auster.common.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
    xmlns:nodelist="xalan://br.com.auster.nextel.xsl.extensions.DocumentFragmentVariable"
    xmlns:cgi="xalan://br.com.auster.nextel.xsl.extensions.CGIPrefix"
    xmlns:xalan="http://xml.apache.org/xalan"
    extension-element-prefixes="xalan number aggregates date string sql phonenumber nodelist cgi"
    exclude-result-prefixes="xalan number string date sql aggregates phonenumber nodelist cgi"
    version="1.0">

    <xsl:include href="bgh-invoice-call-details.xsl"/>

    <xsl:template name="usageHandler">
    
				<xsl:for-each select="LIN3[last()]/XCD[(@SERVICE_SHORT='DOWN' or @SERVICE_SHORT='TP' or @SERVICE_SHORT='MMST' or @SERVICE_SHORT='MMSI')]">						
						<xsl:choose>
							<xsl:when test="(@SERVICE_SHORT='DOWN')">
				            <xsl:variable name="null" 
				                select="number:setValue('downloadDataQuantity', number:getValue('downloadDataQuantity') + 1)"/> 
				            <xsl:variable name="null" 
				                select="number:setValue('totalDownload', number:getValue('totalDownload') + @RE_RATED_AMOUNT)"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'mn',  @MAIN_NUMBER)"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'des', substring-before(VAS/@REMARK,'|'))"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'tp',  substring-after(VAS/@REMARK,'|'))"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'vl',  number:parse(@RE_RATED_AMOUNT))"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'dt',  date:format(CR_TIME/@DATE, 'yyMMdd', 'dd/MM/yy'))"/>
				            <xsl:variable name="null"
				                select="aggregates:addKey('downloads', 'tm',  date:format(CR_TIME/@TIME, 'HHmmss', 'HH%H%mm%M%ss'))"/>
				            <aggregates:assembleKey aggregate="downloads"/>							
		        	</xsl:when> 
	            <xsl:otherwise>
						        <xsl:choose>
						            <xsl:when test="(@TYPE_INDICATOR='A' and @SERVICE_SHORT='TP')">
							            <xsl:variable name="null" 
							                select="number:setValue('torpedoSMSDataQuantity', number:getValue('torpedoSMSDataQuantity') + 1)"/> 		            
						            </xsl:when>
						            <xsl:when test="(@TYPE_INDICATOR='A' and @SERVICE_SHORT='MMST')">
							            <xsl:variable name="null" 
							                select="number:setValue('torpedoMMSTDataQuantity', number:getValue('torpedoMMSTDataQuantity') + 1)"/> 
						            </xsl:when>		            
						            <xsl:when test="(@TYPE_INDICATOR='A' and @SERVICE_SHORT='MMSI')">
							            <xsl:variable name="null" 
							                select="number:setValue('torpedoMMSIDataQuantity', number:getValue('torpedoMMSIDataQuantity') + 1)"/> 		            						            </xsl:when>	
						            <xsl:otherwise>
						            </xsl:otherwise>
						        </xsl:choose>										
				            <xsl:variable name="null" select="number:setValue('totalTorpedo', number:getValue('totalTorpedo') + @RE_RATED_AMOUNT)"/>                          				        
						        <xsl:variable name="null" select="number:setValue('torpedoSMSUnitValue', '0.25')"/>  
						        <xsl:variable name="null" select="number:setValue('torpedoMMSTUnitValue', '0.25')"/> 
						        <xsl:variable name="null" select="number:setValue('torpedoMMSIUnitValue', '0.60')"/>	            
	            </xsl:otherwise>	                      
        		</xsl:choose>  
		    </xsl:for-each>                      
		    
    </xsl:template>

    <xsl:template name="contractDetails">
        <!-- CONTEXT: "LIN2" -->

		<!-- DISPATCH CALLS -->
        <number:setValue name="conexaoSubTotal"    value="0"/>
        <number:setValue name="conexaoSubFranquia" value="0"/>
        <number:setValue name="conexaoSubAPagar"   value="0"/>
        <number:setValue name="conexaoSubValor"    value="0"/>
        <aggregates:reset aggregate="dispatchSummary"/>
        
        <xsl:for-each select="LIN3[last()]/XCD[@SERVICE_SHORT='DISPP' or @SERVICE_SHORT='DISPG']">
            <xsl:call-template name="dispatch-call"/>
        </xsl:for-each>
        
        <xsl:element name="DISPATCH">
            <!-- DURATION -->
            <xsl:attribute name="DR">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('conexaoSubTotal')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- FREE UNITS -->
            <xsl:attribute name="F">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('conexaoSubFranquia')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- CHARGED MINUTES -->
            <xsl:attribute name="CH">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('conexaoSubAPagar')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- VALUE -->
            <xsl:attribute name="V">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('conexaoSubValor')"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:for-each select="aggregates:getKeys('dispatchSummary')/key">
                <xsl:element name="DISPP">
                    <!-- SERVICE CODE -->
                    <!--
                    <xsl:attribute name="ID">
                        <xsl:value-of select="aggregates:getKey('dispatchSummary', @value, 'ser')"/>
                    </xsl:attribute>
                    -->
                    <!-- DESCRIPTION -->
                    <xsl:attribute name="DS">
                        <xsl:value-of select="aggregates:getKey('dispatchSummary', @value, 'des')"/>
                    </xsl:attribute>
                    <!-- DURATION -->
                    <xsl:attribute name="DR">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" 
                                select="aggregates:getValue('dispatchSummary', @value, 'tot')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <!-- FREE UNITS -->
                    <xsl:attribute name="F">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" 
                                select="aggregates:getValue('dispatchSummary', @value, 'fra')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <!-- CHARGED MINUTES -->
                    <xsl:attribute name="CH">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" 
                                select="aggregates:getValue('dispatchSummary', @value, 'apa')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <!-- VALUE -->
                    <xsl:attribute name="V">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" 
                                select="aggregates:getValue('dispatchSummary', @value, 'val')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>

        <!-- BEGINNING OF CALL DETAILS -->
        <number:setValue name="idcdSubTotal"          value="0"/>
        <number:setValue name="homeSubTotal"          value="0"/>
        <number:setValue name="homeSubFranquia"       value="0"/>
        <number:setValue name="homeSubAPagar"         value="0"/>
        <number:setValue name="roamingSubTotal"       value="0"/>
        <number:setValue name="roamingSubFranquia"    value="0"/>
        <number:setValue name="roamingSubAPagar"      value="0"/>
        <aggregates:reset aggregate="callSummary"/>
        <aggregates:reset aggregate="directionSummary"/>
        <aggregates:reset aggregate="z300Summary"/>
        <xsl:element name="CALLS">

            <!-- PREPARING IDCD CALLS INFO -->
            <xsl:variable name="idcd">
                <xsl:call-template name="idcd-calls">
                </xsl:call-template>
            </xsl:variable>


            <!-- GENERATING IDCD CALLS INFO -->
            <xsl:element name="IDCD">

                <!-- DURATION -->
                <xsl:attribute name="DR">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('idcdTimeCall')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGED VALUE -->
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('idcdAmount')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <xsl:copy-of select="$idcd"/>

            </xsl:element>

            <xsl:for-each select="LIN3[last()]/XCD[(@SERVICE_SHORT='TELAL' or @SERVICE_SHORT='PPTEL') and ( (@TYPE_INDICATOR='A') or (@TYPE_INDICATOR='I') or (@TYPE_INDICATOR='C') )]">
 			
            <!-- DETERMINING PHONE-NUMBER AND CGI-PREFIX -->
            <string:setValue name="num" value=""/>
            <string:setValue name="cgiPrefix" value=""/>
            <xsl:choose>
                <xsl:when test="@TYPE = 'I'">
                    <xsl:variable name="null" 
                        select="string:setValue('num', INBOUND_CALL_INFO/@CALLING_NUMBER)"/>
                    <xsl:variable name="null" 
                        select="string:setValue('cgiPrefix', cgi:getPrefix(INBOUND_CALL_INFO/@CGI_CELL))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="null" 
                        select="string:setValue('num', OUTBOUND_CALL_INFO/@DIALED_DIGITS)"/>
                    <xsl:variable name="null" 
                        select="string:setValue('cgiPrefix', cgi:getPrefix(OUTBOUND_CALL_INFO/@CGI_CELL))"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- DETERMINING IF THIS IS A MOBILE (CELULAR) CALL -->
            <xsl:variable name="null" select="phonenumber:parse(string:getValue('num'))"/>
            <xsl:choose>
                <xsl:when test="(phonenumber:getFirstDigit() = '8') or (phonenumber:getFirstDigit() = '9')">
                    <!-- this call was made to a mobile phone,       -->
                    <!-- so we need to set the callNumberType to 'M' -->
                    <!-- 'M' means <M>obile -->
                    <string:setValue name="callNumberType" value="M"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- 'O' means <O>ther -->
                    <string:setValue name="callNumberType" value="O"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- DEFINING THE CALLING TYPE (LOCAL, INURB or INTNC) -->
            <xsl:choose>
                <xsl:when test="@TARIFF_TIME_SHORT='LOCAL' or @TARIFF_TIME_SHORT='INURB' or @TARIFF_TIME_SHORT='INTNC'">
                    <xsl:variable name="null" select="string:setValue('tariff',@TARIFF_TIME_SHORT)"/>
                </xsl:when>
                <xsl:when test="starts-with(@TARIFF_ZONE_SHORT,'L')">
                    <!-- Checks if the user made an local call -->
                    <xsl:variable name="null" select="string:setValue('tariff','LOCAL')"/>
                </xsl:when>
                <xsl:when test="starts-with(@TARIFF_ZONE_SHORT,'N')">
                    <!-- Checks if the user made an interurban call -->
                    <xsl:variable name="null" select="string:setValue('tariff','INURB')"/>
                </xsl:when>
                <xsl:when test="starts-with(@TARIFF_ZONE_SHORT,'I')">
                    <!-- Checks if the user made an international call -->
                    <xsl:variable name="null" select="string:setValue('tariff','INTNC')"/>
                </xsl:when>
                <!-- xsl:when test="@RATED_PARTY_TON='1'">
                    < - Checks if the user made an international call - >
                    <xsl:variable name="null" select="string:setValue('tariff','INTNC')"/>
                </xsl:when -->
                <xsl:when test="string-length(string:getValue('num')) &lt;= 8">
                    <xsl:variable name="null" select="string:setValue('tariff', 'LOCAL')"/>
                </xsl:when>
                <xsl:when test="(string-length(string:getValue('cgiPrefix')) = 0) or (string-length(phonenumber:getAreaCode()) = 0) or (string:getValue('cgiPrefix') = phonenumber:getAreaCode())">
                    <xsl:variable name="null" select="string:setValue('tariff', 'LOCAL')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="null" select="string:setValue('tariff', 'INURB')"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- SETTING THE $TYPE VARIABLE, ACCORDING TO THE CALLING TYPE DEFINED ABOVE -->
            <xsl:choose>
                <xsl:when test="starts-with(string:getValue('num'), '0300')">
                    <xsl:variable name="null" select="string:setValue('type', 'Z3')"/>
                </xsl:when>
                <xsl:when test="@TYPE = 'I'">
                    <xsl:variable name="null" select="string:setValue('type', 'RC')"/>
                    <xsl:if test="(@TYPE_INDICATOR='I') and (@TARIFF_ZONE_SHORT='RZ1' or @TARIFF_ZONE_SHORT='RZ2' or @TARIFF_ZONE_SHORT='RZ3' or @TARIFF_ZONE_SHORT='RZ4' or @TARIFF_ZONE_SHORT='RZ5' or @TARIFF_ZONE_SHORT='RZ6') and (@RE_RATED_AMOUNT &lt; 0)">
                        <xsl:variable name="null" select="string:setValue('type', 'RD')"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@TYPE = 'C'">
                    <xsl:variable name="null" select="string:setValue('type', 'CL')"/>
                </xsl:when>
                <xsl:when test="string:getValue('tariff') = 'LOCAL'">
                    <xsl:variable name="null" select="string:setValue('type', 'LO')"/>
                </xsl:when>
                <xsl:when test="string:getValue('tariff') = 'INURB'">
                    <xsl:variable name="null" select="string:setValue('type', 'LD')"/>
                </xsl:when>
                <xsl:when test="string:getValue('tariff') = 'INTNC'">
                    <xsl:variable name="null" select="string:setValue('type', 'IT')"/>
                </xsl:when>
            </xsl:choose>

            <!-- DETERMING THE CALL LOCATION (HOME or ROAMING) AND AMOUNT TO BE PAID -->
            <string:setValue name="locale" value="H"/>
            <xsl:variable name="null" select="number:setValue('amount', @RE_RATED_AMOUNT)"/>
            <!-- The following statement is used to identify ROAMING calls.               -->
            <!-- The PLMN_INDICATOR will indicate if it is an international roaming call. -->
            <xsl:if test="((string-length(string:getValue('cgiPrefix')) &gt; 0) and (string:getValue('cgiPrefix') != string:getValue('prefix'))) or (@PLMN_INDICATOR = 'V')">
                <string:setValue name="locale" value="R"/>
                <!-- Adjusting the total amount to be paid -->
                <xsl:if test="@PLMN_INDICATOR = 'V'">
                    <xsl:variable name="null" 
                        select="number:setValue('amount', VPLMN_TAP_CHARGE_INFO/@TAP_NET_RATE)"/>
                    <!-- ########## ROAMING INTERNACIONAL ########## -->
                    <xsl:variable name="null" 
                        select="string:setValue('tariff', 'INURB')"/>
                    <!-- ######### ############# -->
                </xsl:if>
            </xsl:if>

	            <!-- PREPARING HOME CALLS INFO -->
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'LO'"/>	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hlocal',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'LD'"/> 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hlong-distance',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'RC'"/> 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hreceived',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'CL'"/>	 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hcollect',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'IT'"/>	 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hinternational',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'Z3'"/> 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hz300',$calls)"/>
	
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'H'"/>
	                    <xsl:with-param name="type" select="'RD'"/>	 	                    
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('hdiscount',$calls)"/>
	            
	            <!-- PREPARING ROAMING CALLS INFO -->
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'LO'"/>                     
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rlocal',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'LD'"/>	                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rlong-distance',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'RC'"/>	                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rreceived',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'CL'"/>	                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rcollect',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'IT'"/>	                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rinternational',$calls)"/>
	            
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'Z3'"/>                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rz300',$calls)"/>
	
	            <xsl:variable name="calls">
	                <xsl:call-template name="telephony-calls">
	                    <xsl:with-param name="location" select="'R'"/>
	                    <xsl:with-param name="type" select="'RD'"/>	                                         
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="null" select="nodelist:add('rdiscount',$calls)"/>
   
			</xsl:for-each>
			
						
            <!-- GENERATING HOME CALLS INFO -->
            <xsl:element name="HOME">

                <!-- DURATION WITHOUT FREE UNITS -->
                <xsl:attribute name="DNF">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('homeSubTotal')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- FREE UNITS -->
                <xsl:attribute name="F">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('homeSubFranquia')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGED MINUTES -->
                <xsl:attribute name="CH">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('homeSubAPagar')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGED VALUE -->
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('contratoDentro')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <xsl:element name="OUTGOING">
                    <xsl:call-template name="directionSummary">
                        <xsl:with-param name="location" select="'H'"/>
                        <xsl:with-param name="direction" select="'OUT'"/>
                    </xsl:call-template>
                    <xsl:element name="LOCAL">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'LO'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hlocal')"/>
                    </xsl:element>
                    <xsl:element name="LONG_DISTANCE">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'LD'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hlong-distance')"/>
                    </xsl:element>
                    <xsl:element name="INTERNATIONAL">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'IT'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hinternational')"/>
                    </xsl:element>
                    <xsl:element name="Z300">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'Z3'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hz300')"/>
                    </xsl:element>
                </xsl:element>

                <xsl:element name="INCOMING">
                    <xsl:call-template name="directionSummary">
                        <xsl:with-param name="location" select="'H'"/>
                        <xsl:with-param name="direction" select="'IN'"/>
                    </xsl:call-template>
                    <xsl:element name="RECEIVED">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'RC'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hreceived')"/>
                    </xsl:element>
                    <xsl:element name="COLLECT">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'CL'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hcollect')"/>
                    </xsl:element>
                    <xsl:element name="DISCOUNTS">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'H'"/>
                            <xsl:with-param name="type" select="'RD'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('hdiscount')"/>
                    </xsl:element>
                </xsl:element>

            </xsl:element>

            <!-- GENERATING ROAMING CALLS INFO -->
            <xsl:element name="ROAMING">

                <!-- DURATION WITHOUT FREE UNITS -->
                <xsl:attribute name="DNF">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('roamingSubTotal')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- FREE UNITS -->
                <xsl:attribute name="F">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('roamingSubFranquia')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGED MINUTES -->
                <xsl:attribute name="CH">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('roamingSubAPagar')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGED VALUE -->
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('contratoFora')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <xsl:element name="OUTGOING">
                    <xsl:call-template name="directionSummary">
                        <xsl:with-param name="location" select="'R'"/>
                        <xsl:with-param name="direction" select="'OUT'"/>
                    </xsl:call-template>
                    <xsl:element name="NO_Z300_SUMMARY">
                        <xsl:call-template name="z300Summary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="direction" select="'OUT'"/>
                            <xsl:with-param name="type" select="'NOZ3'"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="LOCAL">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'LO'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rlocal')"/>
                    </xsl:element>
                    <xsl:element name="LONG_DISTANCE">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'LD'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rlong-distance')"/>
                    </xsl:element>
                    <xsl:element name="INTERNATIONAL">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'IT'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rinternational')"/>
                    </xsl:element>
                    <xsl:element name="Z300">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'Z3'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rz300')"/>
                    </xsl:element>
                </xsl:element>

                <xsl:element name="INCOMING">
                    <xsl:call-template name="directionSummary">
                        <xsl:with-param name="location" select="'R'"/>
                        <xsl:with-param name="direction" select="'IN'"/>
                    </xsl:call-template>
                    <xsl:element name="RECEIVED">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'RC'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rreceived')"/>
                    </xsl:element>
                    <xsl:element name="COLLECT">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'CL'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rcollect')"/>
                    </xsl:element>
                    <xsl:element name="DISCOUNTS">
                        <xsl:call-template name="callSummary">
                            <xsl:with-param name="location" select="'R'"/>
                            <xsl:with-param name="type" select="'RD'"/>
                        </xsl:call-template>
                        <xsl:copy-of select="nodelist:getValue('rdiscount')"/>
                    </xsl:element>
                </xsl:element>

            </xsl:element>

        </xsl:element>
        <!-- END OF CALL DETAILS -->

        <!-- UPDATING CUSTOMER SUBTOTALS -->
        <xsl:variable name="null" select="number:setValue('minutosConexaoDireta', number:getValue('minutosConexaoDireta') + number:getValue('conexaoSubTotal'))"/>
        <xsl:variable name="null" select="number:setValue('minutosChamadasDentro', number:getValue('minutosChamadasDentro') + number:getValue('homeSubTotal'))"/>
        <xsl:variable name="null" select="number:setValue('minutosChamadasFora', number:getValue('minutosChamadasFora') + number:getValue('roamingSubTotal'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasDentro', number:getValue('chamadasDentro') + number:getValue('contratoDentro'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasLocais', number:getValue('chamadasLocais') + number:getValue('contratoLocais'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasLonga', number:getValue('chamadasLonga') + number:getValue('contratoLonga'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasRecebidas', number:getValue('chamadasRecebidas') + number:getValue('contratoRecebidas'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasDescontos', number:getValue('chamadasDescontos') + number:getValue('contratoDescontos'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasRecebidasCobrar', number:getValue('chamadasRecebidasCobrar') + number:getValue('contratoRecebidasCobrar'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasInternacionais', number:getValue('chamadasInternacionais') + number:getValue('contratoInternacionais'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasZ300', number:getValue('chamadasZ300') + number:getValue('contratoZ300'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasFora', number:getValue('chamadasFora') + number:getValue('contratoFora'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasForaRecebidas', number:getValue('chamadasForaRecebidas') + number:getValue('contratoForaRecebidas'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasForaDescontos', number:getValue('chamadasForaDescontos') + number:getValue('contratoForaDescontos'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasForaRecebidasCobrar', number:getValue('chamadasForaRecebidasCobrar') + number:getValue('contratoForaRecebidasCobrar'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasForaOriginadas', number:getValue('chamadasForaOriginadas') + number:getValue('contratoForaOriginadas'))"/>
        <xsl:variable name="null" select="number:setValue('chamadasForaZ300', number:getValue('chamadasForaZ300') + number:getValue('contratoForaZ300'))"/>

    </xsl:template>

    <xsl:template name="callSummary">
        <!-- H = HOME CALLS -->
        <!-- R = ROAMING CALLS -->
        <xsl:param name="location"/>
        <!-- LC = LOCAL -->
        <!-- LD = LONG_DISTANCE -->
        <!-- IT = INTERNATIONAL -->
        <!-- CL = COLLECT -->
        <!-- RC = RECEIVED -->
        <!-- Z3 = 0300 -->
        <xsl:param name="type"/>

        <xsl:for-each select="aggregates:getKeys('callSummary')/key">
            <xsl:if test="(aggregates:getKey('callSummary', @value, 'loc') = $location) and (aggregates:getKey('callSummary', @value, 'type') = $type)">
                <!-- TOTAL DURATION WITHOUT FREE UNITS -->
                <xsl:attribute name="DNF">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'totNoFree')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- AIR DURATION -->
                <xsl:attribute name="DA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'totAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR FREE UNITS USE -->
                <xsl:attribute name="FA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'fraAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR CHARGED MINUTES -->
                <xsl:attribute name="CHA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'apaAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR VALUE -->
                <xsl:attribute name="VA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'valAir')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOLL CHARGED MINUTES -->
                <xsl:attribute name="CHT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'apaTol')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- TOLL VALUE -->
                <xsl:attribute name="VT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'valTol')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL CALL DURATION (everything) -->
                <xsl:attribute name="DR">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'tot')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL CHARGED VALUE -->
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('callSummary', @value, 'val')"/>
                    </xsl:call-template>
                </xsl:attribute>

            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="directionSummary">
        <!-- H = HOME CALLS -->
        <!-- R = ROAMING CALLS -->
        <xsl:param name="location"/>
        <!-- IN  = INCOMING CALLS -->
        <!-- OUT = OUTGOING CALLS -->
        <xsl:param name="direction"/>

        <xsl:for-each select="aggregates:getKeys('directionSummary')/key">
            <xsl:if test="(aggregates:getKey('directionSummary', @value, 'loc') = $location) and (aggregates:getKey('directionSummary', @value, 'dir') = $direction)">
                <!-- TOTAL DURATION WITHOUT FREE UNITS -->
                <xsl:attribute name="DNF">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'totNoFree')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- AIR DURATION -->
                <xsl:attribute name="DA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'totAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR FREE UNITS USE -->
                <xsl:attribute name="FA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'fraAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR CHARGED MINUTES -->
                <xsl:attribute name="CHA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'apaAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR VALUE -->
                <xsl:attribute name="VA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'valAir')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOLL CHARGED MINUTES -->
                <xsl:attribute name="CHT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'apaTol')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- TOLL VALUE -->
                <xsl:attribute name="VT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'valTol')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL CALL DURATION (everything) -->
                <xsl:attribute name="DR">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'tot')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('directionSummary', @value, 'val')"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="z300Summary">
        <!-- H = HOME CALLS -->
        <!-- R = ROAMING CALLS -->
        <xsl:param name="location"/>
        <!-- IN  = INCOMING CALLS -->
        <!-- OUT = OUTGOING CALLS -->
        <xsl:param name="direction"/>
        <!-- Z3   = 0300 -->
        <!-- NOZ3 = ALL CALLS EXCEPT 0300 -->
        <xsl:param name="type"/>

        <xsl:for-each select="aggregates:getKeys('z300Summary')/key">
            <xsl:if test="(aggregates:getKey('z300Summary', @value, 'loc') = $location) and (aggregates:getKey('z300Summary', @value, 'dir') = $direction) and (aggregates:getKey('z300Summary', @value, 'type') = $type)">
                <!-- TOTAL DURATION WITHOUT FREE UNITS -->
                <xsl:attribute name="DNF">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'totNoFree')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- AIR DURATION -->
                <xsl:attribute name="DA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'totAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR FREE UNITS USE -->
                <xsl:attribute name="FA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'fraAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR CHARGED MINUTES -->
                <xsl:attribute name="CHA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'apaAir')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- AIR VALUE -->
                <xsl:attribute name="VA">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'valAir')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOLL CHARGED MINUTES -->
                <xsl:attribute name="CHT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'apaTol')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- TOLL VALUE -->
                <xsl:attribute name="VT">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'valTol')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL CALL DURATION (everything) -->
                <xsl:attribute name="DR">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'tot')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                            select="aggregates:getValue('z300Summary', @value, 'val')"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>