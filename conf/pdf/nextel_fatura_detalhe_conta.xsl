<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">

    <!-- *********************************** -->    
    <!-- * Resumo da conta de cada usuário * -->    
    <!-- *********************************** -->
    
    <!-- 4004-PORTO -->
    <!-- <xsl:variable name="specialCallNumbers" select="document('../html/Vx/SpecialCallNumber.xml')/document"/>  -->
    <xsl:variable name="specialCallNumbers" select="document('../xml/SpecialCallNumber.xml')/document"/>     
    
    
    <!-- ******************************************* -->    
	<!-- SERVIÇOS ADICIONAIS / SERVIÇOS DE TERCEIROS -->
    <!-- ******************************************* -->
	<xsl:template name="DETALHE-CONTA-SRV">
		<fo:block>
            <!-- Serviços Adicionais / Serviços de Terceiros. Só mostra se houver algum -->
            <xsl:if test="CALLS/IDCD/@V!='0,00'">
                <!-- Chamadas de rádio internacionais utilizando o serviço CDI Diário -->
                <fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="1mm">
                    <xsl:text>SERVIÇOS ADICIONAIS</xsl:text>
                </fo:block>
                
                <xsl:call-template name="CHAMADAS-SRV">
                    <xsl:with-param name="title">Conexão Direta Internacional - Diário</xsl:with-param>
                    <xsl:with-param name="calls" select="CALLS/IDCD/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/IDCD"/>
                </xsl:call-template>
			</xsl:if>		
		</fo:block>
	</xsl:template>
	
    <!-- ********************************* -->    
	<!-- NEXTEL ONLINE (SERVIÇOS DE DADOS) -->
    <!-- ********************************* -->
	<xsl:template name="DETALHE-CONTA-ONLINE">
		<fo:block>
            <!-- Serviços Adicionais / Serviços de Terceiros. Só mostra se houver algum -->
            <!--  xsl:if test="CALLS/ONLINE/SVC[@ID='LOLGT'] or CALLS/ONLINE/SVC[@ID='SMSSI']" -->
            <xsl:if test="CALLS/ONLINE/SVC[@ID='LOLGT']">
                <fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="1mm">
                    <xsl:text>NEXTEL ONLINE (SERVIÇOS DE DADOS)</xsl:text>
                </fo:block>
                
                <!-- Localizador Diário -->                
                <xsl:call-template name="CHAMADAS-ONLINE">
                    <xsl:with-param name="title" select="CALLS/ONLINE/SVC[@ID='LOLGT']/@DS" />
                    <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='LOLGT']/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='LOLGT']"/>
                </xsl:call-template>

                <!-- Serviços Interativos - SMS - ->            
                <xsl:call-template name="CHAMADAS-SMSSI">
                    <xsl:with-param name="title" select="CALLS/ONLINE/SVC[@ID='SMSSI']/@DS" />
                    <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='SMSSI']/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='SMSSI']"/>
                </xsl:call-template>
                -->

			</xsl:if>		
		</fo:block>
	</xsl:template>	

    <xsl:template name="DETALHE-CONTA">        
    <fo:block>            
    	<!-- Chamadas de telefonia dentro da área de registro. Só mostra se houver alguma -->            
    	<!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or (@PP='Y' and CALLS/HOME/@CH!='0,00')"> -->
        <xsl:if test="CALLS/HOME/@DNF!='0:00' or (@PP='Y' and CALLS/HOME/@CH!='0:00')">
			<!-- Chamadas de telefonia dentro da área de registro -->                
			<fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="1mm">                    
				<xsl:text>CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO</xsl:text>
			</fo:block>
            <!-- Chamadas locais -->                
            <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Chamadas Locais</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/LOCAL/descendant::CALL"/>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LOCAL"/>                    
            <xsl:with-param name="col_5_value">Local</xsl:with-param>                    
            <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>                    
            <xsl:with-param name="apply_mobile_check">TRUE</xsl:with-param>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                
            </xsl:call-template>                                
            <!-- Chamadas de longa distância -->                
            <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Chamadas de Longa Distância</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/LONG_DISTANCE/descendant::CALL"/>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LONG_DISTANCE"/>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                </xsl:call-template>                
            <!-- Chamadas locais recebidas -->                <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Chamadas Recebidas</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/INCOMING/RECEIVED/descendant::CALL"/>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/RECEIVED"/>                    
            <xsl:with-param name="col_3_title">Origem</xsl:with-param>                    
            <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>                    
            <xsl:with-param name="col_5_value">Local</xsl:with-param>                    
            <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                
            </xsl:call-template>                                
            <!-- Chamadas locais recebidas a cobrar -->                
            <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Chamadas a Cobrar Recebidas</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/INCOMING/COLLECT/descendant::CALL"/>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/COLLECT"/>                    
            <xsl:with-param name="col_3_title">Origem</xsl:with-param>                    
            <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>                    
            <xsl:with-param name="col_5_value">Local</xsl:with-param>                    
            <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                
            </xsl:call-template>               
            <!-- Chamadas internacionais -->                
            <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Chamadas Internacionais</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/INTERNATIONAL/descendant::CALL"/>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/INTERNATIONAL"/>                    
            <xsl:with-param name="hifenize-number">FALSE</xsl:with-param>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                
            </xsl:call-template>                
            <!-- Serviço 0300 -->                
            <xsl:call-template name="CHAMADAS">                    
            <xsl:with-param name="title">Serviço 0300</xsl:with-param>                    
            <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/Z300/descendant::CALL"/>                    
            <xsl:with-param name="col_3_title">Origem</xsl:with-param>                    
            <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>                    
            <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/Z300"/>                    
            <xsl:with-param name="pre_paid" select="@PP"/>                
            </xsl:call-template>                
            <fo:block space-before="0.5mm" space-after="0.5mm" text-align-last="justify">                    
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>                
            </fo:block>                            
		</xsl:if>            
        <!-- Chamadas de telefonia fora da área de registro (roaming). Só mostra se houver alguma -->            
        <!-- <xsl:if test="CALLS/ROAMING/@DNF!='0,00' or (@PP='Y' and CALLS/ROAMING/@CH!='0,00')"> -->
        <xsl:if test="CALLS/ROAMING/@DNF!='0:00' or (@PP='Y' and CALLS/ROAMING/@CH!='0:00')">
          <fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="1mm">
            <xsl:text>CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (ROAMING)</xsl:text>
          </fo:block>
          <!-- Chamadas Originadas -->
          <xsl:variable name="outgoingCalls">
            <xsl:for-each
              select="CALLS/ROAMING/OUTGOING/*[local-name()!='Z300']/descendant::CALL">
              <xsl:sort select="@MN" data-type="number" />
              <xsl:sort select="@SN" data-type="number" />
              <xsl:copy-of select="." />
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="outgoingCalls" select="xalan:nodeset($outgoingCalls)" />
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Chamadas Originadas</xsl:with-param>
            <xsl:with-param name="calls" select="$outgoingCalls/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY" />
            <xsl:with-param name="col_3_title">Origem/Destino</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template>
          <!-- Serviço 0300 -->
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Serviço 0300</xsl:with-param>
            <xsl:with-param name="calls" select="CALLS/ROAMING/OUTGOING/Z300/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/Z300" />
            <xsl:with-param name="col_3_title">Origem</xsl:with-param>
            <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template>
          <!-- Chamadas Recebidas -->
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Chamadas Recebidas</xsl:with-param>
            <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/RECEIVED/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/RECEIVED" />
            <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
            <xsl:with-param name="use_dialed_number">FALSE</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template><!-- Chamadas recebidas a cobrar em roaming -->
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Chamadas a Cobrar Recebidas</xsl:with-param>
            <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/COLLECT/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/COLLECT" />
            <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
            <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template>
          <fo:block space-before="0.5mm" space-after="0.5mm" text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm" />
          </fo:block>
        </xsl:if>
        <!-- Descritivo de descontos local-->
        <xsl:if test="number(translate(CALLS/HOME/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
          <!-- Chamadas de telefonia dentro da área de registro -->
          <fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="3mm">
            <xsl:text>DESCONTOS DENTRO DA ÁREA DE REGISTRO</xsl:text>
          </fo:block>
          <!-- Chamadas descontos local -->
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Descontos de Chamadas Locais</xsl:with-param>
            <xsl:with-param name="calls" select="CALLS/HOME/INCOMING/DISCOUNTS/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/DISCOUNTS" />
            <xsl:with-param name="desconto">TRUE</xsl:with-param>
            <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
            <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
            <xsl:with-param name="col_5_value">Desconto</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template>
          <fo:block space-before="1mm" space-after="1mm" text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm" />
          </fo:block>
        </xsl:if>
        <!-- Descritivo de descontos em roaming-->
        <xsl:if test="number(translate(CALLS/ROAMING/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
          <!-- Chamadas de telefonia dentro da área de registro -->
          <fo:block font-family="Helvetica" font-size="9pt" font-weight="bold" space-after="3mm">
            <xsl:text>DESCONTOS FORA DA ÁREA DE REGISTRO (ROAMING)</xsl:text>
          </fo:block>
          <!-- Chamadas descontos em roaming -->
          <xsl:call-template name="CHAMADAS">
            <xsl:with-param name="title">Descontos de Chamadas em Roaming</xsl:with-param>
            <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/DISCOUNTS/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/DISCOUNTS" />
            <xsl:with-param name="desconto">TRUE</xsl:with-param>
            <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
            <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
            <xsl:with-param name="col_5_value">Desconto</xsl:with-param>
            <xsl:with-param name="pre_paid" select="@PP" />
          </xsl:call-template>
          <fo:block space-before="1mm" space-after="1mm" text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm" />
          </fo:block>
        </xsl:if>
    </fo:block>
    </xsl:template>
    
    <!-- ************************************* -->    
    <!-- * Mostra as chamadas detalhadamente * -->    
    <!-- ************************************* -->    
	
    <!-- ******************************************************************* -->
    <!-- * Mostra as chamadas de rádio (serviço CDI-Diário) detalhadamente * -->
    <!-- ******************************************************************* -->
    <xsl:template name="CHAMADAS-SRV">
        <!-- Título da "tabela" -->
        <xsl:param name="title"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>    
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>        
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">Y</xsl:param>
            
        <!-- Se houverem chamadas CDI-Diário-->
        <xsl:if test="($subtotals/@V!='0,00')">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm">
                    <fo:table-column column-width="2.5cm"/>
                    <fo:table-column column-width="1.8cm"/>
                    <fo:table-column column-width="4.4cm"/>
                    <fo:table-column column-width="3cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="1.5cm"/>
                    <fo:table-column column-width="2cm"/>

                    <!-- Cabeçalho das chamadas CDI-Diário -->
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center" number-columns-spanned="7">
                                <fo:block font-weight="bold" start-indent="5mm">
                                    <xsl:value-of select="$title"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" start-indent="10mm">
                                    <xsl:text>Data</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Hora</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>                            
                            
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
								    <xsl:text>Min / Dur</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                            
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>                                                        
                            
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:text>VALOR R$</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>

                    <fo:table-body>
                        <xsl:apply-templates select="$calls">
                            <xsl:with-param name="is_idcd">
                                <xsl:value-of select="$is_idcd"/>
                            </xsl:with-param>                         
						</xsl:apply-templates>                    

                        <!-- Subtotal -->
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="$subtotals/@V"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </xsl:if>
    </xsl:template>


    <!-- *********************************************************** -->
    <!-- * Mostra as chamadas de NEXTEL ONLINE (SERVIÇOS DE DADOS) * -->
    <!-- *********************************************************** -->
    <xsl:template name="CHAMADAS-ONLINE">
        <!-- Título da "tabela" -->
        <xsl:param name="title"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>    
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>        
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">N</xsl:param>
            
        <!-- Se houverem chamadas NEXTEL ONLINE-->
        <xsl:if test="($subtotals/@V!='0,00')">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm">
                    <fo:table-column column-width="2.5cm"/>
                    <fo:table-column column-width="1.8cm"/>
                    <fo:table-column column-width="4.4cm"/>
                    <fo:table-column column-width="3cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="1.5cm"/>
                    <fo:table-column column-width="2cm"/>

                    <!-- Cabeçalho NEXTEL ONLINE (SERVIÇOS DE DADOS)  -->
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center" number-columns-spanned="7">
                                <fo:block font-weight="bold" start-indent="5mm">
                                    <xsl:value-of select="$title"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
									<xsl:text>Data</xsl:text>
								</fo:block>								
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Hora</xsl:text>
                                </fo:block>                            
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>                                                        
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:text>VALOR R$</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>

                    <fo:table-body>

                    
                   		<xsl:apply-templates select="$calls">
                            <xsl:with-param name="is_idcd">
                                <xsl:value-of select="$is_idcd"/>
                            </xsl:with-param>
                            <xsl:with-param name="is_online">TRUE</xsl:with-param>                                                    
						</xsl:apply-templates>     

                        <!-- Subtotal -->
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="$subtotals/@V"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- ************************************************************** -->
    <!-- * Mostra as chamadas de NEXTEL ONLINE (SERVIÇOS INTERATIVOS) * -->
    <!-- ************************************************************** -->
    <!-- Serviços Interativos - SMS -->    
    <xsl:template name="CHAMADAS-SMSSI">
        <!-- Título da "tabela" -->
        <xsl:param name="title"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>    
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>        
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">N</xsl:param>
            
        <!-- Se houverem chamadas NEXTEL ONLINE-->
        <xsl:if test="($subtotals/@V!='0,00')">
            <fo:block font-family="Helvetica" font-size="9pt">
                <fo:table table-layout="fixed" space-before="1mm">
                    <fo:table-column column-width="1.0cm"/>
                    <fo:table-column column-width="5.7cm"/>
                    <fo:table-column column-width="1.0cm"/>
                    <fo:table-column column-width="3cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="1.5cm"/>
                    <fo:table-column column-width="2cm"/>

                    <!-- NEXTEL ONLINE  - SERVIÇOS INTERATIVOS -->
                    <fo:table-header>
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center" number-columns-spanned="7">
                                <fo:block font-weight="bold" start-indent="5mm">
                                    <xsl:value-of select="$title"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>                        
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
									<xsl:text>Data</xsl:text>
								</fo:block>								
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Hora</xsl:text>
                                </fo:block>                            
                            </fo:table-cell>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>                                                        
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:text>VALOR R$</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <!-- FIM NEXTEL ONLINE  - SERVIÇOS INTERATIVOS -->
                    
                    <fo:table-body>
                    
                   		<xsl:apply-templates select="$calls">
                            <xsl:with-param name="is_serv_int">TRUE</xsl:with-param>                                                    
						</xsl:apply-templates>     
   
                        <!-- Subtotal -->
                        <fo:table-row>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white"/>
                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold">
                                    <xsl:text>Subtotal</xsl:text>
                                </fo:block>
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                            </fo:table-cell>

                            <fo:table-cell border-right="solid" border-color="white" display-align="center">
                                <fo:block font-weight="bold" text-align="right" end-indent="1mm">
                                    <xsl:call-template name="VALOR-OU-ZERO">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="$subtotals/@V"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </xsl:if>
    </xsl:template>

    
    <xsl:template name="CHAMADAS">        
	    <!-- Parametro para tratamento especial de impressão de descontos. -->        
	    <xsl:param name="desconto">FALSE</xsl:param>        
	    <!-- Título da "tabela" -->        
	    <xsl:param name="title"/>        
	    <!-- Nome da 3a. coluna -->        
	    <xsl:param name="col_3_title">Destino</xsl:param>        
	    <!-- Nome da 4a. coluna -->        
	    <xsl:param name="col_4_title">Nº Chamado</xsl:param>       
	    <!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->        
	    <xsl:param name="col_5_value">Longa Distância</xsl:param>        
	    <!-- Node-set de chamadas -->        
	    <xsl:param name="calls"/>        
	    <!-- Elemento com os valores totalizados -->        
	    <xsl:param name="subtotals"/>        
	    <!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->        
	    <xsl:param name="use_call_origin_city">TRUE</xsl:param>        
	    <!-- Mostrar o número chamado ou não. Por padrão mostrar -->        
	    <xsl:param name="use_dialed_number">TRUE</xsl:param>        
	    <!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->        
	    <xsl:param name="apply_mobile_check">FALSE</xsl:param>        
	    <!-- Indica se o número de telefone deve ser hifenizado -->        
	    <xsl:param name="hifenize_number">TRUE</xsl:param>        
	    <!-- Indica se o telefone é pré-pago ou não -->        
	    <xsl:param name="pre_paid">N</xsl:param>
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">N</xsl:param>                
		<!-- Se houverem chamadas ou for desconto ou for pré-pago -->        
		<!-- <xsl:if test="(($subtotals/@DNF!='0,00' or $desconto = 'TRUE') or ($pre_paid='Y' and $subtotals/@CHA!='0,00'))"> -->
		<xsl:if
		  test="(($subtotals/@DNF!='0:00' or $desconto = 'TRUE') or ($pre_paid='Y' and $subtotals/@CHA!='0:00'))">
		  <fo:block font-family="Helvetica" font-size="9pt">
		    <fo:table table-layout="fixed" space-before="1mm">
		      <fo:table-column column-width="2.5cm" />
		      <fo:table-column column-width="1.8cm" />
		      <fo:table-column column-width="4.4cm" />
		      <fo:table-column column-width="3cm" />
		      <fo:table-column column-width="3.5cm" />
		      <fo:table-column column-width="1.5cm" />
		      <fo:table-column column-width="2cm" />
		      <!-- Cabeçalho das chamadas -->
		      <fo:table-header>
		        <fo:table-row>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center"
		            number-columns-spanned="7">
		            <fo:block font-weight="bold" start-indent="5mm">
		              <xsl:value-of select="$title" />
		            </fo:block>
		          </fo:table-cell>
		        </fo:table-row>
		        <fo:table-row>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold" start-indent="10mm">Data</fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold">Hora</fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold">
		              <xsl:value-of select="$col_3_title" />
		            </fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold">
		              <xsl:if test="$use_dialed_number = 'TRUE'">
		                <xsl:value-of select="$col_4_title" />
		              </xsl:if>
		            </fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold">Tipo Chamada</fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold" text-align="right">Min / Dur</fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold" text-align="right" end-indent="1mm">VALOR R$</fo:block>
		          </fo:table-cell>
		        </fo:table-row>
		      </fo:table-header>
		      <fo:table-body>
		        <!-- Mostra cada chamada desse contrato -->
		        <xsl:apply-templates select="$calls">
		          <xsl:with-param name="desconto">
		            <xsl:value-of select="$desconto" />
		          </xsl:with-param>
		          <xsl:with-param name="use_call_origin_city">
		            <xsl:value-of select="$use_call_origin_city" />
		          </xsl:with-param>
		          <xsl:with-param name="use_dialed_number">
		            <xsl:value-of select="$use_dialed_number" />
		          </xsl:with-param>
		          <xsl:with-param name="col_5_value">
		            <xsl:value-of select="$col_5_value" />
		          </xsl:with-param>
		          <xsl:with-param name="apply_mobile_check">
		            <xsl:value-of select="$apply_mobile_check" />
		          </xsl:with-param>
		          <xsl:with-param name="hifenize_number">
		            <xsl:value-of select="$hifenize_number" />
		          </xsl:with-param>
		        </xsl:apply-templates>
		        <!-- Subtotal -->
		        <fo:table-row>
		          <fo:table-cell border-right="solid" border-color="white" />
		          <fo:table-cell border-right="solid" border-color="white" />
		          <fo:table-cell border-right="solid" border-color="white" />
		          <fo:table-cell border-right="solid" border-color="white" />
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold">Subtotal</fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold" text-align="right">
		              <xsl:call-template name="VALOR-OU-ZERO">
		                <xsl:with-param name="value">
		                  <xsl:if test="$desconto='FALSE'"><!-- and $pre_paid='N'">  -->
		                    <xsl:value-of select="$subtotals/@DNF" />
		                  </xsl:if>
		                  <xsl:if test="$desconto='TRUE'">
		                    <xsl:value-of select="$subtotals/@CHT" />
		                  </xsl:if>
		                </xsl:with-param>
		              </xsl:call-template>
		            </fo:block>
		          </fo:table-cell>
		          <fo:table-cell border-right="solid" border-color="white" display-align="center">
		            <fo:block font-weight="bold" text-align="right" end-indent="1mm">
		              <xsl:call-template name="VALOR-OU-ZERO">
		                <xsl:with-param name="value">
		                  <xsl:value-of select="$subtotals/@V" />
		                </xsl:with-param>
		              </xsl:call-template>
		            </fo:block>
		          </fo:table-cell>
		        </fo:table-row>
		      </fo:table-body>
		    </fo:table>
		  </fo:block>
		</xsl:if>
    </xsl:template>
	
    <!-- ************************************************************************************************ -->    
    <!-- * Decide se o dado a ser mostrado é de chamada ou de interconexão, mostrando-o apropriadamente * -->    
    <!-- ************************************************************************************************ -->    
    <xsl:template match="CALL">
        <!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->        
        <xsl:param name="col_5_value">Longa Distância</xsl:param>        
        <!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->        
        <xsl:param name="use_call_origin_city">TRUE</xsl:param>        
        <xsl:param name="desconto">FALSE</xsl:param>        
        <!-- Mostrar o número chamado ou não. Por padrão mostrar -->        
        <xsl:param name="use_dialed_number">TRUE</xsl:param>        
        <!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->        
        <xsl:param name="apply_mobile_check">FALSE</xsl:param>        
        <!-- Indica se o número de telefone deve ser hifenizado -->        
        <xsl:param name="hifenize_number">TRUE</xsl:param>
		<xsl:param name="is_idcd"/>
		<xsl:param name="is_online"/>
        <!-- Serviços Interativos - SMS -->		
		<xsl:param name="is_serv_int"/>		
		
        <!-- ******************************* --> 
        <!-- * Special Number Verification * --> 
        <!-- ******************************* --> 
        <xsl:variable name="callNumber" select="@N"/>
		<xsl:variable name="originalNumber" select="$specialCallNumbers/number[contains($callNumber,@originalNumber)]/@originalNumber"/>        
	    <xsl:variable name="showNumberTemp" select="$specialCallNumbers/number[contains($callNumber,@originalNumber)]/@showNumber"/>
	    <xsl:variable name="showNumber" select="concat(substring-before($callNumber,$originalNumber),$showNumberTemp)"/>		

        <!-- Se for dado de chamada ou desconto, mostre -->        
        <xsl:if test="($desconto='TRUE' or @SN!='1')">
        
          <xsl:choose>
            <xsl:when test="$is_online='TRUE'">
              <fo:table-row>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@DT" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@TM" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block text-align="right" end-indent="1mm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                      <xsl:with-param name="value">
                        <xsl:value-of select="@V" />
                      </xsl:with-param>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:when>

            <!-- NEXTEL ONLINE  - SERVIÇOS INTERATIVOS -->
            <!-- Serviços Interativos - SMS -->
            <xsl:when test="$is_serv_int='TRUE'">
              <fo:table-row>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>

                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@DS" />
                  </fo:block>
                </fo:table-cell>

                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>

                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@DT" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@TM" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block text-align="right" end-indent="1mm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                      <xsl:with-param name="value">
                        <xsl:value-of select="@V" />
                      </xsl:with-param>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:when>
            <!-- FIM NEXTEL ONLINE  - SERVIÇOS INTERATIVOS -->
            <xsl:otherwise>
              <fo:table-row>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block start-indent="10mm">
                    <xsl:value-of select="@DT" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:value-of select="@TM" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:if test="$use_call_origin_city='TRUE'">
                      <xsl:value-of select="@SC" />
                      <xsl:if test="(string-length(@SC) &gt; 0) and (string-length(@DN) &gt; 0)">
                        <xsl:text>/</xsl:text>
                      </xsl:if>
                    </xsl:if>
                    <xsl:choose>
                       <xsl:when test="starts-with(@N,'0300')">
                        <xsl:value-of select="@SC" />
                      </xsl:when>
                      <!-- ******************** --> 
                      <!--  Mensagem Automática -->
                      <!--  frv - 02/07/2007 -->                       
                      <xsl:when test="starts-with(@SC,'Msg.Automática')">
                      <xsl:value-of select="@SC" /> 
                      </xsl:when>
                      <!-- ******************** --> 
                      <xsl:otherwise>
                        <xsl:value-of select="@DN" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                  
                    <xsl:if test="$use_dialed_number='TRUE'">
                      <xsl:choose>
                        <xsl:when test="string-length($showNumber) &gt; 0">
                          <xsl:choose>
                            <xsl:when test="$hifenize_number = 'TRUE'">
                              <xsl:call-template name="HIFENIZAR">
                                <xsl:with-param name="number" select="$showNumber" />
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$showNumber" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="$hifenize_number = 'TRUE'">
                              <xsl:call-template name="HIFENIZAR">
                                <xsl:with-param name="number" select="@N" />
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@N" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="$is_idcd='Y'">
                        <xsl:text>Ilimitado no dia</xsl:text>
                      </xsl:when>
                      <xsl:when test="(@TP='LOCAL') and (@CL='M')">
                        <xsl:text>Local/Celular</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="@TP='LOCAL'">
                            <xsl:text>Local</xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>Longa Distância</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block text-align="right">
                    <xsl:if test="$is_idcd!='Y'">
                      <xsl:value-of select="@DR" />
                    </xsl:if>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-right="solid" border-color="white" display-align="center">
                  <fo:block text-align="right" end-indent="1mm">
                    <xsl:call-template name="VALOR-OU-ZERO">
                      <xsl:with-param name="value">
                        <xsl:value-of select="@V" />
                      </xsl:with-param>
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>        
        <!-- Se for dado de interconexão, mostre -->
        <xsl:if test="($desconto='FALSE' and (@SN='1' and @V!='0,00'))">
          <fo:table-row>
            <fo:table-cell border-right="solid" border-color="white" />
            <fo:table-cell border-right="solid" border-color="white" />
            <fo:table-cell border-right="solid" border-color="white" />
            <fo:table-cell border-right="solid" border-color="white" />
            <fo:table-cell border-right="solid" border-color="white" display-align="center">
              <fo:block>Interconexão</fo:block>
            </fo:table-cell>
            <fo:table-cell border-right="solid" border-color="white" />
            <fo:table-cell border-right="solid" border-color="white" display-align="center">
              <fo:block text-align="right" end-indent="1mm">
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>