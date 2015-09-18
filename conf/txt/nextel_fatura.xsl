<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
                exclude-result-prefixes="xalan barcode phonenumber"
                version="1.0">

    <xsl:output method="text" indent="no" encoding="ISO-8859-1" media-type="text/plain"/>

    <!-- variáveis diversas -->
    <xsl:variable name="delimiter" select="'|&amp;'"/>
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="decimalSeparator" select="','"/>
    <xsl:variable name="userNameMaxLength" select="15"/>


    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
    </xsl:template>

    <xsl:template match="CUSTOMER">

        <!-- *********************** -->
        <!-- * Cabeçalho principal * -->
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
                  <!-- Imprime todas as chaves de subtotais (obrigatório) -->
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

        <!-- Só mostra se houver alguma coisa a mostrar -->
        <xsl:if test="@T!='0,00'">

            <!-- ****************** -->
            <!-- * Terceira parte * -->
            <!-- ****************** -->
            <xsl:call-template name="HEADER-DETALHE">
                <xsl:with-param name="key" select="$DF_startKey"/>
            </xsl:call-template>
            <xsl:call-template name="DETALHE-FATURA"/>
            <!-- Total do usuário -->
            <xsl:value-of select="$DF_endKey"/>
            <xsl:value-of select="@T"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$newline"/>


            <!-- **************** -->
            <!-- * Quarta parte * -->
            <!-- **************** -->
            <!-- Só mostra se houver alguma chamada de telefonia -->
            <!-- Só exibe o detalhe da conta se tiver o serviço de conta detalhada: PCntD -->
            <!-- <xsl:if test="((count(SERVICES/SVC[@ID='PCntD']) &gt; 0) and (CALLS/HOME/@DNF!='0,00' or CALLS/ROAMING/@DNF!='0,00' or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or CALLS/IDCD/@V!='0,00')) or (@PP='Y' and (CALLS/HOME/@CH!='0,00' or CALLS/ROAMING/@CH!='0,00'))"> -->
            <xsl:if test="(SERVICES/SVC[@ID='PCntD'] and (CALLS/HOME/@DNF!='0:00' or CALLS/ROAMING/@DNF!='0:00' or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or CALLS/IDCD/@V!='0,00')) or (@PP='Y' and (CALLS/HOME/@CH!='0:00' or CALLS/ROAMING/@CH!='0:00') or (CALLS/ONLINE/SVC[@ID='LOLGT']))">                        
            <!-- xsl:if test="CALLS/HOME/@DNF!='0,00' or CALLS/ROAMING/@DNF!='0,00'" -->
                <xsl:call-template name="HEADER-DETALHE">
                    <xsl:with-param name="key" select="$DC_startKey"/>
                </xsl:call-template>
                <xsl:call-template name="DETALHE-CONTA-SRV"/>                
                <xsl:call-template name="DETALHE-CONTA-ONLINE"/>   
                <!--
                <xsl:call-template name="DETALHE-CONTA-SRVINT"/>
                -->
                <xsl:call-template name="DETALHE-CONTA"/>
            </xsl:if>
            <xsl:value-of select="$DC_endKey"/>
            <xsl:value-of select="$newline"/>

        </xsl:if>

    </xsl:template>


    <!-- ****************************************************** -->
    <!-- * Formatações dos cabeçalhos e corpos de cada página * -->
    <!-- ****************************************************** -->
    <xsl:include href="nextel_fatura_chaves.xsl"/>
    <xsl:include href="nextel_fatura_header.xsl"/>
    <xsl:include href="nextel_fatura_resumo_fatura_mensal.xsl"/>
    <xsl:include href="nextel_fatura_resumo_equipamento.xsl"/>
    <xsl:include href="nextel_fatura_detalhe_fatura.xsl"/>
    <xsl:include href="nextel_fatura_detalhe_conta.xsl"/>    
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

    <!-- coloca hífens em um número de telefone -->
    <xsl:template name="HIFENIZAR">
        <xsl:param name="number"/>
        <xsl:variable name="null" select="phonenumber:parse(string($number))"/>
        <xsl:value-of select="phonenumber:getHiphenized()"/>
    </xsl:template>
    

</xsl:stylesheet>
