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

    <!-- vari�veis diversas -->
    <!-- <xsl:variable name="delimiter" select="'|&amp;'"/> -->
    <xsl:variable name="delimiter" select="''"/>

    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
        <febraban:reset/>
    </xsl:template>

    <xsl:template match="CUSTOMER">

        <!-- *********************** -->
        <!-- * Cabe�alho principal * -->
        <!-- *********************** -->
        <xsl:call-template name="HEADER">
            <xsl:with-param name="key" select="$headerKey"/>
        </xsl:call-template>

        <!-- **************************** -->
        <!-- * Conta resumo, bilheta��o e servi�os * -->
        <!-- **************************** -->
        <xsl:choose>
            <xsl:when test="count(DETAILS/SUBSCRIBER/CONTRACT) &gt; 0">
                <xsl:apply-templates select="DETAILS/SUBSCRIBER/CONTRACT" mode="DETAILS"/>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Descontos de OCC -->
        <xsl:call-template name="DESCONTOS">
            <xsl:with-param name="ramo" select="DETAILS/SUBSCRIBER/OTHER"/>
            <xsl:with-param name="key" select="$descontosKey"/>
            <xsl:with-param name="tipo" select="'5'"/>
        </xsl:call-template> 
        <xsl:call-template name="DESCONTOS">
            <xsl:with-param name="ramo" select="DETAILS/SUBSCRIBER/CREDITS"/>
            <xsl:with-param name="key" select="$descontosKey"/>
            <xsl:with-param name="tipo" select="'5'"/>
        </xsl:call-template> 
        <xsl:call-template name="DESCONTOS">
            <xsl:with-param name="ramo" select="DETAILS/SUBSCRIBER/PENALTY_INTERESTS"/>
            <xsl:with-param name="key" select="$descontosKey"/>
            <xsl:with-param name="tipo" select="'5'"/>
        </xsl:call-template> 

        <!-- Trailler -->
        <xsl:call-template name="TRAILLER">
            <xsl:with-param name="contratos" select="count(DETAILS/SUBSCRIBER/CONTRACT)"/>
            <xsl:with-param name="key" select="$totalizadorKey"/>
            <xsl:with-param name="total" select="/INVOICE/CUSTOMER/SUMMARY/@T"/>
        </xsl:call-template> 

    </xsl:template>

    <!-- **************************** -->
    <!-- * conta resumo, bilheta��o, servi�os e desconto (se tiver por contrato) * -->
    <!-- **************************** -->
    <xsl:template match="CONTRACT" mode="DETAILS">

        <!-- S� mostra se houver alguma coisa a mostrar -->
        <xsl:if test="@T!='0,00'">

            <xsl:call-template name="CONTA-RESUMO">
                <xsl:with-param name="key" select="$contaResumoKey"/>
            </xsl:call-template>
            <xsl:call-template name="BILHETACAO">
                <xsl:with-param name="key" select="$bilhetacaoKey"/>
            </xsl:call-template>
            <xsl:call-template name="SERVICOS">
                <xsl:with-param name="key" select="$servicosKey"/>
            </xsl:call-template> 
            <xsl:call-template name="DESCONTOS">
                <xsl:with-param name="ramo" select="CHARGES"/>
                <xsl:with-param name="key" select="$descontosKey"/>
                <xsl:with-param name="tipo" select="'1'"/>
            </xsl:call-template> 
        </xsl:if>
    </xsl:template>

    <!-- ****************************************************** -->
    <!-- * Formata��es dos cabe�alhos e corpos de cada p�gina * -->
    <!-- ****************************************************** -->
    <!-- defini��o de todas as chaves a serem geradas -->
    <xsl:include href="nextel_fatura_chaves.xsl"/>
    
    <xsl:include href="nextel_fatura_detalhe_fatura.xsl"/>
    <xsl:include href="nextel_fatura_detalhe_conta.xsl"/>    

    <!-- coloca h�fens em um n�mero de telefone -->
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
