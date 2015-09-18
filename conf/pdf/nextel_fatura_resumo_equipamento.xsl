<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:xalan="http://xml.apache.org/xalan"
  exclude-result-prefixes="xalan"
  version="1.0">
  
    <!-- ***************************** -->
    <!-- * Dados de cada equipamento * -->
    <!-- ***************************** -->
	<xsl:template match="CONTRACT" mode="SUMMARY">
        <fo:table-row height="5mm">
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="left">
                    <!-- FLEET*ID -->
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
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="left">
                    <!-- TELEFONE -->
                    <xsl:call-template name="HIFENIZAR">
                        <xsl:with-param name="number">
                            <xsl:value-of select="@N"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="left">
                    <!-- USUÁRIO -->
                    <xsl:value-of select="substring(@U, 1, $userNameMaxLength)"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- MENSALIDADE (R$) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@M"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- SERVIÇOS ADICIONAIS/SERVIÇOS DE TERCEIROS (R$) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@A"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- CONEXÃO DIRETA NEXTEL (R$) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <!-- xsl:value-of select="SERVICES/SVC[@TP='U' and @ID='DISPP']/@V"/ -->
                            <xsl:value-of select="DISPATCH/@V"/>
                            <!-- xsl:value-of select="DISPATCH/SUMMARY/TOTAL/@V"/ -->
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- DENTRO DA ÁREA DE REGISTRO -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="CALLS/HOME/@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid" border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- FORA DA ÁREA DE REGISTRO -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="CALLS/ROAMING/@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center" border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- SERVIÇOS DE DADOS (R$) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@O"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-left-style="solid"   border-left-width="0.01mm"
                border-right-style="solid"  border-right-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- VALOR TOTAL (R$) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@T"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>



    <!-- ***************************************************** -->
    <!-- * Mostra um resumo de cada equipamento e o subtotal * -->
    <!-- ***************************************************** -->
	<xsl:template match="SUBSCRIBER">
        <!-- Mostra todos os aparelhos dessa conta -->
        <xsl:apply-templates select="./CONTRACT" mode="SUMMARY"/>

        <!-- Subtotal da página -->
        <fo:table-row height="8mm">
            <fo:table-cell display-align="center"
                number-columns-spanned="3"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block font-size="7.5pt" font-weight="bold" text-align="right" margin-right="3mm">
                    SUBTOTAL
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- MENSALIDADE -->	
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@M"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- SERVIÇOS ADICIONAIS / SERVIÇOS DE TERCEIROS -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@A"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- CONEXÃO DIRETA NEXTEL -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@D"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- DENTRO DA ÁREA DE REGISTRO -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/HOME/@T"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- FORA DA ÁREA DE REGISTRO -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/ROAMING/@T"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm">
                <fo:block text-align="right" margin-right="1mm">
                    <!-- SERVIÇOS DE DADOS (NEXTEL ONLINE) -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@O"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center"
                border-top-style="solid"    border-top-width="0.2mm"
                border-bottom-style="solid" border-bottom-width="0.2mm"
                border-left-style="solid"   border-left-width="0.01mm"
                border-right-style="solid"  border-right-width="0.01mm">
                <fo:block font-weight="bold" text-align="right" margin-right="1mm">
                    <!-- VALOR TOTAL -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="/INVOICE/CUSTOMER/SUMMARY/@S"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
	</xsl:template>


    <!-- ****************************************** -->
    <!-- * Resumo por equipamento (Segunda parte) * -->
    <!-- ****************************************** -->
	<xsl:template name="RESUMO-EQUIPAMENTO">

        <!-- Mostra todos os aparelhos dessa conta mais o subtotal -->
            <fo:table table-layout="fixed" font-family="Helvetica" 
                      font-size="7.5pt" space-after="10mm">
                <fo:table-column column-width="24.4mm"/>
                <fo:table-column column-width="18.9mm"/>
                <fo:table-column column-width="26.8mm"/>
                <fo:table-column column-width="20mm"/>
                <fo:table-column column-width="17.1mm"/>
                <fo:table-column column-width="15.1mm"/>
                <fo:table-column column-width="17.2mm"/>
                <fo:table-column column-width="15.8mm"/>
                <fo:table-column column-width="15.1mm"/>
                <fo:table-column column-width="16.8mm"/>
                
                <!-- O cabeçalho da tabela -->
                <fo:table-header>
                    <fo:table-row height="4mm">
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
				                <xsl:choose>
				                  <xsl:when test="DETAILS/SUBSCRIBER/CONTRACT/@TP = 'AMP'">
				                      	<xsl:text>SERIAL</xsl:text>
				                  </xsl:when>
				                  <xsl:otherwise>
										<xsl:text>FLEET * ID</xsl:text>
				                  </xsl:otherwise>
				                </xsl:choose> 
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>TELEFONE</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>USUÁRIO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>MENSALIDADE (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>SERVIÇOS ADICIONAIS (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>CONEXÃO DIRETA NEXTEL (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-columns-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.01mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>CHAMADAS DE TELEFONIA (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>SERVIÇOS DE DADOS (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            number-rows-spanned="2"
                            border-top-style="solid"    border-top-width="0.2mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm"
                            border-right-style="solid"  border-right-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>VALOR TOTAL (R$)</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    
                    <!-- Divisão das chamadas de telefonia -->
                    <fo:table-row height="6mm">
                        <fo:table-cell display-align="center"
                            border-top-style="solid"    border-top-width="0.01mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>DENTRO DA ÁREA DE REGISTRO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center"
                            border-top-style="solid"    border-top-width="0.01mm"
                            border-bottom-style="solid" border-bottom-width="0.2mm"
                            border-left-style="solid"   border-left-width="0.01mm">
                            <fo:block font-weight="bold" text-align="center">
                                <xsl:text>FORA DE ÁREA DE REGISTRO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>

                <fo:table-body>
                    <xsl:apply-templates select="DETAILS/SUBSCRIBER"/>
                </fo:table-body>
            </fo:table>

            <fo:table table-layout="fixed" font-family="Helvetica" font-size="7.5pt">
              <fo:table-column column-width="11.6cm" />
              <fo:table-column column-width="1.1cm" />
              <fo:table-column column-width="6.0cm" />

              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>

                    <xsl:choose>
                      <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
                      <xsl:when test="DETAILS/SUBSCRIBER/OTHER/OCC">
                        <fo:table table-layout="fixed" font-family="Helvetica" font-size="7.5pt" space-after="5mm">
                          <fo:table-column column-width="1.8cm" />
                          <fo:table-column column-width="5cm" />
                          <fo:table-column column-width="2.8cm" />
                          <fo:table-column column-width="2.0cm" />
                          <fo:table-header>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" number-columns-spanned="4">
                                <fo:block font-size="10pt" font-weight="bold">
                                  <xsl:text>AJUSTES</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>DATA</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" number-columns-spanned="2"
                                border-top-style="solid" border-top-width="0.2mm"
                                border-bottom-style="solid" border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>TIPO</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>VALOR</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>
                          <fo:table-body>
                            <!-- Para cada serviço adicional corporativo -->
                            <xsl:for-each select="DETAILS/SUBSCRIBER/OTHER/OCC">
                              <fo:table-row height="5mm" keep-with-next="always">
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="@DT" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" number-columns-spanned="2"
                                  border-bottom-style="solid" border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="substring(@DS, 1, 60)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block text-align="right" end-indent="5mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                      <xsl:with-param name="value">
                                        <xsl:value-of select="@V" />
                                      </xsl:with-param>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </xsl:for-each>
                            <!-- Subtotal -->
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block>Subtotal</fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block text-align="right" end-indent="5mm">
                                  <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                      <xsl:value-of select="DETAILS/SUBSCRIBER/OTHER/@T" />
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-body>
                        </fo:table>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block />
                      </xsl:otherwise>
                    </xsl:choose>

                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>
                  <fo:table-cell>

                    <!-- Total Geral -->
                    <fo:table table-layout="fixed" font-family="Helvetica" font-size="12pt">
                      <fo:table-column column-width="3.5cm" />
                      <fo:table-column column-width="2.5cm" />
                      <fo:table-body>
                        <fo:table-row height="5mm">
                          <fo:table-cell display-align="center" font-weight="bold"
                            border-bottom-style="solid" border-bottom-width="0.2mm">
                            <fo:block>TOTAL GERAL</fo:block>
                          </fo:table-cell>
                          <fo:table-cell display-align="center" text-align="right"
                            border-bottom-style="solid" border-bottom-width="0.2mm">
                            <fo:block>
                              <!-- VALOR TOTAL -->
                              <xsl:call-template name="VALOR-OU-ZERO">
                                <xsl:with-param name="value">
                                 <!-- eho:alterado de @S para @T conforme  conf/html/xml_html/resumo_equipamento/nextel_fatura.xsl -->
                                 <!-- <xsl:value-of select="SUMMARY/@S" /> --> 
                                  <xsl:value-of select="SUMMARY/@T"/>                              
                                </xsl:with-param>
                              </xsl:call-template>
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row height="10mm" keep-with-previous="always">
                          <fo:table-cell display-align="after" font-size="13.5pt"
                            font-weight="bold">
                            <fo:block>VENCIMENTO:</fo:block>
                          </fo:table-cell>
                          <fo:table-cell display-align="after" text-align="center"
                            font-size="13.5pt">
                            <fo:block>
                              <xsl:value-of select="@D" />
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </fo:table-body>
                    </fo:table>

                  </fo:table-cell>
                </fo:table-row>
                
                
                
			<fo:table-row>
                  <fo:table-cell>

                    <xsl:choose>
                      <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
                      <xsl:when test="DETAILS/SUBSCRIBER/CREDITS/OCC">
                        <fo:table table-layout="fixed" font-family="Helvetica" font-size="7.5pt" space-after="5mm">
                          <fo:table-column column-width="1.8cm" />
                          <fo:table-column column-width="5cm" />
                          <fo:table-column column-width="2.8cm" />
                          <fo:table-column column-width="2.0cm" />
                          <fo:table-header>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" number-columns-spanned="4">
                                <fo:block font-size="10pt" font-weight="bold">
                                  <xsl:text>CRÉDITO</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>DATA</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" number-columns-spanned="2"
                                border-top-style="solid" border-top-width="0.2mm"
                                border-bottom-style="solid" border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>TIPO</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>VALOR</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>
                          <fo:table-body>
                            <!-- Para cada serviço adicional corporativo -->
                            <xsl:for-each select="DETAILS/SUBSCRIBER/CREDITS/OCC">
                              <fo:table-row height="5mm" keep-with-next="always">
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="@DT" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" number-columns-spanned="2"
                                  border-bottom-style="solid" border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="substring(@DS, 1, 60)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block text-align="right" end-indent="5mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                      <xsl:with-param name="value">
                                        <xsl:value-of select="@V" />
                                      </xsl:with-param>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </xsl:for-each>
                            <!-- Subtotal -->
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block>Subtotal</fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block text-align="right" end-indent="5mm">
                                  <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                      <xsl:value-of select="DETAILS/SUBSCRIBER/CREDITS/@T" />
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-body>
                        </fo:table>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block />
                      </xsl:otherwise>
                    </xsl:choose>

                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>                
                
          </fo:table-row>      



			<fo:table-row>
                  <fo:table-cell>

                    <xsl:choose>
                      <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
                      <xsl:when test="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/OCC">
                        <fo:table table-layout="fixed" font-family="Helvetica" font-size="7.5pt" space-after="5mm">
                          <fo:table-column column-width="1.8cm" />
                          <fo:table-column column-width="5cm" />
                          <fo:table-column column-width="2.8cm" />
                          <fo:table-column column-width="2.0cm" />
                          <fo:table-header>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" number-columns-spanned="4">
                                <fo:block font-size="10pt" font-weight="bold">
                                  <xsl:text>JUROS/MULTAS REFERENTES À FATURA ANTERIOR</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>DATA</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" number-columns-spanned="2"
                                border-top-style="solid" border-top-width="0.2mm"
                                border-bottom-style="solid" border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>TIPO</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-top-style="solid"
                                border-top-width="0.2mm" border-bottom-style="solid"
                                border-bottom-width="0.1mm">
                                <fo:block text-align="center">
                                  <xsl:text>VALOR</xsl:text>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>
                          <fo:table-body>
                            <!-- Para cada serviço adicional corporativo -->
                            <xsl:for-each select="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/OCC">
                              <fo:table-row height="5mm" keep-with-next="always">
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="@DT" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" number-columns-spanned="2"
                                  border-bottom-style="solid" border-bottom-width="0.1mm">
                                  <fo:block>
                                    <xsl:value-of select="substring(@DS, 1, 60)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center" border-bottom-style="solid"
                                  border-bottom-width="0.1mm">
                                  <fo:block text-align="right" end-indent="5mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                      <xsl:with-param name="value">
                                        <xsl:value-of select="@V" />
                                      </xsl:with-param>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </xsl:for-each>
                            <!-- Subtotal -->
                            <fo:table-row height="5mm" keep-with-next="always">
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                <fo:block />
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block>Subtotal</fo:block>
                              </fo:table-cell>
                              <fo:table-cell display-align="center" border-bottom-style="solid"
                                border-bottom-width="0.2mm">
                                <fo:block text-align="right" end-indent="5mm">
                                  <xsl:call-template name="VALOR-OU-ZERO">
                                    <xsl:with-param name="value">
                                      <xsl:value-of select="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/@T" />
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-body>
                        </fo:table>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block />
                      </xsl:otherwise>
                    </xsl:choose>

                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>                
                
          </fo:table-row>  


                
              </fo:table-body>
            </fo:table>

            <!-- Final do resumo por equipamento -->
	</xsl:template>

</xsl:stylesheet>