<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:xalan="http://xml.apache.org/xalan" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xalan" version="1.0">

  <xsl:template match="MULTAS">
    <fo:page-sequence master-reference="extrato-unificado" 
                      force-page-count="no-force">
      <!-- cabeçalho -->
      <fo:static-content flow-name="xsl-region-before">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">
            <xsl:text>NOTAS DE DÉBITO E MULTAS</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="printBottomBorder">true</xsl:with-param>
        </xsl:call-template>
      </fo:static-content>
      <!-- corpo -->
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="MULTAS" />
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <xsl:template name="MULTAS">
    <xsl:call-template name="RENDER-DETALHES-MULTAS">
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
          <xsl:call-template name="RENDER-DETALHES-MULTAS"/>
          <xsl:call-template name="RENDER-BOLETO">
            <xsl:with-param name="boleto" select="BOLETO"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
 
  
  <xsl:template name="RENDER-DETALHES-MULTAS">
    <xsl:param name="itens" select="."/>
    <xsl:param name="break-page" select="true()"/>
    
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" color="{$detTitleFontColor}">
      <xsl:if test="$break-page">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>
      <xsl:text>BOLETO CONSOLIDADO DE NOTAS DE DÉBITO, MULTA CONTRATUAL E MULTA DE FIDELIZAÇÃO</xsl:text>
    </fo:block>
    
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" space-after="0mm" color="{$detTitleFontColor}"
              border-style="solid solid none solid" border-width="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <xsl:text>
        Descrição do boleto consolidado de Notas de Débito, 
        Multa Contratual e Multa de Fidelização
      </xsl:text>
    </fo:block>
    
    <fo:table xsl:use-attribute-sets="DetalhesTableRow" wrap-option="wrap"
              table-layout="fixed" width="100%"
              table-omit-footer-at-break="true" background-color="{$color_lightgray}"
              border-style="solid solid solid solid" border-width="0.2mm" 
              border-collapse="separate" padding-bottom="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <fo:table-column column-width="19.5mm"/>
      <fo:table-column column-width="35mm" />
      <fo:table-column column-width="37.5mm" />
      <fo:table-column column-width="23.5mm" />
      <fo:table-column column-width="33mm" />
      <fo:table-column column-width="24.5mm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header font-weight="bold" text-align="center">
        <fo:table-row height="{$detalhe_boleto_height}">
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Data da Solicitação</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>N&#x00b0; do Registro de</fo:block>
            <fo:block>Atendimento</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Descrição</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Valor (R$)</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>IMEI/aparelho</fo:block>
            <fo:block>IMEI/SIM card</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Fleet*ID</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Telefone</fo:block>
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
              <xsl:value-of select="@V" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell number-columns-spanned="3">
            <fo:block>
              <!-- EM BRANCO -->
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
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@DT" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@NR" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@DS" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           padding-right="1mm" text-align="right">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <xsl:choose>
                <xsl:when test="AP/@IMEI or AP/@SIM">
                  <xsl:if test="AP/@IMEI">
                    <fo:block xsl:use-attribute-sets="DetalhesTablePadding" 
                              padding-bottom="0mm">
                      <xsl:value-of select="AP/@IMEI" />
                    </fo:block>
                  </xsl:if>
                  <xsl:if test="AP/@SIM">
                    <fo:block xsl:use-attribute-sets="DetalhesTablePadding" 
                              padding-top="0mm">
                      <xsl:value-of select="AP/@SIM" />
                    </fo:block>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                    <xsl:text>----------</xsl:text>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:choose>
                  <xsl:when test="AP/@FID">
                    <xsl:value-of select="AP/@FID" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>----------</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:choose>
                  <xsl:when test="AP/@TEL">
                    <xsl:value-of select="AP/@TEL" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>----------</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
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
                <xsl:choose>
                  <xsl:when test="@IMEI or @SIM">
                    <xsl:if test="@IMEI">
                      <fo:block xsl:use-attribute-sets="DetalhesTablePadding" 
                                padding-bottom="0mm">
                        <xsl:value-of select="@IMEI" />
                      </fo:block>
                    </xsl:if>
                    <xsl:if test="@SIM">
                      <fo:block xsl:use-attribute-sets="DetalhesTablePadding" 
                                padding-top="0mm">
                        <xsl:value-of select="@SIM" />
                      </fo:block>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                      <xsl:text>----------</xsl:text>
                    </fo:block>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
                <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                  <xsl:choose>
                    <xsl:when test="@FID">
                      <xsl:value-of select="@FID" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>----------</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                  <xsl:choose>
                    <xsl:when test="@TEL">
                      <xsl:value-of select="@TEL" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>----------</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

</xsl:stylesheet>
