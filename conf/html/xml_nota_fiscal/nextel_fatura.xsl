<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">  <xsl:output method="html"
              version="4.01"
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1"
              omit-xml-declaration="no"
              indent="no"
              media-type="text/html"/>   <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta name="Author" content="Auster Solutions do Brasil - www.auster.com.br" />
        <title>Nextel Telecomunicações</title>
        <link rel="stylesheet" href="css/nextel_invoice_common.css" type="text/css" />
        <link rel="stylesheet" href="css/nextel_invoice_nf.css" type="text/css" />
      </head>

      <body>
        <xsl:if test="/INVOICE/CUSTOMER/@SR='Y'">          <xsl:apply-templates select="INVOICE/BILL/TELECOM/NF" />
        </xsl:if>
      </body>
    </html>  </xsl:template>  <xsl:template match="NF">
    <table width="700px" class="nfBorderLeft" style="margin-bottom: 1mm" >
      <col width="340px" />
      <col width="100%" />
      <tbody>
        <tr>
          <td class="nfAddr" valign="top"
              style="padding-bottom: 2mm; padding-left: 2mm">
            <div style="margin-top: 1mm; margin-bottom: 1mm">
              <img src="images/nextelNew.jpg" height="35px"/>
            </div>
            <div style="font-weight: bold; margin-bottom: 2mm">
              www.nextel.com.br
            </div>
            <div>
              <xsl:choose>
                <xsl:when test="$location = 'SP'">
                  <span class="nfAddrTel">
                  Grande São Paulo: 4004-6611 - Outras Localidades:
                  0800 90 50 40 - Fax: 11 4004-1201
                  </span>
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Al. Santos, 2356 e 2364
                  <br />
                  Cerqueira César São Paulo - SP - CEP 01418-200
                  <br />
                  CNPJ 66.970.229/0001-67 - Inscr. Estadual: 114.166.101.115
                </xsl:when>
                <xsl:when test="$location = 'RJ'">
                  <span class="nfAddrTel">
                  0800 90 50 40 - FAX (0XX11)3748-1252
                  </span>
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Av. Pres. Vargas, 3.131 - 11º andar - sl. 1102 - parte
                  <br />
                  Cidade Nova - Rio de Janeiro - RJ - CEP 20210-030
                  <br />
                  CNPJ 66.970.229/0011-39 - Inscr.Estadual: 85.727.028
                </xsl:when>
                <xsl:when test="$location = 'MG'">
                  <span class="nfAddrTel">
                  Tel. (0XX31)3228-1400 - Fax: (0XX31)3228-1470
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Rua Inconfidentes, 1180
                  <br />
                  Bairro Funcionários - Belo Horizonte - MG - CEP 30140-120
                  <br />
                  CNPJ 66.970.229/0021-00 - Inscr.Estadual: 062.956.363.0199
                </xsl:when>
                <xsl:when test="$location = 'SC'">
                  <span class="nfAddrTel">
                  Central de Atendimento: *611 (ligue grátis do seu celular)
                  ou 4004-6611
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Rua Souza França, 52 - Centro
                  <br />
                  Florianópolis - SC - CEP 88.015-480
                  <br />
                  CNPJ 66.970.229/0039-30 - Inscr.Estadual: 254.971.750
                </xsl:when>
                <xsl:when test="$location = 'BSB'">
                  <span class="nfAddrTel">
                  Central de Atendimento: *611 (ligue grátis do seu celular)
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  SBN Norte Quadra 01 - Bl. B nº 14 - 13º / 14º Andares
                  <br />
                  CEP: 70040-010 - Asa Norte - Brasília - DF
                  <br />
                  CNPJ 66.970.229/0018-05 - CF/DF: 07.404.653/002-20
                </xsl:when>
                <xsl:when test="$location = 'PR'">
                  <span class="nfAddrTel">
                  Fone: (0XX41)3025-8000 - Fax: (0XX41)3025-8238
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Rua Augusto Stresser, 453
                  <br />
                  Alto da Glória - Curitiba - PR - CEP 80030-340
                  <br />
                  CNPJ 66.970.229/0017-24 - Inscr.Estadual: 90.194.059-20
                </xsl:when>
                <xsl:when test="$location = 'GO'">
                  <span class="nfAddrTel">
                  Central de Atendimento: *611 (ligue grátis do seu celular)
                  ou 4004-6611
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Av.República do Líbano, 1770 - Qd.E-2 Lt.29
                  <br />
                  Setor Oeste - Goiânia - GO - CEP 74115-030
                  <br />
                  CNPJ 66.970.229/0019-96 - Inscr.Estadual: 10.332.587-5
                </xsl:when>
                <xsl:when test="$location = 'BA'">
                  <span class="nfAddrTel">
                  Central de Atendimento ao Cliente: *611 (ligue grátis do
                  seu Nextel) ou (11)4004-6611
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Av.Antonio Carlos Magalhães, 3213 - salas 1107 a 1110 - Brotas
                  <br />
                  Salvador - Bahia - CEP 40280-000
                  <br />
                  C.N.P.J.: 66.970.229/0040-73 - Inscr.Est.: 51.338.686 NO - Inscr.Municipal:
                  157.942/001-78
                </xsl:when>
                <xsl:when test="$location = 'PE'">
                  <span class="nfAddrTel">
                  Central de Atendimento ao Cliente: *611 (Ligue Grátis do seu Nextel) ou 4004-6611
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Rua Agenor Lopes, 277 - sala 302
                  <br />
                  51021-110 - Boa Viagem - Recife - PE
                  <br />
                  C.N.P.J.: 66.970.229/0009-14 - Inscr. Estadual: 181.001.0261944-5
                </xsl:when>
                <xsl:when test="$location = 'RS'">
                  <span class="nfAddrTel">
                  Central de Atendimento ao Cliente: *611 (ligue grátis do
                  seu Nextel) ou (11)4004-6611
                  </span>
                  <br />
                  <br />
                  <span class="nfAddrNextel">Nextel Telecomunicações Ltda</span>
                  <br />
                  Av.Carlos Gomes, 413 - Auxiliadora
                  <br />
                  Porto Alegre - RS - CEP 90480-000
                  <br />
                  CNPJ 66.970.229/0006-71 - Inscr.Estadual: 096/2755109
                </xsl:when>
              </xsl:choose>
            </div>
          </td>
          <td valign="top">
            <div style="font-size: 8pt; font-weight: bold;
                        margin-top: 3mm; margin-bottom: 3mm">
              NOTA FISCAL FATURA DE TELECOMUNICAÇÕES
            </div>
            <div style="font-size: 7pt; font-weight: bold; margin-bottom: 3mm">
              <span>SERVIÇO MÓVEL ESPECIALIZADO REGIME ESPECIAL</span>
              <br/>
              <span>
                <!-- Special Rule -->
                <xsl:choose>
                  <xsl:when test="$location = 'SP'">
                    PROCESSO SF5-258118/99 de 04/04/2001 DEAT/ARE
                  </xsl:when>
                  <xsl:when test="$location = 'RJ'">
                    PROCESSO nº E-04/346.630/99 de 12/07/99
                  </xsl:when>
                  <xsl:when test="$location = 'MG'">
                    PROCESSO PTA nº 16.58152.20 de 29/07/2002
                  </xsl:when>
                  <xsl:when test="$location = 'SC'">
                    PROCESSO n° GR01 7279/051 de 15/09/2005
                  </xsl:when>
                  <xsl:when test="$location = 'BSB'">
                    ATO DECLARATÓRIO Nº 009/2004 - NUESP/GEESP/DITRI/SUREC/SEF
                  </xsl:when>
                  <xsl:when test="$location = 'PR'">
                    PROCESSO nº 2643/01 de 05/11/2001
                  </xsl:when>
                  <xsl:when test="$location = 'GO'">
                    TARE nº 235/05-GSF de 29/11/2005
                  </xsl:when>
                  <xsl:when test="$location = 'BA'">
                    PROCESSO nº 16958920054 de 21/12/2005
                  </xsl:when>
                  <xsl:when test="$location = 'PE'">
                    PROCESSO Nº 9.2005.09.147338.2
                  </xsl:when>
<!-- EHO: Novo Mercado Caxias do Sul -->
                  <xsl:when test="$location = 'RS'">
                    ATO DECLARATÓRIO DRP Nº 2007/061
                  </xsl:when>
                </xsl:choose>
              </span>

              <xsl:if test="$location = 'GO'">
                <span style="font-size: 7pt; font-weight: bold; margin-bottom: 3mm">
                  "DISPENSADO DE AIDF CONFORME DECRETO LEI 4852 ART. 123 INCISO II LETRA C"
                </span>
                <br/>
              </xsl:if>

            </div>
            <div>
              <table style="font-size: 6pt; margin-bottom: 2mm" width="100%">
                <col width="226px" />
                <col width="100%" />
                <tbody>
                  <tr>
                    <td colspan="2">
                      <xsl:text>NOTA FISCAL Nº </xsl:text>
                      <xsl:value-of select="@NR" />
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                      <xsl:text>DATA DE EMISSÃO: </xsl:text>
                      <xsl:value-of select="@DE" />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <xsl:text>DATA DE VENCIMENTO: </xsl:text>
                      <xsl:value-of select="@DV" />
                    </td>
                    <td>
                      <xsl:text>SÉRIE: </xsl:text>
                      <xsl:value-of select="@SR" />
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Customer data -->
    <table width="700px" style="margin-top: 1mm; margin-bottom: 1mm">
      <col width="484px" />
      <col width="100%" />
      <col width="197px" />
      <tbody>
        <tr valign="top">
          <td class="nfBorderRight" style="padding-left: 1mm">
            <div style="font-size: 6pt; font-weight: bold">
              <div style="margin-top: 2mm; margin-bottom: 2mm">
                <xsl:value-of select="CLIENTE/@N" />
              </div>
              <div>
                <xsl:text>ENDEREÇO: </xsl:text>
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@E" />
                </span>
              </div>
              <div>
                CEP:
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@CEP" />
                </span>
                MUNICÍPIO:
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@CI" />
                </span>
                UF:
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@ES" />
                </span>
              </div>
              <div>
                C.N.P.J/C.P.F.:
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@ID" />
                </span>
                INSCR. ESTADUAL:
                <span style="font-weight: normal">
                  <xsl:value-of select="CLIENTE/@IE" />
                </span>
              </div>
              <div style="margin-bottom: 2mm">
                CLASSE DO USUÁRIO:
                <span style="font-weight: normal">NÃO RESIDENCIAL</span>
              </div>
            </div>
          </td>

          <td/>

          <td class="nfBorderRight">
            <div style="font-size: 6pt; margin-top: 2mm; padding-left: 8mm">
              <div style="font-weight: bold">PEDIDO:</div>
              <div>
                <span style="font-weight: bold">
                CLIENTE:
                </span>
                <xsl:value-of select="CLIENTE/@NR" />
              </div>
              <div>
                <span style="font-weight: bold">
                PERÍODO DE:
                </span>
                <xsl:value-of select="@DI" />
              </div>
              <div>
                <span style="font-weight: bold">
                &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
                &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
                &#xa0;&#xa0;&#xa0;&#xa0;ATÉ:
                </span>
                <xsl:value-of select="@DF" />
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <div style="padding-left: 2mm; margin-top: 2mm; margin-bottom: 0.5mm;
                font-size: 6pt; font-weight: bold">
      ASSINATURA MENSAL / SERVIÇOS MEDIDOS / AJUSTES
    </div>

    <table width="700px" class="nfBorderLeft"
           style="font-size: 6pt; font-weight: bold">
      <col width="188px" />
      <col width="64px" />
      <col width="100%" />
      <col width="98px" />
      <tbody>
        <tr>
          <td style="vertical-align: middle; padding-left: 2mm;
                     padding-bottom: 1mm; padding-top: 0.5mm">
            DESCRIÇÃO
          </td>
          <td style="vertical-align: middle; text-align: right;
                     padding-left: 2mm; padding-bottom: 1mm;
                     padding-top: 0.5mm">
            * ALÍQUOTA
          </td>
          <td/>
          <td style="vertical-align: middle; text-align: right;
                     padding-left: 2mm; padding-bottom: 1mm;
                     ; padding-top: 0.5mm">
            VALOR TOTAL R$:
          </td>
        </tr>
        <xsl:for-each select="ITENS/IT">
          <tr>
            <td style="padding-left: 3mm">
              <xsl:value-of select="@DS" />
            </td>
            <td style="text-align: right; padding-left: 3mm">
              <xsl:value-of select="@AIC" />
              %
            </td>
            <td/>
            <td style="text-align: right; padding-left: 3mm">
              <xsl:value-of select="@V" />
            </td>
          </tr>
        </xsl:for-each>
        <tr>
          <td colspan="4"
              style="vertical-align: middle; font-size: 6pt;
                    font-weight: bold; padding-left: 2mm;
                    padding-top: 10mm; padding-bottom: 3mm">
              Reservado ao Fisco:
            <span style="font-size: 10pt; font-family: Courier;
                         margin-bottom: 2mm; padding-left: 15mm">
              <xsl:value-of select="@HC" />
            </span>
          </td>
        </tr>
      </tbody>
    </table>

    <table style="margin-top: 2mm; margin-bottom: 1mm" width="700px">
      <col width="166px" />
      <col width="15px" />
      <col width="144px" />
      <col width="15px" />
      <col width="144px" />
      <col width="100%" />
      <col width="201px" />
      <tbody style="font-size: 6pt">
        <tr>
          <td class="nfBorderRight">
            <div class="nfTotName">
              BASE DE CALCULO ICMS R$
            </div>
            <div class="nfTotValue">
              <xsl:value-of select="@BCIC" />
            </div>
          </td>
          <td/>
          <td class="nfBorderRight">
            <div class="nfTotName">
              ALIQUOTA ICMS
            </div>
            <div class="nfTotValue">
              Vide *
            </div>
          </td>
          <td/>
          <td class="nfBorderRight">
            <div class="nfTotName">
              VALOR ICMS R$
            </div>
            <div class="nfTotValue">
              <xsl:value-of select="@VIC" />
            </div>
          </td>
          <td/>
          <td class="nfBorderRight">
            <div class="nfTotName">
              VALOR TOTAL DA NOTA FISCAL
            </div>
            <div class="nfTotValue">
              <xsl:value-of select="@V" />
            </div>
          </td>
          <td/>
        </tr>
      </tbody>
    </table>

    <!-- Observations -->
    <table width="700px" class="nfBorderLeft"
           style="font-size: 6pt; margin-top: 2mm; margin-bottom: 1mm">
      <col width="100%" />
      <tbody>
        <tr>
          <td>
            <div class="nfTotName" style="padding-left: 2mm">
              OBSERVAÇÕES:
            </div>
          </td>
        </tr>
        <tr height="37px">
          <td style="vertical-align: middle; padding-left: 3mm">
            <xsl:for-each select="OBS/O">
              <div>
                <xsl:value-of select="text()" />
              </div>
            </xsl:for-each>
            <div>
              <xsl:choose>
                <xsl:when test="$location = 'SP' or $location = 'GO'">
                  2ª via emitida, conforme Art. 6º, nos termos do Regime Especial. Não gera crédito de
                  ICMS.
                </xsl:when>
                <xsl:when test="$location = 'MG'">
                  Via adicional, com todos os efeitos da via original, emitida, conforme Seção IV,
                  Art. 8º, inciso I, nos termos do Regime Especial.
                </xsl:when>
                <xsl:when test="$location = 'PR'">
                  Cópia da 1ª via, conforme cláusula Quinta, nos termos do Regime Especial. Não gera
                  direito a crédito.
                </xsl:when>
              </xsl:choose>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Messages -->
    <table width="700px"
           style="font-size: 6pt; margin-top: 2mm; margin-bottom: 10mm">
      <col width="405px" />
      <col width="100%" />
      <tbody>
        <tr>
          <td class="nfBorderRight"
              style="font-weight: bold; padding-left: 2mm; padding-top: 0.5mm;
                     border-bottom-style: none">
              MENSAGENS:
          </td>
          <td style="vertical-align: middle; padding-left: 2mm; text-align: center;
                     font-size: 27pt; font-weight: bold" rowspan="2">
              2a VIA
          </td>
        </tr>
        <tr>
          <td class="nfBorderRight"
              style="vertical-align: middle; padding-left: 3mm; border-top-style: none">
            <xsl:for-each select="MSGS/M">
              <div>
                <xsl:value-of select="text()" />
              </div>
            </xsl:for-each>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:variable name="location">
    <xsl:choose>
      <!-- Sendo de SP e não sendo do mercado 6 - Curitiba -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or
                      (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or
                      (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or
                      (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or
                      (/INVOICE/CUSTOMER/@CID = '28')">
        <xsl:text>SP</xsl:text>
      </xsl:when>
      <!-- Sendo do RJ e não sendo do mercado 4 - Belo Horizonte -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or
                      (/INVOICE/CUSTOMER/@CID = '6')">
        <xsl:text>RJ</xsl:text>
      </xsl:when>
      <!-- Sendo mercado 4 - Belo Horizonte e mercado 25 - Uberlandia-->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">
        <xsl:text>MG</xsl:text>
      </xsl:when>
      <!-- Sendo mercados 13, 22 e 23 - Santa Catarina -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or
                      (/INVOICE/CUSTOMER/@CID = '23')">
        <xsl:text>SC</xsl:text>
      </xsl:when>
      <!-- Sendo do mercado 3 - Brasília -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '3'">
        <xsl:text>BSB</xsl:text>
      </xsl:when>
      <!-- Sendo de SP e sendo do mercado 6 - Curitiba -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">
        <xsl:text>PR</xsl:text>
      </xsl:when>
      <!-- Sendo de SP e sendo do mercado 21 - Goiania -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '21'">
        <xsl:text>GO</xsl:text>
      </xsl:when>
      <!-- Sendo do mercado 19 - Salvador -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '19'">
        <xsl:text>BA</xsl:text>
      </xsl:when>
      <!-- Sendo do mercado 17 - Recife -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '17'">
        <xsl:text>PE</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable></xsl:stylesheet>