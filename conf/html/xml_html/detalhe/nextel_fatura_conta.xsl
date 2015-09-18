<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- ******************************************* -->    
	<!-- SERVIÇOS ADICIONAIS / SERVIÇOS DE TERCEIROS -->
    <!-- ******************************************* -->
	<xsl:template name="DETALHE-CONTA-SRV">
        <xsl:if test="CALLS/IDCD/@V!='0,00'">
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
                    SERVIÇOS ADICIONAIS
				</xsl:with-param>
			</xsl:call-template>
			<!--Chamadas Locais-->
			<xsl:call-template name="CHAMADAS-SRV">
				<xsl:with-param name="title">Conexão Direta Internacional - Diário</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/IDCD/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/IDCD"/>
			</xsl:call-template>
		</xsl:if>
		<tr>
            <td colspan="15" class="text5" height="9">
                <img src="images/dot_black.gif" width="100%" height="3"/>
            </td>
        </tr>
	</xsl:template>
	
    <!-- ********************************* -->    
	<!-- NEXTEL ONLINE (SERVIÇOS DE DADOS) -->
    <!-- ********************************* -->
	<xsl:template name="DETALHE-CONTA-ONLINE">
		<!-- Serviços Adicionais / Serviços de Terceiros. Só mostra se houver algum -->
        <!-- <xsl:if test="CALLS/ONLINE/SVC/@ID='LOLGT' or CALLS/ONLINE/SVC/@ID='SMSSI'"> -->
        <xsl:if test="CALLS/ONLINE/SVC/@ID='LOLGT'">
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
	            	NEXTEL ONLINE (SERVIÇOS DE DADOS)
				</xsl:with-param>
			</xsl:call-template>
            <!-- Localizador Diário -->   
            <xsl:if test="CALLS/ONLINE/SVC/@ID='LOLGT'">             
	            <xsl:call-template name="CHAMADAS-ONLINE">
	            	<xsl:with-param name="title" select="CALLS/ONLINE/SVC[@ID='LOLGT']/@DS" />
	                <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='LOLGT']/descendant::CALL"/>
	                <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='LOLGT']"/>
				</xsl:call-template>
  		    </xsl:if>			
            <!-- Serviços Interativos - SMS - ->  
            <xsl:if test="CALLS/ONLINE/SVC/@ID='SMSSI'">                                       
	            <xsl:call-template name="CHAMADAS-SRVINT">
	            	<xsl:with-param name="title" select="CALLS/ONLINE/SVC[@ID='SMSSI']/@DS" />
	                <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='SMSSI']/descendant::CALL"/>
	                <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='SMSSI']"/>
				</xsl:call-template>
  		    </xsl:if>
            -->				
		</xsl:if>		
		<tr>
            <td colspan="15" class="text5" height="9">
                <img src="images/dot_black.gif" width="100%" height="3"/>
            </td>
        </tr>		
	</xsl:template>	
	
	
	<xsl:template name="DETALHE-CONTA">
		<!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or (@PP='Y' and CALLS/HOME/@CH!='0,00')"> -->
		<xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (@PP='Y' and (CALLS/HOME/@CH!='0:00' and CALLS/HOME/@CH!='0,00'))">				
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
					CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO
				</xsl:with-param>
			</xsl:call-template>
			<!--Chamadas Locais-->
			<xsl:call-template name="CHAMADAS">
				<xsl:with-param name="title">Chamadas Locais</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/LOCAL/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LOCAL"/>
                <xsl:with-param name="col_5_value">Local</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="apply_mobile_check">TRUE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
			</xsl:call-template>		
			<!--Chamadas de Longa Distância-->
			<xsl:call-template name="CHAMADAS">
				<xsl:with-param name="title">Chamadas de Longa Distância</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/LONG_DISTANCE/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LONG_DISTANCE"/>
                <xsl:with-param name="pre_paid" select="@PP"/>
			</xsl:call-template>
			<!--Chamadas Recebidas-->
			<xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Recebidas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/INCOMING/RECEIVED/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/RECEIVED"/>
                <xsl:with-param name="col_3_title">Origem</xsl:with-param>
                <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
                <xsl:with-param name="col_5_value">Local</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
			</xsl:call-template>
			<!--Chamadas recebidas a cobrar-->
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
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="col_3_title">Origem</xsl:with-param>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/Z300"/>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
		</xsl:if>
		<!--Chamadas fora da área de registro-->
		<!-- <xsl:if test="CALLS/ROAMING/@DNF!='0,00' or (@PP='Y' and CALLS/ROAMING/@CH!='0,00')"> -->
		<xsl:if test="(CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or (@PP='Y' and (CALLS/ROAMING/@CH!='0:00' and CALLS/ROAMING/@CH!='0,00'))">				
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
					CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO
				</xsl:with-param>
			</xsl:call-template>
            <!-- Chamadas Originadas -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Originadas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/OUTGOING/*[local-name()!='Z300']/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY"/>
                <xsl:with-param name="col_3_title">Origem/Destino</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
            <!-- Serviço 0300 -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Serviço 0300</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/OUTGOING/Z300/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/Z300"/>
                <xsl:with-param name="col_3_title">Origem</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
            <!-- Chamadas Recebidas -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Recebidas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/RECEIVED/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/RECEIVED"/>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="use_dialed_number">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
            <!-- Chamadas recebidas a cobrar em roaming -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas a Cobrar Recebidas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/COLLECT/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/COLLECT"/>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
		</xsl:if>
		<!--Desconto dentro da área de registro-->
        <xsl:if test="number(translate(CALLS/HOME/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
					DESCONTOS DENTRO DA ÁREA DE REGISTRO
				</xsl:with-param>
			</xsl:call-template>
            <!-- Chamadas descontos local -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Descontos de Chamadas Locais</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/INCOMING/DISCOUNTS/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/DISCOUNTS"/>
                <xsl:with-param name="desconto">TRUE</xsl:with-param>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
                <xsl:with-param name="col_5_value">Desconto</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
		</xsl:if>
		<!--Desconto fora da área de registro-->
        <xsl:if test="number(translate(CALLS/ROAMING/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
			<xsl:call-template name="HEADER-CONTA2">
				<xsl:with-param name="title">
					DESCONTOS FORA DA ÁREA DE REGISTRO (ROAMING)
				</xsl:with-param>
			</xsl:call-template>
            <!-- Chamadas descontos em roaming -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Descontos de Chamadas em Roaming</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/DISCOUNTS/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/DISCOUNTS"/>
                <xsl:with-param name="desconto">TRUE</xsl:with-param>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
                <xsl:with-param name="col_5_value">Desconto</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
		</xsl:if>
		<tr>
            <td colspan="15" class="text5" height="9">
                <img src="images/dot_black.gif" width="100%" height="3"/>
            </td>
        </tr>
	</xsl:template>	
	
	
	<!-- ============================================================================================================= -->	
	
	<xsl:template name="CHAMADAS-SRV">
        <!-- Título da "tabela" -->
		<xsl:param name="title"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">Y</xsl:param>        

        <!--Se houverem chamadas CDI-Diário-->
        <xsl:if test="($subtotals/@V!='0,00')">
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td colspan="4" class="text5" height="20">
					<b><xsl:value-of select="$title"/></b></td>		
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20">&#160;</td>
			</tr>
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b>Data</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b>Hora</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b>Min / Dur</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20" align="right">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20" align="right">
					<b>VALOR R$</b></td>
			</tr>
			
			<xsl:apply-templates select="$calls">
				<xsl:with-param name="is_idcd">
					<xsl:value-of select="$is_idcd"/>
				</xsl:with-param>                                                    
			</xsl:apply-templates>                    			

			<!--Mostra o Subtotal-->			
			<tr> 
                <td width="3%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="tex52" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="text5" height="20">
                	<b><xsl:text>Subtotal</xsl:text></b></td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20" align="right">
                	<b></b>
                </td>
                <td width="2%" class="text5" height="20"><b></b></td>
                <td width="11%" class="text5" height="20" align="right">
                	<b><xsl:call-template name="VALOR-OU-ZERO">
                		<xsl:with-param name="value">
                            <xsl:value-of select="$subtotals/@V"/>
                		</xsl:with-param>
                		</xsl:call-template>
                	</b></td>
            </tr>
			
			<tr>
				<td colspan="15" class="text5" height="9">
				<img src="images/dot_black.gif" width="100%" height="1"/></td>
			</tr>
		</xsl:if>
	</xsl:template>	


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
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td colspan="4" class="text5" height="20">
					<b><xsl:value-of select="$title"/></b></td>		
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20">&#160;</td>
			</tr>
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">
					<b>Data</b>
				</td>
				<td width="2%" class="text5" height="20">

				</td>
				<td width="15%" class="text5" height="20">
					<b>Hora</b>
				</td>
				<td width="2%" class="text5" height="20">&#160;
				
				</td>
				
				<td width="14%" class="text5" height="20" align="right">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20" align="right">
					<b>VALOR R$</b></td>
			</tr>
			
			<xsl:apply-templates select="$calls">
            	<xsl:with-param name="is_idcd">
                	<xsl:value-of select="$is_idcd"/>
                </xsl:with-param>
            	<xsl:with-param name="is_online">TRUE</xsl:with-param>                                                    
			</xsl:apply-templates>     
			                    			

			<!--Mostra o Subtotal-->			
			<tr> 
                <td width="3%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="tex52" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="text5" height="20">
                	<b><xsl:text>Subtotal</xsl:text></b></td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20" align="right">
                	<b></b>
                </td>
                <td width="2%" class="text5" height="20"><b></b></td>
                <td width="11%" class="text5" height="20" align="right">
                	<b><xsl:call-template name="VALOR-OU-ZERO">
                		<xsl:with-param name="value">
                            <xsl:value-of select="$subtotals/@V"/>
                		</xsl:with-param>
                		</xsl:call-template>
                	</b></td>
            </tr>
			
			<tr>
				<td colspan="15" class="text5" height="9">
				<img src="images/dot_black.gif" width="100%" height="1"/></td>
			</tr>
		</xsl:if>
	</xsl:template>	



    <!-- Serviços Interativos - SMS --> 
	<xsl:template name="CHAMADAS-SRVINT">
        <!-- Título da "tabela" -->
        <xsl:param name="title"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>    
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>        

        <!-- Se houverem chamadas NEXTEL ONLINE-->
        <xsl:if test="($subtotals/@V!='0,00')">
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td colspan="4" class="text5" height="20">
					<b><xsl:value-of select="$title"/></b></td>		
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20">&#160;</td>
			</tr>
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">
					<b>Data</b>
				</td>
				<td width="2%" class="text5" height="20">

				</td>
				<td width="15%" class="text5" height="20">
					<b>Hora</b>
				</td>
				<td width="2%" class="text5" height="20">&#160;
				
				</td>
				
				<td width="14%" class="text5" height="20" align="right">
					<b></b>
				</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20" align="right">
					<b>VALOR R$</b></td>
			</tr>
			
			<xsl:apply-templates select="$calls">
            	<xsl:with-param name="is_servint">TRUE</xsl:with-param>                                                                	
			</xsl:apply-templates>     
			                    			

			<!--Mostra o Subtotal-->			
			<tr> 
                <td width="3%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="tex52" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="text5" height="20">
                	<b><xsl:text>Subtotal</xsl:text></b></td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20" align="right">
                	<b></b>
                </td>
                <td width="2%" class="text5" height="20"><b></b></td>
                <td width="11%" class="text5" height="20" align="right">
                	<b><xsl:call-template name="VALOR-OU-ZERO">
                		<xsl:with-param name="value">
                            <xsl:value-of select="$subtotals/@V"/>
                		</xsl:with-param>
                		</xsl:call-template>
                	</b></td>
            </tr>
			
			<tr>
				<td colspan="15" class="text5" height="9">
				<img src="images/dot_black.gif" width="100%" height="1"/></td>
			</tr>
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

        <!-- Se houverem chamadas ou for desconto -->
        <!-- <xsl:if test="($subtotals/@DNF!='0,00' or $desconto = 'TRUE') or ($pre_paid='Y')"> -->
        <xsl:if test="(($subtotals/@DNF!='0:00' and $subtotals/@DNF!='0,00') or $desconto = 'TRUE') or ($pre_paid='Y')">                
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td colspan="4" class="text5" height="20">
					<b><xsl:value-of select="$title"/></b></td>		
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20">&#160;</td>
			</tr>
			<tr>
				<td width="3%" class="text5" height="20">&#160;</td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b>Data</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="7%" class="text5" height="20">
					<b>Hora</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b><xsl:value-of select="$col_3_title"/></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20">
					<b><xsl:value-of select="$col_4_title"/></b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="15%" class="text5" height="20">
					<b>Tipo Chamada</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="14%" class="text5" height="20" align="right">
					<b>Min / Dur</b></td>
				<td width="2%" class="text5" height="20">&#160;</td>
				<td width="11%" class="text5" height="20" align="right">
					<b>VALOR R$</b></td>
			</tr>
			<!--Mostra todas as chamadas deste contrato-->
            <xsl:apply-templates select="$calls">
				<xsl:with-param name="desconto">
				    <xsl:value-of select="$desconto"/>
				</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">
                    <xsl:value-of select="$use_call_origin_city"/>
                </xsl:with-param>
                <xsl:with-param name="use_dialed_number">
                    <xsl:value-of select="$use_dialed_number"/>
                </xsl:with-param>
                <xsl:with-param name="col_5_value">
                    <xsl:value-of select="$col_5_value"/>
                </xsl:with-param>
                <xsl:with-param name="apply_mobile_check">
                    <xsl:value-of select="$apply_mobile_check"/>
                </xsl:with-param>
                <xsl:with-param name="hifenize_number">
                    <xsl:value-of select="$hifenize_number"/>
                </xsl:with-param>
                <!-- Sort calls by call-index (@MN) and sub-number (@SN) -->
                <xsl:sort select="@MN" data-type="number"/>
                <xsl:sort select="@SN" data-type="number"/>
            </xsl:apply-templates>

		<!--Mostra o Subtotal-->			
		<tr> 
                <td width="3%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="7%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="tex52" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20">&#160;</td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="15%" class="text5" height="20">
                	<b><xsl:text>Subtotal</xsl:text></b></td>
                <td width="2%" class="text5" height="20">&#160;</td>
                <td width="14%" class="text5" height="20" align="right">
                	<b><xsl:call-template name="VALOR-OU-ZERO">
                		   <xsl:with-param name="value">
		                       <xsl:if test="$desconto='FALSE'"> <!-- and $pre_paid='N'" -->
		                           <xsl:value-of select="$subtotals/@DNF"/>
		                       </xsl:if>
		                       <xsl:if test="$desconto='TRUE'">
		                           <xsl:value-of select="$subtotals/@CHT"/>
                               </xsl:if>
                           </xsl:with-param>
                		</xsl:call-template></b></td>
                <td width="2%" class="text5" height="20"><b></b></td>
                <td width="11%" class="text5" height="20" align="right">
                	<b><xsl:call-template name="VALOR-OU-ZERO">
                		<xsl:with-param name="value">
                            <xsl:value-of select="$subtotals/@V"/>
                		</xsl:with-param>
                		</xsl:call-template>
                	</b></td>
            </tr>
			
			<tr>
				<td colspan="15" class="text5" height="9">
				<img src="images/dot_black.gif" width="100%" height="1"/></td>
			</tr>
		</xsl:if>
	</xsl:template>


	<xsl:template match="CALL">
		<!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->
		<xsl:param name="col_5_value">Longa Distância</xsl:param>
        <xsl:param name="desconto">FALSE</xsl:param>
		<!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->
		<xsl:param name="use_call_origin_city">TRUE</xsl:param>
		<!-- Mostrar o número chamado ou não. Por padrão mostrar -->
		<xsl:param name="use_dialed_number">TRUE</xsl:param>
		<!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->
		<xsl:param name="apply_mobile_check">FALSE</xsl:param>
		<!-- Indica se o número de telefone deve ser hifenizado -->
		<xsl:param name="hifenize_number">TRUE</xsl:param>
		<xsl:param name="is_idcd"/>
		<xsl:param name="is_online"/> 
        <!-- Serviços Interativos - SMS -->  		                                                   		
		<xsl:param name="is_servint"/> 		
	
        <!-- ******************************* --> 
        <!-- * Special Number Verification * --> 
        <!-- ******************************* -->
        <xsl:variable name="callNumber" select="@N"/>
		<xsl:variable name="originalNumber" select="document('../../SpecialCallNumber.xml')/document/number[contains($callNumber,@originalNumber)]/@originalNumber"/>        
	    <xsl:variable name="showNumberTemp" select="document('../../SpecialCallNumber.xml')/document/number[contains($callNumber,@originalNumber)]/@showNumber"/>
	    <xsl:variable name="showNumber" select="concat(substring-before($callNumber,$originalNumber),$showNumberTemp)"/>			
				
		
        <!-- Se for dado de chamada ou desconto, mostre -->
        <xsl:if test="($desconto='TRUE' or @SN!='1')">
          <xsl:choose>
          <xsl:when test="$is_online='TRUE'">
        
 			<tr valign="top">
				<td width="3%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="15%" class="text5" height="11"></td>				
				<td width="7%" class="text5" height="11"></td>
				<td width="7%" class="text5" height="11"></td>
				<td width="2%" class="text5" height="11">&#160;</td>

				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11">
				<xsl:value-of select="@DT"/><br/>							
				</td>
				<td width="2%" class="text5" height="11">&#160;
						
				</td>
				<td width="15%" class="text5" height="11">
					<xsl:value-of select="@TM"/><br/>
				</td>
				<td width="2%" class="text5" height="11">
				</td>				
				<td width="14%" class="text5" height="11" align="right"></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="11%" class="text5" height="11" align="right">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
				</td>
			</tr>       
	        
    	  </xsl:when>

          <!-- Serviços Interativos - SMS -->  
          <xsl:when test="$is_servint='TRUE'">
        
 			<tr valign="top">
				<td width="3%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="15%" class="text5" height="11">
				<xsl:value-of select="@DS"/><br/>							
				</td>
				<td width="7%" class="text5" height="11"></td>				
				<td width="7%" class="text5" height="11"></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<!-- <td width="15%" class="text5" height="11"></td>  -->
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11">
				<xsl:value-of select="@DT"/><br/>							
				</td>
				<td width="2%" class="text5" height="11">&#160;
						
				</td>
				<td width="15%" class="text5" height="11">
					<xsl:value-of select="@TM"/><br/>
				</td>
				<td width="2%" class="text5" height="11">
				</td>				
				<td width="14%" class="text5" height="11" align="right"></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="11%" class="text5" height="11" align="right">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
				</td>
			</tr>       
	        
    	  </xsl:when>
    	  
    	  <xsl:otherwise>    
			<tr valign="top">
				<td width="3%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="7%" class="text5" height="11">
					<xsl:value-of select="@DT"/><br/></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="7%" class="text5" height="11">
					<xsl:value-of select="@TM"/><br/></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="15%" class="text5" height="11">
					<xsl:if test="$use_call_origin_city='TRUE'">
						<xsl:value-of select="@SC"/>
						<xsl:if test="(string-length(@SC) &gt; 0) and (string-length(@DN) &gt; 0)">
							<xsl:text>/</xsl:text>
						</xsl:if>
					</xsl:if>
                    <xsl:choose>
                        <xsl:when test="starts-with(@N,'0300')">
                            <xsl:value-of select="@SC"/>
                        </xsl:when>
                    <!-- ******************** --> 
                    <!--  Mensagem Automática -->
                    <!--  frv - 02/07/2007 -->                       
                    <xsl:when test="starts-with(@SC,'Msg.Automática')">
                    <xsl:value-of select="@SC" />
                    </xsl:when>
                    <!-- ******************** --> 	                	                	                
                        
                        <xsl:otherwise>
                            <xsl:value-of select="@DN"/>
                        </xsl:otherwise>
                    </xsl:choose>
					<br/></td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11">
					<xsl:if test="$use_dialed_number='TRUE'">
		                <xsl:choose>
		                	<xsl:when test="string-length($showNumber) &gt; 0">
                          		<xsl:value-of select="$showNumber"/>                	
		                	</xsl:when>
		                	<xsl:otherwise>
	                            <xsl:value-of select="@N"/>
		                	</xsl:otherwise>
		                </xsl:choose>					
					</xsl:if>
				</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="15%" class="text5" height="11">
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
				</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11" align="right">
                   	<xsl:if test="$is_idcd!='Y'">				
						<xsl:value-of select="@DR"/>
					</xsl:if>
				</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="11%" class="text5" height="11" align="right">
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
				</td>
			</tr>
		  </xsl:otherwise>		
		  </xsl:choose>	
		</xsl:if>
        <xsl:if test="($desconto='FALSE' and (@SN='1' and @V!='0,00'))">
			<tr valign="top">
				<td width="3%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="7%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="7%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
                <td width="15%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="15%" class="text5" height="11">
                    <xsl:text>Interconexão</xsl:text>
				</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="14%" class="text5" height="11" align="right">&#160;</td>
				<td width="2%" class="text5" height="11">&#160;</td>
				<td width="11%" class="text5" height="11" align="right">
					<xsl:value-of select="@V"/>
				</td>
			</tr>
        </xsl:if>
	</xsl:template>
	</xsl:stylesheet>