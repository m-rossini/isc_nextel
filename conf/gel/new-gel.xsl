<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt" 
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
  xmlns:req="xalan://br.com.auster.dware.graph.Request"
  xmlns:map="xalan://java.util.Map"
  extension-element-prefixes="xalan number" 
  exclude-result-prefixes="lxslt xalan number req map"
  version="1.0">

  <xsl:output method="xml" encoding="ISO-8859-1" />
  
  <xsl:param name="req:request"/>

  <xsl:include href="new-gel-extrato.xsl" />
  <xsl:include href="new-gel-boleto.xsl" />
  <xsl:include href="new-gel-telecom.xsl" />  
  <xsl:include href="new-gel-descricao-boleto.xsl" />
  <xsl:include href="new-gel-boleto-arrecadacao.xsl" />

  <xsl:decimal-format decimal-separator="," grouping-separator="." />
  
  <xsl:variable name="tp-telecom" select="'10'"/>
  <xsl:variable name="tp-compras" select="'20'"/>
  <xsl:variable name="tp-multas" select="'30'"/>
  <xsl:variable name="tp-negociacoes" select="'40'"/>
  
  <xsl:preserve-space elements="M I O"/>

 
  <xsl:template match="/GEL/BILL">

    <xsl:variable name="requestAtts" select="req:getAttributes($req:request)"/>
    <xsl:variable name="processGelFlag" select="map:get($requestAtts, 'processGel')"/>
    
    <xsl:if test="$processGelFlag and ($processGelFlag = 'S')">

      <BILL>
  
        <!-- Extrato Mensal Unificado -->
        <xsl:call-template name="EXTRATO" />
        
        <!-- Nota-Fiscal e Boleto de Telecomunicações -->
        <xsl:call-template name="TELECOM" />
        
        <!-- Descrição e Boleto de Compra de Equipamentos -->
        <xsl:if test="BOLETO[@TP=$tp-compras]">
          <COMPRAS>
            <xsl:call-template name="DESCRICAO-BOLETO">
              <xsl:with-param name="tp" select="$tp-compras"/>
            </xsl:call-template>
          </COMPRAS>
        </xsl:if>
        
        <!-- Descrição e Boleto de Notas de Débito e Multas -->
        <xsl:if test="BOLETO[@TP=$tp-multas]">
          <MULTAS>
            <xsl:call-template name="DESCRICAO-BOLETO">
              <xsl:with-param name="tp" select="$tp-multas"/>
            </xsl:call-template>
          </MULTAS>
        </xsl:if>
        
        <!-- Descrição e Boleto de Negociações -->
        <xsl:if test="BOLETO[@TP=$tp-negociacoes]">
          <NEGOC>
            <xsl:call-template name="DESCRICAO-BOLETO">
              <xsl:with-param name="tp" select="$tp-negociacoes"/>
            </xsl:call-template>
          </NEGOC>
        </xsl:if>
      
      </BILL>
    </xsl:if>

  </xsl:template>

  <xsl:template name="decimalFormat">
    <xsl:param name="value" />
    <xsl:value-of select="format-number(number:round($value, 2), '#.##0,00')" />
  </xsl:template>
  
  <xsl:template name="quantityFormat">
    <xsl:param name="value" />
    <xsl:value-of select="format-number($value, '#.##0')" />
  </xsl:template>
  
  <xsl:template name="buildNumber">
    <xsl:param name="integer" />
    <xsl:param name="decimal" />
    <xsl:choose>
      <xsl:when test="$integer &lt; 0">
        <xsl:value-of select="$integer - ($decimal div 100)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$integer + ($decimal div 100)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
