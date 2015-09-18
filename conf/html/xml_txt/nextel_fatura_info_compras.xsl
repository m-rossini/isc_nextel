<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <xsl:template match="INVOICE/CUSTOMER/MESSAGES[I]" mode="financials">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">INFORMAÇÕES IMPORTANTES</xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="I">
      <xsl:call-template name="formatText">
        <xsl:with-param name="text" select="text()" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$newline" />
      <xsl:if test="position() = last()">
        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>



  <xsl:template match="COMPRAS">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">BOLETO CONSOLIDADO DE COMPRA DE EQUIPAMENTOS, ACESSÓRIOS E REPAROS</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="formatParagraph">
      <xsl:with-param name="text">
        Prezado cliente, esta é a relação de todas as compras de
        aparelhos, acessórios e reparos realizadas através de boleto.
        Não considera compras com cheque, cartão ou através da loja
        Virtual.
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />

    <!-- Table width -->
    <xsl:variable name="width">
      <xsl:variable name="minWidth" select="150"/>
      <xsl:choose>
        <xsl:when test="$lineWidth &lt; $minWidth">
          <xsl:value-of select="$minWidth" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$lineWidth" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="myHR" select="substring($rule,1,$width)"/>
    <xsl:variable name="col-widths">
      <xsl:text>0.07</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.06</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.13</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.05</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.11</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.06</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.08</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.07</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.08</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.11</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.07</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.10</xsl:text>
    </xsl:variable>

    <xsl:variable name="tableHeader">
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />
      <xsl:call-template name="formatCenter">
        <xsl:with-param name="text">Descrição do boleto de compra de equipamentos, acessórios e reparos</xsl:with-param>
        <xsl:with-param name="width" select="$width" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$myHR" />
      <xsl:value-of select="$newline" />

      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:text>Data do</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>N&#x00b0; da</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Descrição</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Quant.</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Local</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>NF</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Valor</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Cond.</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Valor a</xsl:text>
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
          <xsl:text>Evento</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Solicit.</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:text>Total(R$)</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Pagto</xsl:text>
          <xsl:value-of select="$colSep" />
          <xsl:text>Pagar(R$)</xsl:text>
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
            <xsl:value-of select="round(translate(@QT,',','.'))" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@LO" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@NF" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@T" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="concat(@NRP,'/',@QTP)" />
            <xsl:value-of select="$colSep" />
            <xsl:value-of select="@V" />
            <xsl:value-of select="$colSep" />
            <xsl:choose>
              <xsl:when test="AP/@IMEI">
                <xsl:value-of select="AP/@IMEI" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-----</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$colSep" />
            <xsl:choose>
              <xsl:when test="AP/@FID">
                <xsl:value-of select="AP/@FID" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-----</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$colSep" />
            <xsl:choose>
              <xsl:when test="AP/@TEL">
                <xsl:value-of select="AP/@TEL" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-----</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="widths" select="$col-widths" />
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
        <xsl:value-of select="$newline" />
        <xsl:if test="AP/@SIM">
          <xsl:call-template name="formatCol">
            <xsl:with-param name="cols">
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
              <xsl:value-of select="$colSep" />
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
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@T" />
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


  <xsl:template match="COMPRAS/ITENS/IT/AP">
    <xsl:param name="col-widths" />
    <xsl:param name="width" select="$lineWidth"/>
   
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:value-of select="$colSep" />
        <xsl:choose>
          <xsl:when test="@IMEI">
            <xsl:value-of select="@IMEI" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-----</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$colSep" />
        <xsl:choose>
          <xsl:when test="@FID">
            <xsl:value-of select="@FID" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-----</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$colSep" />
        <xsl:choose>
          <xsl:when test="@TEL">
            <xsl:value-of select="@TEL" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-----</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    
    <xsl:if test="@SIM">
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="$colSep" />
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
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>