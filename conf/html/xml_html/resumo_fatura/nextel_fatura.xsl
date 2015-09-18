<?xml version ="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="html"
              version="4.01"
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1"
              omit-xml-declaration="no"
              indent="no"
              media-type="text/html"/>

 	<xsl:include href="nextel_boleto_arrecadacao.xsl"/>
 	<xsl:include href="nextel_customer.xsl"/>

    <xsl:template match="/">
	  <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
        <title>Nextel Telecomunicações</title>
        <link rel="stylesheet" href="include/nextel_invoice_common.css" type="text/css"/>
 	    <link rel="stylesheet" href="include/nextel_invoice_boleto.css" type="text/css"/>
 	    <link href="include/fatura.css" rel="stylesheet"/>
        <script type="text/vbscript" src="../../barcode.vbs"/>
      </head>

      <body>
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
        <xsl:apply-templates select="INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO"/>
      </body>
      </html>
    </xsl:template>

</xsl:stylesheet>