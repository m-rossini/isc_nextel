<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="BOLETO">
    <xsl:param name="header_text" select="@LD"/>
    <xsl:param name="show_bar_code" select="true()"/>
    <xsl:param name="footer_text">Ficha de Compensação</xsl:param>
    
    <hr class="dashedRule"/>
    
    <table width="700px">
      <col width="527px" />
      <col width="100%" />
      <tbody>
        <!-- First line: Bank info and bar code number -->
        <tr>
          <td colspan="2">
            <table width="100%">
              <col width="134px" />
              <col width="60px" />
              <col width="100%" />
              <tbody>
                <tr valign="center" style="font-weight: bold">
                  <td class="ThinBorderRight ThinBorderBottom" 
                      style="font-family: Monospace; font-size: 9pt; padding-left: 2mm">
                    <xsl:value-of select="@NB" />
                  </td>
                  <td class="ThinBorderRight ThinBorderBottom" 
                      style="font-family: Monospace; font-size: 11pt; text-align: center">
                    <xsl:value-of select="@CB"/>
                  </td>
                  <td class="ThinBorderBottom" 
                      style="font-family: Monospace; font-size: 11pt; text-align: right">
                    <xsl:value-of select="$header_text" />
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>

        <!-- Second row -->
        <tr id="bolRow">
          <xsl:if test="not(@LP1) or not(@LP2)">
            <xsl:attribute name="class">bolRowHeight</xsl:attribute>
          </xsl:if>
          <td class="ThinBorderRight ThinBorderBottom">
            <div class="bolName">
              Local de Pagamento
            </div>
            <div class="bolValue">
              <div>
                <xsl:value-of select="@LP1" />
              </div>
              <div>
                <xsl:value-of select="@LP2" />
              </div>
            </div>
          </td>
          <td class="ThinBorderBottom">
            <div class="bolName">
              Vencimento
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <xsl:attribute name="style">
                padding-left: 5mm;
                <xsl:if test="@LP1 and @LP2">
                  padding-top: 6px;
                </xsl:if>
              </xsl:attribute>
              <xsl:value-of select="@DV" />
            </div>
          </td>
        </tr>

        <!-- Third row -->
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderRight ThinBorderBottom">
            <div class="bolName">
              Cedente/Sacador
            </div>
            <div class="bolValue">
              <xsl:value-of select="@S" />
            </div>
          </td>
          <td class="ThinBorderBottom">
            <div class="bolName">
              Agência Código Cedente
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <xsl:value-of select="@AC" />
            </div>
          </td>
        </tr>

        <!-- Fourth row -->
        <tr id="bolRow">
          <td class="ThinBorderRight ThinBorderBottom">
            <table width="100%">
              <col width="132px" />
              <col width="145px" />
              <col width="61px" />
              <col width="61px" />
              <col width="100%" />
              <tbody>
                <tr class="bolRowHeight" id="bolRow">
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Data do Documento
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@DD" />
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Nº do Documento
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@NRD" />
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Esp.Doc.
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@CE" />
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Aceite
                    </div>
                    <div class="bolValue">
                      <!-- EM BRANCO -->
                    </div>
                  </td>
                  <td>
                    <div class="bolName">
                      Data do Movimento
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@DM" />
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
          <td class="ThinBorderBottom">
            <div class="bolName">
              Nosso Número
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <xsl:value-of select="@NN" />
            </div>
          </td>
        </tr>

        <!-- Fifth row -->
        <tr id="bolRow">
          <td class="ThinBorderRight ThinBorderBottom">
            <table width="100%">
              <col width="132px" />
              <col width="100px" />
              <col width="66px" />
              <col width="137px" />
              <col width="100%" />
              <tbody>
                <tr class="bolRowHeight" id="bolRow">
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Uso do Banco
                    </div>
                    <div class="bolValue">
                      <!-- EM BRANCO -->
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Carteira
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@C" />
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Espécie
                    </div>
                    <div class="bolValue">
                      <xsl:value-of select="@M" />
                    </div>
                  </td>
                  <td class="ThinBorderRight">
                    <div class="bolName">
                      Quantidade
                    </div>
                    <div class="bolValue">
                      <!-- EM BRANCO -->
                    </div>
                  </td>
                  <td>
                    <div class="bolName">
                      Valor
                    </div>
                    <div class="bolValue">
                      <!-- EM BRANCO -->
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
          <td class="ThinBorderBottom">
            <div class="bolName">
              (=) Valor do Documento
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <xsl:value-of select="@V" />
            </div>
          </td>
        </tr>

        <!-- Sixth row -->
        <tr>
          <!-- Left side -->
          <td rowspan="6" class="ThinBorderRight ThinBorderBottom">
            <table width="100%">
              <col width="100%" />
              <tbody>
                <tr id="bolRow">
                  <td>
                    <div class="bolName">
                      Instruções (todas as informações deste bloqueto são de exclusiva
                      responsabilidade do Cedente)
                    </div>
                  </td>
                </tr>
                <tr height="94px" id="bolRow" style="vertical-align: middle">
                  <td>
                    <div class="bolValue" style="padding-left: 2mm">
                      <xsl:for-each select="INSTR_BANC/I">
                        <div>
                          <xsl:value-of select="text()" />
                        </div>
                      </xsl:for-each>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>

        <!-- Right side -->
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderBottom">
            <div class="bolName">
              (-) Desconto/Abatimento
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <!-- EM BRANCO -->
            </div>
          </td>
        </tr>
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderBottom">
            <div class="bolName">
              (-) Outras Deduções
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <!-- EM BRANCO -->
            </div>
          </td>
        </tr>
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderBottom">
            <div class="bolName">
              (+) Mora/Multa
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <!-- EM BRANCO -->
            </div>
          </td>
        </tr>
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderBottom">
            <div class="bolName">
              (+) Outros Acréscimos
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <!-- EM BRANCO -->
            </div>
          </td>
        </tr>
        <tr class="bolRowHeight" id="bolRow">
          <td class="ThinBorderBottom">
            <div class="bolName">
              (=) Valor Cobrado
            </div>
            <div class="bolValue" style="padding-left: 5mm">
              <!-- EM BRANCO -->
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Seventh row -->
    <div class="bolName">Sacado</div>
    <div class="bolValue" style="padding-left: 12mm">
      <div>
        <xsl:value-of select="SACADO/@N" />
      </div>
      <div>
        <xsl:value-of select="SACADO/@E" />
      </div>
      <div>
        <xsl:value-of select="SACADO/@CEP" />
        -
        <xsl:value-of select="SACADO/@CI" />
        -
        <xsl:value-of select="SACADO/@ES" />
      </div>
    </div>

    <!-- Eighth row: Bar code -->
    <div class="bolName ThinBorderBottom" 
         style="padding-bottom: 0.5mm; width: 700px">
      Sacador/Avalista
    </div>

    <table class="bolName ThinBorderTop" width="700px" height="49px">
      <col width="513px" />
      <col width="100%" />
      <tbody>
        <tr>
          <td>
            <xsl:if test="$show_bar_code">
              <div>
                <script type="text/vbscript">
                  document.write(WBarCode("<xsl:value-of select="@CBB"/>"))
                </script>
              </div>
            </xsl:if>
          </td>
          <td>
            <div
              style="padding-left: 2mm; text-align: right; 
                          font-weight: bold; font-size: 10pt">
              <xsl:value-of select="$footer_text" />
            </div>
            <div style="text-align: right; font-size: 7pt">Autenticação Mecânica</div>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
  
</xsl:stylesheet>