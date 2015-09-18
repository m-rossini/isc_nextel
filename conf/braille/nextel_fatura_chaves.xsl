<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

    <!-- Título -->
    <xsl:variable name="brailleKey"                     			select="'01'"/>

    <!-- BO = Boleto Consolidado Telecom/Compras/Multas/Negociacoes -->
    <xsl:variable name="BO_C_prefix"                select="'8'"/>
    <xsl:variable name="BO_D_prefix"                select="'9'"/>
    <xsl:variable name="BO_startKey"                select="'0    '"/>
    <xsl:variable name="BO_sacadoKey"               select="'1    '"/>
    <xsl:variable name="BO_instrKey"                select="'2    '"/>
    <xsl:variable name="BO_instrEndKey"             select="'3    '"/>
    <xsl:variable name="BO_itemKey"                 select="'4    '"/>
    <xsl:variable name="BO_apKey"                   select="'5    '"/>
    <xsl:variable name="BO_itemEndKey"              select="'6    '"/>
    <xsl:variable name="BO_endKey"                  select="'9    '"/>

</xsl:stylesheet>
