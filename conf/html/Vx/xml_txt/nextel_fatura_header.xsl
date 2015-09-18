<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- ******************************* -->
    <!-- * Mostra os dados do contrato * -->
    <!-- ******************************* -->
    <xsl:template name="HEADER-DETALHE">
        <xsl:text>DADOS DO USUÁRIO&#13;&#10;</xsl:text>
        <xsl:choose>
		    <xsl:when test="@TP = 'AMP'">
                  <xsl:text>SERIAL: </xsl:text>
                  <xsl:value-of select="@IMEI"/>
	        </xsl:when>
	        <xsl:otherwise>	                  
                <xsl:text>FLEET*ID: </xsl:text>
                <xsl:value-of select="@FID"/>
                <xsl:if test="not(string-length(@FID) = 0)">
                    <xsl:text>*</xsl:text>
                </xsl:if>
                <xsl:value-of select="@MID"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;&#9;</xsl:text>
        <xsl:text>TELEFONE: </xsl:text>
        <xsl:value-of select="@N"/>
        <xsl:text>&#9;&#9;</xsl:text>
        <xsl:text>NOME: </xsl:text>
        <xsl:value-of select="@U"/>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

    </xsl:template>


</xsl:stylesheet>

