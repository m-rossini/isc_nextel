<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt" 
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
  extension-element-prefixes="xalan number" 
  exclude-result-prefixes="lxslt xalan number"
  version="1.0">

  <xsl:template name="DESCRICAO-BOLETO">
    <xsl:param name="tp"/>
    <xsl:param name="boleto" select="BOLETO[@TP=$tp]"/>

    <xsl:if test="$tp != $tp-multas">
      <xsl:attribute name="T">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="sum($boleto/ITEM/@T) div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="V">
      <xsl:call-template name="decimalFormat">
        <xsl:with-param name="value" select="sum($boleto/ITEM/@V) div 100"/>
      </xsl:call-template>
    </xsl:attribute>
    
    <xsl:for-each select="$boleto">
      <ITENS>
        <xsl:if test="$tp != $tp-multas">
          <xsl:attribute name="T">
            <xsl:call-template name="decimalFormat">
              <xsl:with-param name="value" select="sum(ITEM/@T) div 100"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="V">
          <xsl:call-template name="decimalFormat">
            <xsl:with-param name="value" select="sum(ITEM/@V) div 100"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="ITEM" mode="BOLETO">
          <xsl:with-param name="tp" select="$tp"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." />
      </ITENS>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="ITEM" mode="BOLETO">
    <xsl:param name="tp"/>
    <IT>
      <xsl:attribute name="DT">
        <xsl:value-of select="@DT"/>
      </xsl:attribute>
      <xsl:attribute name="NR">
        <xsl:choose>
          <xsl:when test="$tp = $tp-negociacoes">
            <xsl:value-of select="@NF"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@NR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$tp != $tp-negociacoes">
        <xsl:attribute name="DS">
          <xsl:value-of select="@DS"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$tp = $tp-compras">
        <xsl:attribute name="QT">
          <xsl:call-template name="quantityFormat">
            <xsl:with-param name="value" select="@QT div 10000"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="LO">
          <xsl:value-of select="@LO"/>
        </xsl:attribute>
        <xsl:attribute name="NF">
          <xsl:value-of select="@NF"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$tp != $tp-multas">
        <xsl:attribute name="T">
          <xsl:call-template name="decimalFormat">
            <xsl:with-param name="value" select="@T div 100"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="NRP">
          <xsl:value-of select="@NRP"/>
        </xsl:attribute>
        <xsl:attribute name="QTP">
          <xsl:value-of select="@QTP"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      
      <xsl:copy-of select="AP"/>
    </IT>
  </xsl:template>

</xsl:stylesheet>
