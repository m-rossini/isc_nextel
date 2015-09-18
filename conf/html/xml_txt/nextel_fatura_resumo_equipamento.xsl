<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- ***************************** -->
    <!-- * Dados de cada equipamento * -->
    <!-- ***************************** -->
    <xsl:template match="CONTRACT" mode="SUMMARY">
        <!-- FLEET*ID ou SERIAL-->
        <xsl:text>&#9;</xsl:text>

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

        <xsl:text>&#9;</xsl:text>

        <!-- TELEFONE -->
        <xsl:value-of select="@N"/>

        <xsl:text>&#9;</xsl:text>

        <!-- USUÁRIO -->
        <xsl:value-of select="@U"/>

        <xsl:text>&#9;</xsl:text>

        <!-- MENSALIDADE (R$) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="@M"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- SERVIÇOS ADICIONAIS/SERVIÇOS DE TERCEIROS (R$) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="@A"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CONEXÃO DIRETA NEXTEL (R$) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="DISPATCH/@V"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CHAMADAS DENTRO DA ÁREA DE REGISTRO -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="CALLS/HOME/@V"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CHAMADAS FORA DA ÁREA DE REGISTRO -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="CALLS/ROAMING/@V"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- SERVIÇOS DE DADOS (R$) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="@O"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- VALOR TOTAL (R$) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="@T"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#10;&#13;</xsl:text>
    </xsl:template>


    <!-- ***************************************************** -->
    <!-- * Mostra um resumo de cada equipamento e o subtotal * -->
    <!-- ***************************************************** -->
    <xsl:template match="SUBSCRIBER">
        <!-- Mostra todos os aparelhos dessa conta -->
        <xsl:apply-templates select="./CONTRACT" mode="SUMMARY"/>

        <xsl:text>SUBTOTAL</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <!-- MENSALIDADE -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@M"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#9;</xsl:text>

        <!-- SERVIÇOS ADICIONAIS / SERVIÇOS DE TERCEIROS -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@A"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CONEXÃO DIRETA NEXTEL -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@D"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CHAMADAS DENTRO DA ÁREA DE REGISTRO -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/HOME/@T"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- CHAMADAS FORA DA ÁREA DE REGISTRO -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/ROAMING/@T"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- SERVIÇOS DE DADOS (NEXTEL ONLINE) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@O"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- VALOR TOTAL -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@S"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#10;&#13;</xsl:text>

    </xsl:template>


    <!-- ****************************************** -->
    <!-- * Resumo por equipamento (Segunda parte) * -->
    <!-- ****************************************** -->
    <xsl:template name="RESUMO-EQUIPAMENTO">

        <!-- Início da tabela - mostra todos os aparelhos dessa conta mais o subtotal -->

        <!-- primeira linha do cabeçalho -->
        <xsl:choose>
	    <xsl:when test="DETAILS/SUBSCRIBER/CONTRACT/@TP = 'AMP'">
                <xsl:text>SERIAL</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>	                  
                <xsl:text>FLEET * ID</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>TELEFONE</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>USUÁRIO</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>MENSALIDADE (R$)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>SERVIÇOS ADICIONAIS (R$)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>CONEXÃO DIRETA NEXTEL (R$)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>         CHAMADAS DE TELEFONIA (R$)                  </xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>SERVIÇOS DE DADOS (R$)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>VALOR TOTAL (R$) </xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- segunda linha do cabeçalho -->
        <xsl:text>&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:text>DENTRO DA ÁREA DE REGISTRO</xsl:text>
        <xsl:text>&#32;</xsl:text>
        <xsl:text>FORA DE ÁREA DE REGISTRO</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- gera as linhas do corpo da tabela -->
        <xsl:apply-templates select="DETAILS/SUBSCRIBER"/>

        <!-- Final da tabela -->

        <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
        <xsl:if test="count(DETAILS/SUBSCRIBER/OTHER/OCC) &gt; 0">

            <xsl:text>AJUSTES</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>
            <xsl:text>DATA</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>TIPO</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>VALOR</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Para cada serviço adicional corporativo -->
            <xsl:for-each select="DETAILS/SUBSCRIBER/OTHER/OCC">
                <xsl:value-of select="@DT"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="@DS"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="@V"/>
                <xsl:text>&#13;&#10;</xsl:text>
            </xsl:for-each>

            <!-- Subtotal -->
            <xsl:text>&#13;&#10;</xsl:text>
            <xsl:text>&#9;&#9;</xsl:text>
            <xsl:text>Subtotal</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="DETAILS/SUBSCRIBER/OTHER/@T"/>

        </xsl:if>
        
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>TOTAL GERAL:</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <!-- VALOR TOTAL -->
        <xsl:value-of select="SUMMARY/@T"/>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:text>VENCIMENTO:</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <!-- Data de vencimento da fatura -->
        <xsl:value-of select="@D"/>

    </xsl:template>

</xsl:stylesheet>