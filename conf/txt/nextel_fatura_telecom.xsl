<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <xsl:template match="TELECOM">
    <xsl:if test="BOLETO_ARRECADACAO">
      <xsl:apply-templates select="NF" /> 
      <xsl:apply-templates select="BOLETO_ARRECADACAO" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="NF">
    <xsl:value-of select="$TC_NF_Key" />
    <xsl:value-of select="@NR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@SR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DE" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DV" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DF" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@BCIC" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="'Vide *'" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@VIC" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@HC" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="CLIENTE" />
    <xsl:apply-templates select="EMITENTE" />

    <xsl:if test="ITENS/IT">
      <xsl:for-each select="ITENS/IT">
        <xsl:value-of select="$TC_NF_itemKey" />
        <xsl:value-of select="@DS" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@AIC" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:for-each>
      <xsl:value-of select="$TC_NF_itemEndKey" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>

    <xsl:if test="OBS/O">
      <xsl:apply-templates select="OBS/O" mode="financials">
        <xsl:with-param name="key" select="$TC_NF_obsKey" />
      </xsl:apply-templates>
      <xsl:value-of select="$TC_NF_obsEndKey" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>

    <xsl:if test="MSGS/M">
      <xsl:apply-templates select="MSGS/M" mode="financials">
        <xsl:with-param name="key" select="$TC_NF_msgsKey" />
      </xsl:apply-templates>
      <xsl:value-of select="$TC_NF_msgsEndKey" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>

    <xsl:value-of select="$TC_NF_endKey" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

  </xsl:template>



  <xsl:template match="CLIENTE">
    <xsl:value-of select="$TC_NF_clienteKey" />
    <xsl:value-of select="@NR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@N" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@E" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CEP" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@ES" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@ID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@IE" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CES" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>
  
  
  
  <xsl:template match="EMITENTE">
    <xsl:value-of select="$TC_NF_emitenteKey" />
    <xsl:value-of select="@ES" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@ID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@IE" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CES" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>



</xsl:stylesheet>