<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">

    <!-- ****************************** -->
    <!-- * O cabeçalho de cada cliente * -->
    <!-- ****************************** -->
    <xsl:template name="HEADER">
        <xsl:param name="key"/>
        <xsl:value-of select="$key"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@C)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@B"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@M"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@I"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="/INVOICE/CUSTOMER/@D"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@N)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A1)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A2)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A3)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- campos para encarte seletivo -->
        <xsl:text>0</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>0</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>0</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>0</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>0</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
          <xsl:when test="/INVOICE/CUSTOMER/@SR = 'Y'">
            <xsl:text>S</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>N</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- Fatura Braille -->
        <xsl:choose>
          <xsl:when test="/INVOICE/CUSTOMER/@BM = '5'">
            <xsl:text>S</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>N</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        
        <!-- Identificação de Débito Automático -->
<!-- IMPROVE THIS WAY TO GET THE GEL INFO -->        
        <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/@IDDA"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>
        
    </xsl:template>


    <!-- ******************************* -->
    <!-- * Mostra os dados do contrato * -->
    <!-- ******************************* -->
    <xsl:template name="HEADER-DETALHE">
        <xsl:param name="key"/>
        <xsl:value-of select="$key"/>
        <xsl:choose>
		    <xsl:when test="@TP = 'AMP'">
                  <xsl:value-of select="@IMEI"/>
	        </xsl:when>
	        <xsl:otherwise>	                  
                <xsl:value-of select="@FID"/>
                <xsl:if test="not(string-length(@FID) = 0)">
                    <xsl:text>*</xsl:text>
                </xsl:if>
                <xsl:value-of select="@MID"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="HIFENIZAR">
            <xsl:with-param name="number">
                <xsl:value-of select="@N"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="substring(@U, 1, $userNameMaxLength)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@ID"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>
    </xsl:template>

</xsl:stylesheet>