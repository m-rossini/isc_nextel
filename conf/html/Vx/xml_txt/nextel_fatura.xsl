<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:template match="/">
      <xsl:apply-templates select="INVOICE/BILL" />

        <!-- rodap� -->
        <xsl:for-each select="MESSAGES/M">
            <xsl:value-of select="translate(text(), '#', ' ')"/>
            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:for-each>
        <xsl:if test="/BILL/TELECOM/@FP">
          <xsl:text>Esta fatura possui d�bito autom�tico em&#32;</xsl:text>
          <xsl:choose>
            <xsl:when test="/BILL/TELECOM/@FP = 'C'">
              <xsl:text>cart�o de cr�dito</xsl:text>
            </xsl:when>
            <xsl:when test="/BILL/TELECOM/@FP = 'D'">
              <xsl:text>conta corrente</xsl:text>
            </xsl:when>
          </xsl:choose>
          <xsl:text>.&#13;&#10;</xsl:text>
        </xsl:if>
        
            <xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or @PP='Y' or CALLS/IDCD/@V!='0,00' or CALLS/ONLINE/SVC[@ID='LOLGT']">
                <xsl:call-template name="DETALHE-CONTA-SRV"/>                
                <xsl:call-template name="DETALHE-CONTA-ONLINE"/>                 
    <xsl:include href="nextel_fatura_formatting.xsl"/>  