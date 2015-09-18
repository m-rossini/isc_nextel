<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:xalan="http://xml.apache.org/xalan" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xalan" version="1.0">

  <xsl:template name="INFO-COMPRAS">

    <xsl:if test="../CUSTOMER/MESSAGES/I or COMPRAS">
    
      <fo:page-sequence master-reference="extrato-unificado"
                        force-page-count="no-force">

        <!-- cabeçalho -->
        <fo:static-content flow-name="xsl-region-before">
          <xsl:call-template name="HEADER">
            <xsl:with-param name="title">
              <xsl:if test="../CUSTOMER/MESSAGES/I">
               <xsl:text>INFORMAÇÕES</xsl:text>
              </xsl:if>
              <xsl:if test="../CUSTOMER/MESSAGES/I and COMPRAS">
               <xsl:text>&#32;/&#32;</xsl:text>
              </xsl:if>
              <xsl:if test="COMPRAS">
               <xsl:text>BOLETO DE COMPRA</xsl:text>
              </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="printBottomBorder">true</xsl:with-param>
          </xsl:call-template>
        </fo:static-content>

        <!-- corpo -->
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="../CUSTOMER/MESSAGES[I]" mode="financials"/>
          <xsl:apply-templates select="COMPRAS"/>
        </fo:flow>
        
      </fo:page-sequence>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="INVOICE/CUSTOMER/MESSAGES[I]" mode="financials">
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" color="{$detTitleFontColor}">
      <xsl:text>INFORMAÇÕES IMPORTANTES</xsl:text>
    </fo:block>
    <xsl:for-each select="I">
      <xsl:for-each select="xalan:tokenize(text(),'#')">
        <fo:block xsl:use-attribute-sets="ExtratoInfoFont">
          <xsl:if test="position() = 1">
            <xsl:attribute name="font-weight">bold</xsl:attribute>
          </xsl:if>
          <xsl:if test="position() = last()">
            <xsl:attribute name="space-after">5mm</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="." />
        </fo:block>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="COMPRAS">
    <xsl:call-template name="RENDER-DETALHES-COMPRAS">
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
          <xsl:call-template name="RENDER-DETALHES-COMPRAS"/>
          <xsl:call-template name="RENDER-BOLETO">
            <xsl:with-param name="boleto" select="BOLETO"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="RENDER-DETALHES-COMPRAS">
    <xsl:param name="itens" select="."/>
    <xsl:param name="break-page" select="true()"/>
    
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" color="{$detTitleFontColor}">
      <xsl:if test="$break-page">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>
      <xsl:text>BOLETO CONSOLIDADO DE COMPRA DE EQUIPAMENTOS, ACESSÓRIOS E REPAROS</xsl:text>
    </fo:block>
    <fo:block xsl:use-attribute-sets="ExtratoIntroFont">
      Prezado cliente, esta é a relação de todas as compras de
      aparelhos, acessórios e reparos realizadas através de boleto.
      Não considera compras com cheque, cartão ou através da loja
      Virtual.
    </fo:block>
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              text-align="center" space-after="0mm" color="{$detTitleFontColor}"
              border-style="solid solid none solid" border-width="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <xsl:text>Descrição do boleto de compra de equipamentos, acessórios e reparos</xsl:text>
    </fo:block>
    
    <fo:table xsl:use-attribute-sets="DetalhesTableRow"
              table-layout="fixed" width="100%" wrap-option="wrap"
              table-omit-footer-at-break="true" background-color="{$color_lightgray}"
              border-style="solid solid solid solid" border-width="0.2mm" 
              border-collapse="separate" padding-bottom="0.2mm"
              padding-start="0.2mm" padding-end="0.2mm">
      <fo:table-column column-width="12.5mm"/>
      <fo:table-column column-width="16.5mm" />
      <fo:table-column column-width="19mm" />
      <fo:table-column column-width="15.5mm" />
      <fo:table-column column-width="16mm" />
      <fo:table-column column-width="10mm" />
      <fo:table-column column-width="15mm" />
      <fo:table-column column-width="14mm" />
      <fo:table-column column-width="14.5mm"/>
      <fo:table-column column-width="27mm" />
      <fo:table-column column-width="14mm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header font-weight="bold" text-align="center">
        <fo:table-row height="{$detalhe_boleto_height}">
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Data do evento</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>N&#x00b0; da Solicitação</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Descrição</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Quantidade</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Local</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>NF</fo:block>
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
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight
                                                 DetalhesTableBorderBottom"
                         display-align="center">
            <fo:block>Valor a pagar (R$)</fo:block>
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
                         number-columns-spanned="6" padding-top="0.5mm" 
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
          <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
            <fo:block>
              <!-- EM BRANCO -->
            </fo:block>
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
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@QT" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@LO" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@NF" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight"
                           padding-right="1mm" text-align="right">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="@T" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="DetalhesTableBorderRight">
              <fo:block xsl:use-attribute-sets="DetalhesTablePadding">
                <xsl:value-of select="concat(@NRP,'/',@QTP)" />
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
