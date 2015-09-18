<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Colors -->
  <xsl:variable name="color_darkgray" select="'#999999'"/>
  <xsl:variable name="color_midgray" select="'#b2b2b2'"/>
  <xsl:variable name="color_gray" select="'#cccccc'"/>
  <xsl:variable name="color_lightgray" select="'#e5e5e5'"/>

  <!-- ****************************** -->
  <!-- * O cabe�alho de cada p�gina * -->
  <!-- ****************************** -->
  <xsl:template name="HEADER">
    <xsl:param name="title"></xsl:param>
    <xsl:param name="ommitPageNumber"></xsl:param>
    <table width="100%" cellspacing="0" cellpadding="0" style="height: 13em" class="ThinBorderBottom">
      <col width="1*" />
      <col width="1*" />
      <tbody>
        <tr>

          <!-- Lado esquerdo -->
          <td valign="top">
            <p style="margin-bottom: 1.5mm">
              <img src="images/nextelNew.jpg" height="48px" />
            </p>

            <table width="90%" class="ThinBorderTop" style="padding-top: 1mm" cellspacing="0" cellpadding="0">
              <col width="100%" />
              <tbody>
                <tr>
                  <td>
                    <p style="font-size: 5pt; font-weight: normal">
                    <strong style="font-size: 6pt">NEXTEL Telecomunica��es Ltda.</strong>
                    <br/>
                    Al. Santos, 2356/2364 - Cerqueira C�sar - CEP 01418-200 - S�o Paulo - SP
                    <br />
                    C.N.P.J. 66.970.229/0001-67 - Insc. Estadual: 114.166.101.115
                    </p>

                    <!-- Endere�o do cliente -->
                    <p style="font-size: 8pt; padding-left: 10mm; margin-top: 10mm">
                      <xsl:value-of select="/INVOICE/CUSTOMER/@C" />
                      <br />
                      <xsl:value-of select="/INVOICE/CUSTOMER/@N" />
                      <br />
                      <xsl:value-of select="/INVOICE/CUSTOMER/@A1" />
                      <br />
                      <xsl:value-of select="/INVOICE/CUSTOMER/@A2" />
                      <br />
                      <xsl:value-of select="/INVOICE/CUSTOMER/@A3" />
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>

          <!-- Lado direito -->
          <td valign="top">

            <!-- T�tulo do cabe�alho -->
            <p class="ThinBorderTop ThinBorderBottom" 
               style="line-height: 6mm; padding-top: 1mm; 
                      vertical-align: middle; font-size: 12pt; font-weight: bold">
             <xsl:value-of select="$title" />
            </p>

            <!-- Dados da fatura -->
            <p style="font-size: 8pt; padding-left: 10mm; margin-top: 5mm">
              <strong>CLIENTE: </strong>
              <xsl:value-of select="/INVOICE/CUSTOMER/@C" />
              <br />
              <strong>IDENTIFICA��O DO CLIENTE: </strong>
              <xsl:value-of select="/INVOICE/CUSTOMER/@B" />
              <br />
              <strong>DATA DE EMISS�O: </strong>
              <xsl:value-of select="/INVOICE/CUSTOMER/@I" />
            </p>
            <p style="font-size: 8pt; padding-left: 10mm; margin-top: 5mm">
              <strong>PER�ODO DE UTILIZA��O: </strong>
              <xsl:value-of select="/INVOICE/CUSTOMER/@S" />
              <xsl:text> a </xsl:text>
              <xsl:value-of select="/INVOICE/CUSTOMER/@E" />
            </p>
          </td>

        </tr>
      </tbody>
    </table>

  </xsl:template>

</xsl:stylesheet>