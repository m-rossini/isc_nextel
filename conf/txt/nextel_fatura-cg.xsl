<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
                exclude-result-prefixes="xalan barcode phonenumber"
                version="1.0">

    <xsl:output method="text" indent="no" encoding="ISO-8859-1" media-type="text/plain"/>

    <!-- vari�veis diversas -->
    <xsl:variable name="delimiter" select="'|&amp;'"/>
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="decimalSeparator" select="','"/>
    <xsl:variable name="userNameMaxLength" select="15"/>

    <!-- defini��o de todas as chaves a serem geradas -->
    <xsl:include href="nextel_fatura_chaves.xsl"/>

    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
    </xsl:template>

    <xsl:template match="CUSTOMER">

        <!-- *********************** -->
        <!-- * Cabe�alho principal * -->
        <!-- *********************** -->
        <xsl:call-template name="HEADER">
            <xsl:with-param name="key" select="$headerKey"/>
        </xsl:call-template>

        <xsl:if test="DETAILS or SUMMARY">
          <!-- ****************** -->
          <!-- * Primeira parte * -->
          <!-- ****************** -->
          <xsl:call-template name="RESUMO-FATURA-MENSAL"/>
  
          <!-- ***************** -->
          <!-- * Segunda parte * -->
          <!-- ***************** -->
          <xsl:call-template name="RESUMO-EQUIPAMENTO"/>
  
          <!-- **************************** -->
          <!-- * Terceira e quarta partes * -->
          <!-- **************************** -->
          <xsl:choose>
              <xsl:when test="count(DETAILS/SUBSCRIBER/CONTRACT)">
                  <xsl:apply-templates select="DETAILS/SUBSCRIBER/CONTRACT" mode="DETAILS"/>
              </xsl:when>
              <xsl:otherwise>
                  <!-- Imprime todas as chaves de subtotais (obrigat�rio) -->
                  <xsl:value-of select="$DF_endKey"/>
                  <xsl:value-of select="$newline"/>
                  <xsl:value-of select="$DC_endKey"/>
                  <xsl:value-of select="$newline"/>
              </xsl:otherwise>
          </xsl:choose>
  
          <!-- ******************************** -->
          <!-- * Chave finalizadora da fatura * -->
          <!-- ******************************** -->
          <xsl:value-of select="$invoiceEndKey"/>
          <xsl:value-of select="$newline"/>
        </xsl:if>

        <!-- ************************ -->
        <!-- * Boleto / Nota Fiscal * -->
        <!-- ************************ -->
        <xsl:apply-templates select="/INVOICE/BILL"/>

        <!-- ********************************* -->
        <!-- * Chave finalizadora do cliente * -->
        <!-- ********************************* -->
        <xsl:value-of select="$finalKey"/>
        <xsl:value-of select="$newline"/>

    </xsl:template>


    <!-- **************************** -->
    <!-- * Terceira e quarta partes * -->
    <!-- **************************** -->
    <xsl:template match="CONTRACT" mode="DETAILS">

        <!-- S� mostra se houver alguma coisa a mostrar -->
        <xsl:if test="@T!='0,00'">

            <!-- ****************** -->
            <!-- * Terceira parte * -->
            <!-- ****************** -->
            <xsl:call-template name="HEADER-DETALHE">
                <xsl:with-param name="key" select="$DF_startKey"/>
            </xsl:call-template>
            <xsl:call-template name="DETALHE-FATURA"/>
            <!-- Total do usu�rio -->
            <xsl:value-of select="$DF_endKey"/>
            <xsl:value-of select="@T"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$newline"/>


            <!-- **************** -->
            <!-- * Quarta parte * -->
            <!-- **************** -->
            <!-- Control group nao possui esta secao  -->

        </xsl:if>

    </xsl:template>


    <!-- ****************************************************** -->
    <!-- * Formata��es dos cabe�alhos e corpos de cada p�gina * -->
    <!-- ****************************************************** -->
    <xsl:include href="nextel_fatura_header.xsl"/>
    <xsl:include href="nextel_fatura_resumo_fatura_mensal.xsl"/>
    <xsl:include href="nextel_fatura_resumo_equipamento.xsl"/>
    <xsl:include href="nextel_fatura_detalhe_fatura.xsl"/>
    <xsl:include href="nextel_fatura_financials.xsl"/>

    <!-- Imprime o valor passado ou 0,00 -->
    <xsl:template name="VALOR-OU-ZERO">
        <xsl:param name="value">0,00</xsl:param>
        <xsl:choose>
            <xsl:when test="starts-with($value, '-')">
                <xsl:value-of select="concat('(', substring($value, 2), ')')"/>
            </xsl:when>
            <xsl:when test="string-length($value) &gt; 0">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0,00</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- coloca h�fens em um n�mero de telefone -->
    <xsl:template name="HIFENIZAR">
        <xsl:param name="number"/>
        <xsl:variable name="null" select="phonenumber:parse($number)"/>
        <xsl:value-of select="phonenumber:getHiphenized()"/>
    </xsl:template>
    

</xsl:stylesheet>
