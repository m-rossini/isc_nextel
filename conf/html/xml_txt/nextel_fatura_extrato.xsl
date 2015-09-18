<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



  <xsl:template match="EXTRATO">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">EXTRATO MENSAL UNIFICADO</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="formatParagraph">
      <xsl:with-param name="text">
        Caro cliente, os valores dos quadros Demonstrativo de Pagamentos e 
        Lançamentos Futuros (caso existam) são meramente informativos.
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
    <xsl:call-template name="formatParagraph">
      <xsl:with-param name="text">
        Os valores a pagar da fatura do mês corrente são descritos no quadro Fatura Atual.
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="DEMO" />
    <xsl:for-each select="MSGS/M[not(@IM=../../FUT/@IM)]">
      <xsl:call-template name="formatText">
        <xsl:with-param name="text">
          <xsl:if test="@IM">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@IM" />
            <xsl:text>)&#32;</xsl:text>
          </xsl:if>
          <xsl:value-of select="text()" />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:value-of select="$newline" />
      <xsl:if test="position() = last()">
        <xsl:value-of select="$newline" />
      </xsl:if>
    </xsl:for-each>

    <xsl:apply-templates select="FUT" />
    <xsl:for-each select="MSGS/M[@IM=../../FUT/@IM]">
      <xsl:call-template name="formatText">
        <xsl:with-param name="text">
          <xsl:if test="@IM">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@IM" />
            <xsl:text>)&#32;</xsl:text>
          </xsl:if>
          <xsl:value-of select="text()" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
      
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>



  <xsl:template match="DEMO">
    <xsl:apply-templates select="BAL"/>
    <xsl:apply-templates select="ATUAL" />
    
    <xsl:call-template name="printTotal">
      <xsl:with-param name="text">
        <xsl:text>Total Geral</xsl:text>
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="total" select="@T"/>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template match="BAL">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">DEMONSTRATIVO DE PAGAMENTOS - Histórico</xsl:with-param>
    </xsl:call-template>
  
    <xsl:apply-templates select="DEV"/>
    <xsl:apply-templates select="PGTO"/>
    
    <xsl:call-template name="printTotal">
      <xsl:with-param name="text">
        <xsl:text>Total até&#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(PGTO/@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;de&#32;</xsl:text>
        <xsl:value-of select="substring(PGTO/@DT,7)" />
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="total" select="@T"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="DEV">
    <xsl:call-template name="format2Col">
      <xsl:with-param name="col-1">
        <xsl:text>Informações de Saldos Devedores - até&#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;de&#32;</xsl:text>
        <xsl:value-of select="substring(@DT,7)" />
      </xsl:with-param>
      <xsl:with-param name="col-2" select="'Saldo Devedor'" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />

    <xsl:for-each select="IT">
      <xsl:call-template name="format2Col">
        <xsl:with-param name="col-1" select="@DS" />
        <xsl:with-param name="col-2" select="@V" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
    </xsl:for-each>

    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />
    <xsl:call-template name="format2Col">
      <xsl:with-param name="col-1">
        <xsl:text>Total Até&#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;de&#32;</xsl:text>
        <xsl:value-of select="substring(@DT,7)" />
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="col-2" select="@T" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>



  <xsl:template match="PGTO">
    <xsl:variable name="col-widths">
      <xsl:text>0.45</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.19</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.18</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.18</xsl:text>
    </xsl:variable>

    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:text>Histórico de Pagamentos - &#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;</xsl:text>
        <xsl:value-of select="substring(@DT,7)" />
        <xsl:value-of select="$colSep" />
        <xsl:text>Valores Faturados</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Valores Pagos</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Saldo Devedor</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />

    <xsl:for-each select="IT">
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:value-of select="@DS" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@VF" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@VP" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@V" />
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
    </xsl:for-each>

    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />
    <xsl:call-template name="format2Col">
      <xsl:with-param name="col-1">
        <xsl:text>Total de&#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;de&#32;</xsl:text>
        <xsl:value-of select="substring(@DT,7)" />
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="col-2" select="@T" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>



  <xsl:template match="ATUAL">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">FATURA ATUAL</xsl:with-param>
    </xsl:call-template>
  
    <xsl:variable name="col-widths">
      <xsl:text>0.50</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.30</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.20</xsl:text>
    </xsl:variable>

    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(GRP/@DT,4,2)" />
        </xsl:call-template>
        <xsl:text>&#32;de&#32;</xsl:text>
        <xsl:value-of select="substring(GRP/@DT,7)" />
        <xsl:text>&#32;- Vencimento em&#32;</xsl:text>
        <xsl:value-of select="GRP/@DV" />
        <xsl:value-of select="$colSep" />
        <xsl:text>N&#x00b0; do Boleto</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Total</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />
  
    <xsl:for-each select="GRP/IT">
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:value-of select="@DS" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@NB" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@V" />
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
    </xsl:for-each>
    
    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />
    <xsl:call-template name="format2Col">
      <xsl:with-param name="col-1">
        <xsl:text>Total da Fatura de&#32;</xsl:text>
        <xsl:call-template name="MES">
          <xsl:with-param name="mes" select="substring(GRP/@DT,4,2)" />
        </xsl:call-template>
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="col-2" select="@T" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>



  <xsl:template match="FUT">
    <xsl:call-template name="printTitle">
      <xsl:with-param name="text">
        <xsl:text>LANÇAMENTOS FUTUROS - Vencimentos após&#32;</xsl:text>
        <xsl:value-of select="@DT" />
      </xsl:with-param>
    </xsl:call-template>

    <xsl:variable name="col-widths">
      <xsl:text>0.45</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.15</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.10</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.15</xsl:text>
      <xsl:value-of select="$colSep" />
      <xsl:text>0.15</xsl:text>
    </xsl:variable>
    
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:text>Total de</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Parcelas</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Valor</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>Saldo Total</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols">
        <xsl:value-of select="$colSep" />
        <xsl:text>Parcelas</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>a Vencer</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>a Vencer</xsl:text>
        <xsl:value-of select="$colSep" />
        <xsl:text>a Vencer</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="widths" select="$col-widths" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$HR"/>
    <xsl:value-of select="$newline" />
  
    <xsl:for-each select="IT">
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols">
          <xsl:value-of select="@DS" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@NRP" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@NRPV" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@VPV" />
          <xsl:value-of select="$colSep" />
          <xsl:value-of select="@V" />
        </xsl:with-param>
        <xsl:with-param name="widths" select="$col-widths" />
      </xsl:call-template>
      <xsl:value-of select="$newline" />
    </xsl:for-each>
    
    <xsl:call-template name="printTotal">
      <xsl:with-param name="text">
        <xsl:text>Total e Lançamentos Futuros</xsl:text>
        <xsl:if test="@IM">
          <xsl:text>&#32;(</xsl:text>
          <xsl:value-of select="@IM" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="total" select="@T"/>
    </xsl:call-template>
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