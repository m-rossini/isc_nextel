<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
                xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
                xmlns:xalan="http://xml.apache.org/xalan"
                extension-element-prefixes="xalan number string"
                version="1.0">


    <!-- ******************************************** -->
    <!-- * Extrato Conta Corrente (Segunda parte)   * -->
    <!-- ******************************************** -->
	<xsl:template name="EXTRATO-CONTA-CORRENTE">
        <fo:block font-family="Helvetica" font-size="7.5pt">
            <!-- Primeira tabela da conta corrente- Extrato da conta -->
            <xsl:call-template name="SUBTOTAL"/>
            <xsl:call-template name="TABELA_EXTRATO"/>
            <xsl:call-template name="SUBTOTAL_FINAL"/>
            <xsl:call-template name="OBSERVACAO"/>
            <!--  NÃO ENTRARÁ MAIS: Segunda tabela da conta corrente-  Lançamentos futuros -->
            <!-- <xsl:call-template name="LANCAMENTOS"/> -->
            <!-- Terceira tabela da conta corrente- Despesas com cartão de crédito -->
            <xsl:call-template name="DESPESAS"/> 
        </fo:block>
        <!-- Final do extrato da conta corrente -->
    </xsl:template>

    <xsl:template name="SUBTOTAL">
        <!-- Subtotal da página -->
        <fo:table table-layout="fixed" height="2mm">
            <fo:table-column column-width="17.1mm"/>
            <fo:table-column column-width="19mm"/>
            <fo:table-column column-width="69.8mm"/>
            <fo:table-column column-width="28.6mm"/>
            <fo:table-column column-width="25.4mm"/>
            <fo:table-column column-width="25.4mm"/>
            <fo:table-body>
                <fo:table-row height="5mm">
                    <fo:table-cell display-align="center" number-columns-spanned="5"
                        border-bottom-style="solid" border-bottom-width="0.01mm">
                        <fo:block text-align="end"  font-weight="bold" margin-left="1.5mm" margin-right="1.5mm">
                            SALDO EM <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center" border-top-style="solid" border-top-width="0.01mm"
                        border-bottom-style="solid" border-bottom-width="0.01mm"
                        border-left-style="solid"   border-left-width="0.01mm"
                        border-right-style="solid"  border-right-width="0.01mm">
                        <fo:block text-align="end"  font-weight="bold" margin-left="1.5mm" margin-right="1.5mm">
                            <xsl:call-template name="VALOR-OU-ZERO">
                                <xsl:with-param name="value">
                                    <xsl:value-of select="'1.560,63'"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="3mm"><!-- Necessário para dar espaço no layout --></fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="SUBTOTAL_FINAL">
        <fo:table table-layout="fixed" height="2mm">
            <fo:table-column column-width="17.1mm"/>
            <fo:table-column column-width="19mm"/>
            <fo:table-column column-width="69.8mm"/>
            <fo:table-column column-width="28.6mm"/>
            <fo:table-column column-width="25.4mm"/>
            <fo:table-column column-width="25.4mm"/>
            <fo:table-body>
                <fo:table-row height="5mm" space-before="10mm" space-after="10mm">
                    <fo:table-cell display-align="center"
                        number-columns-spanned="5"
                        border-top-style="solid"    border-top-width="0.01mm">
                        <fo:block text-align="end"  font-weight="bold" margin-left="1.5mm" margin-right="1.5mm">
                            SALDO EM <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        border-top-style="solid"    border-top-width="0.01mm"
                        border-bottom-style="solid" border-bottom-width="0.01mm"
                        border-left-style="solid"   border-left-width="0.01mm"
                        border-right-style="solid"  border-right-width="0.01mm">
                        <fo:block text-align="end"  font-weight="bold" margin-left="1.5mm" margin-right="1.5mm">
                            <xsl:call-template name="VALOR-OU-ZERO">
                                <xsl:with-param name="value">
                                    <xsl:value-of select="'0,00'"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="5mm"><!-- Necessário para dar espaço no layout --></fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="OBSERVACAO">
        <fo:table table-layout="fixed" height="1.5cm" space-before.optimum="2mm">
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="170mm"/>
            <fo:table-body>
                <fo:table-row height="2mm">
                    <fo:table-cell>
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            Obs.:
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-size="7.5pt" text-align="start">
                            Pode haver uma defasagem de até 5 dias entre o pagamento de um título e sua respectiva baixa no
                            sistema de controle. 
                            Caso você tenha feito algum pagamento que não foi relacionado acima, favor desconsiderar o 
                            Saldo final.
                        </fo:block>                        
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="TABELA_EXTRATO">
        <!-- Mostra todos os movimentos dessa conta mais o subtotal -->
        <fo:table table-layout="fixed" height="1.5cm" >
            <fo:table-column column-width="17.1mm"/>
            <fo:table-column column-width="19mm"/>
            <fo:table-column column-width="69.8mm"/>
            <fo:table-column column-width="28.6mm"/>
            <fo:table-column column-width="25.4mm"/>
            <fo:table-column column-width="25.4mm"/>
            <!-- O cabeçalho da tabela -->
            <fo:table-header>
                <fo:table-row height="9mm">
                    <fo:table-cell display-align="center" 
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DATA
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center" 
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            TÍTULO
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DESCRIÇÃO
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DESPESAS REALIZADAS
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            PAGAMENTOS EFETUADOS
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm"
                        border-right-style="solid"  border-right-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            SALDO
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="0.1mm"></fo:table-row>                    
            </fo:table-header>
            <fo:table-body border-after-style="solid" border-after-width="0.1mm">
                <!-- Mostra as movimentações dessa conta -->
                <xsl:call-template name="TABELA_EXTRATO_DETALHES">
                    <xsl:with-param name="number">
                        <xsl:value-of select="'1'"/>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="TABELA_EXTRATO_DETALHES">
        <xsl:param name="number"></xsl:param>
        <number:setValue name="valor" value="1"/>
        <string:setValue name="bgcolor" value="#EEEEEE"/>
        
        <xsl:for-each select="//node()[position() &lt;= $number]">
            <xsl:if test="((number:getValue('valor') mod 2.0) = 1)">
                <xsl:variable name="null" select="string:setValue('bgcolor', '#EEEEEE')"/>
            </xsl:if>
            <xsl:if test="((number:getValue('valor') mod 2.0) = 0)">
                <xsl:variable name="null" select="string:setValue('bgcolor', 'transparent')"/>
            </xsl:if>

            <xsl:variable name="null" select="number:setValue('valor', number:getValue('valor') + number('1'))"/>
            <!--  background-color="{string:getValue('bgcolor')}" -->
            <fo:table-row height="5mm">  
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm" >
                    <fo:block margin-left="1.5mm" margin-right="1.5mm" >
                        <!-- DATA -->
                        <xsl:text>15/12/2003</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm" text-align="center">
                        <!-- TÍTULO -->
                        <xsl:text>XXXXXXX</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DESCRIÇÃO -->
                        <xsl:text>Assistência Técnica - Parcela 1/3 - venc: 04/01/04</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DESPESAS REALIZADAS -->
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="'90,00'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- PAGAMENTOS EFETUADOS -->
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="'-65,00'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm"
                    border-right-style="solid" border-right-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- SALDO -->
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="'1.650,63'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each> 
    </xsl:template>

    <xsl:template name="LANCAMENTOS">
        <fo:table table-layout="fixed" height="2.5cm" space-before="1mm">
            <fo:table-column column-width="17.1mm"/>
            <fo:table-column column-width="19mm"/>
            <fo:table-column column-width="90mm"/>
            <fo:table-column column-width="28.6mm"/>
            <fo:table-column column-width="30.4mm"/>

            <!-- O cabeçalho da tabela -->
            <fo:table-header>
                <fo:table-row height="8mm">
                    <fo:table-cell display-align="center"
                        number-columns-spanned="6">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center" text-decoration="underline">
                            LANÇAMENTOS FUTUROS
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="5mm">
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DATA
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            TÍTULO
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DESCRIÇÃO
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DESPESAS REALIZADAS
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm"
                        border-right-style="solid" border-right-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            VENCIMENTO
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="4mm" space-after="3mm"></fo:table-row>                    
            </fo:table-header>
            <fo:table-body border-after-style="solid" border-after-width="0.1mm">
                <xsl:call-template name="LANCAMENTOS_DETALHES"> 
                    <xsl:with-param name="number">
                        <xsl:value-of select="'1'"/>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- ********************************************************* -->
    <!-- * Dados da tabela lançamentos futuros de conta corrente * -->
    <!-- ********************************************************* -->
    <xsl:template name="LANCAMENTOS_DETALHES">
        <xsl:param name="number"></xsl:param>

        <number:setValue name="valor" value="1"/>
        <string:setValue name="bgcolor" value="#EEEEEE"/>
        
        <xsl:for-each select="//node()[position() &lt;= $number]">
            <xsl:if test="((number:getValue('valor') mod 2.0) = 1)">
                <xsl:variable name="null" select="string:setValue('bgcolor', '#EEEEEE')"/>
            </xsl:if>
            <xsl:if test="((number:getValue('valor') mod 2.0) = 0)">
                <xsl:variable name="null" select="string:setValue('bgcolor', '#FFFFFF')"/>
            </xsl:if>

            <xsl:variable name="null" select="number:setValue('valor', number:getValue('valor') + number('1'))"/>
            <!-- background-color="{string:getValue('bgcolor')}" -->
            <fo:table-row height="5mm" >
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DATA -->
                        <xsl:text>15/12/2003</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm"  text-align="center">
                        <!-- TÍTULO -->
                        <xsl:text>XXXXXXX</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DESCRIÇÃO -->
                        <xsl:text>Assistência Técnica - Parcela 2/3 - venc: 14/04/04</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DESPESAS REALIZADAS -->
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="'91,00'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm"
                    border-right-style="solid" border-right-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- VENCIMENTO -->
                        <xsl:text>14/01/2004</xsl:text>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each>
    </xsl:template>
    <!-- Despesas -->
    <xsl:template name="DESPESAS">
        <fo:table table-layout="fixed" height="2.5cm" space-before="5mm"> 
            <fo:table-column column-width="20mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="90mm"/>
            <fo:table-column column-width="38.6mm"/>
            <fo:table-column column-width="26.5mm"/>
            <!-- O cabeçalho da tabela -->
            <fo:table-header>
                <fo:table-row height="8mm">
                    <fo:table-cell display-align="center"
                        number-columns-spanned="6">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center" text-decoration="underline">
                            DESPESAS PAGAS COM CARTÃO DE CRÉDITO
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="5mm" space-after="3mm">
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        number-columns-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DATA
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            DESCRIÇÃO
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            OPERADORA
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center"
                        number-rows-spanned="2"
                        border-top-style="solid"    border-top-width="0.2mm"
                        border-bottom-style="solid" border-bottom-width="0.2mm"
                        border-left-style="solid"   border-left-width="0.01mm" 
                        border-right-style="solid"   border-right-width="0.01mm">
                        <fo:block font-size="7.5pt" font-weight="bold" text-align="center">
                            VALOR TOTAL
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="3mm" space-after="3mm">
                    <fo:table-cell number-columns-spanned="5" border-bottom-style="solid" border-bottom-width="0.2mm">
                    </fo:table-cell>
                </fo:table-row>                    
            </fo:table-header>

            <fo:table-body border-after-style="solid" border-after-width="0.1mm">
                <xsl:call-template name="DESPESAS_DETALHES"> 
                    <xsl:with-param name="number">
                        <xsl:value-of select="'1'"/>
                    </xsl:with-param>
                </xsl:call-template>
        </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- ************************************************************************** -->
    <!-- * Dados da tabela despesas pagas com cartão de crédito na conta corrente * -->
    <!-- ************************************************************************** -->
    <xsl:template name="DESPESAS_DETALHES">
        <xsl:param name="number"></xsl:param>

        <number:setValue name="valor" value="1"/>
        <string:setValue name="bgcolor" value="#EEEEEE"/>
        
        <xsl:for-each select="//node()[position() &lt;= $number]"> 
            <xsl:if test="((number:getValue('valor') mod 2.0) = 1)">
                <xsl:variable name="null" select="string:setValue('bgcolor', '#EEEEEE')"/>
            </xsl:if>
            <xsl:if test="((number:getValue('valor') mod 2.0) = 0)">
                <xsl:variable name="null" select="string:setValue('bgcolor', '#FFFFFF')"/>
            </xsl:if>

            <xsl:variable name="null" select="number:setValue('valor', number:getValue('valor') + number('1'))"/>
            <!--  background-color="{string:getValue('bgcolor')}" -->
            <fo:table-row height="5mm">
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm"
                    number-columns-spanned="2">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm" text-align="center">
                        <!-- DATA -->
                        <xsl:text>15/12/2003</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block margin-left="1.5mm" margin-right="1.5mm">
                        <!-- DESCRIÇÃO -->
                        <xsl:text>Aquisição de Acessórios - 6 parcelas</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                    <fo:block text-align="center" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- OPERADORA -->
                        <xsl:text>Mastercard</xsl:text>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm"
                    border-right-style="solid"   border-right-width="0.01mm">
                    <fo:block text-align="end" margin-left="1.5mm" margin-right="1.5mm">
                        <!-- VALOR TOTAL -->
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="'600,30'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:for-each> 
    </xsl:template>
</xsl:stylesheet>