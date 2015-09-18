<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">    <xsl:output method="html" 
              version="4.01" 
              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
              encoding="ISO-8859-1" 
              omit-xml-declaration="no" 
              indent="no" 
              media-type="text/html"/>    <xsl:variable name="userNameMaxLength" select="15"/>    <xsl:template match="/">        <xsl:apply-templates select="INVOICE/CUSTOMER"/>    </xsl:template>            <xsl:template match="INVOICE/CUSTOMER">        <xsl:if test="count(./DETAILS/SUBSCRIBER/CONTRACT) > 0">            <xsl:apply-templates select="./DETAILS/SUBSCRIBER/CONTRACT" mode="DETAILS"/>        </xsl:if>        <xsl:if test="count(./DETAILS/SUBSCRIBER/CONTRACT) = 0">            <xsl:apply-templates select="./DETAILS/SUBSCRIBER/OTHER" mode="DETAILS"/>        </xsl:if>	    </xsl:template>        <xsl:template match="CONTRACT" mode="DETAILS">                <link href="include/fatura.css" rel="stylesheet"/>                <xsl:if test="@T!='0,00'">            <table width="100%" border="0" cellspacing="0" cellpadding="0">                <tr>                    <td height="200" valign="top">                        <xsl:call-template name="HEADER1-FATURA"/>                    </td>                    <td width="52%" height="257" align="right" valign="top">                        <xsl:call-template name="HEADER2-FATURA"/>                    </td>                </tr>                <tr>                    <td colspan="2" style="line-height: 1px">                        <img src="images/dot_black.gif" width="100%" height="1"/>                    </td>                </tr>                <tr valign="middle" align="center">                    <td colspan="2" height="45">                        <xsl:call-template name="HEADER3-FATURA"/>                    </td>                </tr>                <tr>                    <td colspan="2" style="line-height: 1px">                        <img src="images/dot_black.gif" width="100%" height="1"/>                    </td>                </tr>                <tr valign="middle" align="center">                    <td colspan="2" height="45">                        <xsl:call-template name="DETALHE-FATURA"/>                    </td>                </tr>                <tr valign="top">                    <td colspan="2" height="4">&#160;</td>                </tr>            </table>            <table border="0" width="100%" cellpadding="0" cellspacing="0">                <tr>                    <td>                        <img src="images/dot_black.gif" width="100%" height="3"/>                    </td>                </tr>            </table>            <table width="100%" border="0" cellspacing="0" cellpadding="0">                <tr valign="top">                    <td height="83">                      <!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or CALLS/ROAMING/@DNF!='0,00' or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or @PP='Y' or CALLS/IDCD/@V!='0,00'"> -->
                      <!-- <xsl:if test="CALLS/HOME/@DNF!='0:00' or CALLS/ROAMING/@DNF!='0:00' or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or @PP='Y' or CALLS/IDCD/@V!='0,00'"> -->
                       <xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or @PP='Y' or CALLS/IDCD/@V!='0,00'">                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">                                <tr>                                    <td width="50%" height="257" valign="top">                                        <xsl:call-template name="HEADER1-CONTA"/>                                    </td>                                    <td width="52%" height="257" align="right" valign="top">                                        <table width="95%" border="0" cellspacing="0" cellpadding="0">                                            <tr>                                                <td colspan="3" height="10" style="line-height: 1px">                                                    <img src="images/dot_black.gif" width="100%" height="1"/>                                                </td>                                            </tr>                                            <tr>                                                <td colspan="3" class="text4bold" height="21" valign="middle">                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                        <tr>                                                            <td class="text4bold" width="85%">                                                                CONTA DETALHADA                                                            </td>                                                            <td width="15%" class="text5" align="right">                                                                Página 4                                                            </td>                                                        </tr>                                                    </table>                                                </td>                                            </tr>                                            <tr>                                                <td colspan="3" height="9" style="line-height: 1px">                                                    <img src="images/dot_black.gif" width="100%" height="1"/>                                                </td>                                            </tr>                                            <xsl:call-template name="HEADER2-CONTA"/>                                        </table>                                    </td>                                </tr>                                <tr>                                    <td colspan="2" style="line-height: 1px">                                        <img src="images/dot_black.gif" width="100%" height="1"/>                                    </td>                                </tr>                                <tr valign="middle" align="center">                                    <td colspan="2" height="45">                                        <xsl:call-template name="HEADER3-FATURA"/>                                    </td>                                </tr>                                <tr valign="top">                                    <td colspan="2" height="5" style="line-height: 1px">                                        <img src="images/dot_black.gif" width="100%" height="1"/>                                    </td>                                </tr>                                <tr valign="top">                                    <td colspan="2" height="413">
                                    
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <xsl:call-template name="DETALHE-CONTA-SRV"/>
                                            <tr>
                                                <td width="3%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="7%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="7%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="15%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="14%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="15%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="14%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="11%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                            </tr>
                                        </table>
                                        
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <xsl:call-template name="DETALHE-CONTA-ONLINE"/>
                                            <tr>
                                                <td width="3%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="7%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="7%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="15%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="14%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="15%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="14%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="2%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                                <td width="11%" class="text5" height="20">
                                                    &#160;
                                                </td>
                                            </tr>
                                        </table>
                                        
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <xsl:call-template name="DETALHE-CONTA"/>                                            <tr>                                                <td width="3%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="7%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="7%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="15%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="14%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="15%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="14%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="2%" class="text5" height="20">                                                    &#160;                                                </td>                                                <td width="11%" class="text5" height="20">                                                    &#160;                                                </td>                                            </tr>                                        </table>                                    </td>                                </tr>                            </table>                        </xsl:if>                    </td>                </tr>            </table>        </xsl:if>    </xsl:template>

    <xsl:include href="nextel_detalhe_fatura.xsl"/>    <xsl:include href="nextel_header_fatura.xsl"/>    <xsl:include href="nextel_fatura_conta.xsl"/>    <!-- Imprime o valor passado ou 0,00 -->    <xsl:template name="VALOR-OU-ZERO">        <xsl:param name="value">0,00</xsl:param>        <xsl:choose>            <xsl:when test="starts-with($value, '-')">                <xsl:value-of select="concat('(', substring($value, 2), ')')"/>            </xsl:when>            <xsl:when test="string-length($value) &gt; 0">                <xsl:value-of select="$value"/>            </xsl:when>            <xsl:otherwise>                <xsl:text>0,00</xsl:text>            </xsl:otherwise>        </xsl:choose>    </xsl:template></xsl:stylesheet>
