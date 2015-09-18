<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:req="xalan://br.com.auster.dware.graph.Request"
                xmlns:bgh="xalan://br.com.auster.nextel.xsl.extensions.BGHUtils"
                xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.DateVariable"
                xmlns:inet="xalan://java.net.InetAddress"
                extension-element-prefixes="date inet req bgh"
                exclude-result-prefixes="date inet req bgh"
                version="1.0">

    <xsl:output method="text" indent="no" encoding="ISO-8859-1" media-type="text/plain"/>
    
    <xsl:param name="req:request"/>
    
    <xsl:variable name="delimiter" select="';'"/>

    <xsl:template match="/">
        <date:reset pattern="dd/MM/yyyy"/>
        <xsl:apply-templates select="INVOICE/CUSTOMER"/>
    </xsl:template>

    <xsl:template match="CUSTOMER">

        <xsl:variable name="localHost" select="inet:getLocalHost()"/>
        <xsl:variable name="numberOfContracts" select="count(DETAILS/SUBSCRIBER/CONTRACT)"/>

        <!-- Região: região do Billing (sempre RJ) -->
        <xsl:value-of select="'RJ'"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Ciclo: identificação do ciclo -->
        <xsl:value-of select="@BCN"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Ano: ano de referência do ciclo -->
        <xsl:value-of select="date:format(@BCD, 'yyyy')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Mês: mês de referência do ciclo -->
        <xsl:value-of select="date:format(@BCD, 'MM')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Cidade: identificação da cidade a qual pertence o cliente -->
        <xsl:value-of select="@CT"/>
        <xsl:value-of select="$delimiter"/>
        <!-- CustomerID: identificação do Cliente -->
        <xsl:value-of select="@ID"/>
        <xsl:value-of select="$delimiter"/>
        <!-- CustCode: identificação da fatura -->
        <xsl:value-of select="@B"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Caminho: caminho em que se encontra a fatura -->
        <xsl:value-of select="bgh:getDirectory($req:request, 'xml')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Arquivo: nome do arquivo da fatura sem extensão -->
        <xsl:value-of select="bgh:getFilenameNoExt($req:request, 'xml')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Servidor: nome da maquina (server) onde o arquivo foi gerado -->
        <xsl:value-of select="inet:getHostName($localHost)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Gerado: indica se a fatura foi gerada (Yes/No) -->
        <xsl:text>Y</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <!-- Valor a Pagar: valor a pagar da fatura -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Contratos: quantidade de contratos desta fatura -->
        <xsl:value-of select="$numberOfContracts"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Nota Fiscal: identifica se nota fiscal em regime especial (Y=Yes/N=No) -->
        <xsl:value-of select="@SR"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Paginas: quantidade de paginas geradas para esta fatura -->
        <xsl:value-of select="2 + round($numberOfContracts div 37) + round($numberOfContracts div 2)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Mensalidades: mensalidades de serviços -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Serviços Adicionais: serviços adicionais sem mensalidade -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@A"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Valor de Radio: valor gasto em uso de radio -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@D"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Valor de Telefonia Home: valor de uso de telefonia na area de registro -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Valor de Telefonia Roaming: valor de uso de telefonia fora da area de registro -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Minutos Radio -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@DD_M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Minutos Telefonia Home: minutos de telefonia na area de registro -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@TD_M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Minutos Telefonia Roaming: minutos de telefonia fora da area de registro -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@TD_M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Servico de Dados: valor de uso de dados -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@O"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Ajustes: ajustes de valores (OCC - Other Credit and Charges) -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@C"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- Data Vencimento: data de vencimento da fatura -->
        <xsl:value-of select="@D"/>
        <xsl:call-template name="PRINT-LINEFEED"/>

    </xsl:template>

    <!-- Imprime o valor passado ou 0,00 -->
    <xsl:template name="VALOR-OU-ZERO">
        <xsl:param name="value">0,00</xsl:param>
        <xsl:choose>
            <xsl:when test="string-length($value) &gt; 0">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0,00</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Imprime um caracter de nova linha -->
    <xsl:template name="PRINT-LINEFEED">
        <xsl:text>
</xsl:text>
    </xsl:template>


</xsl:stylesheet>
