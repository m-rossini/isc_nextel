<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:template match="BOLETO_ARRECADACAO">

    <BOLETO_ARRECADACAO>

      <xsl:attribute name="NC">
        <xsl:value-of select="@N-C"/>
      </xsl:attribute>
      <xsl:attribute name="IDDA">
        <xsl:value-of select="@ID-DA"/>
      </xsl:attribute>
      <xsl:attribute name="MR">
        <xsl:value-of select="@MR"/>
      </xsl:attribute>
      <xsl:attribute name="DE">
        <xsl:value-of select="@DE"/>
      </xsl:attribute>
      <xsl:attribute name="DV">
        <xsl:value-of select="@DV"/>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="LD">
        <xsl:value-of select="@LD"/>
      </xsl:attribute>
      <xsl:attribute name="CBB">
        <xsl:value-of select="@CBB"/>
      </xsl:attribute>

     <MSGS>
     	<M1><xsl:value-of select="@M1"/></M1>
     	<M2><xsl:value-of select="@M2"/></M2>
     	<M3><xsl:value-of select="@M3"/></M3>
     	<M4><xsl:value-of select="@M4"/></M4>
     	<M5><xsl:value-of select="@M5"/></M5>
     	<M6><xsl:value-of select="@M6"/></M6>
     	<M7><xsl:value-of select="@M7"/></M7>
     	<M8><xsl:value-of select="@M8"/></M8>
     </MSGS>

    </BOLETO_ARRECADACAO>

  </xsl:template>

</xsl:stylesheet>
