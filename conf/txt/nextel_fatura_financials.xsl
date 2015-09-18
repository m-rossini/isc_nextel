<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
  exclude-result-prefixes="xalan barcode" version="1.0">

  <xsl:include href="nextel_fatura_extrato.xsl"/>
  <xsl:include href="nextel_fatura_telecom.xsl"/>
  <xsl:include href="nextel_fatura_compras_multas_negoc.xsl"/>


  <xsl:template match="/INVOICE/BILL">

    <xsl:apply-templates select="EXTRATO" />

    <xsl:if test="../CUSTOMER/MESSAGES/I">
      <xsl:for-each select="../CUSTOMER/MESSAGES/I">
        <xsl:for-each select="xalan:tokenize(text(),'#')">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:value-of select="$IF_startKey" />
              <xsl:value-of select="." />
              <xsl:value-of select="$delimiter" />
              <xsl:value-of select="$newline" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$IF_lineKey" />
              <xsl:value-of select="." />
              <xsl:value-of select="$delimiter" />
              <xsl:value-of select="$newline" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:value-of select="$IF_endKey" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>

    <xsl:apply-templates select="COMPRAS" />
    <xsl:apply-templates select="MULTAS" />
    <xsl:apply-templates select="NEGOC" />
    <xsl:apply-templates select="TELECOM" />

  </xsl:template>


  <!-- Para geração de todos os tipos de mensagens do Boleto e NF -->
  <xsl:template match="I | O | M" mode="financials">
    <xsl:param name="key" />
    <xsl:value-of select="$key" />
    <xsl:value-of select="./text()" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <!--
  A partir deste ponto, todos os templates são para
  geração das chaves de boletos.
  -->
  <xsl:template match="BOLETO">
    <xsl:param name="key-prefix" />

    <xsl:value-of select="concat($key-prefix,$BO_startKey)" />
    <xsl:value-of select="@NB" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CB" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@LD" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@LP1" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@LP2" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DV" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@S" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@AC" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DD" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NRD" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CE" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NN" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@C" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@M" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="barcode:buildBarCode(@CBB)" />
    <xsl:text>&gt;</xsl:text>
    <xsl:value-of select="$delimiter" />
<!--   EHO: abatimento e desconto  - Retenção de 9,45% - Cliente Governo   -->
          <xsl:value-of select="@VDA"/>
          <xsl:value-of select="$delimiter"/>

    <xsl:value-of select="@FP" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="SACADO">
      <xsl:with-param name="key-prefix" select="$key-prefix" />
    </xsl:apply-templates>

    <xsl:if test="INSTR_BANC/I">
      <xsl:apply-templates select="INSTR_BANC/I" mode="financials">
        <xsl:with-param name="key" select="concat($key-prefix,$BO_instrKey)" />
      </xsl:apply-templates>
      <xsl:value-of select="concat($key-prefix,$BO_instrEndKey)" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="SACADO">
    <xsl:param name="key-prefix" />
    <xsl:value-of select="concat($key-prefix,$BO_sacadoKey)" />
    <xsl:value-of select="@N" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@E" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CEP" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@CI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@ES" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>

  <xsl:template match="BOLETO_ARRECADACAO">
    <xsl:value-of select="$TC_BA_startKey" />
    <xsl:value-of select="@NC" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@IDDA" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@MR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DE" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DV" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@LD" />
    <xsl:value-of select="$delimiter" />
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="barcode:encodeForArrecadacaoBancaria(@CBB)" />
    <xsl:text>&gt;</xsl:text>
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message1Key" />
    <xsl:value-of select="MSGS/M3" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message2Key" />
    <xsl:value-of select="MSGS/M4" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message3Key" />
    <xsl:value-of select="MSGS/M5" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message4Key" />
    <xsl:value-of select="MSGS/M6" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message5Key" />
    <xsl:value-of select="MSGS/M7" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_message6Key" />
    <xsl:value-of select="MSGS/M8" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TC_BA_endKey" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>

</xsl:stylesheet>