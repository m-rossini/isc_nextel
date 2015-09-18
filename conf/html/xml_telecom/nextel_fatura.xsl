<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">  <xsl:output method="html"
              version="4.01"
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1"
              omit-xml-declaration="no"
              indent="no"
              media-type="text/html"/>

	<!-- for arrecadacao bancaria -->
  	<xsl:include href="../xml_html/resumo_fatura/nextel_fatura.xsl"/>
	<xsl:include href="../xml_html/resumo_fatura/nextel_boleto_arrecadacao.xsl"/>
	<!-- for compensacao bancaria -->
	<xsl:include href="../xml_nota_fiscal/nextel_fatura.xsl"/>
  	<xsl:include href="nextel_boleto_bancario.xsl"/>



  	<xsl:template match="/">

        <xsl:choose>
	        <xsl:when test="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO">

			  <!-- includes for arrecadacao bancaria -->
		    <html>
		      <head>
		        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
		        <title>Nextel Telecomunicações</title>
                <link rel="stylesheet" href="../xml_html/resumo_fatura/include/nextel_invoice_common.css" type="text/css"/>
 	            <link rel="stylesheet" href="../xml_html/resumo_fatura/include/nextel_invoice_boleto.css" type="text/css"/>
 	            <link href="../xml_html/resumo_fatura/include/fatura.css" rel="stylesheet"/>
 	            <script type="text/vbscript" src="../barcode.vbs"/>
	          </head>
              <body>
	        	<!-- Estes templates vem de ../xml_html/resumo_fatura/nextel_fatura.xsl -->
		        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
		        <xsl:apply-templates select="INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO"/>
			  </body>
            </html>

	        </xsl:when>

	        <xsl:otherwise>

			<html>
		      <head>
		        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
		        <title>Nextel Telecomunicações</title>
                <link rel="stylesheet" href="../css/nextel_invoice_common.css" type="text/css" />
                <link rel="stylesheet" href="../css/nextel_invoice_nf.css" type="text/css" />
                <link rel="stylesheet" href="css_nextel.css" type="text/css"/>
              </head>
              <body>
		        <xsl:apply-templates select="INVOICE/BILL/TELECOM/NF" />
	        	<xsl:apply-templates select="/INVOICE/BILL/TELECOM/BOLETO" />
			  </body>
            </html>

		    </xsl:otherwise>

		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
