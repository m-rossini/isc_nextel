<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">

    <!-- **************************************************** -->
    <!-- * Resumo da fatura atual (Corpo da primeira parte) * -->
    <!-- **************************************************** -->
    <xsl:template name="RESUMO-FATURA-MENSAL">
        <!-- Corpo da página -->
        <xsl:value-of select="$RF_startKey"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@A"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@D"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@LC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@LD"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@R"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@RC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@I"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@Z3"/>
        </xsl:call-template>
		<!-- Campo de desconto HOME -->
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="SUMMARY/HOME/@DC"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@DNOZ3"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@R"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@RC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@Z3"/>
        </xsl:call-template>
		<!-- Campo de desconto ROAMING -->
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]">
                <xsl:call-template name="VALOR-OU-ZERO">
	            <xsl:with-param name="value" select="SUMMARY/ROAMING/@DC"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@O"/>
        </xsl:call-template>
        <!-- Torpedo SMS -->
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@TP"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@C"/>
        </xsl:call-template>        
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@C1"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@C2"/>
        </xsl:call-template>                

        <!-- Total geral -->
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="SUMMARY/@DICMS!='0,00'">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="SUMMARY/@SS"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Base de calculo -->
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="SUMMARY/@DICMS!='0,00'">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="SUMMARY/@TOTALBC"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Desconto ICMS -->
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="SUMMARY/@DICMS!='0,00'">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="SUMMARY/@DICMS"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>                

        <!-- Total a pagar -->
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>        
       
       <!-- Mensagens oriundas do GEL -->
<!-- IMPROVE THIS WAY TO GET THE GEL INFO -->           
        <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M1"/>
        <xsl:value-of select="$delimiter"/> 
		<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M2"/>
		<xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>
        
        <!-- Mensagens -->
        <xsl:for-each select="MESSAGES/M">
            <xsl:for-each select="xalan:tokenize(text(), '#')">
                <xsl:value-of select="$RF_messagesKey"/>
                <xsl:value-of select="."/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:for-each>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$RF_messagesKey"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$RF_messagesEndKey"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>

    </xsl:template>

</xsl:stylesheet>