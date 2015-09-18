<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" 
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/> 
              
              
  <xsl:include href="nextel_fatura_header.xsl"/>
              
  <xsl:template match="/">
    <xsl:apply-templates select="INVOICE/BILL/EXTRATO"/>
  </xsl:template>

  <xsl:template match="EXTRATO">
  
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br"/>
        <title>Nextel Telecomunicações</title>
        <link rel="stylesheet" href="css/nextel_invoice_common.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_extrato.css" type="text/css" />
      </head>
      
      <body>
      
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">EXTRATO MENSAL UNIFICADO</xsl:with-param>
          <xsl:with-param name="ommitPageNumber">1</xsl:with-param>
        </xsl:call-template>
      
        <p class="exIntro">
          Caro cliente, os valores dos quadros Demonstrativo de 
          Pagamentos e Lançamentos Futuros (caso existam) são 
          meramente informativos.
          <br/>
          Os valores a pagar da fatura do mês corrente são descritos 
          no quadro Fatura Atual.
        </p>

        <xsl:apply-templates select="DEMO" />

        <!-- Mensagens -->
        <xsl:for-each select="MSGS/M[not(@IM=../../FUT/@IM)]">
          <p class="exMsgs">
            <xsl:if test="@IM">
              <xsl:text>(</xsl:text>
              <xsl:value-of select="@IM" />
              <xsl:text>)&#32;</xsl:text>
            </xsl:if>
            <xsl:value-of select="translate(text(),'#',' ')" />
          </p>
          <br/>
        </xsl:for-each>
        
        <xsl:apply-templates select="FUT" />
        
      </body>
  
    </html>
  </xsl:template>
    
    
    
  <xsl:template match="DEMO">
    <xsl:apply-templates select="BAL" />
    <xsl:apply-templates select="ATUAL" />
    <table width="100%" class="MedBorderTop MedBorderBottom exTotTbl">
      <col width="3*" />
      <col width="1*" />
      <tbody>
        <tr>
          <td>
            Total Geral
            <xsl:if test="@IM">
              <xsl:text>)&#32;(</xsl:text>
              <xsl:value-of select="@IM" />
              <xsl:text>)</xsl:text>
            </xsl:if>
          </td>
          <td class="nbrAlign">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>



  <xsl:template match="BAL">
    <p class="exSecTitle" style="margin-bottom: 4mm">DEMONSTRATIVO DE PAGAMENTOS - Histórico</p>
    <xsl:apply-templates select="DEV" />
    <xsl:apply-templates select="PGTO" />
    <table width="100%" class="MedBorderTop MedBorderBottom exTotTbl">
      <col width="3*" />
      <col width="1*" />
      <tbody>
        <tr>
          <td>
            Total até
            <xsl:call-template name="MES">
              <xsl:with-param name="mes" select="substring(PGTO/@DT,4,2)" />
            </xsl:call-template>
            de
            <xsl:value-of select="substring(PGTO/@DT,7)" />
          </td>
          <td class="nbrAlign">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
  
  
  
  <xsl:template match="DEV">
    <table class="exRow" width="100%" style="margin-bottom: 4mm" cellspacing="0" cellpadding="0">
      <col width="2*" />
      <col width="1*" />
      <thead style="font-weight: bold">
        <tr style="padding-top: 1mm">
          <td>
              Informações de Saldos Anteriores - até
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              de
              <xsl:value-of select="substring(@DT,7)" />
          </td>
          <td class="nbrAlign">Saldo</td>
        </tr>
      </thead>
      <tfoot style="font-weight: bold">
        <tr>
          <td>
              Total Até
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              de
              <xsl:value-of select="substring(@DT,7)" />
              <xsl:if test="@IM">
                <xsl:text>&#32;(</xsl:text>
                <xsl:value-of select="@IM" />
                <xsl:text>)</xsl:text>
              </xsl:if>
          </td>
          <td class="nbrAlign">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tfoot>
      <tbody>
        <xsl:for-each select="IT">
          <tr>
            <td>
              <xsl:value-of select="@DS" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@V" />
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
  
  
  
  <xsl:template match="PGTO">
    <table class="exRow" width="100%" style="margin-bottom: 4mm" cellspacing="0" cellpadding="0">
      <col width="2*" />
      <col width="1*" />
      <col width="1*" />
      <col width="1*" />
      <thead style="font-weight: bold">
        <tr style="padding-top: 1mm">
          <td>
              Histórico de Pagamento -
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              <xsl:text>)&#32;</xsl:text>
              <xsl:value-of select="substring(@DT,7)" />
          </td>
          <td style="text-align: right">Valores Faturados</td>
          <td style="text-align: right">Valores Pagos</td>
          <td class="nbrAlign">Saldo</td>
        </tr>
      </thead>
      <tfoot style="font-weight: bold">
        <tr>
          <td>
              Total Até
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              de
              <xsl:value-of select="substring(@DT,7)" />
              <xsl:if test="@IM">
                <xsl:text>&#32;(</xsl:text>
                <xsl:value-of select="@IM" />
                <xsl:text>)</xsl:text>
              </xsl:if>
          </td>
          <td class="nbrAlign" colspan="3">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tfoot>
      <tbody>
        <xsl:for-each select="IT">
          <tr>
            <td>
              <xsl:value-of select="@DS" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@VF" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@VP" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@V" />
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>



  <xsl:template match="ATUAL">
    <table width="100%" style="margin-top: 2mm; margin-bottom: 4mm" cellspacing="0" cellpadding="0">
      <col width="3*" />
      <col width="1*" />
      <col width="1*" />
      <thead class="exSecTitle" style="margin: 0">
        <tr>
          <td colspan="3" style="padding-left: 1mm">
            <xsl:text>FATURA ATUAL</xsl:text>
          </td>
        </tr>
      </thead>
      <tfoot class="exSecTitle" style="margin: 0; background-color: black">
        <tr>
          <td colspan="2" style="padding-left: 3mm; vertical-align: middle">
            Total da Fatura de
            <xsl:call-template name="MES">
              <xsl:with-param name="mes" select="substring(GRP/@DT,4,2)" />
            </xsl:call-template>
            <xsl:if test="@IM">
              <xsl:text>&#32;(</xsl:text>
              <xsl:value-of select="@IM" />
              <xsl:text>)</xsl:text>
            </xsl:if>
          </td>
          <td class="nbrAlign" style="vertical-align: middle">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tfoot>
      <tbody class="exRow" style="margin: 0" bgcolor="{$color_lightgray}">
        <tr height="5mm"><td colspan="3"/></tr>
        <xsl:for-each select="GRP">
          <tr style="font-weight: bold">
            <td style="padding-left: 3mm">
              <xsl:call-template name="MES">
                <xsl:with-param name="mes" select="substring(@DT,4,2)" />
              </xsl:call-template>
              de
              <xsl:value-of select="substring(@DT,7)" />
              - Vencimento em
              <xsl:value-of select="@DV" />
            </td>
            <td style="text-align: right">N&#x00b0; do Boleto</td>
            <td class="nbrAlign">Total</td>
          </tr>
          <xsl:for-each select="IT">
            <tr>
              <td style="padding-left: 3mm">
                <xsl:value-of select="@DS" />
              </td>
              <td style="text-align: right">
                <xsl:value-of select="@NB" />
              </td>
              <td class="nbrAlign">
                <xsl:value-of select="@V" />
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
        <tr height="5mm"><td colspan="3"/></tr>
      </tbody>
    </table>
  </xsl:template>



  <xsl:template match="FUT">
    <p class="exSecTitle" style="margin-top: 2mm">
      LANÇAMENTOS FUTUROS - Vencimentos após
      <xsl:value-of select="@DT" />
    </p>
    <table class="exRow" width="100%" 
           style="font-size: 8pt; margin-bottom: 1mm"
           cellspacing="0" cellpadding="0">
      <col width="3*" />
      <col width="1*" />
      <col width="1*" />
      <col width="1*" />
      <col width="1*" />
      <thead style="font-weight:bold">
        <tr style="padding-top: 1mm">
          <td/>
          <td style="text-align: right">Total de Parcelas</td>
          <td style="text-align: right">Parcelas a Vencer</td>
          <td style="text-align: right">
            Valor da Parcela<br/>a Vencer
          </td>
          <td class="nbrAlign">Saldo Total<br/>a Vencer</td>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="IT">
          <tr>
            <td>
              <xsl:value-of select="@DS" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@NRP" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@NRPV" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@VPV" />
            </td>
            <td class="nbrAlign">
              <xsl:value-of select="@V" />
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
    
    <table width="100%" class="MedBorderTop MedBorderBottom exTotTbl">
      <col width="3*" />
      <col width="1*" />
      <tbody>
        <tr>
          <td>
            Total de Lançamentos Futuros
            <xsl:if test="@IM">
              <xsl:text> (</xsl:text>
              <xsl:value-of select="@IM" />
              <xsl:text>)</xsl:text>
            </xsl:if>
          </td>
          <td class="nbrAlign">
            <xsl:value-of select="@T" />
          </td>
        </tr>
      </tbody>
    </table>

    <xsl:for-each select="../MSGS/M[@IM=../../FUT/@IM]">
      <p class="exMsgs">
        <xsl:if test="@IM">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>) </xsl:text>
        </xsl:if>
        <xsl:value-of select="translate(text(),'#',' ')" />
      </p>
      <br />
    </xsl:for-each>
  </xsl:template>



  <!-- Substitui mês por extenso -->
  <xsl:template name="MES">
    <xsl:param name="mes" />
    <xsl:choose>
      <xsl:when test="$mes = '01'">
        <xsl:text>Janeiro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '02'">
        <xsl:text>Fevereiro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '03'">
        <xsl:text>Março</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '04'">
        <xsl:text>Abril</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '05'">
        <xsl:text>Maio</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '06'">
        <xsl:text>Junho</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '07'">
        <xsl:text>Julho</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '08'">
        <xsl:text>Agosto</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '09'">
        <xsl:text>Setembro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '10'">
        <xsl:text>Outubro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '11'">
        <xsl:text>Novembro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '12'">
        <xsl:text>Dezembro</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
