<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

                
  <xsl:template match="MULTAS">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">BOLETO CONSOLIDADO DE NOTAS DE DÉBITO, MULTA CONTRATUAL E MULTA DE FIDELIZAÇÃO</xsl:with-param>
    </xsl:call-template>

    <!-- Table width -->
    <xsl:variable name="width" select="$lineWidth"/>
    <xsl:variable name="myHR" select="substring($rule,1,$width)"/>
    <xsl:variable name="col-widths">
      <xsl:text>0.10</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.18</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.19</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.14</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.15</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.12</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.12</xsl:text>
    </xsl:variable>

    <xsl:variable name="tableHeader">
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />
      <xsl:call-template name="formatCenter">
        <xsl:with-param name="text">Descrição do boleto consolidado de Notas de Débito, Multa Contratual e Multa de Fidelização</xsl:with-param>
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />

      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Data da</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>N&#x00b0; do Registro</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Descrição</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Valor(R$)</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>IMEI/aparelho</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Fleet</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Tel</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />

      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Solicit.</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>de Atendimento</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:text>IMEI/SIM Card</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>* ID</xsl:text>
          <xsl:value-of select="$colSep" />
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
            <xsl:value-of select="@DS" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@V" />
            <xsl:value-of select="$colSep" />
            <xsl:choose>
              <xsl:when test="AP">
                <xsl:value-of select="AP/@IMEI" />
                <xsl:value-of select="$colSep" />
                <xsl:value-of select="AP/@FID" />
                <xsl:value-of select="$colSep" />
                <xsl:value-of select="AP/@TEL" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-----</xsl:text>
                <xsl:value-of select="$colSep" />
                <xsl:text>-----</xsl:text>
                <xsl:value-of select="$colSep" />
                <xsl:text>-----</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="widths" select="$col-widths" />
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
        <xsl:value-of select="$newline" />
        <xsl:if test="AP">
          <xsl:call-template name="formatCol">
            <xsl:with-param name="cols">
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="AP/@SIM" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
            </xsl:with-param>
            <xsl:with-param name="widths" select="$col-widths" />
            <xsl:with-param name="width" select="$width" />
          </xsl:call-template>
          <xsl:value-of select="$newline" />
        </xsl:if>
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
          <xsl:value-of select="@V" />
          <xsl:value-of select="$colSep" />
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


  <xsl:template match="MULTAS/ITENS/IT/AP">
    <xsl:param name="col-widths" />
    <xsl:param name="width" select="$lineWidth"/>
   
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="@IMEI" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="@FID" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="@TEL" />
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="@SIM" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
  </xsl:template>

</xsl:stylesheet>