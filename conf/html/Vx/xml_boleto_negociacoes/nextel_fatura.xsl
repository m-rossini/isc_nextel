<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">  <xsl:output method="html" 
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/> 
              
 
  <xsl:include href="../xml_extrato/nextel_fatura_header.xsl"/>
  <xsl:include href="../xml_telecom/nextel_boleto_bancario.xsl"/>  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
        <title>Nextel Telecomunicações</title>
        <link rel="stylesheet" href="css/nextel_invoice_common.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_extrato.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_boleto.css" type="text/css" />
        <script type="text/vbscript" src="barcode.vbs"/>
      </head>

      <body>
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">
            BOLETO DE NEGOCIAÇÕES
          </xsl:with-param>
        </xsl:call-template>        <xsl:apply-templates select="INVOICE/BILL/NEGOC" />
      </body>
    </html>  </xsl:template>
  
  <xsl:template match="NEGOC">
    <xsl:call-template name="RENDER-DETALHES-NEGOC">
      <xsl:with-param name="itens" select="ITENS"/>
      <xsl:with-param name="break-page" select="false()"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(ITENS) = 1">
        <xsl:apply-templates select="ITENS/BOLETO"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ITENS">
          <xsl:call-template name="RENDER-DETALHES-NEGOC"/>
          <xsl:apply-templates select="BOLETO"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
   <xsl:template name="RENDER-DETALHES-NEGOC">
    <xsl:param name="itens" select="."/>
    
    <div class="exSecTitle" style="text-align: center; color: #000000">
      BOLETO CONSOLIDADO DE NEGOCIAÇÕES
    </div>

    <table class="detFont" width="100%" bgcolor="{$color_lightgray}"
           style="white-space: normal; border-width: 0.2mm;
                  border-style: solid solid solid solid; margin-top: 12px">
      <col width="14.14%"/>
      <col width="17.80%" />
      <col width="19.37%" />
      <col width="15.97%" />
      <col width="18.06%" />
      <col width="14.66%" />
      <thead style="font-weight: bold">
        <tr id="detRow">
          <td id="detCell" class="exSecTitle" colspan="6"
              style="text-align: center; color: #000000;">
            Descrição do boleto consolidado
          </td>
        </tr>
        <tr id="detRow">
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Data do evento
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            N&#x00b0; do Novo Título
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            N&#x00b0; do Título Original
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Valor Total (R$)
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Cond. de Pagto
          </td>
          <td class="MedBorderBottom" id="detCell">
            Valor a pagar (R$)
          </td>
        </tr>
      </thead>
      <tfoot style="font-weight: bold">
        <tr id="detRow" bgcolor="{$color_darkgray}">
          <td class="MedBorderRight" colspan="3" id="detCell"
              style="vertical-align: middle; text-align: left;
                     padding-top: 0.5mm; padding-left: 3mm">
            Total
          </td>
          <td class="MedBorderRight" id="detCell"
              style="vertical-align: middle; text-align: right;
                     padding-top: 0.2mm; padding-right: 1mm">
            <xsl:value-of select="@T" />
          </td>
          <td class="MedBorderRight" id="detCell">
            <!-- EM BRANCO -->
          </td>
          <td id="detCell"
              style="vertical-align: middle; text-align: right;
                     padding-top: 0.2mm; padding-right: 1mm">
            <xsl:value-of select="@V" />
          </td>
        </tr>
      </tfoot>
      <tbody style="vertical-align: top">
        <xsl:for-each select="$itens/IT">
          <xsl:variable name="isWhite" select="(position() mod 2) != 0"/>
          <tr id="detRow">
            <xsl:if test="$isWhite">
              <xsl:attribute name="style">
                background-color: white
              </xsl:attribute>
            </xsl:if>
            <td class="MedBorderRight" id="detCell">
              <xsl:value-of select="@DT" />
            </td>
            <td class="MedBorderRight" id="detCell">
              <xsl:value-of select="@NR" />
            </td>
            <td class="MedBorderRight" id="detCell">
              <xsl:value-of select="AP/@IMEI" />
            </td>
            <td class="MedBorderRight" id="detCell"
                style="padding-right: 1mm; text-align: right">
              <xsl:value-of select="@T" />
            </td>
            <td class="MedBorderRight" id="detCell">
              <xsl:if test="@NRP &gt; 0 and @QTP &gt; 0">
                <xsl:value-of select="concat(@NRP,'/',@QTP)" />
              </xsl:if>
            </td>
            <td id="detCell"
                style="padding-right: 1mm; text-align: right">
              <xsl:value-of select="@V" />
            </td>
          </tr>
          <xsl:for-each select="AP[position() &gt; 1]">
            <tr id="detRow">
              <xsl:if test="$isWhite">
                <xsl:attribute name="style">
                  background-color: white
                </xsl:attribute>
              </xsl:if>
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td class="MedBorderRight" id="detCell"
                  style="text-align: center">
                <xsl:value-of select="@IMEI" />
              </td>
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td id="detCell">
                  <!-- EM BRANCO -->
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
      </tbody>
    </table>
    
  </xsl:template>
  </xsl:stylesheet>