<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan" xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
  exclude-result-prefixes="xalan phonenumber" version="1.0">

  <xsl:output method="xml" version="1.0" encoding="ISO-8859-1" omit-xml-declaration="no"
    indent="no" />

  <xsl:variable name="userNameMaxLength" select="15" />

  <xsl:template match="/">

    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

      <!-- Define o layout do documento -->
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4-resumo" page-height="29.7cm" page-width="21cm"
          margin-top="11.2mm" margin-bottom="11.2mm" margin-left="11.2mm" margin-right="11.2mm">
          <fo:region-body margin-top="50mm" margin-bottom="0mm" />
          <fo:region-before extent="61mm" />
        </fo:simple-page-master>
        <fo:simple-page-master master-name="A4-equip" page-height="29.7cm" page-width="21cm"
          margin-top="11.2mm" margin-bottom="11.2mm" margin-left="11.2mm" margin-right="11.2mm">
          <fo:region-body margin-top="60mm" margin-bottom="18mm" />
          <fo:region-before extent="61mm" />
          <fo:region-after extent="14.5mm" />
        </fo:simple-page-master>
        <fo:simple-page-master master-name="A4-detalhe" page-height="29.7cm" page-width="21cm"
          margin-top="11.2mm" margin-bottom="11.2mm" margin-left="11.2mm" margin-right="11.2mm">
          <fo:region-body margin-top="72mm" />
          <fo:region-before extent="72mm" />
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="resumo-fatura-mensal">
          <fo:repeatable-page-master-reference master-reference="A4-resumo" />
        </fo:page-sequence-master>
        <fo:page-sequence-master master-name="resumo-equipamento">
          <fo:repeatable-page-master-reference master-reference="A4-equip" />
        </fo:page-sequence-master>
        <fo:page-sequence-master master-name="detalhe-fatura">
          <fo:repeatable-page-master-reference master-reference="A4-detalhe" />
        </fo:page-sequence-master>
        <fo:page-sequence-master master-name="detalhe-conta">
          <fo:repeatable-page-master-reference master-reference="A4-detalhe" />
        </fo:page-sequence-master>

        <!-- Páginas para a parte de FINANCIALS (extrato unificado, NF Telecom e Boletos) -->
        <fo:simple-page-master master-name="A4-extrato" page-height="29.7cm" page-width="21cm"
          margin-top="8mm" margin-bottom="7mm" margin-left="10mm" margin-right="10mm">
          <fo:region-body margin-top="60mm" margin-bottom="0mm" />
          <fo:region-before precedence="true" extent="61mm" />
          <fo:region-after extent="0mm" />
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="extrato-unificado">
          <fo:repeatable-page-master-reference master-reference="A4-extrato" />
        </fo:page-sequence-master>
        <fo:simple-page-master master-name="A4-NF" margin-right="10mm" margin-left="10mm"
          margin-bottom="10mm" margin-top="10mm" page-width="21cm" page-height="29.7cm">
          <fo:region-body margin-bottom="0mm" margin-top="0mm" />
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="nf">
          <fo:repeatable-page-master-reference master-reference="A4-NF" />
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <xsl:apply-templates select="INVOICE/BILL" />
      <xsl:apply-templates select="INVOICE/CUSTOMER[DETAILS or SUMMARY]" />
    </fo:root>
  </xsl:template>

  <xsl:template match="CUSTOMER">

    <!-- ****************** -->
    <!-- * Primeira parte * -->
    <!-- ****************** -->
    <fo:page-sequence master-reference="resumo-fatura-mensal" force-page-count="no-force">

      <!-- cabeçalho -->
      <fo:static-content flow-name="xsl-region-before">
        <xsl:call-template name="INVOICE_SUMMARY_HEADER">
          <xsl:with-param name="title">FATURA DE SERVIÇOS DE TELECOMUNICAÇÕES</xsl:with-param>
        </xsl:call-template>
      </fo:static-content>

<!--  Comentado, pois agora informações de débito automático aparecerá na página de
 		"Nota Fiscal Fatura de Serviço de Telecomunicações"

      - rodapé -

      <fo:static-content flow-name="xsl-region-after">
        <fo:block font-family="Helvetica" font-size="8pt">
          <xsl:for-each select="MESSAGES/M">
            <xsl:for-each select="xalan:tokenize(text(), '#')">
              <fo:block>
                <xsl:value-of select="." />
              </fo:block>
            </xsl:for-each>
            <fo:block space-after="2mm" />
          </xsl:for-each>

          <xsl:if test="/BILL/TELECOM/@FP">
            <fo:block>
              <xsl:text>Esta fatura possui débito automático em&#32;</xsl:text>
              <xsl:choose>
                <xsl:when test="/BILL/TELECOM/@FP = 'C'">
                  <xsl:text>cartão de crédito.</xsl:text>
                </xsl:when>
                <xsl:when test="/BILL/TELECOM/@FP = 'D'">
                  <xsl:text>conta corrente.</xsl:text>
                </xsl:when>
              </xsl:choose>
            </fo:block>
          </xsl:if>

        </fo:block>
      </fo:static-content>

-->

      <!-- corpo -->
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="RESUMO-FATURA-MENSAL" />
      </fo:flow>

    </fo:page-sequence>


    <xsl:apply-templates select="/INVOICE/BILL/TELECOM" />



    <!-- ***************** -->
    <!-- * Segunda parte * -->
    <!-- ***************** -->
    <fo:page-sequence master-reference="resumo-equipamento" force-page-count="no-force">

      <!-- cabeçalho -->
      <fo:static-content flow-name="xsl-region-before">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="title">RESUMO POR EQUIPAMENTO</xsl:with-param>
        </xsl:call-template>
      </fo:static-content>

      <!-- rodapé -->
      <fo:static-content flow-name="xsl-region-after" keep-with-next="always">
        <fo:block font-family="Helvetica" font-size="8pt">
          <fo:block text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm" />
          </fo:block>
          <fo:block>
            <xsl:text>
              Contribuição para FUST - 1% do valor dos serviços - não repassadas as tarifas Art 9
              Lei 9.998/2000
            </xsl:text>
          </fo:block>
          <fo:block>
            <xsl:text>
              Contribuição para o FUNTEL - 0,5% do valor dos serviços - não repassadas as tarifas
              Art 6 &#xA7; 6° Lei 10.052/2000
            </xsl:text>
          </fo:block>
        </fo:block>
      </fo:static-content>

      <!-- corpo -->
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="RESUMO-EQUIPAMENTO" />
      </fo:flow>

    </fo:page-sequence>

    <!-- **************************** -->
    <!-- * Terceira e quarta partes * -->
    <!-- **************************** -->
    <xsl:apply-templates select="./DETAILS/SUBSCRIBER/CONTRACT" mode="DETAILS" />

  </xsl:template>


  <!-- **************************** -->
  <!-- * Terceira e quarta partes * -->
  <!-- **************************** -->
  <xsl:template match="CONTRACT" mode="DETAILS">

    <!-- Só mostra se houver alguma coisa a mostrar -->
    <xsl:if test="@T!='0,00'">

      <!-- ****************** -->
      <!-- * Terceira parte * -->
      <!-- ****************** -->
      <fo:page-sequence master-reference="detalhe-fatura" force-page-count="no-force">

        <!-- cabeçalho -->
        <fo:static-content flow-name="xsl-region-before">
          <xsl:call-template name="HEADER">
            <xsl:with-param name="title">DETALHAMENTO DA FATURA</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="HEADER-DETALHE" />
        </fo:static-content>

        <!-- corpo -->
        <fo:flow flow-name="xsl-region-body">
          <xsl:call-template name="DETALHE-FATURA" />
        </fo:flow>

      </fo:page-sequence>

      <!-- **************** -->
      <!-- * Quarta parte * -->
      <!-- **************** -->
      <!-- Só mostra se houver alguma chamada de telefonia -->
      <xsl:if test="CALLS/HOME/@DNF!='0:00' or CALLS/ROAMING/@DNF!='0:00' or CALLS/HOME/@V!='0,00' or CALLS/ROAMING/@V!='0,00' or @PP='Y' or CALLS/IDCD/@V!='0,00' or CALLS/ONLINE/SVC[@ID='LOLGT']">
        <fo:page-sequence master-reference="detalhe-conta" force-page-count="no-force">

          <!-- cabeçalho -->
          <fo:static-content flow-name="xsl-region-before">
            <xsl:call-template name="HEADER">
              <xsl:with-param name="title">CONTA DETALHADA</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="HEADER-DETALHE" />
          </fo:static-content>

          <!-- corpo -->
          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="DETALHE-CONTA-SRV" />
            <xsl:call-template name="DETALHE-CONTA-ONLINE"/>
            <xsl:call-template name="DETALHE-CONTA" />
          </fo:flow>

        </fo:page-sequence>
      </xsl:if>
    </xsl:if>

  </xsl:template>


  <!-- ****************************************************** -->
  <!-- * Formatações dos cabeçalhos e corpos de cada página * -->
  <!-- ****************************************************** -->
  <xsl:include href="nextel_fatura_header.xsl" />
  <xsl:include href="nextel_fatura_resumo_fatura_mensal_header.xsl" />
  <xsl:include href="nextel_fatura_resumo_fatura_mensal.xsl" />
  <xsl:include href="nextel_fatura_resumo_equipamento.xsl" />
  <xsl:include href="nextel_fatura_detalhe_fatura.xsl" />
  <xsl:include href="nextel_fatura_detalhe_conta.xsl" />
  <xsl:include href="nextel_fatura_financials.xsl" />
  <xsl:include href="nextel_fatura_attributes.xsl" />

  <!-- Imprime o valor passado ou 0,00 -->
  <xsl:template name="VALOR-OU-ZERO">
    <xsl:param name="value">0,00</xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($value, '-')">
        <xsl:value-of select="concat('(', substring($value, 2), ')')" />
      </xsl:when>
      <xsl:when test="string-length($value) &gt; 0">
        <xsl:value-of select="$value" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0,00</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- coloca hífens em um número de telefone -->
  <xsl:template name="HIFENIZAR">
    <xsl:param name="number" />
    <xsl:variable name="null" select="phonenumber:parse(string($number))" />
    <xsl:value-of select="phonenumber:getHiphenized()" />
  </xsl:template>


  <!-- Substitui mês por extenso -->
  <xsl:template name="MES">
    <xsl:param name="mes" />
    <xsl:choose>
      <xsl:when test="$mes = '01'">
        <xsl:text>Janeiro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '02'">
        <xsl:text>Fevereiro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '03'">
        <xsl:text>Março</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '04'">
        <xsl:text>Abril</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '05'">
        <xsl:text>Maio</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '06'">
        <xsl:text>Junho</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '07'">
        <xsl:text>Julho</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '08'">
        <xsl:text>Agosto</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '09'">
        <xsl:text>Setembro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '10'">
        <xsl:text>Outubro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '11'">
        <xsl:text>Novembro</xsl:text>
      </xsl:when>
      <xsl:when test="$mes = '12'">
        <xsl:text>Dezembro</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
