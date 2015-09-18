<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- DADOS PARA A TABELA EXTRATO -->
    <xsl:template name="CORPO_EXTRATO">
        <!-- DATA -->
        <xsl:value-of select="'15/12/2003'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- TITULO -->
        <xsl:value-of select="'XXXXXXX'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- DESCRICAO -->
        <xsl:value-of select="'Assist�ncia T�cnica - Parcela 1/3 - venc: 04/01/2004'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- DESPESAS REALIZADAS -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'90,00'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#9;</xsl:text>
        <!-- PAGAMENTOS EFETUADOS -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'-65,00'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#9;</xsl:text>
        <!-- SALDO -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'1.650,63'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#10;&#13;</xsl:text>
    </xsl:template>

    <!-- DADOS PARA A TABELA LANCAMENTOS -->
    <xsl:template name="CORPO_LANCAMENTOS">
        <!-- DATA -->
        <xsl:value-of select="'15/12/2003'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- TITULO -->
        <xsl:value-of select="'XXXXXXX'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- DESCRICAO -->
        <xsl:value-of select="'Assist�ncia T�cnica - Parcela 2/3 - venc: 04/02/2004'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- DESPESAS REALIZADAS -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'90,00'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#9;</xsl:text>
        <!-- VENCIMENTO -->
        <xsl:value-of select="'14/01/2004'"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>&#10;&#13;</xsl:text>
    </xsl:template>

    <!-- DADOS PARA A TABELA DESPESAS -->
    <xsl:template name="CORPO_DESPESAS">
        <!-- DATA -->
        <xsl:value-of select="'15/12/2003'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- DESCRICAO -->
        <xsl:value-of select="'Aquisi��o de Acess�rios - 6 Parcelas'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- OPERADORA -->
        <xsl:value-of select="'Mastercard'"/>
        <xsl:text>&#9;</xsl:text>
        <!-- VALOR TOTAL -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'600,00'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>&#10;&#13;</xsl:text>
    </xsl:template>
 

    <!-- ***************************************************** -->
    <!-- * Mostra as linhas da tabela de extrato             * -->
    <!-- ***************************************************** -->
    <xsl:template name="TABELA_EXTRATO">
        <xsl:call-template name="CORPO_EXTRATO"/>
    </xsl:template>
    <!-- ***************************************************** -->
    <!-- * Mostra as linhas da tabela de lan�amentos         * -->
    <!-- ***************************************************** -->
    <xsl:template name="TABELA_LANCAMENTOS">
        <xsl:call-template name="CORPO_LANCAMENTOS"/>
    </xsl:template>
    <!-- ***************************************************** -->
    <!-- * Mostra as linhas da tabela de despesas            * -->
    <!-- ***************************************************** -->
    <xsl:template name="TABELA_DESPESAS">
        <xsl:call-template name="CORPO_DESPESAS"/>
    </xsl:template>


    <!-- ****************************************** -->
    <!-- * Extrato da conta corrente              * -->
    <!-- ****************************************** -->
    <xsl:template name="CONTA-CORRENTE">

        <!-- In�cio da tabela - mostra o subtotal inicial -->
        <xsl:text>&#13;&#10;</xsl:text>
        <!-- primeira linha do cabe�alho -->
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:text>SALDO EM </xsl:text> <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'1.560,63'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- Cabe�alho da tabela de extrato -->
        <xsl:text>DATA</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>T�TULO</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>DESCRI��O</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>DESPESAS REALIZADAS</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>PAGAMENTOS EFETUADOS</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>SALDO</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- gera as linhas do corpo da tabela -->
        <xsl:call-template name="TABELA_EXTRATO"/>

        <!-- subtotal -->
        <xsl:text>&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:text>SALDO EM </xsl:text> <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="'0,00'"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- Final da tabela -->
        <xsl:text>Obs: Pode haver uma defasagem de at� 5 dias entre o pagamento de um t�tulo e sua respectiva baixa no sistema de controle.&#13;&#10;&#9;Caso voc� tenha feito algum pagamento que n�o foi relacionado acima, favor desconsiderar o Saldo final.
        </xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <!--  N�O ENTRAR� MAIS: Lan�amentos Futuros - ->
###        <! - - cabe�alhos- ->
###        <xsl:text>LAN�AMENTOS FUTUROS</xsl:text>
###        <xsl:text>&#13;&#10;</xsl:text>
###
###        <xsl:text>DATA</xsl:text>
###        <xsl:text>&#9;</xsl:text>
###        <xsl:text>T�TULO</xsl:text>
###        <xsl:text>&#9;</xsl:text>
###        <xsl:text>DESCRI��O</xsl:text>
###        <xsl:text>&#9;</xsl:text>
###        <xsl:text>DESPESAS REALIZADAS</xsl:text>
###        <xsl:text>&#9;</xsl:text>
###        <xsl:text>VENCIMENTO</xsl:text>
###        <xsl:text>&#13;&#10;</xsl:text>
###
###        <!- - gera as linhas do corpo da tabela - ->
###        <xsl:call-template name="TABELA_LANCAMENTOS"/>
###-->
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- Despesas com cart�o -->
        <!-- cabe�alhos-->
        <xsl:text>DESPESAS PAGAS COM CART�O DE CR�DITO</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <xsl:text>DATA</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>DESCRI��O</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>OPERADORA</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>VALOR TOTAL</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

        <!-- gera as linhas do corpo da tabela -->
        <xsl:call-template name="TABELA_DESPESAS"/>

        
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