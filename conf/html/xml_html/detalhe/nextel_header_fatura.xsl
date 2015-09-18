<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:variable name="date" select="concat(substring(/INVOICE/CUSTOMER/@I,7),substring(/INVOICE/CUSTOMER/@I,4,2),substring(/INVOICE/CUSTOMER/@I,1,2))"/>
    <xsl:variable name="dateFIX" select="20040901"/>

    <xsl:template name="HEADER1-FATURA">
        <table width="91%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td height="48px" valign="bottom" colspan="2">
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
                    NEXTEL Telecomunica&#231;&#245;es Ltda.
                    <br/>
                    <xsl:if test="number($date) &gt;= number($dateFIX)">
                        <xsl:text>Al. Santos, 2356/2364 - Cerqueira César - CEP 01418-200 - São Paulo - SP</xsl:text>
                    </xsl:if>
                    <xsl:if test="number($date) &lt; number($dateFIX)">
                        <xsl:text>Av. Maria Coelho Aguiar, 215 - Bloco D - 6º andar - CEP 05805-900 - São Paulo - SP</xsl:text>
                    </xsl:if>
                    <br/>
                    <xsl:text>CNPJ 66.970.229/0001-67 - Inscr. Estadual: 114.166.101.115</xsl:text>
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
                            <td width="10%" height="73">
                                &#160;
                            </td>
                            <td width="90%" class="text1" height="73">
                                <xsl:value-of select="/INVOICE/CUSTOMER/@C"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@N"/><br/>
                                <br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A1"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A2"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A3"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>


    <xsl:template name="HEADER2-FATURA">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="3" height="10">
                    <img src="images/dot_black.gif" width="100%" height="1"/>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="text4bold" height="21" valign="middle">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="text4bold" width="85%">
                                DETALHAMENTO DA FATURA
                            </td>
                            <td width="15%" class="text5" align="right">
                                Página 3
                            </td>
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
                    <b>CLIENTE: </b><xsl:value-of select="/INVOICE/CUSTOMER/@C"/><br/>
                    <b>IDENTIFICAÇÃO DO CLIENTE: </b><xsl:value-of select="/INVOICE/CUSTOMER/@B"/><br/>
                    <b>DATA DE EMISSÃO: </b><xsl:value-of select="/INVOICE/CUSTOMER/@I"/><br/>
                    <br/>
                    <b>PERÍODO DE UTILIZAÇÃO: </b><xsl:value-of select="/INVOICE/CUSTOMER/@S"/> a <xsl:value-of select="/INVOICE/CUSTOMER/@E"/> <br/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="HEADER3-FATURA">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <td class="text25" width="24%">
                    <b>DADOS DO USUÁRIO</b>
                </td>
                <td class="text25" width="24%">
		        <xsl:choose>
				    <xsl:when test="@TP = 'AMP'">
                        <b>SERIAL: </b><xsl:value-of select="@IMEI"/>
			        </xsl:when>
			        <xsl:otherwise>	                  
                        <b>FLEET*ID: </b><xsl:value-of select="@FID"/><xsl:if test="not(string-length(@FID) = 0)"><xsl:text>*</xsl:text></xsl:if><xsl:value-of select="@MID"/>
		            </xsl:otherwise>
		        </xsl:choose>
                </td>
                <td class="text25" width="26%">
                    <b>TELEFONE: </b><xsl:value-of select="@N"/>
                </td>
                <td class="text25" width="26%">
                    <b>NOME: </b><xsl:value-of select="@U"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="HEADER1-SERVICO">
        <xsl:param name="title"/>
        <tr>
            <td colspan="4" height="26" class="text25">
                <b><xsl:value-of select="$title"/></b>
            </td>		
            <td height="26" width="9%">&#160;</td>
            <td height="26" width="2%">&#160;</td>
            <td height="26" width="19%">&#160;</td>
            <td height="26" width="2%">&#160;</td>
            <td height="26" width="12%">&#160;</td>
            <td height="26" width="2%">&#160;</td>
            <td height="26" width="10%">&#160;</td>
            <td height="26" width="4%">&#160;</td>
        </tr>
    </xsl:template>

    <xsl:template name="HEADER1-CONTA">
        <table width="91%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="48px" valign="bottom" colspan="2">
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
                    NEXTEL Telecomunica&#231;&#245;es Ltda.
                    <br/>
                    <xsl:if test="number($date) &gt;= number($dateFIX)">
                        <xsl:text>Al. Santos, 2356/2364 - Cerqueira César - CEP 01418-200 - São Paulo - SP</xsl:text>
                    </xsl:if>
                    <xsl:if test="number($date) &lt; number($dateFIX)">
                        <xsl:text>Av. Maria Coelho Aguiar, 215 - Bloco D - 6º andar - CEP 05805-900 - São Paulo - SP</xsl:text>
                    </xsl:if>
                    <br/>
                        <xsl:text>CNPJ 66.970.229/0001-67 - Inscr. Estadual: 114.166.101.115</xsl:text>
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
                            <td width="10%" height="73">
                                &#160;
                            </td>
                            <td width="90%" class="text1" height="73">
                                <xsl:value-of select="/INVOICE/CUSTOMER/@C"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@N"/><br/>
                                <br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A1"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A2"/><br/>
                                <xsl:value-of select="/INVOICE/CUSTOMER/@A3"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="HEADER2-CONTA">
        <tr valign="top" style="padding-top: 20px"> 
        <td colspan="3" class="text2" height="213">
            <b>CLIENTE: </b><xsl:value-of select="/INVOICE/CUSTOMER/@C"/><br/>
            <b>IDENTIFICA&#199;&#195;O DO CLIENTE: </b><xsl:value-of select="/INVOICE/CUSTOMER/@B"/><br/>
            <b>DATA DE EMISS&#195;O: </b><xsl:value-of select="/INVOICE/CUSTOMER/@I"/><br/>
            <br/>
            <b>PER&#205;ODO DE UTILIZA&#199;&#195;O: </b><xsl:value-of select="/INVOICE/CUSTOMER/@S"/> a <xsl:value-of select="/INVOICE/CUSTOMER/@E"/><br/>
        </td>
        </tr>
    </xsl:template>

    <xsl:template name="HEADER-CONTA2">
        <xsl:param name="title"/>
        <tr>
            <td width="3" class="text5" height="20">&#160;</td>
            <td colspan="14" class="text5" height="20">
                <b>
                    <xsl:value-of select="$title"/>
                </b>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
