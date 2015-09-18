<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt" 
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
  extension-element-prefixes="xalan number" 
  exclude-result-prefixes="lxslt xalan number"
  version="1.0">

  <xsl:template name="TELECOM">
    <TELECOM>
      <xsl:apply-templates select="NF[@TP=$tp-telecom]"/>
<!--      <xsl:apply-templates select="BOLETO[@TP=$tp-telecom]"/>  -->
	  <xsl:apply-templates select="BOLETO_ARRECADACAO"/>      
    </TELECOM>
  </xsl:template>
  
  <xsl:template match="NF">
    <NF>
      <xsl:attribute name="NR">
        <xsl:value-of select="@NR"/>
      </xsl:attribute>
      <xsl:attribute name="SR">
        <xsl:value-of select="@SR"/>
      </xsl:attribute>
      <xsl:attribute name="DE">
        <xsl:value-of select="@DE"/>
      </xsl:attribute>
      <xsl:attribute name="DV">
        <xsl:value-of select="@DV"/>
      </xsl:attribute>
      <xsl:attribute name="DI">
        <xsl:value-of select="@DI"/>
      </xsl:attribute>
      <xsl:attribute name="DF">
        <xsl:value-of select="@DF"/>
      </xsl:attribute>
      <xsl:attribute name="BCIC">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@BCIC div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="AIC">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@AIC div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="VIC">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@VIC div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="HC">
        <xsl:value-of select="@HC"/>
      </xsl:attribute>
      
      <CLIENTE>
        <xsl:attribute name="N">
          <xsl:value-of select="@N-C"/>
        </xsl:attribute>
        <xsl:attribute name="NR">
          <xsl:value-of select="/GEL/BILL/@BSCS"/>
        </xsl:attribute>
        <xsl:attribute name="ID">
          <xsl:value-of select="@ID-C"/>
        </xsl:attribute>
        <xsl:attribute name="IE">
          <xsl:value-of select="@IE-C"/>
        </xsl:attribute>
        <xsl:attribute name="E">
          <xsl:value-of select="@E-C"/>
        </xsl:attribute>
        <xsl:attribute name="CEP">
          <xsl:value-of select="@CEP-C"/>
        </xsl:attribute>
        <xsl:attribute name="CI">
          <xsl:value-of select="@CI-C"/>
        </xsl:attribute>
        <xsl:attribute name="ES">
          <xsl:value-of select="@ES-C"/>
        </xsl:attribute>
        <xsl:attribute name="CES">
          <xsl:value-of select="@CUF-C"/>
        </xsl:attribute>
      </CLIENTE>
      
      <EMITENTE>
        <xsl:attribute name="ID">
          <xsl:value-of select="@ID-E"/>
        </xsl:attribute>
        <xsl:attribute name="IE">
          <xsl:value-of select="@IE-E"/>
        </xsl:attribute>
        <xsl:attribute name="ES">
          <xsl:value-of select="@ES-E"/>
        </xsl:attribute>
        <xsl:attribute name="CES">
          <xsl:value-of select="@CUF-E"/>
        </xsl:attribute>
      </EMITENTE>
      
      <OBS>
        <xsl:if test="string-length(@OB1) &gt; 0">
          <O><xsl:value-of select="@OB1"/></O>
        </xsl:if>
        <xsl:if test="string-length(@OB2) &gt; 0">
          <O><xsl:value-of select="@OB2"/></O>
        </xsl:if>
        <xsl:if test="string-length(@OB3) &gt; 0">
          <O><xsl:value-of select="@OB3"/></O>
        </xsl:if>
        <xsl:if test="string-length(@OB4) &gt; 0">
          <O><xsl:value-of select="@OB4"/></O>
        </xsl:if>
      </OBS>
      
      <MSGS>
        <xsl:for-each select="MSG">
        <M><xsl:value-of select="@M"/></M>
        </xsl:for-each>
      </MSGS>
      
      <ITENS>
        <xsl:apply-templates select="ITEM" mode="NF"/>
      </ITENS>
    </NF>
  </xsl:template>
  
  <xsl:template match="ITEM" mode="NF">
    <IT>
      <xsl:attribute name="S">
        <xsl:value-of select="@S"/>
      </xsl:attribute>
      <xsl:attribute name="DS">
        <xsl:value-of select="@DS"/>
      </xsl:attribute>
      <xsl:attribute name="QT">
        <xsl:call-template name="quantityFormat">
          <xsl:with-param name="value" select="@QT div 10000"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="VU">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@VU div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="AIC">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@AIC div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </IT>
  </xsl:template>

</xsl:stylesheet>
