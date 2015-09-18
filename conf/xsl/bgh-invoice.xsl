<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
	xmlns:number="xalan://br.com.auster.common.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:nodelist="xalan://br.com.auster.nextel.xsl.extensions.DocumentFragmentVariable"
    xmlns:xalan="http://xml.apache.org/xalan"
    extension-element-prefixes="xalan number aggregates date string sql nodelist"
    exclude-result-prefixes="xalan number string date sql aggregates nodelist"
    version="1.0">

    <xsl:include href="bgh-invoice-header.xsl"/>
    <xsl:include href="bgh-invoice-contract.xsl"/>

    <xsl:template match="/TIMM">
        <!-- resetting everything (just to be sure) -->
        <xsl:call-template name="resetComponents"/>
        <date:setValue name="invoiceStartDate" value=""/>
        <date:setValue name="invoiceEndDate"   value=""/>
        <!-- processing customer invoice -->

        <xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-PAYMENT']" mode="INVOICE"/>

        <xsl:element name="CUSTOMER">
            <xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']" mode="BALANCE"/>
            <xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']" mode="SUMSHEET"/>
        </xsl:element>
        <!-- cleaning up our mess -->
        <xsl:call-template name="resetComponents"/>
    </xsl:template>

    <xsl:template match="UNB" mode="INVOICE">
        <number:setValue name="valorBC" value="0"/>
        <number:setValue name="valorDC"     value="0"/>
        <number:setValue name="totalBC" value="0"/>
        <number:setValue name="totalDC"     value="0"/>
        <number:setValue name="ajusteDesconto" value="0"/>

        <xsl:for-each select="LIN1[TAX[@TYPE='1']]">
            <xsl:variable name="valor" select="number(TAX/DETAIL/@CODE)"/>
            <xsl:variable name="generally" select="string(TAX/@GENERALLY)"/>
            <!-- Rules for ICMS discounting:
              Valor Bruto calculado = Valor liquido(MOA 125) / (1 - Aliquota de ICMS(campo C243-5279 do segmento TAX)),  
              Valor Bruto calculado = 20,82 / (1 - 0,25) = 20,82 / 0,75 = 27,76
              BC = 27,76
              Desconto ICMS - DC
              DC = 27,76 - 20,82 = 6,94
              DC = BC - MOA 125
            -->
            <xsl:if test="not(starts-with($valor,'NaN'))">
                <xsl:if test="starts-with($generally,'Z')">
                    <xsl:variable name="null" select="number:setValue('valorBC',number:ceil(MOA/AMOUNT[@TYPE='125']/@VALUE div (1 - number:round(number:parse($valor) div 100.0,2)) ,2))"/>
                    <xsl:variable name="null" select="number:setValue('totalBC', number:getValue('totalBC') + number:getValue('valorBC'))"/>
                    <xsl:variable name="null" select="number:setValue('valorDC', number:getValue('valorBC') - number:round(number:parse(MOA/AMOUNT[@TYPE='125']/@VALUE),2))"/> 
                    <xsl:variable name="null" select="number:setValue('totalDC', number:getValue('totalDC') + number:getValue('valorDC'))"/>
                </xsl:if>
            </xsl:if>
<!--
                <xsl:element name="TAX">
                    < ! - - DESCRIPTION - - >
                    <xsl:attribute name="Code"><xsl:value-of select="TAX/DETAIL/@CODE"/></xsl:attribute>
                    <xsl:attribute name="Code2"><xsl:value-of select="number(TAX/DETAIL/@CODE)"/></xsl:attribute>
                    <xsl:attribute name="Percent"><xsl:value-of select="TAX/DETAIL/@PERCENT"/></xsl:attribute>
                    <xsl:attribute name="Base"><xsl:value-of select="TAX/DETAIL/@BASE"/></xsl:attribute>
                    <xsl:attribute name="Type"><xsl:value-of select="TAX/@TYPE"/></xsl:attribute>
                    <xsl:attribute name="Generally"><xsl:value-of select="TAX/@GENERALLY"/></xsl:attribute>
                    <xsl:attribute name="BC"><xsl:value-of select="number:getValue('valorBC')"/></xsl:attribute>
                    <xsl:attribute name="DC"><xsl:value-of select="number:getValue('valorDC')"/></xsl:attribute>
                    <xsl:attribute name="MOA125"><xsl:value-of select="MOA/AMOUNT[@TYPE='125']/@VALUE"/></xsl:attribute>
                    <xsl:attribute name="BCRound"><xsl:value-of select="number:round(MOA/AMOUNT[@TYPE='125']/@VALUE div (1 - number:parse($valor) div 100.0) ,2)"/></xsl:attribute>
                    <xsl:attribute name="BCCeil"><xsl:value-of select="number:ceil(MOA/AMOUNT[@TYPE='125']/@VALUE div (1 - number:round(number:parse($valor) div 100.0,2)) ,2)"/></xsl:attribute>
                    <xsl:attribute name="Divisor"><xsl:value-of select="number:round(number:parse($valor) div 100.0,2)"/></xsl:attribute>
                </xsl:element>
-->
            </xsl:for-each>
    </xsl:template>

    <xsl:template match="UNB" mode="BALANCE">

        <xsl:call-template name="header"/>

        <!-- MESSAGES -->
        <!-- @TOKEN@
        <aggregates:reset aggregate="msgs"/>
        <xsl:for-each select="descendant::FTX[@QUALIFIER='ADV']">
            <xsl:variable name="msg" select="concat(LITERAL/@TEXT1, LITERAL/@TEXT2, LITERAL/@TEXT3, LITERAL/@TEXT4, LITERAL/@TEXT5)"/>
            <number:setValue name="flag" value="0"/>
            <xsl:for-each select="sql:query('bscs', 'Messages')/record">
                    <xsl:variable name="null" select="aggregates:addKey('msgs', 'msg', $msg)"/>
                    <aggregates:assembleKey aggregate="msgs"/>
                    <number:setValue name="flag" value="1"/>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:element name="MESSAGES">
            <xsl:for-each select="aggregates:getKeys('msgs')/key">
            	<xsl:sort order="descending" select="aggregates:getKey('msgs', @value, 'msg')"/>
                <xsl:element name="M">
                    <xsl:value-of select="aggregates:getKey('msgs', @value, 'msg')"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
        @TOKEN@ -->

        <xsl:element name="BALANCE">
            <!-- @TOKEN@
            <xsl:variable name="saldoAnterior" select="sql:query('bscs', 'SaldoAnterior', RFF/REFERENCE[@CODE='IT']/@VALUE1)/record"/>
            @TOKEN@ -->
            <xsl:variable name="saldoAnterior" select="'@TOKEN@'"/>
            <!-- BALANCE DATE -->
            <xsl:attribute name="BD">
                <xsl:call-template name="dateFormat">
                    <xsl:with-param name="date"    select="DTM/DATE_TIME[@QUALIFIER='167']"/>
                    <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- PREVIOUS BALANCE -->
            <xsl:attribute name="P">
                <xsl:call-template name="decimalFormat">
                    <!-- @TOKEN@
                    <xsl:with-param name="value" select="$saldoAnterior/@PREV_BALANCE"/>
                    @TOKEN@ -->
                    <xsl:with-param name="value" select="'0'"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- PAYMENT RECEIVED -->
            <xsl:attribute name="R">
                <xsl:call-template name="decimalFormat">
                	<!-- @TOKEN@
                    <xsl:with-param name="value" select="$saldoAnterior/@PAGTOS_EFET"/>
                    @TOKEN@ -->
                    <xsl:with-param name="value" select="'0'"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- OTHER ADJUSTMENTS -->
            <xsl:attribute name="A">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="descendant::MOA/AMOUNT[@TYPE='965']/@VALUE"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- CURRENT BALANCE -->
            <xsl:attribute name="B">
                <xsl:call-template name="decimalFormat">
                	<!--  @TOKEN
                    <xsl:with-param name="value" select="$saldoAnterior/@CSCURBALANCE"/>
                    @TOKEN -->
                    <xsl:with-param name="value" select="'0'"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="UNB" mode="SUMSHEET">

        <!-- VARIABLE DECLARATIONS -->
        <number:setValue name="totalOthers"                 value="0"/>
        <number:setValue name="totalSubscriber"             value="0"/>
        <number:setValue name="mensalidade"                 value="0"/>
        <number:setValue name="conexaoDireta"               value="0"/>
        <number:setValue name="adicionais"                  value="0"/>
        <number:setValue name="servicoDados"                value="0"/>
        <number:setValue name="chamadasDentro"              value="0"/>
        <number:setValue name="chamadasLocais"              value="0"/>
        <number:setValue name="chamadasLonga"               value="0"/>
        <number:setValue name="chamadasRecebidas"           value="0"/>
        <number:setValue name="chamadasDescontos"           value="0"/>
        <number:setValue name="chamadasRecebidasCobrar"     value="0"/>
        <number:setValue name="chamadasInternacionais"      value="0"/>
        <number:setValue name="chamadasZ300"                value="0"/>
        <number:setValue name="chamadasFora"                value="0"/>
        <number:setValue name="chamadasForaRecebidas"       value="0"/>
        <number:setValue name="chamadasForaDescontos"       value="0"/>
        <number:setValue name="chamadasForaRecebidasCobrar" value="0"/>
        <number:setValue name="chamadasForaOriginadas"      value="0"/>
        <number:setValue name="chamadasForaZ300"            value="0"/>
        <number:setValue name="minutosConexaoDireta"        value="0"/>
        <number:setValue name="minutosChamadasDentro"       value="0"/>
        <number:setValue name="minutosChamadasFora"         value="0"/>
        <number:setValue name="totalTorpedo"                value="0"/>
        <number:setValue name="totalDownload"               value="0"/>

        <!-- OTHER CREDITS AND CHARGES -->
        <xsl:variable name="null"
            select="number:setValue('totalOthers', MOA/AMOUNT[@TYPE='936']/@VALUE)"/>

        <!-- DETAILS -->
        <xsl:element name="DETAILS">

            <!-- SUBSCRIBER -->
            <xsl:element name="SUBSCRIBER">

                <aggregates:reset aggregate="occ"/>

                <xsl:for-each select="LIN1">

                    <!-- CONTRACT -->
                    <xsl:for-each select="LIN2[IMD/ITEM/@CODE='CO']">
                        <xsl:call-template name="contractInfo"/>
                    </xsl:for-each>

                    <!-- OTHER CREDITS AND CHARGES DETAILS -->
                    <xsl:for-each select="LIN2[IDENTIFICATION/ARTICLE/@TMDES='O']">
                        <xsl:variable name="null" 
                            select="aggregates:addKey('occ', 'ds', IMD/ITEM[@CODE='FE']/@FULL_VALUE)"/>
                        <xsl:call-template name="setDateAggregateKey">
                            <xsl:with-param name="aggregate" select="'occ'"/>
                            <xsl:with-param name="name"      select="'dt'"/>
                            <xsl:with-param name="date"      select="DTM/DATE_TIME[@QUALIFIER='15']"/>
                            <xsl:with-param name="pattern"   select="'dd/MM/yyyy'"/>
                        </xsl:call-template>
                        <aggregates:assembleKey aggregate="occ"/>
                        <xsl:variable name="value" select="number:parse(MOA/AMOUNT[@TYPE='203']/@VALUE)"/>
                        <xsl:variable name="null"
                            select="aggregates:setValue('occ', 'amount', aggregates:getValue('occ', 'amount') + $value)"/>
                        <xsl:variable name="null" select="number:setValue('totalOthers', number:getValue('totalOthers') + $value)"/>
                    </xsl:for-each>

                </xsl:for-each>

                <xsl:element name="OTHER">
                    <xsl:attribute name="T">
                        <xsl:call-template name="decimalFormat">
                            <xsl:with-param name="value" select="number:getValue('totalOthers')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:for-each select="aggregates:getKeys('occ')/key">
                        <xsl:element name="OCC">
                            <!-- DESCRIPTION -->
                            <xsl:attribute name="DS">
                                <xsl:value-of select="aggregates:getKey('occ', @value, 'ds')"/>
                            </xsl:attribute>
                            <!-- DATE -->
                            <xsl:attribute name="DT">
                                <xsl:value-of select="aggregates:getKey('occ', @value, 'dt')"/>
                            </xsl:attribute>
                            <!-- VALUE -->
                            <xsl:attribute name="V">
                                <xsl:call-template name="decimalFormat">
                                    <xsl:with-param name="value" 
                                        select="aggregates:getValue('occ', @value, 'amount')"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>

            </xsl:element>

        </xsl:element>

        <!-- INVOICE SUMMARY -->
        <xsl:element name="SUMMARY">

            <!-- Verificando e ajustando valores de desconto de ICMS -->
            <xsl:if test="(number:getValue('totalDC')!= 0) and (number:getValue('totalBC')!= 0)">
                <xsl:variable name="null" select="number:setValue('ajusteDesconto', number:getValue('totalDC') - (number:getValue('totalSubscriber') + number:getValue('totalOthers') - number:parse(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']/descendant::MOA/AMOUNT[@TYPE='967']/@VALUE)))"/>
                <xsl:variable name="null" select="number:setValue('totalDC', number:getValue('totalDC') - number:getValue('ajusteDesconto'))"/>
                <xsl:variable name="null" select="number:setValue('totalBC', number:getValue('totalBC') - number:getValue('ajusteDesconto'))"/>
            </xsl:if>

            <!-- TOTAL VALUE -->
            <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']/descendant::MOA/AMOUNT[@TYPE='967']/@VALUE"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- SUBSCRIBERS SUBTOTAL (WITHOUT OCC) -->
            <xsl:attribute name="S">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" 
                        select="number:getValue('totalSubscriber')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- SUBSCRIBERS SUBTOTAL (WITH OCC) -->
            <xsl:attribute name="SS">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" 
                        select="number:getValue('totalSubscriber') + number:getValue('totalOthers')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- MONTHLY FEE -->
            <xsl:attribute name="M">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('mensalidade')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- DISPATCH TOTAL -->
            <xsl:attribute name="D">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('conexaoDireta')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- DISPATCH DURATION (minutes) -->
            <xsl:attribute name="DD">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('minutosConexaoDireta')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- ADDITIONAL SERVICES -->
            <xsl:attribute name="A">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('adicionais')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- NEXTEL ONLINE -->
            <xsl:attribute name="O">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('servicoDados')"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- OTHER CREDITS AND CHARGES TOTAL -->
            <xsl:attribute name="C">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalOthers')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- DISCOUNTS OF ICMS -->
            <xsl:attribute name="DICMS">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="0 - number:getValue('totalDC')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- VALOR BRUTO -->
            <xsl:attribute name="TOTALBC">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="number:getValue('totalBC')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- TOTAL Torpedo Nextel-->
            <xsl:attribute name="TP">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="number:getValue('totalTorpedo')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- CALLS INSIDE LOCAL AREA -->
            <xsl:element name="HOME">
                <!-- TOTAL -->
                <xsl:attribute name="T">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasDentro')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- LOCAL CALLS -->
                <xsl:attribute name="LC">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasLocais')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- LONG DISTANCE CALLS -->
                <xsl:attribute name="LD">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasLonga')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED CALLS -->
                <xsl:attribute name="R">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasRecebidas')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED COLLECT CALLS -->
                <xsl:attribute name="RC">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasRecebidasCobrar')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- INTERNATIONAL CALLS -->
                <xsl:attribute name="I">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasInternacionais')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- 0300 CALLS -->
                <xsl:attribute name="Z3">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasZ300')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- DISCOUNTS CALLS -->
                <xsl:attribute name="DC">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasDescontos')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL DURATION (minutes) -->
                <xsl:attribute name="TD">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('minutosChamadasDentro')"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>

            <!-- CALLS OUTSIDE LOCAL AREA (ROAMING) -->
            <xsl:element name="ROAMING">
                <!-- TOTAL -->
                <xsl:attribute name="T">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasFora')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- DIALED CALLS -->
                <xsl:attribute name="D">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaOriginadas')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED CALLS -->
                <xsl:attribute name="R">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaRecebidas')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED COLLECT CALLS -->
                <xsl:attribute name="RC">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaRecebidasCobrar')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- 0300 CALLS -->
                <xsl:attribute name="Z3">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaZ300')"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- DIALED WITHOUT 0300 CALLS -->
                <xsl:attribute name="DNOZ3">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaOriginadas') - number:getValue('chamadasForaZ300')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- DISCOUNTS CALLS -->
                <xsl:attribute name="DC">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('chamadasForaDescontos')"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL DURATION (minutes) -->
                <xsl:attribute name="TD">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="number:getValue('minutosChamadasFora')"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>

        </xsl:element>

    </xsl:template>

    <xsl:template name="setDateAggregateKey">
        <xsl:param name="aggregate"/>
        <xsl:param name="name"/>
        <xsl:param name="date"/>
        <xsl:param name="pattern"/>
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:variable name="null" select="aggregates:addKey($aggregate, $name, date:format($date/DATE, string:getValue('_datePattern'), $pattern))"/>
    </xsl:template>

    <xsl:template name="setDateVariable">
        <xsl:param name="name"/>
        <xsl:param name="date"/>
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:variable name="null" select="date:setValue($name, $date/DATE, string:getValue('_datePattern'))"/>
    </xsl:template>

    <xsl:template name="datePattern">
        <xsl:param name="formatId"/>
        <xsl:choose>
            <xsl:when test="$formatId = '102'">
                <string:setValue name="_datePattern" value="yyyyMMdd"/>
            </xsl:when>
            <xsl:when test="$formatId = '101'">
                <string:setValue name="_datePattern" value="yyMMdd"/>
            </xsl:when>
            <xsl:when test="$formatId = '609'">
                <string:setValue name="_datePattern" value="yyMM"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="null" select="string:setValue('_datePattern', date:getDefaultPattern())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dateFormat">
        <xsl:param name="date"/>
        <xsl:param name="pattern"/>
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:value-of select="date:format($date/DATE, string:getValue('_datePattern'), $pattern)"/>
    </xsl:template>

    <xsl:template name="decimalFormat">
        <xsl:param name="value"/>
        <xsl:call-template name="dotComma">
            <xsl:with-param name="value" select="format-number(number:round($value, 2), '#,##0.00')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="numberFormat">
        <xsl:param name="value"/>
        <xsl:call-template name="dotComma">
            <xsl:with-param name="value" select="format-number($value, '#,##0')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="dotComma">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '.')">
                <xsl:value-of select="concat( translate(substring-before($value, '.'), ',', '.'), ',', substring-after($value, '.') )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate($value, ',', '.')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="resetComponents">
        <date:reset pattern="yyyyMMdd"/>
        <number:reset/>
        <string:reset/>
        <aggregates:reset/>
        <nodelist:reset/>
    </xsl:template>

</xsl:stylesheet>