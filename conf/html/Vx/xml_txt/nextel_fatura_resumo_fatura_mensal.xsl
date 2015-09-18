<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- **************************************************** -->
    <!-- * Resumo da fatura atual (Corpo da primeira parte) * -->
    <!-- **************************************************** -->
    <xsl:template name="RESUMO-FATURA-MENSAL">

        <!-- Fatura atual -->
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>FATURA DE SERVIÇOS DE TELECOMUNICAÇÕES</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:text>VALOR</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>(Total de Gastos no período - EM R$)</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>MENSALIDADES</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@M"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>SERVIÇOS ADICIONAIS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@A"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CONEXÃO DIRETA NEXTEL</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@D"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@T"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS LOCAIS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@LC"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS DE LONGA DISTÂNCIA</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@LD"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS RECEBIDAS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@R"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS RECEBIDAS A COBRAR</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@RC"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS INTERNACIONAIS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@I"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>SERVIÇO 0300</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/HOME/@Z3"/>
            </xsl:with-param>
        </xsl:call-template>

        <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
        <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	        <xsl:text>&#13;&#10;</xsl:text>
	        <xsl:text>DESCONTO PROMOÇÃO ME LIGA</xsl:text>
	        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
	        <xsl:call-template name="VALOR-OU-ZERO">
	            <xsl:with-param name="value">
	                <xsl:value-of select="SUMMARY/HOME/@DC"/>
	            </xsl:with-param>
	        </xsl:call-template>
        </xsl:if>

        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (EM ROAMING)</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/ROAMING/@T"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS ORIGINADAS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/ROAMING/@DNOZ3"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS RECEBIDAS</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/ROAMING/@R"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>CHAMADAS RECEBIDAS A COBRAR</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/ROAMING/@RC"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>SERVIÇO 0300</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/ROAMING/@Z3"/>
            </xsl:with-param>
        </xsl:call-template>

        <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
        <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
	        <xsl:text>&#13;&#10;</xsl:text>
	        <xsl:text>DESCONTO PROMOÇÃO ME LIGA</xsl:text>
	        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
	        <xsl:call-template name="VALOR-OU-ZERO">
	            <xsl:with-param name="value">
	                <xsl:value-of select="SUMMARY/ROAMING/@DC"/>
	            </xsl:with-param>
	        </xsl:call-template>
        </xsl:if>

        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>NEXTEL ONLINE (SERVIÇOS DE DADOS)</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@O"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:if test="SUMMARY/@TP">
            <xsl:text>NEXTEL TORPEDO</xsl:text>
            <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="SUMMARY/@TP"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:if>
        <xsl:text>AJUSTES</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@C"/>
            </xsl:with-param>
        </xsl:call-template>

		<!-- Suporte para isenção de ICMS -->
		<xsl:if test="SUMMARY/@DICMS!='0,00'">
	        <xsl:text>&#13;&#10;</xsl:text>
	        <xsl:text>TOTAL GERAL</xsl:text>
	        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
	        <xsl:call-template name="VALOR-OU-ZERO">
	            <xsl:with-param name="value">
                        <xsl:value-of select="SUMMARY/@S"/>
	            </xsl:with-param>
	        </xsl:call-template>
	        <xsl:text>&#13;&#10;</xsl:text>
            <xsl:text>DESCONTO ICMS (Base de cálculo R$</xsl:text>
		        <xsl:call-template name="VALOR-OU-ZERO">
		            <xsl:with-param name="value">
		                <xsl:value-of select="SUMMARY/@TOTALBC"/>
		            </xsl:with-param>
		        </xsl:call-template>
                <xsl:text>)</xsl:text>
	        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
	        <xsl:call-template name="VALOR-OU-ZERO">
	            <xsl:with-param name="value">
	                <xsl:value-of select="SUMMARY/@DICMS"/>
	            </xsl:with-param>
	        </xsl:call-template>
        </xsl:if>
        
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>TOTAL A PAGAR*</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="SUMMARY/@T"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>* O pagamento desta fatura não isenta o pagamento de eventuais saldos anteriores.</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>VENCIMENTO:</xsl:text>
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:value-of select="/INVOICE/CUSTOMER/@D"/>

    </xsl:template>

</xsl:stylesheet>