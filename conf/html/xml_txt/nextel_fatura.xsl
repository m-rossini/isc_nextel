<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text" encoding="ISO-8859-1" media-type="text/plain"/>

    <xsl:template match="/">
      <xsl:apply-templates select="INVOICE/BILL" />      <xsl:apply-templates select="INVOICE/CUSTOMER[DETAILS or SUMMARY]" />    </xsl:template>    <xsl:template match="INVOICE/CUSTOMER">        <!-- Define o layout do documento -->        <!-- ****************** -->        <!-- * Primeira parte * -->        <!-- ****************** -->        <!-- cabeçalho -->        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>cabecalho da fatura</xsl:text>    
        <!-- corpo -->        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>fatura de serviços de telecomunicações</xsl:text>        <xsl:call-template name="RESUMO-FATURA-MENSAL"/>        
        <!-- rodapé -->
        <xsl:for-each select="MESSAGES/M">
            <xsl:value-of select="translate(text(), '#', ' ')"/>
            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:for-each>
        <xsl:if test="/BILL/TELECOM/@FP">
          <xsl:text>Esta fatura possui débito automático em&#32;</xsl:text>
          <xsl:choose>
            <xsl:when test="/BILL/TELECOM/@FP = 'C'">
              <xsl:text>cartão de crédito</xsl:text>
            </xsl:when>
            <xsl:when test="/BILL/TELECOM/@FP = 'D'">
              <xsl:text>conta corrente</xsl:text>
            </xsl:when>
          </xsl:choose>
          <xsl:text>.&#13;&#10;</xsl:text>
        </xsl:if>
                <!-- ***************** -->        <!-- * Segunda parte * -->        <!-- ***************** -->        <!-- cabeçalho -->        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>cabecalho resumo por equipamento</xsl:text>                <!-- rodapé -->        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>rodape resumo por equipamento</xsl:text>        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>Contribuição para FUST - 1% do valor dos serviços - não repassadas as tarifas Art 9 Lei 9.998/2000</xsl:text>        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>Contribuição para o FUNTEL - 0,5% do valor dos serviços - não repassadas as tarifas Art 6 &#xA7; 6° Lei 10.052/2000</xsl:text>                <!-- corpo -->        <xsl:text>&#13;&#10;</xsl:text>        resumo do equipamento        <xsl:call-template name="RESUMO-EQUIPAMENTO"/>        <!-- **************************** -->        <!-- * Terceira e quarta partes * -->        <!-- **************************** -->        <xsl:text>&#13;&#10;</xsl:text>        <xsl:text>Terceira e quarta partes - geral</xsl:text>        <xsl:apply-templates select="./DETAILS/SUBSCRIBER/CONTRACT" mode="DETAILS"/>    </xsl:template>    <!-- **************************** -->    <!-- * Terceira e quarta partes * -->    <!-- **************************** -->    <xsl:template match="CONTRACT" mode="DETAILS">        <!-- Só mostra se houver alguma coisa a mostrar -->        <xsl:if test="@T!='0,00'">            <!-- ****************** -->            <!-- * Terceira parte * -->            <!-- ****************** -->            <!-- cabeçalho -->            <xsl:text>&#13;&#10;</xsl:text>            <xsl:text>Terceira parte - Detalhamento da Fatura</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>                        <!-- cabeçalho -->            <xsl:call-template name="HEADER-DETALHE"/>                        <!-- corpo -->            <xsl:call-template name="DETALHE-FATURA"/>                                    <!-- **************** -->            <!-- * Quarta parte * -->            <!-- **************** -->            <!-- Só mostra se houver alguma chamada de telefonia -->
            <xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or @PP='Y' or CALLS/IDCD/@V!='0,00' or CALLS/ONLINE/SVC[@ID='LOLGT']">                <xsl:text>&#13;&#10;</xsl:text>                <xsl:text>Quarta parte - Conta Detalhada</xsl:text>                <xsl:text>&#13;&#10;</xsl:text>                    <!-- cabeçalho -->                <xsl:call-template name="HEADER-DETALHE"/>                                <!-- corpo -->
                <xsl:call-template name="DETALHE-CONTA-SRV"/>                
                <xsl:call-template name="DETALHE-CONTA-ONLINE"/>                                 <xsl:call-template name="DETALHE-CONTA"/>            </xsl:if>        </xsl:if>    </xsl:template>    <!-- ****************************************************** -->    <!-- * Formatações dos cabeçalhos e corpos de cada página * -->    <!-- ****************************************************** -->    <xsl:include href="nextel_fatura_header.xsl"/>    <xsl:include href="nextel_fatura_resumo_fatura_mensal.xsl"/>    <xsl:include href="nextel_fatura_resumo_equipamento.xsl"/>    <xsl:include href="nextel_fatura_detalhe_fatura.xsl"/>    <xsl:include href="nextel_fatura_detalhe_conta.xsl"/>
    <xsl:include href="nextel_fatura_formatting.xsl"/>      <!-- Imprime o valor passado ou 0,00 -->    <xsl:template name="VALOR-OU-ZERO">        <xsl:param name="value">0,00</xsl:param>        <xsl:value-of select="$value"/>        <xsl:if test="$value=''">            <xsl:text>0,00</xsl:text>        </xsl:if>    </xsl:template>    </xsl:stylesheet>