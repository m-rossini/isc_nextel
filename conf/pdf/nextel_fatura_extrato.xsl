<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                exclude-result-prefixes="xalan"
                version="1.0">


  <xsl:template match="EXTRATO">

    <fo:page-sequence master-reference="extrato-unificado"
                      initial-page-number="1"
                      force-page-count="no-force">

      <!-- cabeçalho -->
      <fo:static-content flow-name="xsl-region-before">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">EXTRATO MENSAL UNIFICADO</xsl:with-param>
          <xsl:with-param name="printBottomBorder">true</xsl:with-param>
        </xsl:call-template>
      </fo:static-content>

      <!-- corpo -->
      <fo:flow flow-name="xsl-region-body">

        <fo:block xsl:use-attribute-sets="ExtratoIntroFont">
          Caro cliente, os valores dos quadros Demonstrativo de 
          Pagamentos e Lançamentos Futuros (caso existam) são 
          meramente informativos.
        </fo:block>
        <fo:block xsl:use-attribute-sets="ExtratoIntroFont">
          Os valores a pagar da fatura do mês corrente são descritos 
          no quadro Fatura Atual.
        </fo:block>
        <xsl:apply-templates select="DEMO" />
        <!-- Mensagens -->
        <xsl:for-each select="MSGS/M[not(@IM=../../FUT/@IM)]">
          <xsl:variable name="IM" select="@IM"/>
          <xsl:for-each select="xalan:tokenize(text(),'#')">
            <fo:block xsl:use-attribute-sets="ExtratoMessagesFont">
              <xsl:if test="(position() = 1) and $IM">
                <fo:inline>(</fo:inline>
                <fo:inline><xsl:value-of select="$IM" /></fo:inline>
                <fo:inline>)&#32;</fo:inline>
              </xsl:if>
              <fo:inline>
                <xsl:value-of select="." />
              </fo:inline>
            </fo:block>
          </xsl:for-each>
        </xsl:for-each>

        <xsl:apply-templates select="FUT" />
      </fo:flow>

    </fo:page-sequence>

  </xsl:template>



  <xsl:template match="DEMO">
    <xsl:apply-templates select="BAL" />
    <xsl:apply-templates select="ATUAL" />
    <fo:table table-layout="fixed" width="100%" wrap-option="no-wrap"
              xsl:use-attribute-sets="ExtratoTotalsTable">
      <fo:table-column column-width="proportional-column-width(3)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:text>Total Geral</xsl:text>
              <xsl:if test="@IM">
                <fo:inline>&#32;(</fo:inline>
                <fo:inline><xsl:value-of select="@IM" /></fo:inline>
                <fo:inline>)</fo:inline>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>



  <xsl:template match="BAL">
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable" space-after="4mm">
      <xsl:text>DEMONSTRATIVO DE PAGAMENTOS - Histórico</xsl:text>
    </fo:block>
    <xsl:apply-templates select="DEV" />
    <xsl:apply-templates select="PGTO" />
    <fo:table table-layout="fixed" width="100%" wrap-option="no-wrap"
              xsl:use-attribute-sets="ExtratoTotalsTable">
      <fo:table-column column-width="proportional-column-width(3)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:text>Total até&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(PGTO/@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>&#32;de&#32;</xsl:text>
              <xsl:value-of select="substring(PGTO/@DT,7)" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>



  <xsl:template match="DEV">
    <fo:table table-layout="fixed" width="100%" 
              wrap-option="no-wrap" space-after="4mm">
      <fo:table-column column-width="proportional-column-width(2)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header xsl:use-attribute-sets="ExtratoTableHeaderRow">
        <fo:table-row padding-top="1mm">
          <fo:table-cell>
            <fo:block>
              <xsl:text>Informações de Saldos Anteriores - até&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>&#32;de&#32;</xsl:text>
              <xsl:value-of select="substring(@DT,7)" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>Saldo</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-footer xsl:use-attribute-sets="ExtratoTableHeaderRow">
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:text>Total Até&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>&#32;de&#32;</xsl:text>
              <xsl:value-of select="substring(@DT,7)" />
              <xsl:if test="@IM">
                <fo:inline>&#32;(</fo:inline>
                <fo:inline><xsl:value-of select="@IM" /></fo:inline>
                <fo:inline>)</fo:inline>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-footer>
      <fo:table-body xsl:use-attribute-sets="ExtratoTableRow">
        <xsl:for-each select="IT">
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:value-of select="@DS" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableEndCell">
              <fo:block>
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>



  <xsl:template match="PGTO">
    <fo:table table-layout="fixed" width="100%" 
              wrap-option="no-wrap" space-after="4mm">
      <fo:table-column column-width="proportional-column-width(2)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header xsl:use-attribute-sets="ExtratoTableHeaderRow">
        <fo:table-row padding-top="1mm">
          <fo:table-cell>
            <fo:block>
              <xsl:text>Histórico de Pagamento -&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>&#32;</xsl:text>
              <xsl:value-of select="substring(@DT,7)" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>Valores Faturados</fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>Valores Pagos</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>Saldo</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-footer xsl:use-attribute-sets="ExtratoTableHeaderRow">
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:text>Total de&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>&#32;de&#32;</xsl:text>
              <xsl:value-of select="substring(@DT,7)" />
              <xsl:if test="@IM">
                <fo:inline>&#32;(</fo:inline>
                <fo:inline><xsl:value-of select="@IM" /></fo:inline>
                <fo:inline>)</fo:inline>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell number-columns-spanned="3" 
                         xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-footer>
      <fo:table-body xsl:use-attribute-sets="ExtratoTableRow">
        <xsl:for-each select="IT">
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:value-of select="@DS" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableMiddleCell">
              <fo:block>
                <xsl:value-of select="@VF" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableMiddleCell">
              <fo:block>
                <xsl:value-of select="@VP" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableEndCell">
              <fo:block>
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>



  <xsl:template match="ATUAL">
    <fo:table table-layout="fixed" width="100%" wrap-option="no-wrap" 
              space-before="2mm" space-after="4mm">
      <fo:table-column column-width="proportional-column-width(3)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header xsl:use-attribute-sets="ExtratoTableTitleRow">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="3">
            <fo:block>FATURA ATUAL</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-footer xsl:use-attribute-sets="ExtratoTableTitleRow" 
                       background-color="black">
        <fo:table-row height="6mm">
          <fo:table-cell number-columns-spanned="2" padding-start="3mm" 
                         display-align="center">
            <fo:block>
              <xsl:text>Total da Fatura de&#32;</xsl:text>
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(GRP/@DT,4,2)" />
              </xsl:call-template>
              <xsl:if test="@IM">
                <fo:inline>&#32;(</fo:inline>
                <fo:inline><xsl:value-of select="@IM" /></fo:inline>
                <fo:inline>)</fo:inline>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell display-align="center" 
                         xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-footer>
      <fo:table-body xsl:use-attribute-sets="ExtratoTableRow" 
                     background-color="{$color_lightgray}">
        <fo:table-row height="2mm"/>
        <xsl:for-each select="GRP">
          <fo:table-row font-weight="bold">
            <fo:table-cell padding-start="3mm">
              <fo:block>
                <xsl:call-template name="MES">
                  <xsl:with-param name="mes" select="substring(@DT,4,2)" />
                </xsl:call-template>
                <xsl:text>&#32;de&#32;</xsl:text>
                <xsl:value-of select="substring(@DT,7)" />
                <xsl:text>&#32;- Vencimento em&#32;</xsl:text>
                <xsl:value-of select="@DV" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block>N&#x00b0; do Boleto</fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableEndCell">
              <fo:block>Total</fo:block>
            </fo:table-cell>
          </fo:table-row>
          <xsl:for-each select="IT">
            <fo:table-row>
              <fo:table-cell padding-start="3mm">
                <fo:block>
                  <xsl:value-of select="@DS" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right">
                <fo:block>
                  <xsl:value-of select="@NB" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="TableEndCell">
                <fo:block>
                  <xsl:value-of select="@V" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </xsl:for-each>
        <fo:table-row height="2mm"/>
      </fo:table-body>
    </fo:table>
  </xsl:template>



  <xsl:template match="FUT">
    <fo:block xsl:use-attribute-sets="ExtratoTableTitleTable"
              space-before="2mm">
      <xsl:text>LANÇAMENTOS FUTUROS - Vencimentos após&#32;</xsl:text>
      <xsl:value-of select="@DT" />
    </fo:block>
    <fo:table table-layout="fixed" width="100%" 
              wrap-option="no-wrap" space-after="1mm">
      <fo:table-column column-width="proportional-column-width(3)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-header xsl:use-attribute-sets="ExtratoTableHeaderRow"
                       font-size="8pt">
        <fo:table-row padding-top="1mm">
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>Total de Parcelas</fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>Parcelas a Vencer</fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right">
            <fo:block>Valor da Parcela</fo:block>
            <fo:block>a Vencer</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>Saldo Total</fo:block>
            <fo:block>a Vencer</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body xsl:use-attribute-sets="ExtratoTableRow"
                     font-size="8pt">
        <xsl:for-each select="IT">
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <xsl:value-of select="@DS" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableMiddleCell">
              <fo:block>
                <xsl:value-of select="@NRP" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableMiddleCell">
              <fo:block>
                <xsl:value-of select="@NRPV" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableMiddleCell">
              <fo:block>
                <xsl:value-of select="@VPV" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="TableEndCell">
              <fo:block>
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
    <fo:table table-layout="fixed" width="100%" wrap-option="no-wrap"
              xsl:use-attribute-sets="ExtratoTotalsTable"
              font-size="8pt">
      <fo:table-column column-width="proportional-column-width(3)" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:text>Total de Lançamentos Futuros</xsl:text>
              <xsl:if test="@IM">
                <fo:inline>&#32;(</fo:inline>
                <fo:inline><xsl:value-of select="@IM" /></fo:inline>
                <fo:inline>)</fo:inline>
              </xsl:if>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="TableEndCell">
            <fo:block>
              <xsl:value-of select="@T" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
    <xsl:for-each select="../MSGS/M[@IM=../../FUT/@IM]">
      <xsl:variable name="msgs" select="xalan:tokenize(text(), '#')"/>
      <fo:block xsl:use-attribute-sets="ExtratoMessagesFont">
        <fo:inline>(</fo:inline>
        <fo:inline>
          <xsl:value-of select="@IM" />
        </fo:inline>
        <fo:inline>) </fo:inline>
        <fo:inline>
          <xsl:value-of select="$msgs[position() = 1]" />
        </fo:inline>
      </fo:block>
      <xsl:for-each select="$msgs[position() &gt; 1]">
        <fo:block xsl:use-attribute-sets="ExtratoMessagesFont">
          <xsl:value-of select="." />
        </fo:block>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>



</xsl:stylesheet>
