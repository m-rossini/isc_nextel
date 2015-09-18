<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
                xmlns:febraban="xalan://br.com.auster.nextel.xsl.extensions.FebrabanVariable"
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan barcode phonenumber febraban"
                version="1.0">

    <xsl:output method="text" indent="no" encoding="ISO-8859-1" media-type="text/plain"/>

    <!-- variáveis diversas -->
    <!-- <xsl:variable name="delimiter" select="'|&amp;'"/> -->
    <xsl:variable name="delimiter" select="''"/>

    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
        <febraban:reset/>
    </xsl:template>

    <xsl:template match="CUSTOMER">
        <!-- *********************** -->
        <!-- * Dados Fatura em Braille * -->
        <!-- *********************** -->
        <xsl:call-template name="BRAILLE">
            <xsl:with-param name="key" select="$brailleKey"/>
        </xsl:call-template>
    </xsl:template>


    <!-- ****************************************************** -->
    <!-- * Formatações dos cabeçalhos e corpos de cada página * -->
    <!-- ****************************************************** -->
    <!-- definição de todas as chaves a serem geradas -->
    <xsl:include href="nextel_fatura_chaves.xsl"/>    
    <xsl:include href="nextel_fatura_detalhe_fatura.xsl"/> 
    <!-- <xsl:include href="nextel_fatura_detalhe_conta.xsl"/>     -->

    <!-- coloca hífens em um número de telefone -->
    <xsl:template name="HIFENIZAR">
        <xsl:param name="number"/>
        <xsl:variable name="null" select="phonenumber:parse(string($number))"/>
        <xsl:value-of select="phonenumber:getHiphenized()"/>
    </xsl:template>

    <!-- Imprime um caracter de nova linha -->
    <xsl:template name="PRINT-LINEFEED">
        <xsl:text>
</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
