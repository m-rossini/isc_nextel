<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:xalan="http://xml.apache.org/xalan" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xalan" version="1.0">

  <xsl:template match="NEGOC">
    <fo:page-sequence master-reference="extrato-unificado" 
                      force-page-count="no-force">
      <!-- cabeçalho -->
      <fo:static-content flow-name="xsl-region-before">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">
            <xsl:text>BOLETO DE NEGOCIAÇÕES</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="printBottomBorder">true</xsl:with-param>
        </xsl:call-template>
      </fo:static-content>
      <!-- corpo -->
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="NEGOC" />
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <xsl:template name="NEGOC">
    <xsl:call-template name="RENDER-DETALHES-NEGOC">
      <xsl:with-param name="itens" select="ITENS"/>
      <xsl:with-param name="break-page" select="false()"/>
    </xsl:call-template>
    
    <xsl:choose>
      <xsl:when test="count(ITENS) = 1">
        <xsl:call-template name="RENDER-BOLETO">
          <xsl:with-param name="boleto" select="ITENS/BOLETO"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ITENS">
          <xsl:call-template name="RENDER-DETALHES-NEGOC"/>
          <xsl:call-template name="RENDER-BOLETO">
            <xsl:with-param name="boleto" select="BOLETO"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
 
  
  <xsl:template name="RENDER-DETALHES-NEGOC">
    <xsl:param name="itens" select="."/>
    <xsl:param name="break-page" select="true()"/>
    
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" color="{$detTitleFontColor}">
      <xsl:if test="$break-page">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>
      <xsl:text>BOLETO CONSOLIDADO DE NEGOCIAÇÕES</xsl:text>
    </fo:block>
    
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" space-after="0mm" color="{$detTitleFontColor}"
              border-style="solid solid none solid" border-width="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <xsl:text>Descrição do boleto consolidado</xsl:text>
    </fo:block>
    
    <fo:table xsl:use-attribute-sets="DetalhesTableRow" wrap-option="wrap"
              table-layout="fixed" width="100%"
              table-omit-footer-at-break="true" background-color="{$color_lightgray}"
              border-style="solid solid solid solid" border-width="0.2mm" 
              border-collapse="separate" padding-bottom="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <fo:table-column column-width="27mm"/>
      <fo:table-column column-width="34mm" />
      <fo:table-column column-width="37mm" />
      <fo:table-column column-width="30.5mm" />
      <fo:table-column column-width="34.5mm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header font-weight="bold" text-align="center">
        <fo:table-row height="{$detalhe_boleto_height}">
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Data do Evento</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>N&#x00b0; do Novo Título</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>N&#x00b0; do Título Original</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Valor Total (R$)</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Cond. de Pagto</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Valor a pagar (R$)</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-footer font-weight="bold" color="{$detTitleFontColor}">
        <fo:table-row background-color="{$color_darkgray}" 
                      height="{$detalhe_boleto_height}">
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                         number-columns-spanned="3" padding-top="0.5mm" 
                         padding-left="3mm" display-align="center">
            <fo:block>Total</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                         display-align="center" text-align="right" 
                         padding-right="1mm" padding-top="0.2mm" >
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell number-columns-spanned="2"
                         display-align="center" text-align="right" 
                         padding-right="1mm" padding-top="0.2mm" >
            <fo:block>
              <xsl:value-of select="@V" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-footer>
      <fo:table-body text-align="center" display-align="before">
        <xsl:for-each select="$itens/IT">
          <xsl:variable name="isWhite" select="(position() mod 2) != 0"/>
          <fo:table-row height="{$detalhe_boleto_height}">
            <xsl:if test="$isWhite">
              <xsl:attribute name="background-color">
                white
              </xsl:attribute>
            </xsl:if>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           display-align="center">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@DT" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           display-align="center">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@NR" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           display-align="center">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="AP/@IMEI" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           display-align="center"
                           padding-right="1mm" text-align="right">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@T" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           display-align="center">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="concat(@NRP,'/',@QTP)" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                           padding-right="1mm" text-align="right">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <xsl:for-each select="AP[position() &gt; 1]">
            <fo:table-row>
              <xsl:if test="$isWhite">
                <xsl:attribute name="background-color">
                  white
                </xsl:attribute>
              </xsl:if>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block>
                  <!-- EM BRANCO -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block>
                  <!-- EM BRANCO -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                  <xsl:value-of select="@IMEI" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block>
                  <!-- EM BRANCO -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block>
                  <!-- EM BRANCO -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                  <!-- EM BRANCO -->
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

</xsl:stylesheet>
