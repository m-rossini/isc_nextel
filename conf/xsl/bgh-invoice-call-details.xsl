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

    <xsl:template name="dispatch-call">

        <number:setValue name="aPagar"   value="0"/>
        <number:setValue name="franquia" value="0"/>
        <number:setValue name="total"    value="0"/>

        <xsl:variable name="null"
            select="number:setValue('amount', @RE_RATED_AMOUNT)"/>
        <xsl:variable name="null"
            select="aggregates:addKey('dispatchSummary', 'ser', @SERVICE_SHORT)"/>

        <xsl:choose>
            <xsl:when test="@SERVICE_SHORT = 'DISPP'">
                <xsl:variable name="null"
                    select="aggregates:addKey('dispatchSummary', 'des', 'Rádio Digital - Individual')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="null"
                    select="aggregates:addKey('dispatchSummary', 'des', 'Rádio Digital - Grupo')"/>
            </xsl:otherwise>
        </xsl:choose>

        <aggregates:assembleKey aggregate="dispatchSummary"/>
        <xsl:if test="(@TYPE_INDICATOR = 'A')">
            <xsl:variable name="null"
                select="number:setValue('ratedBefore', @RATED_CALL_VOLUME_BEFORE)"/>
            <xsl:variable name="null"
                select="number:setValue('ratedAfter', @RATED_CALL_VOLUME_AFTER)"/>
            <xsl:variable name="null"
                select="number:setValue('roundedBefore', @ROUNDED_CALL_VOLUME_BEFORE)"/>
            <xsl:variable name="null"
                select="number:setValue('roundedAfter', @ROUNDED_CALL_VOLUME_AFTER)"/>
            <xsl:variable name="null" 
                select="number:setValue('total', number:getValue('roundedBefore') div 60)"/>
            <xsl:choose>
                <!-- DISPATCH WITH UNLIMITED CALLS -->
                <xsl:when test="number(number:getValue('amount')) = 0">
                    <xsl:variable name="null" select="number:setValue('franquia', number:getValue('total'))"/>
                    <number:setValue name="aPagar" value="0"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(@FREE_UNIT_SHORT) &gt; 0">
                        <xsl:variable name="null" select="number:setValue('franquia', ((number:getValue('ratedBefore') - number:getValue('ratedAfter')) + (number:getValue('roundedBefore') - number:getValue('roundedAfter'))) div 60)"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="number:getValue('ratedAfter') &lt;= number:getValue('roundedAfter')">
                            <xsl:variable name="null" 
                                select="number:setValue('aPagar', number:getValue('ratedAfter') div 60)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="null" 
                                select="number:setValue('aPagar', number:getValue('roundedAfter') div 60)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="null"
                select="number:setValue('conexaoSubFranquia', number:getValue('conexaoSubFranquia') + number:getValue('franquia'))"/>
            <xsl:variable name="null"
                select="number:setValue('conexaoSubTotal', number:getValue('conexaoSubTotal') + number:getValue('total'))"/>
        </xsl:if>
        <xsl:variable name="null"
            select="number:setValue('conexaoSubAPagar', number:getValue('conexaoSubAPagar') + number:getValue('aPagar'))"/>
        <xsl:variable name="null"
            select="number:setValue('conexaoSubValor', number:getValue('conexaoSubValor') + number:getValue('amount'))"/>
        <xsl:variable name="null"
            select="number:setValue('conexaoDireta', number:getValue('conexaoDireta') + number:getValue('amount'))"/>
        <!-- SUM -->
        <xsl:variable name="null"
            select="aggregates:setValue('dispatchSummary', 'tot', aggregates:getValue('dispatchSummary', 'tot') + number:getValue('total'))"/>
        <xsl:variable name="null"
            select="aggregates:setValue('dispatchSummary', 'fra', aggregates:getValue('dispatchSummary', 'fra') + number:getValue('franquia'))"/>
        <xsl:variable name="null"
            select="aggregates:setValue('dispatchSummary', 'apa', aggregates:getValue('dispatchSummary', 'apa') + number:getValue('aPagar'))"/>
        <xsl:variable name="null"
            select="aggregates:setValue('dispatchSummary', 'val', aggregates:getValue('dispatchSummary', 'val') + number:getValue('amount'))"/>
    </xsl:template>

    <xsl:template name="idcd-calls">

        <xsl:for-each select="LIN3[last()]/XCD[(@SERVICE_SHORT='CDIC' and DISCOUNTING_RATED_AMOUNT/@DISCOUNTING_INDICATOR='N')]">

            <!-- DETERMINING IF THIS IS A MOBILE (CELULAR) CALL -->
            <string:setValue name="callNumberType" value="O"/>

            <!-- DETERMING THE AMOUNT OF THE CDIC TO BE PAID -->
            <xsl:variable name="null" select="number:setValue('amount', @RE_RATED_AMOUNT)"/>

            <!-- DETERMING THE CALL VOLUME OF THE CDIC -->
            <xsl:variable name="null" select="number:setValue('roundedBefore', @ROUNDED_CALL_VOLUME_BEFORE)"/>
            <xsl:variable name="null" select="number:setValue('timeCall', number:getValue('roundedBefore') div 60)"/>

            <!-- UPDATING CHARGED AMOUNT SUBTOTAL FOR CDIC CALLS -->
            <xsl:variable name="null" select="number:setValue('idcdAmount', number:getValue('idcdAmount') + number:getValue('amount'))"/>

            <!-- UPDATING CALL VOLUME SUBTOTAL FOR CDIC CALLS -->
            <xsl:variable name="null" select="number:setValue('idcdTimeCall', number:getValue('idcdTimeCall') + number:getValue('timeCall'))"/>

            <!-- CREATING XML FRAGMENT TREE WITH CALL CDIC INFO -->
            <xsl:element name="CALL">
                <!-- MAIN NUMBER (call sequential index, starting from 1) -->
                <xsl:attribute name="MN">
                    <xsl:value-of select="@MAIN_NUMBER"/>
                </xsl:attribute>
                <!-- SUB NUMBER ('0' means AIR and '1' means TOLL) -->
                <xsl:attribute name="SN">
                    <xsl:choose>
                        <xsl:when test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                            <xsl:value-of select="0"/>
                        </xsl:when>
                        <xsl:when test="@TYPE_INDICATOR = 'I'">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <!-- CLASSIFICATION (M=MOBILE/O=OTHER) -->
                <xsl:attribute name="CL">
                    <xsl:value-of select="string:getValue('callNumberType')"/>
                </xsl:attribute>
                <!-- DATE -->
                <xsl:attribute name="DT">
                    <xsl:value-of select="date:format(CR_TIME/@DATE, 'yyMMdd', 'dd/MM/yy')"/>
                </xsl:attribute>
                <!-- TIME -->
                <xsl:attribute name="TM">
                    <xsl:value-of select="date:format(CR_TIME/@TIME, 'HHmmss', 'HH%H%mm%M%ss')"/>
                </xsl:attribute>
                <!-- CALL DURATION (minutes) -->
                <xsl:attribute name="DR">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('timeCall')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CHARGE AMOUNT -->
                <xsl:attribute name="V">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('amount')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- CALL TYPE -->
                <xsl:attribute name="TP">
                    <xsl:value-of select="@TARIFF_TIME_SHORT"/>
                </xsl:attribute>
            </xsl:element>
            <!-- END OF XML FRAGMENT TREE WITH CALL CDIC INFO -->

        </xsl:for-each>

    </xsl:template>

    <xsl:template name="telephony-calls">
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

        <!-- xsl:for-each select="LIN3[last()]/XCD[(@SERVICE_SHORT='TELAL' or @SERVICE_SHORT='PPTEL') and ( (@TYPE_INDICATOR='A') or (@TYPE_INDICATOR='I') or (@TYPE_INDICATOR='C') )]"-->



            <!-- IF THIS CALL MATCHES THE PARAMETERS PASSED TO THIS TEMPLATE CALL, USE IT -->
            <xsl:if test="(string:getValue('locale') = $location) and (string:getValue('type') = $type)">

                <!-- initializing some usefull variables -->
                <xsl:variable name="null" select="number:setValue('ratedBefore', @RATED_CALL_VOLUME_BEFORE)"/>
                <xsl:variable name="null" select="number:setValue('ratedAfter', @RATED_CALL_VOLUME_AFTER)"/>
                <xsl:variable name="null" select="number:setValue('roundedBefore', @ROUNDED_CALL_VOLUME_BEFORE)"/>
                <xsl:variable name="null" select="number:setValue('roundedAfter', @ROUNDED_CALL_VOLUME_AFTER)"/>

                <!-- Updating charged amount subtotal for HOME calls -->
                <xsl:if test="$location = 'H'">
                    <xsl:variable name="null" select="number:setValue('contratoDentro', number:getValue('contratoDentro') + number:getValue('amount'))"/>
                    <xsl:choose>
                        <xsl:when test="@TYPE = 'O'">
                            <xsl:if test="$type = 'LO'">
                                <xsl:variable name="null" select="number:setValue('contratoLocais', number:getValue('contratoLocais') + number:getValue('amount'))"/>
                            </xsl:if>
                            <xsl:if test="$type = 'LD'">
                                <xsl:variable name="null" select="number:setValue('contratoLonga', number:getValue('contratoLonga') + number:getValue('amount'))"/>
                            </xsl:if>
                            <xsl:if test="$type = 'IT'">
                                <xsl:variable name="null" select="number:setValue('contratoInternacionais', number:getValue('contratoInternacionais') + number:getValue('amount'))"/>
                            </xsl:if>
                            <xsl:if test="$type = 'Z3'">
                                <xsl:variable name="null" select="number:setValue('contratoZ300', number:getValue('contratoZ300') + number:getValue('amount'))"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@TYPE = 'I'">
                            <xsl:choose>
                                <xsl:when test="(@TYPE_INDICATOR='I') and (@TARIFF_ZONE_SHORT='RZ1' or @TARIFF_ZONE_SHORT='RZ2' or @TARIFF_ZONE_SHORT='RZ3' or @TARIFF_ZONE_SHORT='RZ4' or @TARIFF_ZONE_SHORT='RZ5' or @TARIFF_ZONE_SHORT='RZ6') and (@RE_RATED_AMOUNT &lt; 0)">
                                    <xsl:variable name="null" select="number:setValue('contratoDescontos', number:getValue('contratoDescontos') + number:getValue('amount'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="null" select="number:setValue('contratoRecebidas', number:getValue('contratoRecebidas') + number:getValue('amount'))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@TYPE = 'C'">
                            <xsl:variable name="null" select="number:setValue('contratoRecebidasCobrar', number:getValue('contratoRecebidasCobrar') + number:getValue('amount'))"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                <!-- Updating charged amount subtotal for ROAMING calls -->
                <xsl:if test="$location = 'R'">
                    <xsl:variable name="null" 
                        select="number:setValue('contratoFora', number:getValue('contratoFora') + number:getValue('amount'))"/>
                    <xsl:if test="$type = 'Z3'">
                        <xsl:variable name="null" 
                            select="number:setValue('contratoForaZ300', number:getValue('contratoForaZ300') + number:getValue('amount'))"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@TYPE = 'O'">
                            <xsl:variable name="null" 
                                select="number:setValue('contratoForaOriginadas', number:getValue('contratoForaOriginadas') + number:getValue('amount'))"/>
                        </xsl:when>
                        <xsl:when test="@TYPE = 'I'">
                            <xsl:choose>
                                <xsl:when test="(@TYPE_INDICATOR='I') and (@TARIFF_ZONE_SHORT='RZ1' or @TARIFF_ZONE_SHORT='RZ2' or @TARIFF_ZONE_SHORT='RZ3' or @TARIFF_ZONE_SHORT='RZ4' or @TARIFF_ZONE_SHORT='RZ5' or @TARIFF_ZONE_SHORT='RZ6') and (@RE_RATED_AMOUNT &lt; 0)">
		                            <xsl:variable name="null" 
		                                select="number:setValue('contratoForaDescontos', number:getValue('contratoForaDescontos') + number:getValue('amount'))"/>
                                </xsl:when>
                                <xsl:otherwise>
		                            <xsl:variable name="null" 
		                                select="number:setValue('contratoForaRecebidas', number:getValue('contratoForaRecebidas') + number:getValue('amount'))"/>
		                        </xsl:otherwise>
		                    </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@TYPE = 'C'">
                            <xsl:variable name="null" select="number:setValue('contratoForaRecebidasCobrar', number:getValue('contratoForaRecebidasCobrar') + number:getValue('amount'))"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                <!-- FREE UNITS (FRANQUIA) CALCULATION -->
                <number:setValue name="total"    value="0"/>
                <number:setValue name="franquia" value="0"/>
                <number:setValue name="aPagar"   value="0"/>
                <!-- TYPE_INDICATOR in the XCD: 'A' means AIR and 'I' means TOLL. -->
                <xsl:if test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                    <!-- The total duration of the call will always         -->
                    <!-- be retrieved from the ROUNDED_BEFORE field         -->
                    <!-- and divided by 60 to transform seconds to minutes. -->
                    <xsl:variable name="null" 
                        select="number:setValue('total', number:getValue('roundedBefore') div 60)"/>
                    <!-- The FREE_UNIT_SHORT will tell us if this contract -->
                    <!-- has any discount in it's rateplan.                -->
                    <xsl:if test="string-length(@FREE_UNIT_SHORT) &gt; 0">
                        <!-- The free minutes can be retrieved with        -->
                        <!-- the following formula:                        -->
                        <!-- FREE_UNITS = (RATED_BEFORE - RATED_AFTER) +   -->
                        <!--              (ROUNDED_BEFORE - ROUNDED_AFTER) -->
                        <!-- And we need to divide by 60 in order to have  -->
                        <!-- the time in minutes (it comes in seconds).    -->
                        <xsl:variable name="null" select="number:setValue('franquia', ((number:getValue('ratedBefore') - number:getValue('ratedAfter')) + (number:getValue('roundedBefore') - number:getValue('roundedAfter'))) div 60)"/>
                    </xsl:if>
                </xsl:if>

                <!-- DETERMINING QUANTITY OF CHARGED MINUTES -->
				<xsl:if test="not(starts-with(@SERVICE_SHORT,'PPTEL'))">
	                <xsl:choose>
	                    <xsl:when test="number:getValue('ratedAfter') &lt;= number:getValue('roundedAfter')">
	                        <xsl:variable name="null" select="number:setValue('aPagar', number:getValue('ratedAfter') div 60)"/>
	                    </xsl:when>
	                    <xsl:otherwise>
	                        <xsl:variable name="null" select="number:setValue('aPagar', number:getValue('roundedAfter') div 60)"/>
	                    </xsl:otherwise>
	                </xsl:choose>
				</xsl:if>

                <!-- ################################ -->
                <!-- BEGINNING TO DETERMINE SUBTOTALS -->
                <!-- ################################ -->

                <!-- aggregation for the SUBTOTAL of all calls (grouped by $location and $type) -->
                <xsl:variable name="null" select="aggregates:addKey('callSummary', 'loc', $location)"/>
                <xsl:variable name="null" select="aggregates:addKey('callSummary', 'type', $type)"/>
                <aggregates:assembleKey aggregate="callSummary"/>

                <!-- aggregation for the SUBTOTAL of incoming/outgoing calls (grouped by $location and 'IN/OUT')-->
                <xsl:choose>
                    <xsl:when test="(@TYPE = 'C') or (@TYPE = 'I')">
                        <xsl:variable name="null" select="aggregates:addKey('directionSummary', 'dir', 'IN')"/>
                    </xsl:when>
                    <xsl:when test="@TYPE = 'O'">
                        <xsl:variable name="null" select="aggregates:addKey('directionSummary', 'dir', 'OUT')"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:variable name="null" select="aggregates:addKey('directionSummary', 'loc', $location)"/>
                <aggregates:assembleKey aggregate="directionSummary"/>

                <!-- aggregation for the SUBTOTAL of outgoing roaming calls without Z300 -->
                <!-- (grouped by $type, $location and direction)                         -->
                <xsl:choose>
                    <xsl:when test="$type = 'Z3'">
                        <xsl:variable name="null" select="aggregates:addKey('z300Summary', 'type', 'Z3')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="null" select="aggregates:addKey('z300Summary', 'type', 'NOZ3')"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="(@TYPE = 'C') or (@TYPE = 'I')">
                        <xsl:variable name="null" select="aggregates:addKey('z300Summary', 'dir', 'IN')"/>
                    </xsl:when>
                    <xsl:when test="@TYPE = 'O'">
                        <xsl:variable name="null" select="aggregates:addKey('z300Summary', 'dir', 'OUT')"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:variable name="null" select="aggregates:addKey('z300Summary', 'loc', $location)"/>
                <aggregates:assembleKey aggregate="z300Summary"/>

                <!-- AIR AND TOLL VARIABLES INITIALIZATION -->
                <!-- TOTAL -->
                <number:setValue name="totAir" value="0"/>
                <!-- FREE UNITS -->
                <number:setValue name="fraAir" value="0"/>
                <!-- FEE -->
                <number:setValue name="apaAir" value="0"/>
                <number:setValue name="apaTol" value="0"/>
                <!-- VALUE -->
                <number:setValue name="valAir" value="0"/>
                <number:setValue name="valTol" value="0"/>

                <!-- TOTAL WITHOUT FREE UNITS -->
                <number:setValue name="totNoFree" value="0"/>
                <xsl:if test="(number(number:parse(@RATED_FLAT_AMOUNT)) &gt; 0) or ((@PLMN_INDICATOR = 'V') and (number(number:getValue('amount')) &gt; 0)) or (starts-with(@SERVICE_SHORT,'PPTEL'))">
                    <xsl:variable name="null" select="number:setValue('totNoFree', number:getValue('total'))"/>
                </xsl:if>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'totNoFree', aggregates:getValue('callSummary', 'totNoFree') + number:getValue('totNoFree'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'totNoFree', aggregates:getValue('directionSummary', 'totNoFree') + number:getValue('totNoFree'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'totNoFree', aggregates:getValue('z300Summary', 'totNoFree') + number:getValue('totNoFree'))"/>

                <!-- VALUE BY RATE TYPE (AIR OR TOLL) -->
                <xsl:choose>
                    <xsl:when test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                        <xsl:variable name="null" select="number:setValue('totAir', number:getValue('totNoFree'))"/>
                        <xsl:variable name="null" select="number:setValue('fraAir', number:getValue('franquia'))"/>
                        <xsl:variable name="null" select="number:setValue('apaAir', number:getValue('aPagar'))"/>
                        <xsl:variable name="null" select="number:setValue('valAir', number:getValue('amount'))"/>
                    </xsl:when>
                    <xsl:when test="@TYPE_INDICATOR = 'I'">
                        <xsl:if test="$location = 'H'">
                            <xsl:variable name="null" select="number:setValue('apaTol', number:getValue('aPagar'))"/>
                            <xsl:variable name="null" select="number:setValue('valTol', number:getValue('amount'))"/>
                        </xsl:if>
                        <xsl:if test="$location = 'R'">
                            <xsl:variable name="null" select="number:setValue('apaTol', number:getValue('aPagar'))"/>
                            <xsl:variable name="null" select="number:setValue('valTol', number:getValue('amount'))"/>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>

                <!-- AIR SUBTOTAL -->
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'totAir', aggregates:getValue('callSummary', 'totAir') + number:getValue('totAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'totAir', aggregates:getValue('directionSummary', 'totAir') + number:getValue('totAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'totAir', aggregates:getValue('z300Summary', 'totAir') + number:getValue('totAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'fraAir', aggregates:getValue('callSummary', 'fraAir') + number:getValue('fraAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'fraAir', aggregates:getValue('directionSummary', 'fraAir') + number:getValue('fraAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'fraAir', aggregates:getValue('z300Summary', 'fraAir') + number:getValue('fraAir'))"/>
				<xsl:if test="not(starts-with(@SERVICE_SHORT,'PPTEL'))">
	                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'apaAir', aggregates:getValue('callSummary', 'apaAir') + number:getValue('apaAir'))"/>
                </xsl:if>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'apaAir', aggregates:getValue('directionSummary', 'apaAir') + number:getValue('apaAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'apaAir', aggregates:getValue('z300Summary', 'apaAir') + number:getValue('apaAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'valAir', aggregates:getValue('callSummary', 'valAir') + number:getValue('valAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'valAir', aggregates:getValue('directionSummary', 'valAir') + number:getValue('valAir'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'valAir', aggregates:getValue('z300Summary', 'valAir') + number:getValue('valAir'))"/>

                <!-- TOLL SUBTOTAL -->
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'apaTol', aggregates:getValue('callSummary', 'apaTol') + number:getValue('apaTol'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'apaTol', aggregates:getValue('directionSummary', 'apaTol') + number:getValue('apaTol'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'apaTol', aggregates:getValue('z300Summary', 'apaTol') + number:getValue('apaTol'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'valTol', aggregates:getValue('callSummary', 'valTol') + number:getValue('valTol'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'valTol', aggregates:getValue('directionSummary', 'valTol') + number:getValue('valTol'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'valTol', aggregates:getValue('z300Summary', 'valTol') + number:getValue('valTol'))"/>

                <!-- SUBTOTAL (everything) -->
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'tot', aggregates:getValue('callSummary', 'tot') + number:getValue('total'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'tot', aggregates:getValue('directionSummary', 'tot') + number:getValue('total'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'tot', aggregates:getValue('z300Summary', 'tot') + number:getValue('total'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'fra', aggregates:getValue('callSummary', 'fra') + number:getValue('franquia'))"/>
				<xsl:if test="not(starts-with(@SERVICE_SHORT,'PPTEL'))">
					  <xsl:variable name="null" 
                        select="aggregates:setValue('callSummary', 'apa', aggregates:getValue('callSummary', 'apa') + number:getValue('aPagar'))"/>
                </xsl:if>
                <xsl:variable name="null" 
                    select="aggregates:setValue('callSummary', 'val', aggregates:getValue('callSummary', 'val') + number:getValue('amount'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('directionSummary', 'val', aggregates:getValue('directionSummary', 'val') + number:getValue('amount'))"/>
                <xsl:variable name="null" 
                    select="aggregates:setValue('z300Summary', 'val', aggregates:getValue('z300Summary', 'val') + number:getValue('amount'))"/>

                <!-- SUBTOTAL for home calls -->
                <xsl:if test="$location = 'H'">
                    <xsl:variable name="null" 
                        select="number:setValue('homeSubTotal', number:getValue('homeSubTotal') + number:getValue('totNoFree'))"/>
                    <xsl:variable name="null" 
                        select="number:setValue('homeSubFranquia', number:getValue('homeSubFranquia') + number:getValue('franquia'))"/>
                    <!-- only AIR minutes will be counted on the SUBTOTAL -->
                    <xsl:if test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                        <xsl:variable name="null" 
                            select="number:setValue('homeSubAPagar', number:getValue('homeSubAPagar') + number:getValue('aPagar'))"/>
                    </xsl:if>
                </xsl:if>
                <!-- SUBTOTAL for roaming calls -->
                <xsl:if test="$location = 'R'">
                    <xsl:variable name="null" 
                        select="number:setValue('roamingSubTotal', number:getValue('roamingSubTotal') + number:getValue('totNoFree'))"/>
                    <xsl:variable name="null" 
                        select="number:setValue('roamingSubFranquia', number:getValue('roamingSubFranquia') + number:getValue('franquia'))"/>
                    <!-- only AIR minutes will be counted on the SUBTOTAL -->
                    <xsl:if test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                        <xsl:variable name="null" 
                            select="number:setValue('roamingSubAPagar', number:getValue('roamingSubAPagar') + number:getValue('aPagar'))"/>
                    </xsl:if>
                </xsl:if>
                <!-- ################################ -->
                <!-- FINISHED TO DETERMINE SUBTOTALS  -->
                <!-- ################################ -->

                <xsl:variable name="null" 
                    select="number:setValue('timeCall', number:getValue('roundedBefore') div 60)"/>

                <!-- CREATING XML FRAGMENT TREE WITH CALL INFO -->
                <xsl:element name="CALL">
                    <!-- MAIN NUMBER (call sequential index, starting from 1) -->
                    <xsl:attribute name="MN">
                        <xsl:value-of select="@MAIN_NUMBER"/>
                    </xsl:attribute>
                    <!-- SUB NUMBER ('0' means AIR and '1' means TOLL) -->
                    <xsl:attribute name="SN">
                        <xsl:choose>
                            <xsl:when test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C')">
                                <xsl:value-of select="0"/>
                            </xsl:when>
                            <xsl:when test="@TYPE_INDICATOR = 'I'">
                                <xsl:value-of select="1"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <!-- CLASSIFICATION (M=MOBILE/O=OTHER) -->
                    <xsl:attribute name="CL">
                        <xsl:value-of select="string:getValue('callNumberType')"/>
                    </xsl:attribute>
                    <xsl:if test="(@TYPE_INDICATOR = 'A') or (@TYPE_INDICATOR = 'C') or (@TYPE_INDICATOR = 'I')">
                        <!-- DATE -->
                        <xsl:attribute name="DT">
                            <xsl:value-of select="date:format(CR_TIME/@DATE, 'yyMMdd', 'dd/MM/yy')"/>
                        </xsl:attribute>
                        <!-- TIME -->
                        <xsl:attribute name="TM">
                            <xsl:value-of select="date:format(CR_TIME/@TIME, 'HHmmss', 'HH%H%mm%M%ss')"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="(@PLMN_INDICATOR = 'V') and (string-length(concat(CALL_ORIGIN_INFO/@CITY, CALL_DESTINATION_INFO/@CITY_COUNTRY)) = 0)">
                                <!-- SOURCE -->
                                <xsl:attribute name="SC">
                                    <xsl:value-of select="VPLMN_TAP_CHARGE_INFO/@SO_DESCRIPTION"/>
                                </xsl:attribute>
                                <!-- DESTINATION -->
                                <xsl:attribute name="DN">
                                    <!-- EMPTY FIELD -->
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- SOURCE -->
                                <xsl:attribute name="SC">
                                    <xsl:value-of select="CALL_ORIGIN_INFO/@CITY"/>
                                </xsl:attribute>
                                <!-- DESTINATION -->
                                <xsl:attribute name="DN">
                                    <xsl:value-of select="CALL_DESTINATION_INFO/@CITY_COUNTRY"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- PHONE NUMBER -->
                        <xsl:attribute name="N">
                            <xsl:value-of select="string:getValue('num')"/>
                        </xsl:attribute>
                        <!-- CALL DURATION (minutes) -->
                        <xsl:attribute name="DR">
                            <xsl:call-template name="decimalFormat">
                                <xsl:with-param name="value" select="number:getValue('timeCall')"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <!-- CHARGE AMOUNT -->
                    <xsl:attribute name="V">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" select="number:getValue('amount')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <!-- CALL TYPE -->
                    <xsl:attribute name="TP">
                        <xsl:value-of select="string:getValue('tariff')"/>
                    </xsl:attribute>
                </xsl:element>
                <!-- END OF XML FRAGMENT TREE WITH CALL INFO -->
            </xsl:if>
        <!-- /xsl:for-each -->

    </xsl:template>

</xsl:stylesheet>