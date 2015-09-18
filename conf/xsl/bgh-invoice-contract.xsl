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
    xmlns:xalan="http://xml.apache.org/xalan"
    extension-element-prefixes="xalan number aggregates date string sql phonenumber nodelist"
    exclude-result-prefixes="xalan number string date sql aggregates phonenumber nodelist"
                version="1.0">


    <xsl:include href="bgh-invoice-contract-details.xsl"/>
    <xsl:include href="bgh-invoice-contract-charges.xsl"/>
    <xsl:include href="bgh-invoice-service-summary.xsl"/>
        

    <xsl:template name="contractInfo">

        <!-- CONTEXT: "LIN2" -->

        <number:setValue name="idcdAmount"                  value="0"/>
        <number:setValue name="idcdTimeCall"                value="0"/>
        <number:setValue name="contratoDentro"              value="0"/>
        <number:setValue name="contratoLocais"              value="0"/>
        <number:setValue name="contratoLonga"               value="0"/>
        <number:setValue name="contratoRecebidas"           value="0"/>
        <number:setValue name="contratoDescontos"           value="0"/>
        <number:setValue name="contratoRecebidasCobrar"     value="0"/>
        <number:setValue name="contratoInternacionais"      value="0"/>
        <number:setValue name="contratoZ300"                value="0"/>
        <number:setValue name="contratoFora"                value="0"/>
        <number:setValue name="contratoForaRecebidas"       value="0"/>
        <number:setValue name="contratoForaDescontos"       value="0"/>
        <number:setValue name="contratoForaRecebidasCobrar" value="0"/>
        <number:setValue name="contratoForaOriginadas"      value="0"/>
        <number:setValue name="contratoForaZ300"            value="0"/>

        <string:setValue name="cdicChergeType"              value=""/>
        <string:setValue name="cdicChargeServiceCode"       value=""/>
        <string:setValue name="cdicChargeServiceDesc"       value=""/>
        <string:setValue name="cdicChargeRatePlanc"         value=""/>
        <string:setValue name="cdicStatus"                  value="a"/>
        <date:setValue   name="cdicDateStart"               value=""/>
        <date:setValue   name="cdicDateEnd"                 value=""/>
        <number:setValue name="cdicChargeDays"              value="0"/>
        <string:setValue name="cdicDiscountDesc"            value=""/>
        <number:setValue name="cdicDiscountVal"             value="0"/>
        <number:setValue name="subCDICChargeValue"          value="0"/>

        <number:setValue name="men"                			value="0"/>
        <number:setValue name="torpedoSMS"                	value="0"/>
        <number:setValue name="torpedoMMST"                	value="0"/>

        <number:setValue name="torpedoMMSI"                	value="0"/>

        <number:setValue name="subtotalAdditional" 			value="0"/>
        <number:setValue name="onlineAmount"       			value="0"/>

        <string:setValue name="service"  value=""/>
        <string:setValue name="outState" value=""/>
        <string:setValue name="state"    value=""/>

        <xsl:variable name="contractId" select="IMD/ITEM[@CODE='CO']/@FULL_VALUE"/>
        <xsl:variable name="deviceId"   select="IMD/ITEM[@CODE='SMNUM']/@FULL_VALUE"/>
        
        <!-- Type(Analogico / Digital) -->
        <xsl:variable name="typeId"     select="IMD/ITEM[@CODE='MRKT']/@SHORT_VALUE"/>

		<!-- @TOKEN
        <xsl:variable name="mibasContract" 
                      select="sql:query('mibas', 'MibasContract', $deviceId)/record"/>
        @TOKEN -->
        <xsl:variable name="mibasContract" select="."/>

        <xsl:if test="$typeId = 'GSM'">
	
	        <xsl:variable name="null" 
	            select="string:setValue('fleetId', $mibasContract/@fleet_id)"/>
	        <xsl:variable name="null" 
	            select="string:setValue('memberId', $mibasContract/@member_id)"/>
	
	        <!-- using the condition bellow only to avoid making an unnecessary SQL statement call -->
	
	        <xsl:if test="(string-length(string:getValue('fleetId')) = 0) or (string-length(string:getValue('memberId')) = 0)">
	         	<!-- @TOKEN@
	            <xsl:variable name="mibasFleet" select="sql:query('mibas', 'MibasFleet', $deviceId)/record"/>
	            @TOKEN@ -->
	            <xsl:variable name="mibasFleet" select="."/>
	            <xsl:if test="string-length(string:getValue('fleetId')) = 0">
	                <xsl:variable name="null" select="string:setValue('fleetId', $mibasFleet/@fleet_id)"/>
	            </xsl:if>
	            <xsl:if test="string-length(string:getValue('memberId')) = 0">
	                <xsl:variable name="null" select="string:setValue('memberId', $mibasFleet/@member_id)"/>
	            </xsl:if>
	        </xsl:if>

		</xsl:if>

		<xsl:if test="$typeId = 'AMP'">
			<xsl:value-of select="string:setValue('fleetId','')"/>
			<xsl:value-of select="string:setValue('memberId','')"/>
		</xsl:if>
		
        <xsl:variable name="directoryNumbers" select="IMD[(ITEM/@CODE='DNNUM') and (preceding-sibling::node()[(position()=1) and ((ITEM[@CODE='SN']/@SHORT_VALUE='TELAL') or (ITEM[@CODE='SN']/@SHORT_VALUE='PPTEL'))])]"/>

        <xsl:variable name="directoryNumber" select="$directoryNumbers[last()]/ITEM/@FULL_VALUE"/>

        <!-- auxiliary variable to hold some directory number info -->
        <xsl:variable name="numberInfo" select="phonenumber:parse($directoryNumber)"/>
        <!-- DIRECTORY NUMBER PREFIX -->
        <xsl:variable name="null" select="string:setValue('prefix', phonenumber:getAreaCode())"/>
        <!-- PHANTOM NUMBER INDICATOR -->
        <xsl:variable name="null" select="string:setValue('phantom', phonenumber:getFirstDigit())"/>

        <!-- SUBSCRIBER SUBTOTAL (amount + discounts) -->
        <!-- ################################################################ -->
        <!-- REVER!!! sum(descendant::LIN6/MOA) NÃO PARECE ESTAR CORRETO!!!!! -->
        <!-- ################################################################ -->
        <xsl:variable name="null" select="number:setValue('totalSubscriber', number:getValue('totalSubscriber') + number:setValue('subtotalSubscriber', number:parse(MOA/AMOUNT[@TYPE='931']/@VALUE) + sum(descendant::LIN6/MOA/AMOUNT[@TYPE='919']/@VALUE)))"/>

        <!-- storing nextel online services (nol) -->
        <xsl:variable name="nol" select="descendant::LIN4[IMD/ITEM/@CODE='SN' and (IMD/ITEM/@SHORT_VALUE='SMST' or IMD/ITEM/@SHORT_VALUE='WP' or IMD/ITEM/@SHORT_VALUE='TWM' or IMD/ITEM/@SHORT_VALUE='WPTWM' or IMD/ITEM/@SHORT_VALUE='CLIRB' or IMD/ITEM/@SHORT_VALUE='CIRDT' or IMD/ITEM/@SHORT_VALUE='NMSIM' or IMD/ITEM/@SHORT_VALUE='NMPLS' or IMD/ITEM/@SHORT_VALUE='NMBAS' or IMD/ITEM/@SHORT_VALUE='N200K' or IMD/ITEM/@SHORT_VALUE='MDD3' or IMD/ITEM/@SHORT_VALUE='N1200' or IMD/ITEM/@SHORT_VALUE='N2200' or IMD/ITEM/@SHORT_VALUE='N4200' or IMD/ITEM/@SHORT_VALUE='N5200' or IMD/ITEM/@SHORT_VALUE='N2300' or IMD/ITEM/@SHORT_VALUE='N3300' or IMD/ITEM/@SHORT_VALUE='N4300' or IMD/ITEM/@SHORT_VALUE='N5300' or IMD/ITEM/@SHORT_VALUE='N1600' or IMD/ITEM/@SHORT_VALUE='N2600' or IMD/ITEM/@SHORT_VALUE='N3600' or IMD/ITEM/@SHORT_VALUE='N4600' or IMD/ITEM/@SHORT_VALUE='N5600' or IMD/ITEM/@SHORT_VALUE='N11MB' or IMD/ITEM/@SHORT_VALUE='N21MB' or IMD/ITEM/@SHORT_VALUE='N31MB' or IMD/ITEM/@SHORT_VALUE='N41MB' or IMD/ITEM/@SHORT_VALUE='N51MB' or IMD/ITEM/@SHORT_VALUE='N13MB' or IMD/ITEM/@SHORT_VALUE='N23MB' or IMD/ITEM/@SHORT_VALUE='N33MB' or IMD/ITEM/@SHORT_VALUE='N43MB' or IMD/ITEM/@SHORT_VALUE='N53MB' or IMD/ITEM/@SHORT_VALUE='N110M' or IMD/ITEM/@SHORT_VALUE='N210M' or IMD/ITEM/@SHORT_VALUE='N310M' or IMD/ITEM/@SHORT_VALUE='N410M' or IMD/ITEM/@SHORT_VALUE='N510M' or IMD/ITEM/@SHORT_VALUE='MDD1' or IMD/ITEM/@SHORT_VALUE='MDD2' or IMD/ITEM/@SHORT_VALUE='MDD4' or IMD/ITEM/@SHORT_VALUE='MDD4' or IMD/ITEM/@SHORT_VALUE='N1300' or IMD/ITEM/@SHORT_VALUE='EQON' or IMD/ITEM/@SHORT_VALUE='TP' or IMD/ITEM/@SHORT_VALUE='NOWAS' or IMD/ITEM/@SHORT_VALUE='LONEX' or IMD/ITEM/@SHORT_VALUE='EQLOC' or IMD/ITEM/@SHORT_VALUE='ITAUW' or IMD/ITEM/@SHORT_VALUE='DOWN' or IMD/ITEM/@SHORT_VALUE='DOWNS' or IMD/ITEM/@SHORT_VALUE='MMST' or IMD/ITEM/@SHORT_VALUE='MMSI' or IMD/ITEM/@SHORT_VALUE='GPSDA')]"/>


        <!-- storing additional services (all but [TELAL, DISPP, DISPG and NOL, ME]) -->
        <xsl:variable name="additional" select="xalan:difference(descendant::LIN4[IMD/ITEM/@CODE='SN' and not(IMD/ITEM/@SHORT_VALUE='ME' or IMD/ITEM/@SHORT_VALUE='DISPP' or IMD/ITEM/@SHORT_VALUE='DISPG' or IMD/ITEM/@SHORT_VALUE='TELAL' or IMD/ITEM/@SHORT_VALUE='PPTEL' or IMD/ITEM/@SHORT_VALUE='CDI' or IMD/ITEM/@SHORT_VALUE='CDIC' or IMD/ITEM/@SHORT_VALUE='CDIB' or IMD/ITEM/@SHORT_VALUE='CDIA')], $nol)"/>

        <xsl:call-template name="serviceSummary"/>

        <xsl:element name="CONTRACT">

            <!-- CONTRACT ID -->
            <xsl:attribute name="ID">
                <xsl:value-of select="$contractId"/>
            </xsl:attribute>

            <!-- Para obter o MPRP -->
            <xsl:variable name="minutePackage"   select="LIN3[IMD/ITEM/@CODE='CT']/LIN4/IMD/ITEM[@CODE='TM']/@SHORT_VALUE"/>
            <!-- FLEET ID -->
            <xsl:attribute name="FID">
                <xsl:choose>
                    <xsl:when test="(contains($minutePackage,'MPRP'))">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string:getValue('fleetId')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- MEMBER ID -->
            <xsl:attribute name="MID">
                <xsl:choose>
                    <xsl:when test="(contains($minutePackage,'MPRP'))">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string:getValue('memberId')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- SUBSCRIBER NAME -->
            <xsl:attribute name="U">
                <xsl:choose>
                    <xsl:when test="(contains($minutePackage,'MPRP'))">
                        <xsl:value-of select="'Pac. de Minutos'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$mibasContract/@holder_name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- Pre Pago -->
            <xsl:attribute name="PP">
                <xsl:choose>
                    <xsl:when test="LIN3[last()]/XCD[@SERVICE_SHORT='PPTEL']">
                        <xsl:value-of select="'Y'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'N'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- PHONE NUMBER -->
            <xsl:if test="string:getValue('phantom') != '1'">
                <xsl:attribute name="N">
                    <xsl:choose>
                        <xsl:when test="(contains($minutePackage,'MPRP'))">
                            <xsl:value-of select="''"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$directoryNumber"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            
            <!-- SUBSCRIBER TOTAL -->
            <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('subtotalSubscriber')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- MONTHLY TOTAL -->
            <xsl:attribute name="M">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('men')"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:variable name="null"
                select="number:setValue('mensalidade', number:getValue('mensalidade') + number:getValue('men'))"/>

            <!-- ADDITIONAL SERVICES TOTAL -->
            <xsl:attribute name="A">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('subtotalAdditional')"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:variable name="null" select="number:setValue('adicionais', number:getValue('adicionais') + number:getValue('subtotalAdditional'))"/>

            <!-- NEXTEL ONLINE SERVICES TOTAL -->
            <xsl:attribute name="O">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('onlineAmount')"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:variable name="null"
                select="number:setValue('servicoDados', number:getValue('servicoDados') + number:getValue('onlineAmount'))"/>
            
            <!-- CONTRACT IMEI -->
            <xsl:attribute name="IMEI">
                <xsl:value-of select="$deviceId"/>
            </xsl:attribute>

            <!-- RADIO TYPE -->
            <xsl:attribute name="TP">
                <xsl:value-of select="$typeId"/>
            </xsl:attribute>
            
            
            <!-- SERVICES SUMMARY OUTPUT -->
            <xsl:element name="SERVICES">
                <xsl:for-each select="aggregates:getKeys('servicesSummary')/key">
                    <xsl:element name="SVC">
                        <!-- TYPE -->
                        <xsl:attribute name="TP">
                            <xsl:value-of select="aggregates:getKey('servicesSummary', @value, 'tp')"/>
                        </xsl:attribute>
                        <!-- SERVICE CODE -->
                        <xsl:attribute name="ID">
                            <xsl:value-of select="aggregates:getKey('servicesSummary', @value, 'id')"/>
                        </xsl:attribute>
                        <!-- VALUE -->
                        <xsl:attribute name="V">
                            <xsl:call-template name="decimalFormat">
                                <xsl:with-param name="value" 
                                    select="aggregates:getValue('servicesSummary', @value, 'v')"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
                <number:setValue name="circuitDataTotal" value="0"/>
                <string:setValue name="circuitDataType"               value=""/>
                <string:setValue name="circuitDataServiceCode"        value=""/>
                <string:setValue name="circuitDataServiceDescription" value=""/>
                <string:setValue name="circuitDataStatus"             value=""/>
                <number:setValue name="circuitDataQuantity"           value=""/>
                <number:setValue name="circuitDataValue"              value=""/>
                
                <number:setValue name="torpedoSMSDataTotal" value="0"/>
                <string:setValue name="torpedoSMSDataType"               value=""/>
                <string:setValue name="torpedoSMSDataServiceCode"        value=""/>
                <string:setValue name="torpedoSMSDataServiceDescription" value=""/>
                <string:setValue name="torpedoSMSDataStatus"             value=""/>
                <number:setValue name="torpedoSMSDataQuantity"           value=""/>
                <number:setValue name="torpedoSMSDataValue"              value=""/>
                <number:setValue name="torpedoSMSUnitValue"              value=""/>

                <number:setValue name="torpedoMMSTDataTotal" value="0"/>
                <string:setValue name="torpedoMMSTDataType"               value=""/>
                <string:setValue name="torpedoMMSTDataServiceCode"        value=""/>
                <string:setValue name="torpedoMMSTDataServiceDescription" value=""/>
                <string:setValue name="torpedoMMSTDataStatus"             value=""/>
                <number:setValue name="torpedoMMSTDataQuantity"           value=""/>
                <number:setValue name="torpedoMMSTDataValue"              value=""/>
                <number:setValue name="torpedoMMSTUnitValue"              value=""/>
                
                <number:setValue name="torpedoMMSIDataTotal" value="0"/>
                <string:setValue name="torpedoMMSIDataType"               value=""/>
                <string:setValue name="torpedoMMSIDataServiceCode"        value=""/>
                <string:setValue name="torpedoMMSIDataServiceDescription" value=""/>
                <string:setValue name="torpedoMMSIDataStatus"             value=""/>
                <number:setValue name="torpedoMMSIDataQuantity"           value=""/>
                <number:setValue name="torpedoMMSIDataValue"              value=""/>
                <number:setValue name="torpedoMMSIUnitValue"              value=""/>
                <number:setValue name="downloadDataTotal" value="0"/>
                <string:setValue name="downloadDataType"               value=""/>
                <string:setValue name="downloadDataServiceCode"        value=""/>
                <string:setValue name="downloadDataServiceDescription" value=""/>
                <string:setValue name="downloadDataStatus"             value=""/>
                <number:setValue name="downloadDataQuantity"           value=""/>
                <number:setValue name="downloadDataValue"              value=""/>
                <number:setValue name="downloadUnitValue"              value=""/>

                <xsl:for-each select="$nol">
                    <xsl:call-template name="serviceCharges">
                        <xsl:with-param name="useNextelOnlineMode" select="'TRUE'"/>
                    </xsl:call-template>
                </xsl:for-each>

                <!-- Circuit Data information flush - show only if there is any quantity or value -->
                <xsl:if test="(string-length(string:getValue('circuitDataServiceCode')) &gt; 0) and ( (number(number:getValue('circuitDataQuantity')) != 0) or (number(number:getValue('circuitDataValue')) != 0) )">
                    <xsl:element name="ONLINE">
                        <!-- TYPE -->
                        <xsl:attribute name="TP">
                            <xsl:value-of select="string:getValue('circuitDataType')"/>
                        </xsl:attribute>
                        <!-- SERVICE CODE -->
                        <xsl:attribute name="ID">
                            <xsl:value-of select="string:getValue('circuitDataServiceCode')"/>
                        </xsl:attribute>
                        <!-- SERVICE DESCRIPTON -->
                        <xsl:attribute name="DS">
                            <xsl:value-of select="string:getValue('circuitDataServiceDescription')"/>
                        </xsl:attribute>
                        <!-- QUANTITY -->
                        <xsl:attribute name="Q">
                            <xsl:call-template name="decimalFormat">
                                <xsl:with-param name="value" select="number:getValue('circuitDataQuantity')"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <!-- STATUS -->
                        <xsl:attribute name="ST">
                            <xsl:value-of select="string:getValue('circuitDataStatus')"/>
                        </xsl:attribute>
                        <!-- VALUE -->
                        <xsl:attribute name="V">
                            <xsl:call-template name="decimalFormat">
                                <xsl:with-param name="value" select="number:getValue('circuitDataValue')"/>
                            </xsl:call-template>
                            
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
                
								<!--  BY AUSTER -->
                <xsl:if test="(string-length(string:getValue('torpedoSMSDataServiceCode'))  &gt; 0) or
							                (string-length(string:getValue('torpedoMMSTDataServiceCode')) &gt; 0) or
							                (string-length(string:getValue('torpedoMMSIDataServiceCode')) &gt; 0) or
							                (string-length(string:getValue('downloadDataServiceCode')) 		&gt; 0)">

		                <xsl:if test="(string-length(string:getValue('downloadDataServiceCode')) &gt; 0)">
		                    <aggregates:reset aggregate="downloads"/>                    
		                </xsl:if>						
		                	                
		                <xsl:call-template name="usageHandler"/>	
		                
		                <xsl:if test="(string-length(string:getValue('torpedoSMSDataServiceCode')) &gt; 0)">

				            <xsl:variable name="null" 
				                select="number:setValue('torpedoSMSUnitValue', number:getValue('torpedoSMSDataValue') div number:getValue('torpedoSMSDataQuantity'))"/>		                	

		                    <xsl:element name="TORPEDO">
		                        <!-- TYPE -->
		                        <xsl:attribute name="TP">
		                            <xsl:value-of select="string:getValue('torpedoSMSDataType')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE CODE -->
		                        <xsl:attribute name="ID">
		                            <xsl:value-of select="string:getValue('torpedoSMSDataServiceCode')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE DESCRIPTON -->
		                        <xsl:attribute name="DS">
		                            <xsl:value-of select="string:getValue('torpedoSMSDataServiceDescription')"/>
		                        </xsl:attribute>
		                        <!-- QUANTITY -->
		                        <xsl:attribute name="Q">
		                            <xsl:call-template name="numberFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoSMSDataQuantity')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- STATUS -->
		                        <xsl:attribute name="ST">
		                            <xsl:value-of select="string:getValue('torpedoSMSDataStatus')"/>
		                        </xsl:attribute>
		                        <!-- UNITARY VALUE -->
		                        <xsl:attribute name="U">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoSMSUnitValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- VALUE -->
		                        <xsl:attribute name="V">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoSMSDataValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                    </xsl:element>		                
		                </xsl:if>		

		                <xsl:if test="(string-length(string:getValue('torpedoMMSTDataServiceCode')) &gt; 0)">	

				            <xsl:variable name="null" 
				                select="number:setValue('torpedoMMSTUnitValue', number:getValue('torpedoMMSTDataValue') div number:getValue('torpedoMMSTDataQuantity'))"/>		                	

		                    <xsl:element name="TORPEDO">
		                        <!-- TYPE -->
		                        <xsl:attribute name="TP">
		                            <xsl:value-of select="string:getValue('torpedoMMSTDataType')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE CODE -->
		                        <xsl:attribute name="ID">
		                            <xsl:value-of select="string:getValue('torpedoMMSTDataServiceCode')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE DESCRIPTON -->
		                        <xsl:attribute name="DS">
		                            <xsl:value-of select="string:getValue('torpedoMMSTDataServiceDescription')"/>
		                        </xsl:attribute>
		                        <!-- QUANTITY -->
		                        <xsl:attribute name="Q">
		                            <xsl:call-template name="numberFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSTDataQuantity')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- STATUS -->
		                        <xsl:attribute name="ST">
		                            <xsl:value-of select="string:getValue('torpedoMMSTDataStatus')"/>
		                        </xsl:attribute>
		                        <!-- UNITARY VALUE -->
		                        <xsl:attribute name="U">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSTUnitValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- VALUE -->
		                        <xsl:attribute name="V">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSTDataValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                    </xsl:element>		                	                				                
										</xsl:if>		
										
		                <xsl:if test="(string-length(string:getValue('torpedoMMSIDataServiceCode')) &gt; 0)">		

				            <xsl:variable name="null" 
				                select="number:setValue('torpedoMMSIUnitValue', number:getValue('torpedoMMSIDataValue') div number:getValue('torpedoMMSIDataQuantity'))"/>		                	

		                    <xsl:element name="TORPEDO">
		                        <!-- TYPE -->
		                        <xsl:attribute name="TP">
		                            <xsl:value-of select="string:getValue('torpedoMMSIDataType')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE CODE -->
		                        <xsl:attribute name="ID">
		                            <xsl:value-of select="string:getValue('torpedoMMSIDataServiceCode')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE DESCRIPTON -->
		                        <xsl:attribute name="DS">
		                            <xsl:value-of select="string:getValue('torpedoMMSIDataServiceDescription')"/>
		                        </xsl:attribute>
		                        <!-- QUANTITY -->
		                        <xsl:attribute name="Q">
		                            <xsl:call-template name="numberFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSIDataQuantity')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- STATUS -->
		                        <xsl:attribute name="ST">
		                            <xsl:value-of select="string:getValue('torpedoMMSIDataStatus')"/>
		                        </xsl:attribute>
		                        <!-- UNITARY VALUE -->
		                        <xsl:attribute name="U">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSIUnitValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- VALUE -->
		                        <xsl:attribute name="V">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('torpedoMMSIDataValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                    </xsl:element>		                								
		                </xsl:if>
		                
		                <xsl:if test="(string-length(string:getValue('downloadDataServiceCode')) &gt; 0)">
		                    <xsl:element name="DOWNLOADS">	
		                        <!-- TYPE -->
		                        <xsl:attribute name="TP">
		                            <xsl:value-of select="string:getValue('downloadDataType')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE CODE -->
		                        <xsl:attribute name="ID">
		                            <xsl:value-of select="string:getValue('downloadDataServiceCode')"/>
		                        </xsl:attribute>
		                        <!-- SERVICE DESCRIPTON -->
		                        <xsl:attribute name="DS">
		                            <xsl:value-of select="string:getValue('downloadDataServiceDescription')"/>
		                        </xsl:attribute>
		                        <!-- QUANTITY -->
		                        <xsl:attribute name="Q">
		                            <xsl:call-template name="numberFormat">
		                                <xsl:with-param name="value" select="number:getValue('downloadDataQuantity')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		                        <!-- STATUS -->
		                        <xsl:attribute name="ST">
		                            <xsl:value-of select="string:getValue('downloadDataStatus')"/>
		                        </xsl:attribute>
		                        <!-- VALUE -->
		                        <xsl:attribute name="V">
		                            <xsl:call-template name="decimalFormat">
		                                <xsl:with-param name="value" select="number:getValue('downloadDataValue')"/>
		                            </xsl:call-template>
		                        </xsl:attribute>
		
		                        <xsl:for-each select="aggregates:getKeys('downloads')/key">
		                            <xsl:element name="DL">
		                                <!-- Main Number -->
		                                <xsl:attribute name="MN">
		                                    <xsl:value-of select="aggregates:getKey('downloads', @value, 'mn')"/>
		                                </xsl:attribute>
		                                <!-- Valor -->
		                                <xsl:attribute name="VU">
		                                    <xsl:call-template name="decimalFormat">
		                                        <xsl:with-param name="value" 
		                                            select="aggregates:getKey('downloads', @value, 'vl')"/>
		                                    </xsl:call-template>
		                                </xsl:attribute>
		                                <!-- Description -->
		                                <xsl:attribute name="DS">
		                                    <xsl:value-of select="aggregates:getKey('downloads', @value, 'des')"/>
		                                </xsl:attribute>
		                                <!-- TYPE -->
		                                <xsl:attribute name="T">
		                                    <xsl:value-of select="aggregates:getKey('downloads', @value, 'tp')"/>
		                                </xsl:attribute>
		                                <!-- DATE -->
		                                <xsl:attribute name="DT">
		                                    <xsl:value-of select="aggregates:getKey('downloads', @value, 'dt')"/>
		                                </xsl:attribute>
		                                <!-- TIME -->
		                                <xsl:attribute name="TM">
		                                    <xsl:value-of select="aggregates:getKey('downloads', @value, 'tm')"/>
		                                </xsl:attribute>
		                            </xsl:element>
		                            
		                        </xsl:for-each>
		                    </xsl:element>		                		                
		                </xsl:if>
		                
                </xsl:if> 
                               
                <xsl:element name="TOTAL">
                    <xsl:attribute name="CDATA">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" select="number:getValue('circuitDataTotal')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
                
            </xsl:element>
            
            <!-- CHARGES -->
            <xsl:element name="CHARGES">
                <xsl:call-template name="contractCharges"/>
            </xsl:element>

          
            <!-- DETAILS -->
            <xsl:call-template name="contractDetails"/>
            <nodelist:reset/>

        </xsl:element>
        
    </xsl:template>

</xsl:stylesheet>
