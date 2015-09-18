<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
  <xsl:output method="html" 
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/>

    <xsl:variable name="userNameMaxLength" select="10"/>
    <xsl:variable name="date" select="concat(substring(/INVOICE/CUSTOMER/@I,7),substring(/INVOICE/CUSTOMER/@I,4,2),substring(/INVOICE/CUSTOMER/@I,1,2))"/>
    <xsl:variable name="dateFIX" select="20040901"/>

    <xsl:template match="/">
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
    </xsl:template>

    <xsl:template match="CUSTOMER">

        <xsl:param name="title">RESUMO POR EQUIPAMENTO</xsl:param>

        <link href="include/fatura.css" rel="stylesheet"/>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="48%" height="257" valign="top">
                    <table width="89%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2" height="48px" valign="bottom">
                                <img src="images/logo_black_New.gif"/>
                            </td>
                        </tr>
                        <tr valign="bottom" align="left">
                            <td colspan="2" height="15" style="line-height: 1px">
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="34" class="text0">
                                <xsl:text>NEXTEL Telecomunicações Ltda.</xsl:text>
                                <br/>
                                <xsl:if test="number($date) &gt;= number($dateFIX)">
                                    <xsl:text>Al. Santos, 2356/2364 - Cerqueira César - CEP 01418-200 - São Paulo - SP</xsl:text>
                                </xsl:if>
                                <xsl:if test="number($date) &lt; number($dateFIX)">
                                    <xsl:text>Av. Maria Coelho Aguiar, 215 - Bloco D - 6º andar - CEP 05805-900 - São Paulo - SP</xsl:text>
                                </xsl:if> 
                                <br/>
                                <xsl:text>C.N.P.J. 66.970.229/0001-67 - Insc. Estadual: 114.166.101.115</xsl:text>
                                &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                                <xsl:text>nextel.com.br</xsl:text>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="line-height: 1px">
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td colspan="2" height="110">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="10%" height="73">&#160;</td>
                                        <td width="90%" class="text1" height="73">
                                            <xsl:value-of select="@C"/><br/>
                                            <xsl:value-of select="@N"/><br/><br/>
                                            <xsl:value-of select="@A1"/><br/>
                                            <xsl:value-of select="@A2"/><br/>
                                            <xsl:value-of select="@A3"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="52%" height="257" align="right" valign="top">
                    <table width="95%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="3" height="10" style="line-height: 1px">
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" class="text4bold" height="21" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td class="text4bold" width="85%">
                                          <xsl:value-of select="$title"/>
                                        </td>
                                        <td width="15%" class="text05" align="right">Página 2</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" height="9" style="line-height: 1px">
                              <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td colspan="3" class="text2" height="213" style="padding-top: 20px">
                                <b>CLIENTE:&#160;</b><xsl:value-of select="@C"/><br/>
                                <b>IDENTIFICAÇÃO DO CLIENTE:&#160;</b><xsl:value-of select="@B"/><br/>
                                <b>DATA DE EMISSÃO:&#160;</b><xsl:value-of select="@I"/><br/>
                                <br/>
                                <b>PERÍODO DE UTILIZAÇÃO:&#160;</b>
                                <xsl:value-of select="@S"/>
                                <xsl:text> a </xsl:text>
                                <xsl:value-of select="@E"/> <br/>                              
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr valign="top" align="right">
                <td colspan="2" height="331">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="6" height="24">
                                <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000">
                                    <tr align="center">
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                        <xsl:choose>
										    <xsl:when test="DETAILS/SUBSCRIBER/CONTRACT/@TP = 'AMP'">
								                  SERIAL
									        </xsl:when>
									        <xsl:otherwise>	                  
								                FLEET * ID
								            </xsl:otherwise>
								        </xsl:choose>
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            TELEFONE
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="9%">
                                            USUÁRIO
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            MENSALIDADE (R$)
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            SERVIÇOS
                                            <br/>
                                            ADICIONAIS
                                            <br/>
                                            (R$)
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            CONEXÃO
                                            <br/>
                                            DIRETA
                                            <br/>
                                            NEXTEL
                                            <br/>
                                            (R$)
                                        </td>
                                        <td class="text1bold" colspan="2" bgcolor="#FFFFFF">
                                            CHAMADAS DE
                                            <br/>
                                            TELEFONIA (R$)
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            SERVIÇOS DE
                                            <br/>
                                            DADOS (R$)
                                        </td>
                                        <td class="text1bold" rowspan="2" bgcolor="#FFFFFF" width="10%">
                                            VALOR TOTAL
                                            <br/>
                                            (R$)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="text1bold" align="center" bgcolor="#FFFFFF" width="10%">
                                            DENTRO DA ÁREA DE
                                            <br/>
                                            REGISTRO
                                        </td>
                                        <td class="text1bold" align="center" bgcolor="#FFFFFF" width="10%">
                                            FORA DE ÁREA
                                            <br/>
                                            DE REGISTRO
                                        </td>
                                    </tr>
                                    <tr class="text1">
                                        <td width="10%" height="75" align="left" bgcolor="#FFFFFF">
                                            <p>
                                                <span class="text1">
                                                    <xsl:call-template name="FLEET-ID"/>
                                                </span>
                                            </p>
                                        </td>
                                        <td width="10%" height="75" align="left" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="TELEFONE"/></p>
                                        </td>
                                        <td width="9%" height="75" align="left" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="USUARIO"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="MENSALIDADE"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="SERVICOS-ADICIONAIS"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="CONEXAO-DIRETA"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="DENTRO-DA-AREA"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="FORA-DA-AREA"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <p><xsl:call-template name="DADOS"/></p>
                                        </td>
                                        <td width="10%" height="75" align="right" bgcolor="#FFFFFF">
                                            <xsl:call-template name="TOTAL"/>
                                        </td>
                                    </tr>
                                    <xsl:call-template name="SUBTOTAL"/>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="5%" height="12">
                                    &#160;
                                </td>
                                <td colspan="5" height="12">
                                    &#160;
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="12">
                                    &#160;
                                </td>
                            </tr>
                        </table>
                        <table border="0" bordercolor="#000000" cellspacing="0" cellpadding="0" width="100%">
                            <tr width="100%">
                                <!-- Final do resumo por equipamento -->
                                <td width="500">
                                    <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
                                    <xsl:if test="count(DETAILS/SUBSCRIBER/OTHER/OCC) &gt; 0">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="text2bold" colspan="3">
                                                    AJUSTES
                                                    <img src="images/dot_black.gif" width="100%" height="1"/>
                                                </td>
                                            </tr>  
                                            <tr>
                                                <td class="text1">DATA<img src="images/dot_black.gif" width="100%" height="1"/></td>
                                                <td class="text1" align="center">TIPO<img src="images/dot_black.gif" width="100%" height="1"/></td>
                                                <td class="text1">VALOR<img src="images/dot_black.gif" width="100%" height="1"/></td>
                                            </tr>  
                                            <!-- Para cada serviço adicional corporativo -->
                                            <xsl:for-each select="DETAILS/SUBSCRIBER/OTHER/OCC">
                                                <tr>
                                                    <td class="text1"><xsl:value-of select="@DT"/>
                                                    <img src="images/dot_black.gif" width="100%" height="1"/></td>
                                                    <td class="text1" width="100%">
                                                        &#160;&#160;
                                                        <xsl:value-of select="substring(@DS, 1, 55)"/>
                                                        <img src="images/dot_black.gif" width="100%" height="1"/>
                                                    </td>
                                                    <td class="text1" align="right">
                                                        <xsl:call-template name="VALOR-OU-ZERO">
                                                            <xsl:with-param name="value">
                                                                <xsl:value-of select="@V"/>
                                                            </xsl:with-param>
                                                        </xsl:call-template>
                                                        <img src="images/dot_black.gif" width="100%" height="1"/>
                                                    </td>
                                                </tr>  
                                            </xsl:for-each>
                                            <!-- Subtotal -->
                                            <tr>
                                                <td></td>
                                                <td class="text1" align="center" width="100%" height="1">
                                                    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                                                    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                                                    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Subtotal
                                                </td>
                                                <td class="text1" align="right">
                                                    <xsl:call-template name="VALOR-OU-ZERO">
                                                        <xsl:with-param name="value">
                                                            <xsl:value-of select="DETAILS/SUBSCRIBER/OTHER/@T"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" align="right">
                                                    <img src="images/dot_black.gif" width="45%" height="1"/>
                                                </td>
                                            </tr>
                                    </table>
                                </xsl:if>
                            </td>
                        </tr>
                        <tr valign="bottom" align="right">
                            <td width="168" class="text35bold" height="27">
                            </td>
                            <td width="168" class="text35bold" height="27" align="right">
                                TOTAL GERAL
                            </td>
                            <td width="90" class="text3" align="right" height="27">
                                <b><xsl:value-of select="SUMMARY/@T"/></b>
                            </td>
                        </tr>
                        <tr valign="bottom" align="right">
                            <td></td>
                            <td  align="right" colspan="2">
                                <img src="images/dot_black.gif" width="85%" height="1"/>
                            </td>
                        </tr>
                        <tr valign="bottom" align="right">
                            <td></td>
                            <td width="168" class="text4bold" height="43">
                                VENCIMENTO:
                            </td>
                            <td width="90" class="text3" height="43" align="right">
                                <b><xsl:value-of select="@D"/></b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="91">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr valign="bottom">
                            <td class="text2" colspan="2" height="30">
                                <br/>
                                <br/>
                                <br/>					
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="text1" colspan="2" height="42">
                                Contribuição para FUST - 1% do valor dos serviços - não repassadas as tarifas Art 9 Lei 9.998/2000
                                <br/>
                                Contribuição para o FUNTEL - 0,5% do valor dos serviços - não repassadas as tarifas Art 6 § 6° Lei 10.052/2000
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    &#160;
                </td>
            </tr>
        </table>


    </xsl:template>


    <!-- Imprime o valor passado ou 0,00 -->
    <xsl:template name="VALOR-OU-ZERO">
        <xsl:param name="value">0,00</xsl:param>
        <xsl:choose>
            <xsl:when test="starts-with($value, '-')">
                <xsl:value-of select="concat('(', substring($value, 2), ')')"/>
            </xsl:when>
            <xsl:when test="string-length($value) &gt; 0">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0,00</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="FLEET-ID">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
	        <xsl:choose>
			    <xsl:when test="@TP = 'AMP'">
	                  <xsl:value-of select="@IMEI"/>
		        </xsl:when>
		        <xsl:otherwise>	                  
	                <xsl:value-of select="@FID"/>
	                <xsl:if test="not(string-length(@FID) = 0)">
	                    <xsl:text>*</xsl:text>
	                </xsl:if>
	                <xsl:value-of select="@MID"/>
	            </xsl:otherwise>
	        </xsl:choose>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="TELEFONE">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:value-of select="@N"/>&#160;<br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="USUARIO">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            &#160;
            <xsl:value-of select="substring(@U, 1, $userNameMaxLength)"/>
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="MENSALIDADE">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@M"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="SERVICOS-ADICIONAIS">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@A"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="CONEXAO-DIRETA">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="DISPATCH/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="DENTRO-DA-AREA">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="CALLS/HOME/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="FORA-DA-AREA">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="CALLS/ROAMING/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="DADOS">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@O"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="TOTAL">
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@T"/>
                </xsl:with-param>
            </xsl:call-template>
            &#160;
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="SUBTOTAL">
        <tr>
            <td colspan="3" height="35" class="text2bold" align="right" bgcolor="#FFFFFF">
                SUBTOTAL&#160;&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@M"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@A"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@D"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/HOME/@T"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/ROAMING/@T"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" class="text2" align="right" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@O"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
            <td width="10%" height="35" align="right" class="text2bold" bgcolor="#FFFFFF">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@S"/>
                    </xsl:with-param>
                </xsl:call-template>&#160;
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>