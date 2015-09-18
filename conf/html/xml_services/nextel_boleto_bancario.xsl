<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="BOLETO_SERVICES">
  <tr>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td><img src="images/spacer.gif" width="34" height="1"/></td>
    <td><img src="images/spacer.gif" width="65" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="3" height="1"/></td>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td><img src="images/spacer.gif" width="4" height="1"/></td>
    <td><img src="images/spacer.gif" width="10" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="29" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="16" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="11" height="1"/></td>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td><img src="images/spacer.gif" width="4" height="1"/></td>
    <td><img src="images/spacer.gif" width="10" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="46" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="30" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="24" height="1"/></td>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td><img src="images/spacer.gif" width="4" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="40" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
    <td><img src="images/spacer.gif" width="36" height="1"/></td>
    <td><img src="images/spacer.gif" width="3" height="1"/></td>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td><img src="images/spacer.gif" width="7" height="1"/></td>
    <td><img src="images/spacer.gif" width="93" height="1"/></td>
    <td><img src="images/spacer.gif" width="60" height="1"/></td>
    <td><img src="images/spacer.gif" width="5" height="1"/></td>
    <td></td>
  </tr>
  <tr>
    <td colspan="5" height="16" valign="bottom">
      <table width="140" border="0" cellspacing="0" cellpadding="0" height="21">
        <tr>
        	<td align="left" valign="bottom" class="Logo_Bradesco" height="13">
				<img src="images/spacer.gif" width="5" height="1"/>
				<xsl:value-of select="FIRST/@NB"/></td>
        </tr>
      </table>
    </td>
    <td height="16" align="left" valign="bottom"> <img src="images/Nextel_02.gif" width="1" height="21"/></td>
    <td colspan="4" height="16" valign="bottom">
      <table width="48" border="0" cellspacing="0" cellpadding="0" height="21">
        <tr>
          <td align="center"></td>
        </tr>
        <tr>
          <td align="center" class="Font_12_red" height="3"><xsl:value-of select="substring(FIRST/@CBDV,1,3)"/>-<xsl:value-of select="substring(FIRST/@CBDV, 4, 1)"/></td>
        </tr>
      </table>
    </td>
    <td height="16" valign="bottom"> <img src="images/Nextel_02.gif" width="1" height="21"/></td>
    <td colspan="26" height="16" valign="bottom">
      <table width="470" border="0" cellspacing="0" cellpadding="0" height="21">
        <tr>
          <td align="left" valign="bottom" class="Font_12_red"><img src="images/spacer.gif" width="1" height="1"/><xsl:value-of select="SECOND/@LD"/></td>
        </tr>
      </table>
    </td>
    <td colspan="2" rowspan="36">
      <table width="65" border="0" cellspacing="0" cellpadding="0" height="279">
        <tr>
          <td height="281"><img src="images/spacer.gif" border="0" width="4" height="1"/></td>
        </tr>
      </table>
    </td>
    <td height="16"> <img src="images/spacer.gif" width="1" height="21"/></td>
  </tr>
  <tr>
    <td colspan="37"> <img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="31" rowspan="2">
      <table width="413" border="0" cellspacing="0" cellpadding="0" height="20">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Local de Pagamento</td>
        </tr>
        <tr>
          <td align="left" valign="middle" class="Font_08">
		<img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="FIRST/@LP1"/><br/>
		<img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="FIRST/@LP2"/>
	  </td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="28" valign="top"/></td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>Vencimento</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="13" >
        <tr>
          <td align="left" valign="middle" class="Fonte_08_light"><img src="images/spacer.gif" border="0" width="44" height="1"/><xsl:value-of select="SECOND/@DV"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="13"/></td>
  </tr>
  <tr>
    <td colspan="37"> <img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="31">
      <table width="413" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Cedente/Sacador </td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>Agência Código Cedente </td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="31">
      <table width="413" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="FIRST/@RSE"/></td>
        </tr>
      </table>
    </td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="11" >
        <tr>
          <td align="left" class="Fonte_08_light" valign="middle"><img src="images/spacer.gif" border="0" width="44" height="1"/><xsl:value-of select="FIRST/@AC"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="11"/></td>
  </tr>
  <tr>
    <td colspan="37"> <img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="3">
      <table width="104" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="4" height="1"/>Data do Documento </td>
        </tr>
      </table>
    </td>
    <td rowspan="2"><img src="images/Nextel_20.gif" width="1" height="20" valign="top"/></td>
    <td colspan="10">
      <table width="107" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="4" height="1"/>N° do Documento</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="6">
      <table width="47" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="4" height="1"/>Esp. Doc.</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td>
      <table width="46" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Aceite</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="7">
      <table width="105" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Data do Movimento</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>Nosso Número</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="3" height="2">
      <table width="104" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="SECOND/@DE"/></td>
        </tr>
      </table>
    </td>
    <td colspan="10" height="2">
      <table width="107" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle"><img src="images/spacer.gif" border="0" width="4" height="1"/><xsl:value-of select="SECOND/@ND"/></td>
        </tr>
      </table>
    </td>
    <td colspan="6" height="2">
      <table width="47" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="SECOND/@CED"/></td>
        </tr>
      </table>
    </td>
    <td height="2">
      <table width="46" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle"><img src="images/spacer.gif" border="0" width="4" height="1"/><xsl:value-of select="SECOND/@CGP"/></td>
        </tr>
      </table>
    </td>
    <td colspan="7" height="2">
      <table width="105" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle"><img src="images/spacer.gif" border="0" width="4" height="1"/><xsl:value-of select="FIRST/@DP"/></td>
        </tr>
      </table>
    </td>
    <td colspan="5" height="2">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="11" >
        <tr>
          <td align="left" valign="middle" class="Fonte_08_light"><img src="images/spacer.gif" border="0" width="44" height="1"/><!--xsl:value-of select="FIRST/@C"/--><xsl:value-of select="SECOND/@NN"/></td>
        </tr>
      </table>
    </td>
    <td height="2"> <img src="images/spacer.gif" width="1" height="11"/></td>
  </tr>
  <tr>
    <td colspan="37"> <img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="3">
      <table width="104" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Uso do Banco</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="8">
      <table width="77" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Carteira </td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/><img src="images/spacer.gif" border="0" width="8" height="1"/></td>
    <td colspan="3">
      <table width="46" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Espécie</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="8">
      <table width="108" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Quantidade </td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="5">
      <table width="74" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/>Valor</td>
        </tr>
      </table>
    </td>
    <td rowspan="2"> <img src="images/Nextel_40.gif" width="1" height="20" valign="top"/></td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>(=) Valor do Documento</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="3">
      <table width="104" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"></td>
        </tr>
      </table>
    </td>
    <td colspan="8">
      <table width="77" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/><xsl:value-of select="FIRST/@C"/></td>
        </tr>
      </table>
    </td>
    <td colspan="3">
      <table width="46" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="10" height="1"/><xsl:value-of select="FIRST/@DM"/></td>
        </tr>
      </table>
    </td>
    <td colspan="8">
      <table width="108" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/></td>
        </tr>
      </table>
    </td>
    <td colspan="5">
      <table width="74" border="0" cellspacing="0" cellpadding="0" height="11">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="8" height="1"/></td>
        </tr>
      </table>
    </td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="11" class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Fonte_08_light"><img src="images/spacer.gif" border="0" width="44" height="1"/><xsl:value-of select="SECOND/VO/@INT"/>,<xsl:value-of select="SECOND/VO/@DEC"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="11"/></td>
  </tr>
  <tr>
    <td colspan="37"> <img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="31" height="2">
      <table width="413" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top">
          <img src="images/spacer.gif" border="0" width="4" height="1"/>
          Instruções (Todas as informações deste bloqueto são de exclusiva responsabilidade do cedente)</td>
        </tr>
      </table>
    </td>
    <td rowspan="14"><img src="images/Nextel_57.gif" width="1" height="100"/></td>
    <td colspan="5" height="2">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>(-)Desconto/Abatimento</td>
        </tr>
      </table>
    </td>
    <td height="2"> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="31" rowspan="13" align="left" valign="top">
      <table width="413" border="0" cellspacing="0" cellpadding="0" >
        <tr>
          <td height="78" align="left" valign="top" class="Font_08">
            <img src="images/spacer.gif" border="0" width="5" height="1"/><xsl:value-of select="SECOND/@IB1"/><br/>
            <img src="images/spacer.gif" border="0" width="5" height="1"/><xsl:value-of select="SECOND/@IB2"/><br/>
            <img src="images/spacer.gif" border="0" width="5" height="1"/><xsl:value-of select="SECOND/@IB3"/><br/>
          </td>
        </tr>
      </table>
    </td>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0"  class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="48" height="6"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="5"><img src="images/Nextel_60.gif" width="139" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="1" height="1"/>(-) Outras Deduções</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="48" height="6"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="5"><img src="images/Nextel_60.gif" width="139" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="8">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="1" height="1"/>(+) Mora/Multa</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="48" height="6"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="5"><img src="images/Nextel_60.gif" width="139" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="1" height="1"/>(+) Outros Acréscimos</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="48" height="6"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="5"><img src="images/Nextel_60.gif" width="139" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="1" height="1"/>(=) Valor Cobrado</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="7"/></td>
  </tr>
  <tr>
    <td colspan="5">
      <table width="144" border="0" cellspacing="0" cellpadding="0" class="Font_08">
        <tr>
          <td align="left" valign="middle" class="Font_08"><img src="images/spacer.gif" border="0" width="48" height="6"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="37"><img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td colspan="2">
      <table width="39" border="0" cellspacing="0" cellpadding="0" height="7">
        <tr>
          <td align="left" valign="top">Sacado</td>
        </tr>
      </table>
    </td>
    <td colspan="31" rowspan="4" align="left" valign="top">
      <table width="411" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="43" align="left" valign="middle" class="Font_08"><b><xsl:value-of select="SECOND/@NE"/>
            <br/>
            <xsl:value-of select="SECOND/@E"/>
            <br/>
            <xsl:value-of select="SECOND/@CEP"/> - <xsl:value-of select="SECOND/@CI"/> - <xsl:value-of select="SECOND/@ES"/></b></td>
        </tr>
      </table>
    </td>
    <td colspan="4" rowspan="2">
      <table width="108" border="0" cellspacing="0" cellpadding="0" height="33">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="4" height="1"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="9"/></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="2">
      <table width="39" border="0" cellspacing="0" cellpadding="0" height="26">
        <tr>
          <td><img src="images/spacer.gif" border="0" width="4" height="1"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="24"/></td>
  </tr>
  <tr>
    <td colspan="4" rowspan="2">
      <table width="108" border="0" cellspacing="0" cellpadding="0" height="10">
        <tr>
          <td align="left" valign="top"><img src="images/spacer.gif" border="0" width="4" height="1"/></td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="2"/></td>
  </tr>
  <tr>
    <td colspan="2">
      <table width="39" border="0" cellspacing="0" cellpadding="0" height="8">
        <tr>
          <td align="left" valign="top">Sacador/Avalista</td>
        </tr>
      </table>
    </td>
    <td> <img src="images/spacer.gif" width="1" height="8"/></td>
  </tr>
  <tr>
    <td colspan="37"><img src="images/Nextel_07.gif" width="652" height="1"/></td>
    <td> <img src="images/spacer.gif" width="1" height="8"/></td>
  </tr>
    </xsl:template>

</xsl:stylesheet>