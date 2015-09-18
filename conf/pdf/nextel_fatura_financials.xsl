<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="xalan barcode"
                version="1.0">

  <xsl:variable name="detTitleFontColor" select="'black'"/>

  <xsl:template match="BILL">
    <xsl:apply-templates select="EXTRATO" />
    <xsl:call-template name="INFO-COMPRAS" />
    <xsl:apply-templates select="MULTAS"/>
    <xsl:apply-templates select="NEGOC"/>
  </xsl:template>

  <xsl:include href="nextel_fatura_extrato.xsl" />
  <xsl:include href="nextel_fatura_nf.xsl" />
  <xsl:include href="nextel_fatura_info_compras.xsl" />
  <xsl:include href="nextel_fatura_multas.xsl" />
  <xsl:include href="nextel_fatura_negociacoes.xsl" />


  <!-- renderiza os boletos "normais"(compras, negociações e multas) -->
  <xsl:template name="RENDER-BOLETO">
    <xsl:param name="boleto" select="BOLETO"/>

    <!-- area em branco, reservada para o boleto -->
    <fo:block space-before="9.5cm" line-height="0pt">&#x00A0;</fo:block>
    <fo:block-container position="absolute"
                        top="12.6cm" bottom="22.1cm"
                        left="0cm" right="18.8cm">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row keep-together="always">
            <fo:table-cell display-align="after">
              <fo:block space-before="5mm" space-after="2mm" font-size="0pt"
                        text-align-last="justify">
                <fo:leader leader-pattern="rule" rule-style="dashed" />
              </fo:block>
              <xsl:apply-templates select="$boleto">
                <xsl:with-param name="footer_text">Ficha de Compensação</xsl:with-param>
              </xsl:apply-templates>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block-container>
  </xsl:template>


  <!-- renderiza o boleto de arrecadação -->
  <xsl:template name="RENDER-BOLETO-ARRECADACAO">
    <xsl:param name="boleto" select="BOLETO"/>

    <!-- area em branco, reservada para o boleto -->
    <fo:block-container position="absolute"
                        top="17cm" bottom="22.1cm"
                        left="0cm" right="18.8cm">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row keep-together="always">
            <fo:table-cell display-align="after">
              <fo:block space-before="5mm" space-after="2mm" font-size="0pt"
                        text-align-last="justify">
                <fo:leader leader-pattern="rule" rule-style="dashed" />
              </fo:block>
              <xsl:apply-templates select="$boleto">
                <xsl:with-param name="footer_text">Ficha de Compensação</xsl:with-param>
              </xsl:apply-templates>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block-container>
  </xsl:template>

  <!-- Boleto -->
  <xsl:template match="BOLETO">
    <xsl:param name="header_text">
      <xsl:value-of select="@LD" />
    </xsl:param>
    <xsl:param name="show_bar_code">true</xsl:param>
    <xsl:param name="footer_text" />
    <fo:table table-layout="fixed" font-family="Helvetica">
      <fo:table-column column-width="14cm" />
      <fo:table-column column-width="4.6cm" />
      <fo:table-body>
        <!-- First line: Bank info and bar code number -->
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2">
            <fo:table table-layout="fixed">
              <fo:table-column column-width="35.5mm" />
              <fo:table-column column-width="16.0mm" />
              <fo:table-column column-width="134.0mm" />
              <fo:table-body>
                <fo:table-row font-family="Courier" font-weight="bold">
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders"
                                 display-align="center">
                    <fo:block start-indent="2mm" font-size="9pt">
                      <xsl:value-of select="@NB" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders"
                                 display-align="center">
                    <fo:block text-align="center" font-size="11pt">
                      <xsl:value-of select="@CB"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell border-bottom-style="solid"
                                 display-align="center">
                    <fo:block text-align="right" font-size="11pt">
                      <xsl:value-of select="$header_text" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>

        <!-- Second row -->
        <fo:table-row height="0.6cm">
          <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Local de Pagamento</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont">
              <fo:block>
                <xsl:value-of select="@LP1" />
              </fo:block>
              <fo:block>
                <xsl:value-of select="@LP2" />
              </fo:block>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Vencimento</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <xsl:if test="@LP1 and @LP2">
                <xsl:attribute name="padding-top">1mm</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@DV" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Third row -->
        <fo:table-row height="0.6cm">
          <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Cedente/Sacador</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont">
              <xsl:value-of select="@S" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Agência Código Cedente</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <xsl:value-of select="@AC" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Fourth row -->
        <fo:table-row>
          <fo:table-cell>
            <fo:table table-layout="fixed">
              <fo:table-column column-width="3.5cm" />
              <fo:table-column column-width="3.84cm" />
              <fo:table-column column-width="1.63cm" />
              <fo:table-column column-width="1.63cm" />
              <fo:table-column column-width="3.4cm" />
              <fo:table-body>

                <fo:table-row height="0.6cm">
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Data do Documento</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@DD" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Nº do Documento</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@NRD" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Esp.Doc.</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@CE" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Aceite</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <!-- EM BRANCO -->
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Data do Movimento</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@DM" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Nosso Número</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <xsl:value-of select="@NN" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Fifth row -->
        <fo:table-row>
          <fo:table-cell>
            <fo:table table-layout="fixed">
              <fo:table-column column-width="3.5cm" />
              <fo:table-column column-width="2.66cm" />
              <fo:table-column column-width="1.76cm" />
              <fo:table-column column-width="3.64cm" />
              <fo:table-column column-width="2.44cm" />
              <fo:table-body>
                <fo:table-row height="0.6cm">
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Uso do Banco</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <!-- EM BRANCO -->
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Carteira</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@C" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Espécie</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@M" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Quantidade</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <!-- EM BRANCO -->
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Valor</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <!-- EM BRANCO -->
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(=) Valor do Documento</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <xsl:value-of select="@V" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Sixth row -->
        <fo:table-row>
          <!-- Left side -->
          <fo:table-cell number-rows-spanned="6" border-bottom-style="solid"
            border-right-style="solid" display-align="before">
            <fo:table table-layout="fixed">
              <fo:table-column column-width="13cm" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      Instruções (todas as informações deste bloqueto são de exclusiva
                      responsabilidade do Cedente)
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="2.5cm">
                  <fo:table-cell display-align="center">
                    <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="2mm">
                      <xsl:for-each select="INSTR_BANC/I">
                        <fo:block>
                          <xsl:value-of select="text()" />
                        </fo:block>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>

        <!-- Right side -->
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(-) Desconto/Abatimento</xsl:text>
            </fo:block>
 <!-- EHO: abatimento e desconto -->
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
                   <xsl:value-of select="@VDA" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(-) Outras Deduções</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <!-- EM BRANCO -->
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(+) Mora/Multa</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <!-- EM BRANCO -->
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(+) Outros Acréscimos</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <!-- EM BRANCO -->
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>(=) Valor Cobrado</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="5mm">
              <!-- EM BRANCO -->
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Seventh row -->
    <fo:block xsl:use-attribute-sets="BoletoNameFont">
      <xsl:text>Sacado</xsl:text>
    </fo:block>
    <fo:block xsl:use-attribute-sets="BoletoValueFont" start-indent="12mm">
      <fo:block>
        <xsl:value-of select="SACADO/@N" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="SACADO/@E" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="SACADO/@CEP" />
        -
        <xsl:value-of select="SACADO/@CI" />
        -
        <xsl:value-of select="SACADO/@ES" />
      </fo:block>
    </fo:block>

    <!-- Eighth row: Bar code -->
    <fo:block xsl:use-attribute-sets="BoletoNameFont">Sacador/Avalista</fo:block>
    <fo:table xsl:use-attribute-sets="BoletoNameFont" table-layout="fixed" height="13mm"
      width="18.6cm" start-indent="0mm" border-top-style="solid">
      <fo:table-column column-width="13.6cm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <xsl:if test="$show_bar_code = 'true'">
              <fo:block>
                <xsl:for-each select="barcode:drawBarCode(@CBB)/bar">
                  <xsl:if test="@color = '0' and @width = '0'">
                    <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/1.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '0' and @width = '1'">
                    <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/1.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '1' and @width = '0'">
                    <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/2.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '1' and @width = '1'">
                    <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/2.gif" />
                  </xsl:if>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="right" font-weight="bold" font-size="10pt"
              font-family="Helvetica">
              <xsl:value-of select="$footer_text" />
            </fo:block>
            <fo:block text-align="right" font-size="7pt" font-family="Helvetica">
              <xsl:text>Autenticação Mecânica</xsl:text>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>


<!-- Boleto de Arrecadação-->
  <xsl:template match="BOLETO_ARRECADACAO">
    <xsl:param name="show_bar_code">true</xsl:param>
    <fo:table table-layout="fixed" font-family="Helvetica">
      <fo:table-column column-width="18.6cm" />
      <fo:table-body>
        <!-- First row -->
        <fo:table-row>
          <fo:table-cell>
            <fo:table table-layout="fixed">
              <fo:table-column column-width="35mm" />
              <fo:table-column column-width="150.5mm" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders">
	                  <fo:block>
	                      <fo:external-graphic src="conf/pdf/nextelNew.jpg" height="10mm" width="32mm"/>
	                  </fo:block>
                  </fo:table-cell>
                  <fo:table-cell border-bottom-style="solid" display-align="center">
	                  <fo:block start-indent="6pt" text-align="left" font-size="8pt">
	                    <fo:block>
	                    <xsl:value-of select="MSGS/M3"/>
	                    </fo:block>
	                    <fo:block>
	                    <xsl:value-of select="MSGS/M4"/>
	                    </fo:block>
	                  </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>

        <!-- Second row -->
        <fo:table-row height="0.6cm">
          <fo:table-cell border-bottom-style="solid" number-columns-spanned="2" display-align="before">
            <fo:block xsl:use-attribute-sets="BoletoNameFont">
              <xsl:text>Nome do Cliente</xsl:text>
            </fo:block>
            <fo:block xsl:use-attribute-sets="BoletoValueFont">
              <fo:block>
                <xsl:value-of select="@NC" />
              </fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- third row -->
        <fo:table-row>
          <fo:table-cell>
            <fo:table table-layout="fixed">
              <fo:table-column column-width="5.0cm" />
              <fo:table-column column-width="3.55cm" />
              <fo:table-column column-width="3.55cm" />
              <fo:table-column column-width="3.55cm" />
              <fo:table-column column-width="2.9cm" />
              <fo:table-body>

                <fo:table-row height="0.6cm">
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="before">
                    <fo:block xsl:use-attribute-sets="BoletoNameFont">
                      <xsl:text>Identificação de Débito Automático</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="BoletoValueFont">
                      <xsl:value-of select="@IDDA" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="center">
                    <fo:block xsl:use-attribute-sets="CenteredBoletoNameFont">
                      <xsl:text>Mês de Referência</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="CenteredBoletoValueFont">
                      <xsl:value-of select="@MR" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="center">
                    <fo:block xsl:use-attribute-sets="CenteredBoletoNameFont">
                      <xsl:text>Data de Emissão</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="CenteredBoletoValueFont">
                      <xsl:value-of select="@DE" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="BoletoCellBorders" display-align="center">
                    <fo:block xsl:use-attribute-sets="CenteredBoletoNameFont">
                      <xsl:text>Data de Vencimento</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="CenteredBoletoValueFont">
                      <xsl:value-of select="@DV" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell border-bottom-style="solid" display-align="center">
                    <fo:block xsl:use-attribute-sets="CenteredBoletoNameFont">
                      <xsl:text>Valor</xsl:text>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="CenteredBoletoValueFont">
                      <xsl:value-of select="@V" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- fourth row: Bar code -->

    <fo:table xsl:use-attribute-sets="BoletoNameFont" table-layout="fixed" height="13mm"
      width="18.6cm" border-top-style="solid" font-family="Helvetica">
      <fo:table-column column-width="13.6cm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
      	<fo:table-row>
      		<fo:table-cell padding-top="6pt">
      			<fo:block text-align="left" font-size="8pt">
      				<xsl:value-of select="@LD" />
      			</fo:block>
      		</fo:table-cell>
	        <fo:table-cell padding-top="6pt">
	          <fo:block text-align="center" font-size="7pt">
	            <xsl:text>Autenticação Mecânica</xsl:text>
	          </fo:block>
	        </fo:table-cell>
      	</fo:table-row>
        <fo:table-row>
          <fo:table-cell padding-top="4pt" number-columns-spanned="2">
            <xsl:if test="$show_bar_code = 'true'">
              <fo:block>
                <xsl:for-each select="barcode:drawBarCodeFromEncoded(barcode:encodeForArrecadacaoBancaria(@CBB))/bar">
                  <xsl:if test="@color = '0' and @width = '0'">
                    <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/1.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '0' and @width = '1'">
                    <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/1.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '1' and @width = '0'">
                    <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/2.gif" />
                  </xsl:if>
                  <xsl:if test="@color = '1' and @width = '1'">
                    <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/2.gif" />
                  </xsl:if>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>


</xsl:stylesheet>
