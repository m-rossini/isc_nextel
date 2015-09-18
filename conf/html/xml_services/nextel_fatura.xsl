<?xml version="1.0" encoding="ISO-8859-1"?>
<!--                xmlns:xalan="http://xml.apache.org/xalan"                 exclude-result-prefixes="xalan"
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" omit-xml-declaration="no" indent="no" media-type="text/html"/>

    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/BILL/SERVICES"/>
    </xsl:template>

    <!-- ****************************************************** -->
    <!-- * Boleto Bancario - SERVICES * -->
    <!-- ****************************************************** -->
    <xsl:template match="SERVICES">
    
    <!-- xsl:if test="/INVOICE/CUSTOMER/@ST!='SP' and /INVOICE/CUSTOMER/@ST!='RJ'" -->

<link rel="stylesheet" href="css/css_nextel.css" type="text/css"/>
<table width="640" border="0" cellpadding="0" cellspacing="0">

	<xsl:call-template name="BOLETO_SERVICES"/>

</table>

    <!-- /xsl:if -->

    </xsl:template>


    <!-- ****************************************************** -->
    <!-- * Formatações dos cabeçalhos e corpos de cada página * -->
    <!-- ****************************************************** -->
    <xsl:include href="nextel_boleto_bancario.xsl"/>

</xsl:stylesheet>
