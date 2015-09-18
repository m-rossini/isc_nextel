<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:variable name="date" select="concat(substring(/INVOICE/CUSTOMER/@I,7),substring(/INVOICE/CUSTOMER/@I,4,2),substring(/INVOICE/CUSTOMER/@I,1,2))"/>
    <xsl:variable name="dateFIX" select="20040901"/>

    <xsl:template match="CUSTOMER">
        <xsl:param name="title">FATURA DE SERVIÇOS DE TELECOMUNICAÇÕES</xsl:param>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="48%" height="257" valign="top">
                    <table width="89%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="10%">&#160;</td>
                            <td colspan="2" height="48px" valign="bottom">
                                <img src="images/logo_black_New.gif"/>
                            </td>
                        </tr>
                        <tr valign="bottom" align="left">
                            <td width="10%">&#160;</td>
                            <td colspan="2" height="15" style="line-height: 1px">
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr>
                            <td width="10%">&#160;</td>
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
                            <td width="10%">&#160;</td>
                            <td colspan="2" style="line-height: 1px">
                                <img src="images/dot_black.gif" width="100%" height="1"/>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="10%">&#160;</td>
                            <td colspan="2" height="110">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="10%" height="73">&#160;</td>
                                        <td width="90%" class="text1" height="73">
                                            <xsl:value-of select="@C"/>
                                            <br/>
                                            <xsl:value-of select="@N"/>
                                            <br/>
                                            <br/>
                                            <xsl:value-of select="@A1"/>
                                            <br/>
                                            <xsl:value-of select="@A2"/>
                                            <br/>
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
                                        <td width="15%" class="text05" align="right">Página 1</td>
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
                            <td colspan="3" class="text2" height="150" style="padding-top: 20px">
                                <b>CLIENTE:&#160;</b>
                                <xsl:value-of select="@C"/>
                                <br/>
                                <b>IDENTIFICAÇÃO DO CLIENTE:&#160;</b>
                                <xsl:value-of select="@B"/>
                                <br/>
                                <b>CÓDIGO DO CLIENTE:&#160;</b>
                                &#160;<xsl:value-of select="@M"/>
                                <br/>
                                <b>DATA DE EMISSÃO:&#160;</b>
                                <xsl:value-of select="@I"/>
                                <br/>
                                <br/>
                                <b>PERÍODO DE UTILIZAÇÃO:&#160;</b><xsl:value-of select="@S"/><xsl:text> a </xsl:text><xsl:value-of select="@E"/>
                                <br/>
                                <b>IDENTIFICAÇÃO DE DÉBITO AUTOMÁTICO:&#160;</b>
                                <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/@IDDA"/>
                            </td>
                        </tr>
                        <tr>
                        	<td>
                        	</td>
                        	<td>
                        	</td>
                        	<td colspan="3" class="text25" style="padding-top: 20px">
                        		<div align="right">
                        		<b>VENCIMENTO:&#160;</b>
                                <xsl:value-of select="@D"/>
                                </div>
                        	</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr valign="top">
                <td colspan="2" height="555">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			            <tr>
					       <td width="5%" height="8">
					           &#160;
					       </td>
				          <td colspan="5" height="8">
				              <img src="images/dot_black.gif" width="96%" height="1"/>
				          </td>
			            </tr>
                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="3" class="text25" height="32">
                                <b>FATURA DE SERVIÇOS DE TELECOMUNICAÇÕES</b>
                            </td>
                            <td height="32" width="12%">
                                &#160;
                            </td>
                            <td colspan="2" height="32" class="text1bold" align="center">
                                VALOR
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="6" class="text25" height="32" valign="top">
                                (Total de Gastos no período - EM R$)
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td height="31" width="5%" class="text5bold">
                                &#160;
                            </td>
                            <td colspan="2" class="text5bold" height="32">
                                MENSALIDADES
                            </td>
                            <td height="31" class="text5bold" width="20%">
                                &#160;
                            </td>
                            <td height="31" class="text5bold" width="8%">
                                &#160;
                            </td>
                            <td class="text5bold" align="right" width="12%" height="31">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@M"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td height="24" width="5%">
                                &#160;
                            </td>
                            <td colspan="2" class="text5bold" height="32">
                                SERVIÇOS ADICIONAIS
                            </td>
                            <td height="24" class="text5bold" width="20%">
                                &#160;
                            </td>
                            <td height="24" class="text5bold" width="8%">
                                &#160;
                            </td>
                            <td class="text5bold" align="right" width="12%">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@A"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td height="24" width="5%">
                                &#160;
                            </td>
                            <td colspan="2" class="text5bold" height="32">
                                CONEXÃO DIRETA NEXTEL
                            </td>
                            <td height="24" class="text5bold" width="20%">
                                &#160;
                            </td>
                            <td height="24" class="text5bold" width="8%">
                                &#160;
                            </td>
                            <td class="text5bold" align="right" width="12%">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@D"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td height="24" width="5%">
                                &#160;
                            </td>
                            <td colspan="2" class="text5bold" height="32">
                                CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO
                            </td>
                            <td height="24" class="text5bold" width="20%">
                                &#160;
                            </td>
                            <td height="24" class="text5bold" width="8%">
                                &#160;
                            </td>
                            <td class="text5bold" align="right" width="12%">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td width="5%" height="88">
                                &#160;
                            </td>
                            <td width="3%" height="88" class="text5">
                                &#160;
                            </td>
                            <td width="52%" class="text5" height="88">
                                CHAMADAS LOCAIS
                                <br/>
                                CHAMADAS DE LONGA DISTÂNCIA
                                <br/>
                                CHAMADAS RECEBIDAS
                                <br/>
                                CHAMADAS RECEBIDAS A COBRAR
                                <br/>
                                CHAMADAS INTERNACIONAIS
                                <br/>
                                SERVIÇO 0300
			                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
			                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	                                <br/>
	                                DESCONTO PROMOÇÃO ME LIGA
	                            </xsl:if>
                            </td>
                            <td width="20%" height="88">
                                &#160;
                            </td>
                            <td width="8%" class="text5" align="right" height="88">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@LC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@LD"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@R"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@RC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@I"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@Z3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
			                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
			                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/HOME/@DC"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                                <br/>
								</xsl:if>
                            </td>
                            <td width="12%" class="text1" align="right" height="88">
                                &#160;
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="24">
                                &#160;
                            </td>
                            <td colspan="3" height="22" class="text5bold" valign="bottom">
                                CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (EM ROAMING)
                            </td>
                            <td width="8%" height="24">
                                &#160;
                            </td>
                            <td width="12%" align="right" class="text5bold">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td width="5%" height="59">
                                &#160;
                            </td>
                            <td width="3%" height="59">
                                &#160;
                            </td>
                            <td width="52%" class="text5" height="59" valign="top">
                                CHAMADAS ORIGINADAS
                                <br/>
                                CHAMADAS RECEBIDAS
                                <br/>
                                CHAMADAS RECEBIDAS A COBRAR
                                <br/>
                                SERVIÇO 0300
			                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
			                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	                                <br/>
	                                DESCONTO PROMOÇÃO ME LIGA
	                            </xsl:if>
                            </td>
                            <td width="20%" height="59" valign="top">
                                &#160;
                            </td>
                            <td width="8%" class="text5" align="right" height="59" valign="top">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@DNOZ3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@R"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@RC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@Z3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <br/>
			                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
			                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/ROAMING/@DC"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                                <br/>
								</xsl:if>
                            </td>
                            <td width="12%" class="text1" align="right" valign="top" height="59">
                                &#160;
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="31">
                                &#160;
                            </td>
                            <td colspan="2" height="31" class="text5bold">
                                NEXTEL ONLINE (SERVIÇOS DE DADOS)
                            </td>
                            <td width="20%" height="31">
                                &#160;
                            </td>
                            <td width="8%" height="31">
                                &#160;
                            </td>
                            <td width="12%" align="right" class="text5bold">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@O"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <!-- TORPEDO NEXTEL -->
                        <xsl:if test="SUMMARY/@TP">
                            <tr>
                                <td width="5%">
                                    &#160;
                                </td>
                                <td width="3%">
                                    &#160;
                                </td>
                                <td width="52%" class="text5" valign="top">
                                    NEXTEL TORPEDO
                                </td>
                                <td width="20%">
                                    &#160;
                                </td>
                                <td width="8%" class="text5" align="right" valign="top">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="SUMMARY/@TP"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </td>
                            </tr>

                        </xsl:if>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="25">
                                &#160;
                            </td>
                            <td colspan="2" height="25" class="text5bold">
                                AJUSTES
                            </td>
                            <td width="20%" height="25">
                                &#160;
                            </td>
                            <td width="8%" height="25">
                                &#160;
                            </td>
                            <td width="12%" align="right" class="text5bold" height="25">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@C"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>

                        <tr>
                            <td width="5%" height="8">
                                &#160;
                            </td>
                            <td colspan="5" height="8">
                                <img src="images/dot_black.gif" width="96%" height="1"/>
                            </td>
                        </tr>

                      <!--  O bloco condicional abaixo é necessário, pois agora podemos ter dois XMLs como fonte:
					   			- o antigo (antes do projeto de arrecadaçao bancaria)
					   			- o novo (com as alteraçoes do projeto de arrecadaçao bancaria)

					   		 Para que o XSL monte a pagina HTML na versão antiga e na versão nova, será verificado a presença da TAG
					   		 "/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO" que foi criada no projeto arrecadaçao bancaria.
					   		 Se ela existir o XSL montará o HTML no formato novo, senão montará no formato antigo.
					 	-->
                       	<xsl:if test="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO">
							<tr>
	                            <td width="5%" height="25">
	                                &#160;
	                            </td>
	                            <td colspan="2" height="25" class="text5bold">
	                                CRÉDITO
	                            </td>
	                            <td width="20%" height="25">
	                                &#160;
	                            </td>
	                            <td width="8%" height="25">
	                                &#160;
	                            </td>
	                            <td width="12%" align="right" class="text5bold" height="25">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/@C1"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                            </td>
	                        </tr>

	                        <tr>
	                            <td width="5%" height="8">
	                                &#160;
	                            </td>
	                            <td colspan="5" height="8">
	                                <img src="images/dot_black.gif" width="96%" height="1"/>
	                            </td>
	                        </tr>

							<tr>
	                            <td width="5%" height="25">
	                                &#160;
	                            </td>
	                            <td colspan="2" height="25" class="text5bold">
	                                JUROS/MULTAS REFERENTES À FATURA ANTERIOR
	                            </td>
	                            <td width="20%" height="25">
	                                &#160;
	                            </td>
	                            <td width="8%" height="25">
	                                &#160;
	                            </td>
	                            <td width="12%" align="right" class="text5bold" height="25">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/@C2"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td width="5%" height="12">
	                                &#160;
	                            </td>
	                            <td colspan="5" height="12">
	                                <img src="images/dot_black.gif" width="96%" height="1"/>
	                            </td>
	                        </tr>
						</xsl:if>

                        <!-- Suporte a faturas com isenção de ICMS -->
                        <xsl:if test="SUMMARY/@DICMS!='0,00'">
	                        <tr>
	                            <td width="5%" height="19">
	                                &#160;
	                            </td>
	                            <td colspan="2" class="text35bold" height="19">
	                                TOTAL GERAL
	                            </td>
	                            <td width="20%" height="19">
	                                &#160;
	                            </td>
	                            <td width="8%" height="19">
	                                &#160;
	                            </td>
	                            <td width="12%" align="right" class="text35bold" height="19">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
                                            <xsl:if test="SUMMARY/@SS">
                                                <xsl:value-of select="SUMMARY/@SS"/>
                                            </xsl:if>
                                            <xsl:if test="not(SUMMARY/@SS)">
                                                <xsl:value-of select="SUMMARY/@S"/>
                                            </xsl:if>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td width="5%" height="19">
	                                &#160;
	                            </td>
	                            <td colspan="2" class="text35bold" height="19">
	                                DESCONTO ICMS (Base de cálculo R$
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/@TOTALBC"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                                )
	                            </td>
	                            <td width="20%" height="19">
	                                &#160;
	                            </td>
	                            <td width="8%" height="19">
	                                &#160;
	                            </td>
	                            <td width="12%" align="right" class="text35bold" height="19">
	                                <xsl:call-template name="VALOR-OU-ZERO">
	                                    <xsl:with-param name="value">
	                                        <xsl:value-of select="SUMMARY/@DICMS"/>
	                                    </xsl:with-param>
	                                </xsl:call-template>
	                            </td>
	                        </tr>
	                    </xsl:if>

                        <tr>
                            <td width="5%" height="19">
                                &#160;
                            </td>
                            <td colspan="2" class="text35bold" height="19">
                                TOTAL A PAGAR
                            </td>
                            <td width="20%" height="19">
                                &#160;
                            </td>
                            <td width="8%" height="19">
                                &#160;
                            </td>
                            <td width="12%" align="right" class="text35bold" height="19">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
            	<td>
            		&#160;
            	</td>
            </tr>
            <tr>
            	<td>
            		&#160;
            	</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">

					   <!--  O bloco condicional abaixo é necessário, pois agora podemos ter dois XMLs como fonte:
					   			- o antigo (antes do projeto de arrecadaçao bancaria)
					   			- o novo (com as alteraçoes do projeto de arrecadaçao bancaria)

					   		 Para que o XSL monte a pagina HTML na versão antiga e na versão nova, será verificado a presença da TAG
					   		 "/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO" que foi criada no projeto arrecadaçao bancaria.
					   		 Se ela existir o XSL montará o HTML no formato novo, senão montará no formato antigo.
					 	-->
     					<xsl:choose>
	 						<xsl:when test="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO">
		 						<tr>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M1" />
		                              <br/>
		                          </td>
		                        </tr>
		 						<tr>
		                          <td width="5%" height="8">
		                              &#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M2" />
		                              <br/>
		                          </td>
		                        </tr>
								<tr>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M5" />
		                              <br/>
		                          </td>
		                        </tr>
								<tr>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M6" />
		                              <br/>
		                          </td>
		                        </tr>
								<tr>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M7" />
		                              <br/>
		                          </td>
		                        </tr>
								<tr>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
		                          <td class="text2" colspan="2">
		                              <xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M8" />
		                              <br/>
		                          </td>
		                        </tr>
					         	<tr id="bolRow">
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
						          <td class="ThinBorderLeft ThinBorderTop ThinBorderRight ThinBorderBottom" height="10">
						          	<div class="bolName">
					             		Autenticação Mecânica
					            	</div>
						          	&#160;
						          </td>
		 						  <td width="5%" height="8">
		                          	&#160;
		                          </td>
						        </tr>
						     </xsl:when>
						     <xsl:otherwise>
		 						 <tr>
		                          <td class="text2" colspan="2">
		                            <xsl:for-each select="MESSAGES/M">
		                              <xsl:value-of select="translate(text(), '#', ' ')" />
		                              <br/>
		                            </xsl:for-each>
		                            <xsl:if test="/INVOICE/BILL/TELECOM/BOLETO/@FP">
		                              <br/>
		                              <xsl:text>Esta fatura possui débito automático em&#32;</xsl:text>
		                              <xsl:choose>
		                                <xsl:when test="/INVOICE/BILL/TELECOM/BOLETO/@FP = 'C'">
		                                  <xsl:text>cartão de crédito.</xsl:text>
		                                </xsl:when>
		                                <xsl:when test="/INVOICE/BILL/TELECOM/BOLETO/@FP = 'D'">
		                                  <xsl:text>conta corrente.</xsl:text>
		                                </xsl:when>
		                              </xsl:choose>
		                              <br/>
		                            </xsl:if>
		                          </td>
		                        </tr>
						     </xsl:otherwise>
					     </xsl:choose>

                    </table>
                </td>
            </tr>
        </table>

    </xsl:template>

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

 </xsl:stylesheet>