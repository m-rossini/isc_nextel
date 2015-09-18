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


    
    <xsl:template name="serviceSummary">
        <aggregates:reset aggregate="servicesSummary"/>

        <xsl:variable name="typeId" select="IMD/ITEM[@CODE='MRKT']/@SHORT_VALUE"/>

        <xsl:for-each select="LIN3">
            <xsl:for-each select="LIN4[IMD/ITEM/@CODE='SN']">
                <xsl:variable name="contractServiceCode" select="IMD/ITEM[@CODE='SN']/@SHORT_VALUE"/>
                <xsl:variable name="null"
                    select="aggregates:addKey('servicesSummary', 'tp', IDENTIFICATION/ARTICLE/@CHARGE_TYPE)"/>
                <xsl:variable name="null"
                    select="aggregates:addKey('servicesSummary', 'id', $contractServiceCode)"/>
                <aggregates:assembleKey aggregate="servicesSummary"/>
                <xsl:variable name="null"
                    select="aggregates:setValue('servicesSummary', 'v', aggregates:getValue('servicesSummary', 'v') + number:parse(MOA/AMOUNT[@TYPE='203']/@VALUE))"/>
                <!-- Fix para permitir adicionar SUBSCRIBER (CHARGE_TYPE=S) em Servicos adicionais - subtotal -->
         
                <xsl:if test="((IDENTIFICATION/ARTICLE/@CHARGE_TYPE='A') or (IDENTIFICATION/ARTICLE/@CHARGE_TYPE='S' and $typeId='AMP') or ($contractServiceCode='CDIC'))">
                    <number:setValue name="amount" value="0"/>
                    <xsl:choose>
                        <!-- MONTHLY FEE -->
                        <xsl:when test="$contractServiceCode='ME' or $contractServiceCode='DISPP' or $contractServiceCode='TELAL' or $contractServiceCode='PPTEL'">
                            <xsl:variable name="null"
                                select="number:setValue('amount', MOA/AMOUNT[@TYPE='203']/@VALUE)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- ADDITIONAL SERVICES -->
                            <xsl:if test="$contractServiceCode!='SMST' and $contractServiceCode!='WP' and $contractServiceCode!='TWM' and $contractServiceCode!='WPTWM' and $contractServiceCode!='CLIRB' and $contractServiceCode!='CIRDT' and $contractServiceCode!='NMSIM' and $contractServiceCode!='NMPLS' and $contractServiceCode!='NMBAS' and $contractServiceCode!='N200K' and $contractServiceCode!='MDD3' and $contractServiceCode!='N1200' and $contractServiceCode!='N2200' and $contractServiceCode!='N4200' and $contractServiceCode!='N5200' and $contractServiceCode!='N2300' and $contractServiceCode!='N3300' and $contractServiceCode!='N4300' and $contractServiceCode!='N5300' and $contractServiceCode!='N1600' and $contractServiceCode!='N2600' and $contractServiceCode!='N3600' and $contractServiceCode!='N4600' and $contractServiceCode!='N5600' and $contractServiceCode!='N11MB' and $contractServiceCode!='N21MB' and $contractServiceCode!='N31MB' and $contractServiceCode!='N41MB' and $contractServiceCode!='N51MB' and $contractServiceCode!='N13MB' and $contractServiceCode!='N23MB' and $contractServiceCode!='N33MB' and $contractServiceCode!='N43MB' and $contractServiceCode!='N53MB' and $contractServiceCode!='N110M' and $contractServiceCode!='N210M' and $contractServiceCode!='N310M' and $contractServiceCode!='N410M' and $contractServiceCode!='N510M' and $contractServiceCode!='MDD1' and $contractServiceCode!='MDD2' and $contractServiceCode!='MDD4' and $contractServiceCode!='MDD4' and $contractServiceCode!='N1300' and $contractServiceCode!='EQON' and $contractServiceCode!='TP' and $contractServiceCode!='NOWAS' and $contractServiceCode!='LONEX' and $contractServiceCode!='EQLOC' and $contractServiceCode!='ITAUW' and $contractServiceCode!='DOWN' and $contractServiceCode!='DOWNS' and $contractServiceCode!='MMST' and $contractServiceCode!='MMSI' and $contractServiceCode!='GPSDA'">

                                <!-- ################################################################ -->
                                <!-- REVER!!! sum(descendant::LIN6/MOA) NÃO PARECE ESTAR CORRETO!!!!! -->
                                <!-- ################################################################ -->
                                <xsl:variable name="null" select="number:setValue('subtotalAdditional', number:getValue('subtotalAdditional') + number:parse(MOA/AMOUNT[@TYPE='203']/@VALUE) + sum(descendant::LIN6/MOA/AMOUNT[@TYPE='919']/@VALUE))"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:variable name="null"
                        select="number:setValue('men', number:getValue('men') + number:getValue('amount'))"/>
                </xsl:if>
                <!-- NEXTEL ONLINE SERVICES -->
                <xsl:if test="$contractServiceCode='SMST' or $contractServiceCode='WP' or $contractServiceCode='TWM' or $contractServiceCode='WPTWM' or $contractServiceCode='CLIRB' or $contractServiceCode='CIRDT' or $contractServiceCode='NMSIM' or $contractServiceCode='NMPLS' or $contractServiceCode='NMBAS' or $contractServiceCode='N200K' or $contractServiceCode='MDD3' or $contractServiceCode='N1200' or $contractServiceCode='N2200' or $contractServiceCode='N4200' or $contractServiceCode='N5200' or $contractServiceCode='N2300' or $contractServiceCode='N3300' or $contractServiceCode='N4300' or $contractServiceCode='N5300' or $contractServiceCode='N1600' or $contractServiceCode='N2600' or $contractServiceCode='N3600' or $contractServiceCode='N4600' or $contractServiceCode='N5600' or $contractServiceCode='N11MB' or $contractServiceCode='N21MB' or $contractServiceCode='N31MB' or $contractServiceCode='N41MB' or $contractServiceCode='N51MB' or $contractServiceCode='N13MB' or $contractServiceCode='N23MB' or $contractServiceCode='N33MB' or $contractServiceCode='N43MB' or $contractServiceCode='N53MB' or $contractServiceCode='N110M' or $contractServiceCode='N210M' or $contractServiceCode='N310M' or $contractServiceCode='N410M' or $contractServiceCode='N510M' or $contractServiceCode='MDD1' or $contractServiceCode='MDD2' or $contractServiceCode='MDD4' or $contractServiceCode='MDD4' or $contractServiceCode='N1300' or $contractServiceCode='EQON' or $contractServiceCode='TP' or $contractServiceCode='NOWAS' or $contractServiceCode='LONEX' or $contractServiceCode='EQLOC' or $contractServiceCode='ITAUW' or $contractServiceCode='DOWN' or $contractServiceCode='DOWNS' or $contractServiceCode='MMST' or $contractServiceCode='MMSI' or $contractServiceCode='GPSDA'">

                    <xsl:variable name="null" 
                        select="number:setValue('amount', MOA/AMOUNT[@TYPE='203']/@VALUE)"/>
                    <xsl:variable name="null"
                        select="number:setValue('onlineAmount', number:getValue('onlineAmount') + number:getValue('amount'))"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
