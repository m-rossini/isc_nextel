<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:xalan="http://xml.apache.org/xalan"
  exclude-result-prefixes="xalan"
  version="1.0">
  
    <!-- **************************************************** -->
    <!-- * Resumo da fatura atual (Corpo da primeira parte) * -->
    <!-- **************************************************** -->
	<xsl:template name="RESUMO-FATURA-MENSAL">

        <!-- Fatura atual -->
        <fo:block font-family="Helvetica" font-size="10pt" space-before="2mm" space-after="2mm">
            <fo:table table-layout="fixed">
                <fo:table-column column-width="13cm"/>
                <fo:table-column column-width="38mm"/>
                <fo:table-column column-width="5mm"/>
                <fo:table-column column-width="12mm"/>
                <fo:table-body>
                  	<fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="2mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          	</fo:table-row>                   
                    <fo:table-row>
                        <fo:table-cell  padding-top="2mm">
                            <fo:block font-size="12pt" font-weight="bold" display-align="center">
                              <xsl:text>FATURA DE SERVIÇOS DE TELECOMUNICAÇÕES</xsl:text>
                            </fo:block>
                            <fo:block font-weight="normal">
                              <xsl:text>(Total de Gastos no período - EM R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  padding-top="2mm" display-align="center" number-columns-spanned="3">
                            <fo:block font-size="9pt" font-weight="bold" text-align="right">
                              <xsl:text>VALOR</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		            </fo:table-row>                      
                    <!-- Mensalidades -->   
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                              <xsl:text>MENSALIDADES</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@M"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		            </fo:table-row>                 
                    <!-- Serviços adicionais -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>SERVIÇOS ADICIONAIS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@A"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		            </fo:table-row>                     
                    <!-- Conexão direta Nextel -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                               <xsl:text>CONEXÃO DIRETA NEXTEL</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@D"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		            </fo:table-row>                     
                    <!-- Chamadas de telefonia dentro da área de registro -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS LOCAIS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@LC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS DE LONGA DISTÂNCIA</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@LD"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS RECEBIDAS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@R"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS RECEBIDAS A COBRAR</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@RC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS INTERNACIONAIS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@I"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>SERVIÇO 0300</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/HOME/@Z3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
                        <fo:table-row>
                            <fo:table-cell display-align="center" padding-top="1mm">
                                <fo:block start-indent="18mm">
                                    <xsl:text>DESCONTO PROMOÇÃO ME LIGA</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center" padding-top="1mm">
                                <fo:block text-align="end">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="SUMMARY/HOME/@DC"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                    <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		            </fo:table-row>                    
                    <!-- Chamadas de telefonia fora da área de registro -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" number-columns-spanned="2" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (EM ROAMING)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="2" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@T"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS ORIGINADAS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@DNOZ3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS RECEBIDAS</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@R"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>CHAMADAS RECEBIDAS A COBRAR</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@RC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>SERVIÇO 0300</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/ROAMING/@Z3"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <!-- Descontos da Promoção ME LIGA - mostra só se tiver o plano DM* -->
                    <xsl:if test="count(DETAILS/SUBSCRIBER/CONTRACT/CHARGES/CHG/SVC[starts-with(@TR,'DM')]) &gt; 0">
                        <fo:table-row>
                            <fo:table-cell display-align="center" padding-top="1mm">
                                <fo:block start-indent="18mm">
                                    <xsl:text>DESCONTO PROMOÇÃO ME LIGA</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center" padding-top="1mm">
                                <fo:block text-align="end">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="SUMMARY/ROAMING/@DC"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>    
                   <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          </fo:table-row>                      
                    <!-- Serviços de dados -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>NEXTEL ONLINE (SERVIÇOS DE DADOS)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@O"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>

                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block start-indent="18mm">
                                <xsl:text>NEXTEL TORPEDO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" padding-top="1mm">
                            <fo:block text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@TP"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                   <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          </fo:table-row>                                      
                    <!-- Serviços adicionais corporativos -->
                    <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="2mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>AJUSTES</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@C"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                   <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          </fo:table-row>                                          
                  <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="2mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>CRÉDITO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@C1"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                  </fo:table-row>                                                                        
                  <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          </fo:table-row>                                              
                  <fo:table-row>
                        <fo:table-cell display-align="center" padding-top="2mm">
                            <fo:block font-weight="bold" start-indent="11mm">
                                <xsl:text>JUROS/MULTAS REFERENTES À FATURA ANTERIOR</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center" number-columns-spanned="3" padding-top="1mm">
                            <fo:block font-weight="bold" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@C2"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                  </fo:table-row>                      
                  <fo:table-row>
	                  <fo:table-cell number-columns-spanned="4" display-align="center" padding-top="1mm"> 
				        <fo:block font-size="0pt" text-align-last="justify">
				            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
				        </fo:block>
			          </fo:table-cell>
		          </fo:table-row>                                                             
                </fo:table-body>
            </fo:table>
        </fo:block>

        <!-- Total a pagar -->
        <fo:block font-family="Helvetica" font-size="12pt" space-before="1mm">
            <fo:table table-layout="fixed">
                <fo:table-column column-width="11.76cm"/>
                <fo:table-column column-width="7cm"/>
                <fo:table-body>
                    
                    <xsl:if test="SUMMARY/@DICMS!='0,00'">
                        <fo:table-row>
                            <fo:table-cell display-align="before">
                                <fo:block start-indent="11mm">
                                    <xsl:text>TOTAL GERAL: </xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="before">
                                <fo:block end-indent="1mm" text-align="end">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="SUMMARY/@SS"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell display-align="before">
                                <fo:block start-indent="11mm">
                                    <xsl:text>DESCONTO ICMS (Base de cálculo R$&#32;</xsl:text>
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value"> 
                                        <xsl:value-of select="SUMMARY/@TOTALBC"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:text>)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="before">
                            <fo:block end-indent="1mm" text-align="end">
                                <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                        <xsl:value-of select="SUMMARY/@DICMS"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>
                <fo:table-row>
                    <fo:table-cell display-align="before">
                        <fo:block font-weight="bold">
                            <xsl:text>TOTAL A PAGAR</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="before">
                        <fo:block end-indent="1mm" text-align="end" font-weight="bold">
                            <xsl:call-template name="VALOR-OU-ZERO">
                                <xsl:with-param name="value">
                                    <xsl:value-of select="SUMMARY/@T"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>                              
            </fo:table-body>
        </fo:table>
        </fo:block>
        
		<fo:block font-family="Helvetica" font-size="8pt" space-before="5mm">
            <fo:table table-layout="fixed">
                <fo:table-column column-width="18.5cm"/>
                <fo:table-body>                                        
                	<fo:table-row>
	                    <fo:table-cell display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M1"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row>
                	<fo:table-row>
	                    <fo:table-cell padding-top="1mm" padding-bottom="1mm" display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M2"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row>
                	<fo:table-row>
	                    <fo:table-cell padding-top="1mm" padding-bottom="1mm" display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M5"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row>  
                	<fo:table-row>
	                    <fo:table-cell padding-top="1mm" padding-bottom="1mm" display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M6"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row>  
                	<fo:table-row>
	                    <fo:table-cell padding-top="1mm" padding-bottom="1mm" display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M7"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row> 
                	<fo:table-row>
	                    <fo:table-cell padding-top="1mm" padding-bottom="1mm" display-align="before">
	                        <fo:block>
	                         	<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/MSGS/M8"/>
	                        </fo:block>
	                    </fo:table-cell>
                	</fo:table-row>                 	                    	                	
                	<fo:table-row>
				        <fo:table-cell border-bottom-style="solid" border-bottom-width="0.1mm"
				        			   border-top-style="solid" border-top-width="0.1mm" 
				        			   border-left-style="solid" border-left-width="0.1mm" 
				          			   border-right-style="solid" border-right-width="0.1mm">
				          <fo:block start-indent="1mm" text-align="left" font-size="6pt"
				                    font-family="Helvetica" padding-top="0.5mm">
				            <xsl:text>Autenticação Mecânica</xsl:text>
				          </fo:block>
				          <fo:block start-indent="12mm" space-before="2mm" space-after="2mm" />	          
				        </fo:table-cell>                	
                	</fo:table-row>                              
            	</fo:table-body>
        	</fo:table> 
        	       
        </fo:block>        

        <xsl:call-template name="RENDER-BOLETO-ARRECADACAO">
          <xsl:with-param name="boleto" select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO"/>
        </xsl:call-template>

    </xsl:template>      

</xsl:stylesheet>