<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
	xmlns:number="xalan://br.com.auster.common.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:xalan="http://xml.apache.org/xalan"
    extension-element-prefixes="xalan number aggregates date string sql"
    exclude-result-prefixes="xalan number string date sql aggregates"
                version="1.0">

    <xsl:template name="contractCharges">

       <xsl:variable name="typeId" select="IMD/ITEM[@CODE='MRKT']/@SHORT_VALUE"/>

       <xsl:for-each select="LIN3[IMD/ITEM/@CODE='CT']">
       
            <xsl:if test="((IMD/ITEM[@CODE='CT']/@FULL_VALUE = 'A') or 
            			   (IMD/ITEM[@CODE='CT']/@FULL_VALUE = 'S' and $typeId='AMP'))">

                <xsl:element name="CHG">
                    <!-- TYPE -->
                    <xsl:attribute name="TP">
                        <xsl:value-of select="IMD/ITEM[@CODE='CT']/@FULL_VALUE"/>
                    </xsl:attribute>
                    <!-- VALUE -->	
                    <xsl:attribute name="V">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" select="MOA/AMOUNT[@TYPE='932']/@VALUE"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:for-each select="LIN4">
                   	    <xsl:call-template name="serviceCharges">
                    	    <xsl:with-param name="useNextelOnlineMode" select="'FALSE'"/>
       	                </xsl:call-template>
                    </xsl:for-each>
                </xsl:element>

            </xsl:if>

            <xsl:if test="((IMD/ITEM[@CODE='CT']/@FULL_VALUE = 'U'))">
            
                <xsl:for-each select="LIN4[IMD/ITEM[@CODE='SN']/@SHORT_VALUE = 'CDIC']">
               	    <xsl:call-template name="serviceChargesCDIC"/>
                </xsl:for-each>

		        <xsl:if test="number:getValue('subCDICChargeValue') &gt; 0">
               		<xsl:element name="CHG">
                   		<!-- TYPE -->
                   		<xsl:attribute name="TP">
                       		<xsl:value-of select="IMD/ITEM[@CODE='CT']/@FULL_VALUE"/>
                   		</xsl:attribute>
                   		<!-- VALUE -->	
                   		<xsl:attribute name="V">
                       		<xsl:call-template name="decimalFormat">
                           		<xsl:with-param name="value" select="number:getValue('subCDICChargeValue')"/>
                       		</xsl:call-template>
                   		</xsl:attribute>

               	    	<xsl:call-template name="subServiceChargesCDIC"/>
                   	    	
               		</xsl:element>
		        </xsl:if>

            </xsl:if>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="serviceChargesCDIC">
        <xsl:variable name="null"
            select="string:setValue('cdicChargeType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
        <xsl:variable name="null"
            select="string:setValue('cdicChargeServiceCode', IMD/ITEM/@SHORT_VALUE)"/>
        <xsl:variable name="null"
            select="string:setValue('cdicChargeServiceDesc', IMD/ITEM/@FULL_VALUE)"/>
        <xsl:variable name="null"
            select="string:setValue('cdicChargeRatePlan', IMD/ITEM[@CODE='TM']/@FULL_VALUE)"/>
        <xsl:variable name="null"
            select="number:setValue('cdicChargeValue', MOA/AMOUNT[@TYPE='203']/@VALUE)"/>
        <xsl:variable name="null" 
            select="number:setValue('subCDICChargeValue', number:getValue('subCDICChargeValue') + number:getValue('cdicChargeValue'))"/>

        <xsl:for-each select="LIN5">
            <xsl:for-each select="LIN6[IMD/ITEM/@CODE='DISC']">
                <xsl:variable name="null" 
                    select="string:setValue('cdicDiscountDesc',IMD/ITEM[@CODE='DISC']/@FULL_VALUE)"/>
                <xsl:variable name="null"
                    select="number:setValue('cdicDiscountVal', number:getValue('cdicDiscountVal') + number:parse(MOA/AMOUNT[@TYPE='919']/@VALUE))"/>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="subServiceChargesCDIC">

	    <xsl:element name="SVC">
			<!-- TYPE -->
	        <xsl:attribute name="TP">
	        	<xsl:value-of select="string:getValue('cdicChargeType')"/>
	        </xsl:attribute>
	        <!-- SERVICE CODE -->
	        <xsl:attribute name="ID">
	        	<xsl:value-of select="string:getValue('cdicChargeServiceCode')"/>
	        </xsl:attribute>
	        <xsl:attribute name="DS">
	        	<xsl:value-of select="string:getValue('cdicChargeServiceDesc')"/>
	        </xsl:attribute>
            <!-- TARIFF DESCRIPTION -->
            <xsl:attribute name="TR">
            	<xsl:value-of select="string:getValue('cdicChargeRatePlan')"/>
            </xsl:attribute>
	        <!-- STATUS -->
	        <xsl:attribute name="ST">
	        	<xsl:value-of select="string:getValue('cdicStatus')"/>
	        </xsl:attribute>
	        <!-- START DATE -->
	        <xsl:attribute name="S">
	        	<xsl:choose>
	        		<xsl:when test="string-length(date:getValue('cdicDateStart')) &gt; 0">
	        			<xsl:value-of select="date:format(date:getValue('cdicDateStart'), 'dd/MM')"/>
	        		</xsl:when>
	        		<xsl:otherwise>
	        			<xsl:value-of select="date:format(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']/DTM/DATE_TIME[@QUALIFIER='167'], 'dd/MM')"/>
	        		</xsl:otherwise>
	        	</xsl:choose>
	        </xsl:attribute>
	        <!-- END DATE -->
	        <xsl:attribute name="E">
	        	<xsl:choose>
	        		<xsl:when test="string-length(date:getValue('cdicDateEnd')) &gt; 0">
	        			<xsl:value-of select="date:format(date:getValue('cdicDateEnd'), 'dd/MM')"/>
	        		</xsl:when>
	        		<xsl:otherwise>
	        			<xsl:value-of select="date:format(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']/DTM/DATE_TIME[@QUALIFIER='168'], 'dd/MM')"/>
	        		</xsl:otherwise>
	        	</xsl:choose>
	        </xsl:attribute>
	        <!-- NUMBER OF DAYS -->
	        <xsl:attribute name="ND"> 
            	<xsl:call-template name="numberFormat">
              		<xsl:with-param name="value" select="number:getValue('cdicChargeDays')"/>
            	</xsl:call-template>
	        </xsl:attribute>
	        <!-- VALUE -->
	        <xsl:attribute name="V">
	        	<xsl:call-template name="decimalFormat">
	        		<xsl:with-param name="value" select="number:getValue('subCDICChargeValue')"/>
	        	</xsl:call-template>
	        </xsl:attribute>
	            <!-- DISCOUNTS -->
    	        <xsl:element name="DCT">
    	            <!-- DESCRIPTION -->
                    <xsl:attribute name="DS">
    		        	<xsl:value-of select="string:getValue('cdicDiscountDesc')"/>
                    </xsl:attribute>
                    <!-- VALUE -->
                    <xsl:attribute name="V">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" select="number:getValue('cdicDiscountVal')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
	</xsl:element>
    </xsl:template>

    <xsl:template name="serviceCharges">
        <xsl:param name="useNextelOnlineMode" select="'FALSE'"/>

        <xsl:variable name="null"
            select="number:setValue('quantity', number:parse(QTY/DETAIL[@TYPE='110']/@VOLUME) div 60)"/>
        <xsl:variable name="null"
            select="number:setValue('chargeDays', QTY/DETAIL[@TYPE='111']/@VOLUME)"/>
        <xsl:variable name="null"
            select="number:setValue('chargeValue', MOA/AMOUNT[@TYPE='203']/@VALUE)"/>

	        <!-- PRORATE -->
	        <date:setValue   name="dateStart" value=""/>
	        <date:setValue   name="dateEnd"   value=""/>
	        <string:setValue name="outState"  value="a"/>

	        <xsl:choose>
	            <xsl:when test="$useNextelOnlineMode = 'TRUE'">
	                <string:setValue name="outputDiscounts" value="FALSE"/>
	            </xsl:when>
	            <xsl:otherwise>
	                <string:setValue name="outputDiscounts" value="TRUE"/>
	            </xsl:otherwise>
	        </xsl:choose>

	        <!-- STATUS -->
	        <string:setValue name="testState" value="TRUE"/>
	        <xsl:if test="not(LIN5[((number:getValue('chargeValue') &gt;= 0) and (IMD/ITEM[@CODE='STATE']/@FULL_VALUE = 'a')) or ((number:getValue('chargeValue') &lt; 0) and ((IMD/ITEM[@CODE='STATE']/@FULL_VALUE = 'd') or (IMD/ITEM[@CODE='STATE']/@FULL_VALUE = 's')))])">
	            <string:setValue name="testState" value="FALSE"/>
	        </xsl:if>
	        <xsl:call-template name="serviceStatus">
	            <xsl:with-param name="testState" select="string:getValue('testState')"/>
	        </xsl:call-template>

	        <xsl:if test="(string:getValue('outState') = 'a') and (string-length(date:getValue('dateStart')) &gt; 0) and (string-length(date:getValue('dateEnd')) &gt; 0) and ((date:getValue('dateStart') != date:getValue('invoiceStartDate')) or (date:getValue('dateEnd') != date:getValue('invoiceEndDate')))">
	            <string:setValue name="outState" value="m"/>

		        <!-- Tratamento de problemas que vem da TIMM: informacao de periodo de devolucao de servico errado. -->
		        <xsl:if test="(((date:getNumberOfDays(date:getTimeFromVar('dateEnd') - date:getTimeFromVar('dateStart'))+1) != (number:getValue('chargeDays'))) and (number:getValue('chargeValue') &lt; 0))">

        		        <string:setValue name="outState"  value="d"/>
		                <xsl:variable name="null"
		                    select="date:setValue('dateEnd',  date:getDecrementTime(date:getTimeFromVar('dateStart'),'1'))"/>
        		        <xsl:variable name="null"
                		    select="date:setValue('dateStart', date:getDecrementTime(date:getTimeFromVar('dateStart'),number:getValue('chargeDays')+1))"/>
		        </xsl:if>
	        </xsl:if>

	        <xsl:variable name="chargesServiceCode" select="IMD/ITEM/@SHORT_VALUE"/>
	        <xsl:choose>
	            <!-- NEXTEL ONLINE SERVICES CHARGES -->
	            <xsl:when test="$useNextelOnlineMode = 'TRUE'">
	                <string:setValue name="elementName" value="ONLINE"/>
	            </xsl:when>
	            <!-- ALL SERVICE CHARGES -->
	            <xsl:otherwise>
	                <string:setValue name="elementName" value="SVC"/>
	            </xsl:otherwise>
	        </xsl:choose>

	        <xsl:choose>
	            <xsl:when test="($useNextelOnlineMode = 'TRUE') and ($chargesServiceCode = 'CIRDT')">
	                <xsl:variable name="null" 
	                    select="string:setValue('circuitDataType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('circuitDataServiceCode', $chargesServiceCode)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('circuitDataServiceDescription', IMD/ITEM/@FULL_VALUE)"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('circuitDataQuantity', number:getValue('circuitDataQuantity') + number:getValue('quantity'))"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('circuitDataStatus', string:getValue('outState'))"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('circuitDataValue', number:getValue('circuitDataValue') + number:getValue('chargeValue'))"/>
	                <xsl:variable name="null" select="number:setValue('circuitDataTotal', number:getValue('circuitDataTotal') + number:getValue('chargeValue'))"/>
	            </xsl:when>

	            <xsl:when test="($useNextelOnlineMode = 'TRUE') and ($chargesServiceCode = 'TP')">
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoSMSDataType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoSMSDataServiceCode', $chargesServiceCode)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoSMSDataServiceDescription', IMD/ITEM/@FULL_VALUE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoSMSDataStatus', string:getValue('outState'))"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('torpedoSMSDataValue', number:getValue('torpedoSMSDataValue') + number:getValue('chargeValue'))"/>
	                <xsl:variable name="null" 
	                	select="number:setValue('torpedoSMSDataTotal', number:getValue('torpedoSMSDataTotal') + number:getValue('chargeValue'))"/>
	            </xsl:when>

	            <xsl:when test="($useNextelOnlineMode = 'TRUE') and ($chargesServiceCode = 'MMST')">
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSTDataType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSTDataServiceCode', $chargesServiceCode)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSTDataServiceDescription', IMD/ITEM/@FULL_VALUE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSTDataStatus', string:getValue('outState'))"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('torpedoMMSTDataValue', number:getValue('torpedoMMSTDataValue') + number:getValue('chargeValue'))"/>
	                <xsl:variable name="null" 
	                	select="number:setValue('torpedoMMSTDataTotal', number:getValue('torpedoMMSTDataTotal') + number:getValue('chargeValue'))"/>
	            </xsl:when>

	            <xsl:when test="($useNextelOnlineMode = 'TRUE') and ($chargesServiceCode = 'MMSI')">
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSIDataType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSIDataServiceCode', $chargesServiceCode)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSIDataServiceDescription', IMD/ITEM/@FULL_VALUE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('torpedoMMSIDataStatus', string:getValue('outState'))"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('torpedoMMSIDataValue', number:getValue('torpedoMMSIDataValue') + number:getValue('chargeValue'))"/>
	                <xsl:variable name="null" 
	                	select="number:setValue('torpedoMMSIDataTotal', number:getValue('torpedoMMSIDataTotal') + number:getValue('chargeValue'))"/>
	            </xsl:when>

	            <xsl:when test="($useNextelOnlineMode = 'TRUE') and ($chargesServiceCode = 'DOWN')">
	                <xsl:variable name="null" 
	                    select="string:setValue('downloadDataType', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('downloadDataServiceCode', $chargesServiceCode)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('downloadDataServiceDescription', IMD/ITEM/@FULL_VALUE)"/>
	                <xsl:variable name="null" 
	                    select="string:setValue('downloadDataStatus', string:getValue('outState'))"/>
	                <xsl:variable name="null" 
	                    select="number:setValue('downloadDataValue', number:getValue('downloadDataValue') + number:getValue('chargeValue'))"/>
	                <xsl:variable name="null" select="number:setValue('downloadDataTotal', number:getValue('downloadDataTotal') + number:getValue('chargeValue'))"/>
	            </xsl:when>
	            <xsl:otherwise>
	                <xsl:element name="{string:getValue('elementName')}">
	                    <!-- TYPE -->
	                    <xsl:attribute name="TP">
	                        <xsl:value-of select="IDENTIFICATION/ARTICLE/@CHARGE_TYPE"/>
	                    </xsl:attribute>
	                    <!-- SERVICE CODE -->
	                    <xsl:attribute name="ID">
	                        <xsl:value-of select="$chargesServiceCode"/>
	                    </xsl:attribute>
	                    <!-- TARIFF CODE
	                    <xsl:attribute name="TAR">
	                        <xsl:value-of select="IMD/ITEM[@CODE='TM']/@SHORT_VALUE"/>
	                    </xsl:attribute>
	                    -->
	                    <!-- SERVICE DESCRIPTON -->
	                    <xsl:attribute name="DS">
	                        <xsl:value-of select="IMD/ITEM/@FULL_VALUE"/>
	                    </xsl:attribute>
	                    <xsl:choose>
	                        <xsl:when test="$useNextelOnlineMode = 'TRUE'">
	                            <!-- QUANTITY -->
	                            <xsl:attribute name="Q">
	                                <xsl:call-template name="decimalFormat">
	                                    <xsl:with-param name="value" select="number:getValue('quantity')"/>
	                                </xsl:call-template>
	                            </xsl:attribute>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <!-- TARIFF DESCRIPTION -->
	                            <xsl:attribute name="TR">
	                                <xsl:value-of select="IMD/ITEM[@CODE='TM']/@FULL_VALUE"/>
	                            </xsl:attribute>
	                            <!-- TARIFF SHORT DESCRIPTION - rateplan description - - >
	                            <xsl:attribute name="TRSD">
	                                <xsl:value-of select="IMD/ITEM[@CODE='TM']/@SHORT_VALUE"/>
	                            </xsl:attribute>
	                            -->
	                        </xsl:otherwise>
	                    </xsl:choose>
	                    <!-- STATUS -->
	                    <xsl:attribute name="ST">
	                        <xsl:value-of select="string:getValue('outState')"/>
	                    </xsl:attribute>
	                    <!-- START DATE -->
	                    <xsl:attribute name="S">
	                        <xsl:choose>
	                            <xsl:when test="string-length(date:getValue('dateStart')) &gt; 0">
	                                <xsl:value-of select="date:format(date:getValue('dateStart'), 'dd/MM')"/>
	                            </xsl:when>
	                            <xsl:otherwise>
	                                <xsl:value-of select="date:format(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']/DTM/DATE_TIME[@QUALIFIER='167'], 'dd/MM')"/>
	                            </xsl:otherwise>
	                        </xsl:choose>
	                    </xsl:attribute>
	                    <!-- END DATE -->
	                    <xsl:attribute name="E">
	                        <xsl:choose>
	                            <xsl:when test="string-length(date:getValue('dateEnd')) &gt; 0">
	                                <xsl:value-of select="date:format(date:getValue('dateEnd'), 'dd/MM')"/>
	                            </xsl:when>
	                            <xsl:otherwise>
	                                <xsl:value-of select="date:format(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']/DTM/DATE_TIME[@QUALIFIER='168'], 'dd/MM')"/>
	                            </xsl:otherwise>
	                        </xsl:choose>
	                    </xsl:attribute>
	                    <!-- NUMBER OF DAYS -->
	                    <xsl:attribute name="ND"> 
                       		<xsl:call-template name="numberFormat">
                           		<xsl:with-param name="value" select="number:getValue('chargeDays')"/>
                           		<!-- xsl:with-param name="value" select="date:getNumberOfDays(date:getTimeFromVar('dateEnd') - date:getTimeFromVar('dateStart')) + 1"/ -->
                       		</xsl:call-template>
	                    </xsl:attribute>
	                    <!-- VALUE -->
	                    <xsl:attribute name="V">
	                        <xsl:call-template name="decimalFormat">
	                            <xsl:with-param name="value" select="number:getValue('chargeValue')"/>
	                        </xsl:call-template>
	                    </xsl:attribute>
	
	                    <xsl:if test="string:getValue('outputDiscounts') = 'TRUE'">
	                        <!-- DISCOUNTS -->
	                        <xsl:for-each select="aggregates:getKeys('discounts')/key">
	                            <xsl:element name="DCT">
	                                <!-- DESCRIPTION -->
	                                <xsl:attribute name="DS">
	                                    <xsl:value-of select="aggregates:getKey('discounts', @value, 'description')"/>
	                                </xsl:attribute>
	                                <!-- VALUE -->
	                                <xsl:attribute name="V">
	                                    <xsl:call-template name="decimalFormat">
	                                        <xsl:with-param name="value" select="aggregates:getValue('discounts', @value, 'val')"/>
	                                    </xsl:call-template>
	                                </xsl:attribute>
	                            </xsl:element>
	                        </xsl:for-each>
	                    </xsl:if>

	                </xsl:element>
	            </xsl:otherwise>
	        </xsl:choose>

    </xsl:template>

    <xsl:template name="serviceStatus">
        <xsl:param name="testState" select="'TRUE'"/>

        <!-- Context: "LIN4" -->
        <aggregates:reset aggregate="discounts"/>
        <xsl:for-each select="LIN5">

            <xsl:variable name="null"
   		        select="string:setValue('state', IMD/ITEM[@CODE='STATE']/@FULL_VALUE)"/>
            <xsl:call-template name="setDateVariable">
   		        <xsl:with-param name="name" select="'beginDate'"/>
                <xsl:with-param name="date" select="DTM/DATE_TIME[@QUALIFIER='901']"/>
   		    </xsl:call-template>
            <xsl:call-template name="setDateVariable">
   		        <xsl:with-param name="name" select="'endDate'"/>
                <xsl:with-param name="date" select="DTM/DATE_TIME[@QUALIFIER='902']"/>
   		    </xsl:call-template>

            <xsl:if test="($testState = 'FALSE') or ((number:getValue('chargeValue') &gt;= 0) and (string:getValue('state') = 'a')) or ((number:getValue('chargeValue') &lt; 0) and ((string:getValue('state') = 'd') or (string:getValue('state') = 's')))">
                <xsl:variable name="null"
                    select="string:setValue('outState', string:getValue('state'))"/>
                <xsl:if test="string-length(date:getValue('dateStart')) = 0">
                    <xsl:variable name="null"
                        select="date:setValue('dateStart', date:getValue('beginDate'))"/>
                </xsl:if>
                <xsl:if test="string-length(date:getValue('dateEnd')) = 0">
                    <xsl:variable name="null"
                        select="date:setValue('dateEnd', date:getValue('endDate'))"/>
                </xsl:if>
                <xsl:if test="date:compare(date:getValue('beginDate'), date:getValue('dateStart')) &lt; 0">
                    <xsl:variable name="null"
                        select="date:setValue('dateStart', date:getValue('beginDate'))"/>
                </xsl:if>
                <xsl:if test="date:compare(date:getValue('endDate'), date:getValue('dateEnd')) &gt; 0">
                    <xsl:variable name="null"
                        select="date:setValue('dateEnd', date:getValue('endDate'))"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="string:getValue('outputDiscounts') = 'TRUE'"> 
	            <xsl:for-each select="LIN6[IMD/ITEM/@CODE='DISC']">
                    <xsl:variable name="null" 
                        select="aggregates:addKey('discounts', 'description', IMD/ITEM[@CODE='DISC']/@FULL_VALUE)"/>
                    <aggregates:assembleKey aggregate="discounts"/>
                    <xsl:variable name="null"
                        select="aggregates:setValue('discounts', 'val', aggregates:getValue('discounts', 'val') + number:parse(MOA/AMOUNT[@TYPE='919']/@VALUE))"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>