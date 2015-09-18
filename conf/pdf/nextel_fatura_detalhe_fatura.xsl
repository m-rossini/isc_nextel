<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:xalan="http://xml.apache.org/xalan"
    exclude-result-prefixes="xalan"
    version="1.0">

    <!-- ************************************ -->
    <!-- * Resumo da fatura de cada usuário * -->
    <!-- ************************************ -->
    <xsl:template name="DETALHE-FATURA">

        <!-- Mensalidade. Mostra esse bloco só se houver alguma -->
        <xsl:if test="CHARGES/CHG[@TP='A']/SVC[@ID='ME' or @ID='DISPP' or @ID='TELAL']">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="7.5cm"/>
                    <fo:table-column column-width="5cm"/>
                    <fo:table-column column-width="2.7cm"/>
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell display-align="center" number-columns-spanned="4">
                                <fo:block font-weight="bold">
                                    MENSALIDADE
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" start-indent="10mm">
                                    <xsl:text>Período</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Plano de serviço</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Cobrança Proporcional</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:text>VALOR R$</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Mostra os dados de cada plano deste aparelho -->
                        <xsl:for-each select="CHARGES/CHG[@TP='A']/SVC[@ID='DISPP' or @ID='TELAL' or @ID='ME']">
                            <fo:table-row>
                                <fo:table-cell display-align="center">
                                    <fo:block start-indent="10mm">
                                        <xsl:value-of select="@S"/>
                                        <xsl:text> a </xsl:text>
                                        <xsl:value-of select="@E"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block>
                                        <xsl:value-of select="@TR"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block>
                                        <xsl:if test="@ST='d' or @ST='s'">
                                            <xsl:text>Devolução </xsl:text>
                                            <xsl:value-of select="@ND"/>
                                            <xsl:text> dia(s)</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="@ST='m'">
                                            <xsl:text>Cobrança </xsl:text>
                                            <xsl:value-of select="@ND"/>
                                            <xsl:text> dia(s)</xsl:text>
                                        </xsl:if>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block text-align="right">
                                        <xsl:call-template name="VALOR-OU-ZERO">
                                            <xsl:with-param name="value">
                                                <xsl:value-of select="@V"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                        <!-- Subtotal -->
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="@M"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Serviços adicionais/Serviços de terceiros. Mostra esse bloco só se houver algum -->
        <xsl:if test="CHARGES/CHG[@TP='A' or @TP='S' or @TP='U']/SVC[((@TP='A' or @TP='S') or (@TP='U' and @ID='CDIC')) and not (@ID='DISPP' or @ID='TELAL' or @ID='ME' or @ID='CLIRB' or @ID='CIRDT' or @ID='NMSIM' or @ID='NMPLS' or @ID='NMBAS' or @ID='SMST' or @ID='WP' or @ID='TWM' or @ID='WPTWM' or @ID='N200K' or @ID='MDD3' or @ID='N1200' or @ID='N2200' or @ID='N4200' or @ID='N5200' or @ID='N2300' or @ID='N3300' or @ID='N4300' or @ID='N5300' or @ID='N1600' or @ID='N2600' or @ID='N3600' or @ID='N4600' or @ID='N5600' or @ID='N11MB' or @ID='N21MB' or @ID='N31MB' or @ID='N41MB' or @ID='N51MB' or @ID='N13MB' or @ID='N23MB' or @ID='N33MB' or @ID='N43MB' or @ID='N53MB' or @ID='N110M' or @ID='N210M' or @ID='N310M' or @ID='N410M' or @ID='N510M' or @ID='MDD1' or @ID='MDD2' or @ID='MDD4' or @ID='MDD4' or @ID='N1300' or @ID='EQON' or @ID='NOWAS' or @ID='LONEX' or @ID='AGBKP' or @ID='EQLOC' or @ID='ITAUW' or @ID='ITAUA' or @ID='E930' or @ID='DOWN' or @ID='DOWNS' or @ID='GPSDA' )]">

            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="7.5cm"/>
                    <fo:table-column column-width="5cm"/>
                    <fo:table-column column-width="2.7cm"/>
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell display-align="center" number-columns-spanned="3">
                                <fo:block font-weight="bold">
                                    <xsl:text>SERVIÇOS ADICIONAIS</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" start-indent="10mm">
                                    <xsl:text>Período</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Plano de Serviço</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Cobrança Proporcional</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:text>VALOR R$</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Mostra todos os serviços adicionais desse aparelho -->
                        <xsl:for-each select="CHARGES/CHG[@TP='A' or @TP='S' or @TP='U']/SVC[((@TP='A' or @TP='S') or (@TP='U' and @ID='CDIC')) and not (@ID='DISPP' or @ID='TELAL' or @ID='ME' or @ID='CLIRB' or @ID='CIRDT' or @ID='NMSIM' or @ID='NMPLS' or @ID='NMBAS' or @ID='SMST' or @ID='WP' or @ID='TWM' or @ID='WPTWM' or @ID='N200K' or @ID='MDD3' or @ID='N1200' or @ID='N2200' or @ID='N4200' or @ID='N5200' or @ID='N2300' or @ID='N3300' or @ID='N4300' or @ID='N5300' or @ID='N1600' or @ID='N2600' or @ID='N3600' or @ID='N4600' or @ID='N5600' or @ID='N11MB' or @ID='N21MB' or @ID='N31MB' or @ID='N41MB' or @ID='N51MB' or @ID='N13MB' or @ID='N23MB' or @ID='N33MB' or @ID='N43MB' or @ID='N53MB' or @ID='N110M' or @ID='N210M' or @ID='N310M' or @ID='N410M' or @ID='N510M' or @ID='MDD1' or @ID='MDD2' or @ID='MDD4' or @ID='MDD4' or @ID='N1300' or @ID='EQON' or @ID='NOWAS' or @ID='LONEX' or @ID='AGBKP' or @ID='EQLOC' or @ID='ITAUW' or @ID='ITAUA' or @ID='E930' or @ID='DOWN' or @ID='DOWNS' or @ID='GPSDA' )]">
                            <!-- Serviço -->
                            <fo:table-row>
                                <fo:table-cell display-align="center">
                                    <fo:block start-indent="10mm">
                                        <xsl:value-of select="@S"/>
                                        <xsl:if test="string-length(@S) &gt; 0">
                                            <xsl:text> a </xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="@E"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block>
                                        <xsl:value-of select="@DS"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block>
                                        <xsl:if test="@ST='d' or @ST='s'">
                                            <xsl:text>Devolução </xsl:text>
                                            <xsl:value-of select="@ND"/>
                                            <xsl:text> dia(s)</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="@ST='m' and not (@TP='U' and @ID='CDIC' and @ND='0')">
                                            <xsl:text>Cobrança </xsl:text>
                                            <xsl:value-of select="@ND"/>
                                            <xsl:text> dia(s)</xsl:text>
                                        </xsl:if>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block text-align="right">
										<xsl:choose>
											<xsl:when test="@TP='U' and @ID='CDIC'">
												<!--CDI Diário aplicando o desconto -->																					
		                                        <xsl:call-template name="VALOR-OU-ZERO">
		                                            <xsl:with-param name="value">
	                                                    <xsl:choose> 
											                <xsl:when test="translate( translate(DCT/@V, '.',''), ',' , '.') &lt; 0">
				                                               <!-- <xsl:value-of select="translate( format-number( translate( translate(@V, '.',''), ',','.') + translate( translate(DCT/@V, '.',''), ',' , '.'), '#,###,##0.00'), '.' , ',')"/> -->
				                                               <!-- <xsl:value-of select="format-number(( translate( translate(@V, '.',','), ',','.') + translate( translate(DCT/@V, '.',','), ',' , '.')), '#.###.##0,00')"/> -->
				                                               <xsl:value-of select="format-number(( translate( translate(@V, '.',''), ',','.') + translate( translate(DCT/@V, '.',''), ',' , '.')), '#.###.##0,00')"/>				                                               
											                </xsl:when> 
											                <xsl:otherwise>
											                    <xsl:value-of select="@V"/>
											                </xsl:otherwise>
											            </xsl:choose>
		                                            </xsl:with-param>
		                                        </xsl:call-template>										
											</xsl:when>
											<xsl:otherwise>
		                                        <xsl:call-template name="VALOR-OU-ZERO">
		                                            <xsl:with-param name="value">
		                                                <xsl:value-of select="@V"/>
		                                            </xsl:with-param>
		                                        </xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <!-- Desconto -->							<xsl:if test="not (@TP='U' and @ID='CDIC')">        
	                            <xsl:for-each select="DCT">
	                                <fo:table-row>	                                    <fo:table-cell border-right="solid" border-color="white"/>	                                    <fo:table-cell display-align="center">	                                        <fo:block>	                                            <xsl:value-of select="@DS"/>	                                        </fo:block>	                                    </fo:table-cell>	                                    <fo:table-cell border-right="solid" border-color="white"/>	                                    <fo:table-cell display-align="center">	                                        <fo:block text-align="right">	                                            <xsl:call-template name="VALOR-OU-ZERO">	                                                <xsl:with-param name="value">	                                                    <xsl:value-of select="@V"/>	                                                </xsl:with-param>	                                            </xsl:call-template>	                                        </fo:block>	                                    </fo:table-cell>	                                </fo:table-row>
                            	</xsl:for-each>
							</xsl:if>
                        </xsl:for-each>
	                        
                        <!-- Subtotal -->
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="@A"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Conexão direta Nextel. Mostra esse bloco só se houver algum -->
        <xsl:if test="DISPATCH/DISPP">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="7.5cm"/>
                    <fo:table-column column-width="2cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="2.5cm"/>
                    <fo:table-column column-width="3.2cm"/>
                    <fo:table-header>
                        <xsl:call-template name="HEADER-SERVICO">
                            <xsl:with-param name="title">
                                <xsl:text>CONEXÃO DIRETA NEXTEL</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Mostra os planos referentes a Conexão Direta Nextel para este aparelho -->
                        <xsl:for-each select="DISPATCH/DISPP">
                            <xsl:call-template name="ROW-SERVICO">
                                <xsl:with-param name="col_1">
                                    <xsl:value-of select="@DS"/>
                                </xsl:with-param>
                                <xsl:with-param name="col_2">
                                    <xsl:value-of select="@DR_M"/>
                                </xsl:with-param>
                                <xsl:with-param name="col_3">
                                    <xsl:value-of select="@F_M"/>
                                </xsl:with-param>
                                <xsl:with-param name="col_4">
                                    <xsl:value-of select="@CH_M"/>
                                </xsl:with-param>
                                <xsl:with-param name="col_5">
                                    <xsl:value-of select="@V"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                        <!-- Subtotal -->
                        <xsl:call-template name="SUBTOTAL-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:value-of select="DISPATCH/@DR_M"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="DISPATCH/@F_M"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="DISPATCH/@CH_M"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="DISPATCH/@V"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Chamadas de telefonia dentro da área de registro. Só mostra se houver alguma -->
        <!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or CALLS/HOME/@CH!='0,00' or CALLS/HOME/@V!='0,00'"> -->
        <xsl:if test="CALLS/HOME/@DNF!='0:00' or CALLS/HOME/@CH!='0:00' or CALLS/HOME/@V!='0,00'">        
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="7.5cm"/>
                    <fo:table-column column-width="2cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="2.5cm"/>
                    <fo:table-column column-width="3.2cm"/>
                    <fo:table-header>
                        <xsl:call-template name="HEADER-SERVICO">
                            <xsl:with-param name="title">
                                <xsl:text>CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Chamadas locais -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Local</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas locais -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas de longa distância -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Longa Distância</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas longa -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas internacionais -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Internacional</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas internacionais -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas recebidas -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Recebidas</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/INCOMING/RECEIVED/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/INCOMING/RECEIVED/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/INCOMING/RECEIVED/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/INCOMING/RECEIVED/@V"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas recebidas a cobrar -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Recebidas a Cobrar</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas recebidas a cobrar -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/INCOMING/COLLECT/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Serviço 0300 -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Serviço 0300</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para serviço 0300 -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/OUTGOING/Z300/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Desconto para chamadas locais -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Desconto Promoção Me Liga</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/INCOMING/DISCOUNTS/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/HOME/INCOMING/DISCOUNTS/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Subtotal -->
                        <xsl:call-template name="SUBTOTAL-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:value-of select="CALLS/HOME/@DNF"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/HOME/@F"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/HOME/@CH"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/HOME/@V"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Chamadas de telefonia fora da área de registro. Só mostra se houver alguma -->
        <!-- <xsl:if test="CALLS/ROAMING/@DNF!='0,00' or CALLS/ROAMING/@CH!='0,00' or CALLS/ROAMING/@V!='0,00'"> -->
        <xsl:if test="CALLS/ROAMING/@DNF!='0:00' or CALLS/ROAMING/@CH!='0:00' or CALLS/ROAMING/@V!='0,00'">        
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="7.5cm"/>
                    <fo:table-column column-width="2cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="2.5cm"/>
                    <fo:table-column column-width="3.2cm"/>
                    <fo:table-header>
                        <xsl:call-template name="HEADER-SERVICO">
                            <xsl:with-param name="title">
                                <xsl:text>CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (Roaming)</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Chamadas originadas em roaming -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Originadas</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas originadas em roaming -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas recebidas em roaming -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Recebidas</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/RECEIVED/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/RECEIVED/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/RECEIVED/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/RECEIVED/@V"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Chamadas recebidas a cobrar em roaming -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Recebidas a Cobrar</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para chamadas recebidas a cobrar em roaming -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/COLLECT/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Serviço 0300 em roaming -->
                        <xsl:call-template name="ROW-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Serviço 0300</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@DA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@FA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@CHA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@VA"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Interconexão para serviço 0300 em roaming -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Interconexão</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/OUTGOING/Z300/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Desconto para chamadas roaming -->
                        <xsl:call-template name="ROW-INTERCONEXAO">
                            <xsl:with-param name="col_1">
                                <xsl:text>Desconto Promoção Me Liga</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <!-- EMPTY FIELD -->
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/DISCOUNTS/@CHT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_5">
                                <xsl:value-of select="CALLS/ROAMING/INCOMING/DISCOUNTS/@VT"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_6">
                                <xsl:value-of select="@PP"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <!-- Subtotal -->
                        <xsl:call-template name="SUBTOTAL-SERVICO">
                            <xsl:with-param name="col_1">
                                <xsl:value-of select="CALLS/ROAMING/@DNF"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_2">
                                <xsl:value-of select="CALLS/ROAMING/@F"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_3">
                                <xsl:value-of select="CALLS/ROAMING/@CH"/>
                            </xsl:with-param>
                            <xsl:with-param name="col_4">
                                <xsl:value-of select="CALLS/ROAMING/@V"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Serviços de Dados (Nextel OnLine). Mostra esse bloco só se houver algum -->
        <xsl:if test="SERVICES/ONLINE or SERVICES/TORPEDO or SERVICES/DOWNLOADS or SERVICES/SVC[@ID='LOLGT']">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="3cm"/>
                    <fo:table-column column-width="5.5cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="3.2cm"/>
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2">
                                <fo:block font-weight="bold">
                                    <xsl:text>NEXTEL ONLINE (SERVIÇOS DE DADOS)</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <xsl:if test="SERVICES/ONLINE[@ID='CIRDT']">
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="center">
                                        <xsl:text>Quantidade</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="center">
                                        <fo:block>Unidade</fo:block>
                                        <fo:block>de Medida</fo:block>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="right">
                                        <xsl:text>VALOR R$</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:if>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Mostra o serviço de transmissão de dados por circuito desse aparelho, se houver -->
                        <xsl:if test="SERVICES/ONLINE[@ID='CIRDT']">
                            <fo:table-row>
                                <fo:table-cell display-align="center" number-columns-spanned="2">
                                    <fo:block font-weight="bold" start-indent="10mm">
                                        <xsl:text>Transmissão de Dados por Circuito</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block text-align="right" end-indent="1.3cm">
                                        <xsl:call-template name="VALOR-OU-ZERO">
                                            <xsl:with-param name="value">
                                                <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@Q"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block text-align="right" end-indent="6mm">
                                        <xsl:text>min</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block text-align="right">
                                        <xsl:call-template name="VALOR-OU-ZERO">
                                            <xsl:with-param name="value">
                                                <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@V"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:if>
                        <!-- Mostra os serviços de transmissão de dados por pacote desse aparelho, se houver -->
                        <xsl:if test="SERVICES/ONLINE[not (@ID='CIRDT')]">
                            <fo:table-row>
                                <fo:table-cell display-align="center" number-columns-spanned="2">
                                    <fo:block font-weight="bold" start-indent="10mm">
                                        <xsl:text>Transmissão de Dados por Pacote</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="center">
                                        <xsl:text>Período</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="center">
                                        <xsl:text>Cobrança Proporcional</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-weight="bold" text-align="right">
                                        <xsl:text>VALOR R$</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <xsl:for-each select="SERVICES/ONLINE[not(@ID='CIRDT')]">
                                <fo:table-row>
                                    <fo:table-cell border-right="solid" border-color="white"/>
                                    <fo:table-cell display-align="center">
                                        <fo:block>
                                            <xsl:value-of select="@DS"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell display-align="center">
                                        <fo:block text-align="center">
                                            <xsl:value-of select="@S"/>
                                            <xsl:text> a </xsl:text>
                                            <xsl:value-of select="@E"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell display-align="center">
                                        <fo:block text-align="center">
                                            <xsl:if test="@ST='d' or @ST='s'">
                                                <xsl:text>Devolução </xsl:text>
                                                <xsl:value-of select="@ND"/>
                                                <xsl:text> dia(s)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test="@ST='m'">
                                                <xsl:text>Cobrança </xsl:text>
                                                <xsl:value-of select="@ND"/>
                                                <xsl:text> dia(s)</xsl:text>
                                            </xsl:if>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell display-align="center">
                                        <fo:block text-align="right">
                                            <xsl:call-template name="VALOR-OU-ZERO">
                                                <xsl:with-param name="value">
                                                    <xsl:value-of select="@V"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </xsl:if>
                    </fo:table-body>
                </fo:table>                <!-- ################ TORPEDO SMS/MMS ####################  -->                <!-- Mostra os serviços de torpedo desse aparelho, se houver --><!-- EHO: Mudança mms outras operadoras -->            <xsl:if test="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='DRin' or @ID='MMSI']"> 
                	<fo:block>                		<fo:table table-layout="fixed" space-before="1mm" space-after="1mm">                			<fo:table-column column-width="6cm" />                			<fo:table-column column-width="4.5cm" />                			<fo:table-column column-width="2.5cm" />                			<fo:table-column column-width="2.5cm" />                			<fo:table-column column-width="3.2cm" />                			<xsl:call-template name="HEADER-TP" />                			<fo:table-body><!-- EHO: Mudança mms outras operadoras -->
               				<xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='DRin' or @ID='MMSI']"> 
                					<xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />                					<xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />                				</xsl:apply-templates>                			</fo:table-body>                		</fo:table>                	</fo:block>                </xsl:if>                <!-- ############## FIM TORPEDO SMS/MMS ################## -->

                <!-- ################ LOCALIZADOR DIARIO ################# -->
                <!-- Mostra o serviço localizador diário, se houver -->

<!-- EHO: correção localizador diário
                <xsl:if test="SERVICES/SVC/@ID='LOLGT'" >
                    <fo:block>
                        <xsl:call-template name="LOLGT"/>
                    </fo:block>                
                </xsl:if>
-->
                <xsl:if test="CALLS/ONLINE/SVC[@ID='LOLGT']">
                	<fo:block>
                		<fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                			<fo:table-column column-width="6cm" />
                			<fo:table-column column-width="4.5cm" />
                			<fo:table-column column-width="2.5cm" />
                			<fo:table-column column-width="2.5cm" />
                			<fo:table-column column-width="3.2cm" />
                			<xsl:call-template name="LOLGT" />
                			<fo:table-body>
                				<xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='LOLGT' ]">
                					<xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />
                					<xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />
                				</xsl:apply-templates>
                			</fo:table-body>
                		</fo:table>
                	</fo:block>
                </xsl:if>
                <!-- ############## FIM LOCALIZADOR DIARIO ############### -->

                <!-- ################## DOWNLOAD ###################  -->
                <!-- Mostra os serviços de download de arquivos desse aparelho, se houver -->
                <xsl:if test="SERVICES/DOWNLOADS">
                    <fo:block>
                        <xsl:call-template name="DOWN"/>
                    </fo:block>
                </xsl:if>
                <!-- ################## FIM DOWNLOAD ##################### -->
                
                <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                    <fo:table-column column-width="3cm"/>
                    <fo:table-column column-width="5.5cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="3.2cm"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell display-align="center">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="@O"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
                <fo:block text-align-last="justify">
                  <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                </fo:block>
            </fo:block>
        </xsl:if>
        <!-- Total do usuário -->
        <fo:block font-family="Helvetica" font-size="10pt" font-weight="bold">
            <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                <fo:table-column column-width="12cm"/>
                <fo:table-column column-width="4.5cm"/>
                <fo:table-column column-width="2.2cm"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell border-right="solid" border-color="white"/>
                        <fo:table-cell display-align="center" border-bottom-style="solid" border-bottom-width="0.1mm">
                            <fo:block>
                                <xsl:text>TOTAL DO USUÁRIO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" border-bottom-style="solid" border-bottom-width="0.1mm">
                            <fo:block font-size="11pt" text-align="right">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    <!-- ****************************************************** -->
    <!-- * Cabeçalho de cada listagem dos serviços utilizados * -->
    <!-- ****************************************************** -->
    <xsl:template name="HEADER-SERVICO">
        <xsl:param name="title"/>
        <fo:table-row>
            <fo:table-cell display-align="center" number-columns-spanned="6">
                <fo:block font-weight="bold">
                    <xsl:value-of select="$title"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" start-indent="10mm">
                    <xsl:text>Tipo de Chamada</xsl:text>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>Total</xsl:text>
                </fo:block>
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>(min)</xsl:text>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>Franquia Utilizada</xsl:text>
                </fo:block>
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>(min)</xsl:text>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>Minutos</xsl:text>
                </fo:block>
                <fo:block font-weight="bold" text-align="center">
                    <xsl:text>a Pagar</xsl:text>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="right">
                    <xsl:text>VALOR R$</xsl:text>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <!-- *********************************************************************************** -->
    <!-- * Cada linha indica um serviço. Os valores das colunas são parâmetros do template * -->
    <!-- *********************************************************************************** -->
    <xsl:template name="ROW-SERVICO">
        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <xsl:param name="col_5"/>
        <xsl:param name="col_6">N</xsl:param>
        <!-- Só mostra se houver minutos -->
        <!-- <xsl:if test="($col_2!='0,00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')"> -->
        <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='')">        
            <fo:table-row>
                <fo:table-cell display-align="center">
                    <fo:block start-indent="10mm">
                        <xsl:value-of select="$col_1"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="6mm">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_2"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="1.3cm">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_3"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="6mm">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_4"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_5"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>
    <!-- *********************************************************************************** -->
    <!-- * Cada linha indica um serviço. Os valores das colunas são parâmetros do template * -->
    <!-- *********************************************************************************** -->
    <xsl:template name="ROW-INTERCONEXAO">
        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <xsl:param name="col_5"/>
        <xsl:param name="col_6">N</xsl:param>
        <!-- Só mostra se houver minutos -->
        <!-- <xsl:if test="($col_2!='0,00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')"> -->
        <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='')">
            <fo:table-row>
                <fo:table-cell display-align="center">
                    <fo:block start-indent="10mm">
                        <xsl:value-of select="$col_1"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="6mm">
                        <xsl:value-of select="$col_2"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="1.3cm">
                        <xsl:value-of select="$col_3"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right" end-indent="6mm">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_4"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                    <fo:block text-align="right">
                        <xsl:call-template name="VALOR-OU-ZERO">
                            <xsl:with-param name="value">
                                <xsl:value-of select="$col_5"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>
    <!-- ********************************************************************************* -->
    <!-- * Mostra a linha de subtotal. Os valores das colunas são parâmetros do template * -->
    <!-- ********************************************************************************* -->
    <xsl:template name="SUBTOTAL-SERVICO">
        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <fo:table-row>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" start-indent="10mm">
                    Subtotal
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="right" end-indent="6mm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="$col_1"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="right" end-indent="1.3cm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="$col_2"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="right" end-indent="6mm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="$col_3"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block font-weight="bold" text-align="right">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="$col_4"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <!-- ######## Downloads  ######## -->
    <xsl:template name="DOWN">
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="6cm"/>
            <fo:table-column column-width="4.5cm"/>
            <fo:table-column column-width="2.5cm"/>
            <fo:table-column column-width="2.5cm"/>
            <fo:table-column column-width="3.2cm"/>
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" start-indent="10mm">
                            <xsl:text>NEXTEL DOWNLOADS</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Período</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Quantidade</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="right">
                            <xsl:text>VALOR R$</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell display-align="center">
                        <fo:block start-indent="20mm">
                            <xsl:value-of select="SERVICES/DOWNLOADS/@DS"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block text-align="center">
                            <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                            <xsl:text> a </xsl:text>
                            <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block text-align="center">
                            <xsl:value-of select="SERVICES/DOWNLOADS/@Q"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block text-align="right">
                            <xsl:value-of select="SERVICES/DOWNLOADS/@V"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <xsl:call-template name="REP-DW">
            <xsl:with-param name="downloads" select="SERVICES/DOWNLOADS"/>
        </xsl:call-template>
        
    </xsl:template>


    <!-- ######## Torpedos  ######## -->
    <xsl:template name="HEADER-TP">
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" start-indent="10mm">
                            <xsl:text>Envio de Mensagens</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Período</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Quantidade</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>V. UNIT. R$</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="right">
                            <xsl:text>VALOR R$</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
    </xsl:template>

    <!-- Linha Detalhe do Torpedo e Localizador-->
    <xsl:template match="SVC">
    <xsl:param name="start"/>
    <xsl:param name="end"/>

    <!--EHO: correção localizador diário  -->

    <!-- ######## Localizador  ######## -->
    <xsl:if test="@ID='LOLGT'">    
    	<fo:table-row>
	       <fo:table-cell display-align="center">
		     <fo:block start-indent="20mm">
		        <xsl:value-of select="@DS"/>
		     </fo:block>
	       </fo:table-cell>
	       <fo:table-cell display-align="center">
		      <fo:block text-align="center">
		         <xsl:value-of select="$start"/>
		            <xsl:text> a </xsl:text>
		         <xsl:value-of select="$end"/>
		      </fo:block>
	       </fo:table-cell>
	       <fo:table-cell display-align="center">
		      <fo:block text-align="center">
		         <xsl:value-of select="@Q"/>
		      </fo:block>
	       </fo:table-cell>
	       <fo:table-cell display-align="center">
		      <fo:block text-align="center">
		         <xsl:text>  </xsl:text>
		      </fo:block>
	       </fo:table-cell>
           <fo:table-cell display-align="center">
		      <fo:block text-align="right">
		        <xsl:call-template name="VALOR-OU-ZERO">
			       <xsl:with-param name="value">
			           <xsl:value-of select="@V"/>
			       </xsl:with-param>
		        </xsl:call-template>
		      </fo:block>
	       </fo:table-cell>
	    </fo:table-row>
    </xsl:if>
    <!-- ######## END Localizador  ######## -->

    <!-- ######## Torpedos  ######## -->
    <xsl:if test="@ID!='LOLGT'">    
	   <fo:table-row>
	      <fo:table-cell display-align="center">
		     <fo:block start-indent="20mm">
		        <xsl:value-of select="@DS"/>
		     </fo:block>
	      </fo:table-cell>
	      <fo:table-cell display-align="center">
	     	 <fo:block text-align="center">
		        <xsl:value-of select="$start"/>
		           <xsl:text> a </xsl:text>
		        <xsl:value-of select="$end"/>
		     </fo:block>
	      </fo:table-cell>
	      <fo:table-cell display-align="center">
		     <fo:block text-align="center">
		        <xsl:value-of select="@Q"/>
		     </fo:block>
	      </fo:table-cell>
          <!--  Não Demonstra Valor Unitário para Serviços Interativos (SMSSI)  -->
          <xsl:if test="@ID!='SMSSI'">
             <fo:table-cell border-right="solid" border-color="white" display-align="center">
               <fo:block text-align="center">
                 <!-- <xsl:value-of select="@U"/> -->
                  <!-- <xsl:value-of select="translate(format-number((translate(@V, ',' , '.') div translate(@Q, ',' , '.')), '##0.00'), '.' , ',')" />  -->
<!-- EHO: correção arredondamento do valor unitário do Torpedo / promoção 5 sms -->
<!--                         <xsl:value-of select="translate((translate(@V, ',' , '.') div translate(@Q, ',' , '.')), '.' , ',')" /> -->
          <xsl:if test="@Q='0'">
                <xsl:value-of select="format-number(translate(@V, ',' , '.') div 1 ,'#.##0,00')" />                                       
          </xsl:if>
          <xsl:if test="@Q!='0'">
                <xsl:value-of select="format-number(translate(@V, ',' , '.') div translate(@Q, ',' , '.'),'#.##0,00')" />                                       
          </xsl:if>

               </fo:block>
             </fo:table-cell>
          </xsl:if>
          <xsl:if test="@ID='SMSSI'">
             <fo:table-cell border-right="solid" border-color="white" display-align="center">
               <fo:block text-align="center">
                 <xsl:text>-</xsl:text>
               </fo:block>
             </fo:table-cell>
          </xsl:if>
          <fo:table-cell display-align="center">
		     <fo:block text-align="right">
		       <xsl:call-template name="VALOR-OU-ZERO">
		   	      <xsl:with-param name="value">
			         <xsl:value-of select="@V"/>
			      </xsl:with-param>
		       </xsl:call-template>
		     </fo:block>
	      </fo:table-cell>
	   </fo:table-row>
    </xsl:if>
    <!-- ######## END Torpedos  ######## -->
    </xsl:template>


    <!-- tabela repetivel -->
    <xsl:template name="REP-DW">
        <xsl:param name="downloads"/>
        <!-- Descritivo  downloads -->
        <fo:block font-family="Helvetica" font-size="6pt">
            <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
                <fo:table-column column-width="6cm"/>
                <fo:table-column column-width="1cm"/>
                <fo:table-column column-width="2cm"/>
                <fo:table-column column-width="5cm"/>
                <fo:table-column column-width="2.4cm"/>
                <fo:table-column column-width="2.3cm"/>
                <fo:table-header>
                    <fo:table-row>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" start-indent="10mm">
                                <xsl:text>Downloads - Descritivo</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>Data</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>Hora</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" text-align="center" end-indent="1cm">
                                <xsl:text>Nome</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>Tipo</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block font-weight="bold" text-align="right">
                                <xsl:text>V. UNIT. R$</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:apply-templates select="$downloads//DL"> 
                      <xsl:sort select="@MN" data-type="number"/>
                    </xsl:apply-templates>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    <!-- linhas do download -->
    <xsl:template match="DL">
        <fo:table-row>
            <fo:table-cell display-align="center">
                <fo:block start-indent="20mm"/>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block text-align="center">
                    <xsl:value-of select="@DT"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block text-align="center">
                    <xsl:value-of select="@TM"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block text-align="start">
                    <xsl:value-of select="@DS"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
                <fo:block text-align="start" start-indent="5mm">
                    <xsl:value-of select="@T"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" number-columns-spanned="2">
                <fo:block text-align="right">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value" select="@VU"/>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    
    <!-- ######## Localizador Diário  ######## -->

    <xsl:template name="LOLGT">
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" start-indent="10mm">
                            <xsl:text>Localizador Nextel</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Período</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text>Quantidade</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            <xsl:text> </xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block font-weight="bold" text-align="right">
                            <xsl:text>VALOR R$</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
    </xsl:template>

 <!--EHO: correção localizador diário

    <xsl:template name="LOLGT">
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="6cm"/>
            <fo:table-column column-width="4.5cm"/>
            <fo:table-column column-width="2.5cm"/>
            <fo:table-column column-width="2.5cm"/>
            <fo:table-column column-width="3.2cm"/>
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" start-indent="10mm">
                            Localizador Nextel
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            Período
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            Quantidade
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                            VALOR R$
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block start-indent="20mm">
                            <xsl:value-of select="CALLS/ONLINE/SVC/@DS"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block text-align="center">
                            <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                            <xsl:text> a </xsl:text>
                            <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block text-align="center">
                            <xsl:value-of select="CALLS/ONLINE/SVC/@Q"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block font-weight="bold" text-align="center">
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-right="solid" border-color="white" display-align="center">
                        <fo:block text-align="center">
                            <xsl:value-of select="CALLS/ONLINE/SVC/@V"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
   </xsl:template>
  -->

<!-- conf/pdf/nextel_fatura_detalhe_fatura.xsl -->     
</xsl:stylesheet>