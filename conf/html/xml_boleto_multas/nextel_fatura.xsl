<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">  <xsl:output method="html" 
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/> 
              
 
  <xsl:include href="../xml_extrato/nextel_fatura_header.xsl"/>
  <xsl:include href="../xml_telecom/nextel_boleto_bancario.xsl"/>
    <xsl:template match="/">
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
            NOTAS DE DÉBITO E MULTAS
          </xsl:with-param>
        </xsl:call-template>        <xsl:apply-templates select="INVOICE/BILL/MULTAS" />
      </body>
    </html>  </xsl:template>
  
  <xsl:template match="MULTAS">
    <xsl:call-template name="RENDER-DETALHES-MULTAS">
      <xsl:with-param name="itens" select="ITENS"/>
      <xsl:with-param name="break-page" select="false()"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(ITENS) = 1">
        <xsl:apply-templates select="ITENS/BOLETO"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ITENS">
          <xsl:call-template name="RENDER-DETALHES-MULTAS"/>
          <xsl:apply-templates select="BOLETO"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
   <xsl:template name="RENDER-DETALHES-MULTAS">
    <xsl:param name="itens" select="."/>
    
    <div class="exSecTitle" style="text-align: center; color: #000000">
      BOLETO CONSOLIDADO DE NOTAS DE DÉBITO, MULTA CONTRATUAL E MULTA DE FIDELIZAÇÃO
    </div>

    <table class="detFont" width="100%" bgcolor="{$color_lightgray}"
           style="white-space: normal; border-width: 0.2mm;
                  border-style: solid solid solid solid; margin-top: 12px">
      <col width="10.21%"/>
      <col width="18.32%" />
      <col width="18.06%" />
      <col width="12.30%" />
      <col width="17.28%" />
      <col width="12.83%" />
      <col width="11.00%" />
      <thead style="font-weight: bold">
        <tr id="detRow">
          <td id="detCell" class="exSecTitle" colspan="7"
              style="text-align: center; color: #000000;">
            Descrição do boleto consolidado de Notas de Débito, 
            Multa Contratual e Multa de Fidelização
          </td>
        </tr>
        <tr id="detRow">
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Data da Solicitação
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            N&#x00b0; do Registro de<br/>Atendimento
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Descrição
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Valor (R$)
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            IMEI/aparelho<br/>
            IMEI/SIM card
          </td>
          <td class="MedBorderRight MedBorderBottom" id="detCell">
            Fleet*ID
          </td>
          <td class="MedBorderBottom" id="detCell">
            Telefone
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
            <xsl:value-of select="@V" />
          </td>
          <td colspan="3" id="detCell">
            <!-- EM BRANCO -->
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
              <xsl:value-of select="@DS" />
            </td>
            <td class="MedBorderRight" id="detCell"
                style="padding-right: 1mm; text-align: right">
              <xsl:value-of select="@V" />
            </td>
            <td class="MedBorderRight" id="detCell">
              <xsl:choose>
                <xsl:when test="AP/@IMEI or AP/@SIM">
                  <xsl:if test="AP/@IMEI">
                    <div style="padding-bottom: 0mm; text-align: center">
                      <xsl:value-of select="AP/@IMEI" />
                    </div>
                  </xsl:if>
                  <xsl:if test="AP/@SIM">
                    <div style="padding-bottom: 0mm; text-align: center">
                      <xsl:value-of select="AP/@SIM" />
                    </div>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <div style="text-align: center">
                    <xsl:text>----------</xsl:text>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="MedBorderRight" id="detCell">
              <xsl:choose>
                <xsl:when test="AP/@FID">
                  <xsl:value-of select="AP/@FID" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>----------</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td id="detCell">
              <xsl:choose>
                <xsl:when test="AP/@TEL">
                  <xsl:value-of select="AP/@TEL" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>----------</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
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
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td class="MedBorderRight" id="detCell">
                  <!-- EM BRANCO -->
              </td>
              <td class="MedBorderRight" id="detCell">
                <xsl:choose>
                  <xsl:when test="@IMEI or @SIM">
                    <xsl:if test="@IMEI">
                      <div style="text-align: center">
                        <xsl:value-of select="@IMEI" />
                      </div>
                    </xsl:if>
                    <xsl:if test="@SIM">
                      <div style="margin: 0 0.5mm 0.5mm 0.5mm; text-align: center">
                        <xsl:value-of select="@SIM" />
                      </div>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <div style="text-align: center">
                      <xsl:text>----------</xsl:text>
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="MedBorderRight" id="detCell" style="text-align: center">
                <xsl:choose>
                  <xsl:when test="@FID">
                    <xsl:value-of select="@FID" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>----------</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td id="detCell" style="text-align: center">
                <xsl:choose>
                  <xsl:when test="@TEL">
                    <xsl:value-of select="@TEL" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>----------</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
      </tbody>
    </table>
    
  </xsl:template>
  </xsl:stylesheet>