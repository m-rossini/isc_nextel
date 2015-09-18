<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt" 
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
  extension-element-prefixes="xalan number" 
  exclude-result-prefixes="lxslt xalan number"
  version="1.0">

  <xsl:template match="BOLETO">
    <BOLETO>
      <xsl:attribute name="NB">
        <xsl:value-of select="@NB"/>
      </xsl:attribute>
      <xsl:attribute name="CB">
        <xsl:value-of select="concat(@CB,'-',@CBDV)"/>
      </xsl:attribute>
      <xsl:attribute name="LD">
        <xsl:value-of select="INFO/@LD"/>
      </xsl:attribute>
      <xsl:attribute name="CBB">
        <xsl:value-of select="INFO/@CBB"/>
      </xsl:attribute>
      <xsl:attribute name="LP1">
        <xsl:value-of select="@LP1"/>
      </xsl:attribute>
      <xsl:attribute name="LP2">
        <xsl:value-of select="@LP2"/>
      </xsl:attribute>
      <xsl:attribute name="DV">
        <xsl:value-of select="INFO/@DV"/>
      </xsl:attribute>
      <xsl:attribute name="S">
        <xsl:value-of select="@N-E"/>
      </xsl:attribute>
      <xsl:attribute name="AC">
        <xsl:value-of select="@AC"/>
      </xsl:attribute>
      <xsl:attribute name="DD">
        <xsl:value-of select="@DP"/>
      </xsl:attribute>
      <xsl:attribute name="NRD">
        <xsl:value-of select="INFO/@NRD"/>
      </xsl:attribute>
      <xsl:attribute name="CE">
        <xsl:value-of select="INFO/@CE"/>
      </xsl:attribute>
      <xsl:attribute name="DM">
        <xsl:value-of select="INFO/@DE"/>
      </xsl:attribute>
      <xsl:attribute name="NN">
        <xsl:value-of select="INFO/@NN"/>
      </xsl:attribute>
      <xsl:attribute name="C">
        <xsl:value-of select="@C"/>
      </xsl:attribute>
      <xsl:attribute name="M">
        <xsl:value-of select="@M"/>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="INFO/@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="FP">
        <xsl:value-of select="@FP"/>
      </xsl:attribute>

<!--EHO: desconto e abatimento -->
	  <xsl:attribute name="VDA">
        <xsl:if test="string-length(INFO/@VDA) &gt; 0">
           <xsl:call-template name="decimalFormat">
              <xsl:with-param name="value" select="INFO/@VDA div 100"/>
           </xsl:call-template>
        </xsl:if>
	  </xsl:attribute>
      
      <SACADO>
        <xsl:attribute name="N">
          <xsl:value-of select="INFO/@N-C"/>
        </xsl:attribute>
        <xsl:attribute name="E">
          <xsl:value-of select="INFO/@E-C"/>
        </xsl:attribute>
        <xsl:attribute name="CEP">
          <xsl:value-of select="INFO/@CEP-C"/>
        </xsl:attribute>
        <xsl:attribute name="CI">
          <xsl:value-of select="INFO/@CI-C"/>
        </xsl:attribute>
        <xsl:attribute name="ES">
          <xsl:value-of select="INFO/@ES-C"/>
        </xsl:attribute>
      </SACADO>
      
      <INSTR_BANC>
        <xsl:if test="string-length(@IB1) &gt; 0">
          <I><xsl:value-of select="@IB1"/></I>
        </xsl:if>
        <xsl:if test="string-length(@IB2) &gt; 0">
          <I><xsl:value-of select="@IB2"/></I>
        </xsl:if>
<!--EHO: desconto e abatimento (mensagem)-->
        <xsl:if test="string-length(@IB3) &gt; 0">
          <I><xsl:value-of select="@IB3"/></I>
        </xsl:if>
<!-- xx -->        
        <xsl:if test="string-length(INFO/@IB1) &gt; 0">
          <I><xsl:value-of select="INFO/@IB1"/></I>
        </xsl:if>
        <xsl:if test="string-length(INFO/@IB2) &gt; 0">
          <I><xsl:value-of select="INFO/@IB2"/></I>
        </xsl:if>
        <xsl:if test="string-length(INFO/@IB3) &gt; 0">
          <I><xsl:value-of select="INFO/@IB3"/></I>
        </xsl:if>
      </INSTR_BANC>
    </BOLETO>
  </xsl:template>

</xsl:stylesheet>
