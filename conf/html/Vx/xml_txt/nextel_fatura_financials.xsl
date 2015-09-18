<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">            
   
  <xsl:include href="nextel_fatura_extrato.xsl"/>
  <xsl:include href="nextel_fatura_info_compras.xsl"/>
  <xsl:include href="nextel_fatura_multas.xsl"/>
  <xsl:include href="nextel_fatura_negociacoes.xsl"/>
                 
  <xsl:template match="BILL">
    <xsl:apply-templates select="EXTRATO" />
    <xsl:apply-templates select="../CUSTOMER/MESSAGES[I]" mode="financials" />
    <xsl:apply-templates select="COMPRAS" />
    <xsl:apply-templates select="MULTAS" />
    <xsl:apply-templates select="NEGOC" />
  </xsl:template>

</xsl:stylesheet>