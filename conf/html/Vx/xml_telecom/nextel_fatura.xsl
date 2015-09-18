<?xml version="1.0" encoding="ISO-8859-1"?>
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/> 

  <xsl:include href="nextel_boleto_bancario.xsl" />
  <xsl:include href="../xml_nota_fiscal/nextel_fatura.xsl"/>

      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
        <title>Nextel Telecomunica��es</title>
        <link rel="stylesheet" href="css/nextel_invoice_common.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_nf.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_boleto.css" type="text/css" />
        <link rel="stylesheet" href="css/css_nextel.css" type="text/css"/>
        <script type="text/vbscript" src="barcode.vbs"/>
      </head>

      <body>
        <xsl:apply-templates select="INVOICE/BILL/TELECOM/NF" />
        <xsl:apply-templates select="INVOICE/BILL/TELECOM/BOLETO" />
      </body>
    </html>