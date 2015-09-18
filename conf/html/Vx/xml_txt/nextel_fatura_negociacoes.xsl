<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

                
  <xsl:template match="NEGOC">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">BOLETO CONSOLIDADO DE NEGOCIAÇÕES</xsl:with-param>
    </xsl:call-template>

    <!-- Table width -->
    <xsl:variable name="width" select="$lineWidth"/>
    <xsl:variable name="myHR" select="substring($rule,1,$width)"/>
    <xsl:variable name="col-widths">
      <xsl:text>0.14</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.18</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.19</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.16</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.18</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.15</xsl:text>
    </xsl:variable>

    <xsl:variable name="tableHeader">
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />
      <xsl:call-template name="formatCenter">
        <xsl:with-param name="text">Descrição do boleto consolidado</xsl:with-param>
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />

      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Data do</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>N&#x00b0; do Novo</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>N&#x00b0; do Título</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Valor</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Cond.</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Valor a</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />

      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Evento</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Título</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Original</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Total(R$)</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Pagto</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Pagar(R$)</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />
    </xsl:variable>

    <xsl:for-each select="ITENS">
      <xsl:value-of select="$tableHeader"/>
      <xsl:for-each select="IT">
        <xsl:call-template name="formatCol">
          <xsl:with-param name="cols">
            <xsl:value-of select="@DT" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@NR" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="AP/@IMEI" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@T" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="concat(@NRP,'/',@QTP)" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@V" />
          </xsl:with-param>
          <xsl:with-param name="widths" select="$col-widths" />
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
        <xsl:value-of select="$newline" />
        <xsl:apply-templates select="AP[position() &gt; 1]">
          <xsl:with-param name="col-widths" select="$col-widths" />
          <xsl:with-param name="width" select="$width" />
        </xsl:apply-templates>
      </xsl:for-each>
      
      <xsl:value-of select="$myHR"/>
      <xsl:value-of select="$newline" />
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Total</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@T" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@V" />
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$myHR"/>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$newline" />
    </xsl:for-each>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="NEGOC/ITENS/IT/AP">
    <xsl:param name="col-widths" />
    <xsl:param name="width" select="$lineWidth"/>
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="@IMEI" />
        <xsl:value-of select="$colSep" />
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
  </xsl:template>


</xsl:stylesheet>