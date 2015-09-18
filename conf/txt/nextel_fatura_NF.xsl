<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
                exclude-result-prefixes="xalan barcode phonenumber"
                version="1.0">

    <xsl:output method="text" indent="no" encoding="ISO-8859-1" media-type="text/plain"/>
    
    
    <xsl:include href="nextel_fatura_financials.xsl"/>
    <xsl:include href="nextel_fatura_chaves.xsl"/>
    

    <!-- variáveis diversas -->
    <xsl:variable name="delimiter" select="'|&amp;'"/>
    <xsl:variable name="newline" select="'&#10;'" />


    <xsl:template match="/">
        <xsl:if test="INVOICE/BILL">
          <xsl:apply-templates select="INVOICE/BILL"/>
          <xsl:value-of select="$finalKey"/>
          <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>
    

</xsl:stylesheet>
