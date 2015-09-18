<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">    <!-- *********************************** -->    <!-- * Resumo da conta de cada usuário * -->    <!-- *********************************** -->	
	<xsl:template name="DETALHE-CONTA-SRV">
        <!-- Serviços Adicionais / Serviços de Terceiros. Só mostra se houver algum -->	
        <xsl:if test="CALLS/IDCD/@V!='0,00'">
            <!-- Chamadas de rádio internacionais utilizando o serviço CDI Diário -->        
            <xsl:text>SERVIÇOS ADICIONAIS</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>
            
            <xsl:call-template name="CHAMADAS-SRV">
                <xsl:with-param name="title">Conexão Direta Internacional - Diário</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/IDCD/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/IDCD"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:if> 
	</xsl:template>
	
    <!-- ********************************* -->    
	<!-- NEXTEL ONLINE (SERVIÇOS DE DADOS) -->
    <!-- ********************************* -->
	<xsl:template name="DETALHE-CONTA-ONLINE">
            <!-- Serviços Adicionais / Serviços de Terceiros. Só mostra se houver algum -->
            <!--  <xsl:if test="CALLS/ONLINE/SVC/@ID='LOLGT' or CALLS/ONLINE/SVC/@ID='SMSSI'"> -->
            <xsl:if test="CALLS/ONLINE/SVC/@ID='LOLGT'">
                <xsl:text>NEXTEL ONLINE (SERVIÇOS DE DADOS)</xsl:text>
            	<xsl:text>&#13;&#10;</xsl:text>
            	                
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
				
            	<xsl:text>&#13;&#10;</xsl:text>                
			</xsl:if>		
	</xsl:template>	
	

    <xsl:template name="DETALHE-CONTA">

        <!-- Chamadas de telefonia dentro da área de registro. Só mostra se houver alguma -->
        <!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or (@PP='Y' and CALLS/HOME/@CH!='0,00')"> -->
        <xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (@PP='Y' and (CALLS/HOME/@CH!='0:00' and CALLS/HOME/@CH!='0,00'))">        

            <!-- Chamadas de telefonia dentro da área de registro -->
            <xsl:text>CHAMADAS DE TELEFONIA DENTRO DA ÁREA DE REGISTRO</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>
            
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


            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Chamadas de longa distância -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas de Longa Distância</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/LONG_DISTANCE/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LONG_DISTANCE"/>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Chamadas locais recebidas -->
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
            
            <xsl:text>&#13;&#10;</xsl:text>

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
            
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Chamadas internacionais -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Internacionais</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/INTERNATIONAL/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/INTERNATIONAL"/>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
            
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Serviço 0300 -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Serviço 0300</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/HOME/OUTGOING/Z300/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/Z300"/>
                <xsl:with-param name="col_3_title">Origem</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>
            
            <xsl:text>&#13;&#10;</xsl:text>

        </xsl:if>
        <!-- Chamadas de telefonia fora da área de registro (roaming). Só mostra se houver alguma -->
        <!-- <xsl:if test="CALLS/ROAMING/@DNF!='0,00' or (@PP='Y' and CALLS/ROAMING/@CH!='0,00')"> -->
        <xsl:if test="(CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or (@PP='Y' and (CALLS/ROAMING/@CH!='0:00' and CALLS/ROAMING/@CH!='0,00'))">                
            <!-- Chamadas de telefonia dentro da área de registro -->
            <xsl:text>CHAMADAS DE TELEFONIA FORA DA ÁREA DE REGISTRO (ROAMING)</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>


            <!-- Chamadas Originadas -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Originadas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/OUTGOING/*[local-name()!='Z300']/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY"/>
                <xsl:with-param name="col_3_title">Origem/Destino</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Serviço 0300 -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Serviço 0300</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/OUTGOING/Z300/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/Z300"/>
                <xsl:with-param name="col_3_title">Origem</xsl:with-param>
                <xsl:with-param name="use_call_origin_city">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Chamadas Recebidas -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas Recebidas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/RECEIVED/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/RECEIVED"/>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="use_dialed_number">FALSE</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Chamadas recebidas a cobrar em roaming -->
            <xsl:call-template name="CHAMADAS">
                <xsl:with-param name="title">Chamadas a Cobrar Recebidas</xsl:with-param>
                <xsl:with-param name="calls" select="CALLS/ROAMING/INCOMING/COLLECT/descendant::CALL"/>
                <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/COLLECT"/>
                <xsl:with-param name="col_3_title">Área de Recebimento</xsl:with-param>
                <xsl:with-param name="col_4_title">Nº Chamador</xsl:with-param>
                <xsl:with-param name="pre_paid" select="@PP"/>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

        </xsl:if>

		<!--Desconto dentro da área de registro-->
        <xsl:if test="number(translate(CALLS/HOME/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">

            <!-- Descontos de telefonia dentro da área de registro -->
            <xsl:text>DESCONTOS DENTRO DA ÁREA DE REGISTRO</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

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

            <xsl:text>&#13;&#10;</xsl:text>
            
		</xsl:if>
		
		<!--Desconto fora da área de registro-->
        <xsl:if test="number(translate(CALLS/ROAMING/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">

            <!-- Descontos de telefonia fora da área de registro -->
            <xsl:text>DESCONTOS FORA DA ÁREA DE REGISTRO (ROAMING)</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

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
            <xsl:text>&#13;&#10;</xsl:text>
		</xsl:if>
    </xsl:template>


	<!-- =================================================================================================== -->

	
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

        <!-- Se houverem chamadas ou for desconto -->
        <xsl:if test="($subtotals/@V!='0,00')">

            <!-- Primeira linha do cabeçalho -->
            <xsl:value-of select="$title"/>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Segunda linha do cabeçalho -->
            <xsl:text>Data</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Hora</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text></xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text></xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Min / Dur</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text></xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>VALOR R$</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Mostra cada chamada desse contrato -->
			<xsl:apply-templates select="$calls">
				<xsl:with-param name="is_idcd">
					<xsl:value-of select="$is_idcd"/>
				</xsl:with-param>                                                    
			</xsl:apply-templates>                    

            <!-- Subtotal -->
            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>
            <xsl:text>Subtotal</xsl:text>
            <xsl:text>&#9;</xsl:text>

            <xsl:text>&#9;</xsl:text>

            <!-- Valor total de todas as chamadas -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$subtotals/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            
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

            <!-- Primeira linha do cabeçalho -->
            <xsl:value-of select="$title"/>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Segunda linha do cabeçalho -->
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Data</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Hora</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>VALOR R$</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Mostra cada chamada desse contrato -->
 			<xsl:apply-templates select="$calls">
				<xsl:with-param name="is_idcd">
					<xsl:value-of select="$is_idcd"/>
				</xsl:with-param>      
				<xsl:with-param name="is_online">TRUE</xsl:with-param>
			</xsl:apply-templates>                    

            <!-- Subtotal -->
            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>
            <xsl:text>Subtotal</xsl:text>
            <xsl:text>&#9;</xsl:text>

            <xsl:text>&#9;</xsl:text>

            <!-- Valor total de todas as chamadas -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$subtotals/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            
        </xsl:if>

    </xsl:template>    
	
    <!-- ************************************************************** -->
    <!-- * Mostra as chamadas de NEXTEL ONLINE (SERVIÇOS INTERATIVOS) * -->
    <!-- ************************************************************** -->
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

            <!-- Primeira linha do cabeçalho -->
            <xsl:value-of select="$title"/>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Segunda linha do cabeçalho -->
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Data</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Hora</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>VALOR R$</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Mostra cada chamada desse contrato -->
 			<xsl:apply-templates select="$calls">
				<xsl:with-param name="is_servint">TRUE</xsl:with-param>
			</xsl:apply-templates>                    

            <!-- Subtotal -->
            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>
            <xsl:text>Subtotal</xsl:text>
            <xsl:text>&#9;</xsl:text>

            <xsl:text>&#9;</xsl:text>

            <!-- Valor total de todas as chamadas -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$subtotals/@V"/>
                </xsl:with-param>
            </xsl:call-template>
            
        </xsl:if>

    </xsl:template>    

    <!-- ************************************* -->    <!-- * Mostra as chamadas detalhadamente * -->    <!-- ************************************* -->    <xsl:template name="CHAMADAS">        <!-- Título da "tabela" -->        <xsl:param name="title"/>        <!-- Parametro para tratamento especial de impressão de descontos. -->        <xsl:param name="desconto">FALSE</xsl:param>        <!-- Nome da 3a. coluna -->        <xsl:param name="col_3_title">Destino</xsl:param>        <!-- Nome da 4a. coluna -->        <xsl:param name="col_4_title">Nº Chamado</xsl:param>        <!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->        <xsl:param name="col_5_value">Longa Distância</xsl:param>        <!-- Node-set de chamadas -->        <xsl:param name="calls"/>        <!-- Elemento com os valores totalizados -->        <xsl:param name="subtotals"/>        <!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->        <xsl:param name="use_call_origin_city">TRUE</xsl:param>        <!-- Mostrar o número chamado ou não. Por padrão mostrar -->        <xsl:param name="use_dialed_number">TRUE</xsl:param>        <!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->        <xsl:param name="apply_mobile_check">FALSE</xsl:param>        <!-- Indica se o telefone é pré-pago ou não -->        <xsl:param name="pre_paid">N</xsl:param>        <!-- Se houverem chamadas ou for desconto -->        <!-- <xsl:if test="($subtotals/@DNF!='0,00' or $desconto = 'TRUE') or ($pre_paid='Y' and $subtotals/@CHA!='0,00')"> -->
        <xsl:if test="(($subtotals/@DNF!='0:00' and $subtotals/@DNF!='0,00') or $desconto = 'TRUE') or ($pre_paid='Y' and ($subtotals/@CHA!='0:00' and $subtotals/@CHA!='0,00'))">

            <!-- Primeira linha do cabeçalho -->            <xsl:value-of select="$title"/>            <xsl:text>&#13;&#10;</xsl:text>            <!-- Segunda linha do cabeçalho -->            <xsl:text>Data</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>Hora</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:value-of select="$col_3_title"/>            <xsl:text>&#9;</xsl:text>            <xsl:text>Nº Chamado</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>Tipo Chamada</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>Min / Dur</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>VALOR R$</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>            <!-- Mostra cada chamada desse contrato -->            <xsl:apply-templates select="$calls">                <xsl:with-param name="desconto">                    <xsl:value-of select="$desconto"/>                </xsl:with-param>                <xsl:with-param name="use_call_origin_city">                    <xsl:value-of select="$use_call_origin_city"/>                </xsl:with-param>                <xsl:with-param name="use_dialed_number">                    <xsl:value-of select="$use_dialed_number"/>                </xsl:with-param>                <xsl:with-param name="col_5_value">                    <xsl:value-of select="$col_5_value"/>                </xsl:with-param>                <xsl:with-param name="apply_mobile_check">                    <xsl:value-of select="$apply_mobile_check"/>
                </xsl:with-param>                <!-- Sort calls by call-index (@MN) and sub-number (@SN) -->                <xsl:sort select="@MN" data-type="number"/>                <xsl:sort select="@SN" data-type="number"/>            </xsl:apply-templates>            <!-- Subtotal -->            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>            <xsl:text>Subtotal</xsl:text>            <xsl:text>&#9;</xsl:text>            <!-- Duração total de todas as chamadas sem contabilizar as gratuitas -->            <xsl:call-template name="VALOR-OU-ZERO">                <xsl:with-param name="value">	                <xsl:if test="$desconto='FALSE'"> <!--  and $pre_paid='N'" -->	                    <xsl:value-of select="$subtotals/@DNF"/>	                </xsl:if>	                <xsl:if test="$desconto='TRUE'">	                    <xsl:value-of select="$subtotals/@CHT"/>	                </xsl:if>                </xsl:with-param>            </xsl:call-template>            <xsl:text>&#9;</xsl:text>            <!-- Valor total de todas as chamadas -->            <xsl:call-template name="VALOR-OU-ZERO">                <xsl:with-param name="value">                    <xsl:value-of select="$subtotals/@V"/>                </xsl:with-param>            </xsl:call-template>                    </xsl:if>    </xsl:template>    <!-- ************************************************************************************************ -->    <!-- * Decide se o dado a ser mostrado é de chamada ou de interconexão, mostrando-o apropriadamente * -->    <!-- ************************************************************************************************ -->    <xsl:template match="CALL">        <!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->        <xsl:param name="col_5_value">Longa Distância</xsl:param>        <xsl:param name="desconto">FALSE</xsl:param>        <!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->        <xsl:param name="use_call_origin_city">TRUE</xsl:param>        <!-- Mostrar o número chamado ou não. Por padrão mostrar -->        <xsl:param name="use_dialed_number">TRUE</xsl:param>        <!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->        <xsl:param name="apply_mobile_check">FALSE</xsl:param>
		<xsl:param name="is_idcd"/>
		<xsl:param name="is_online"/>
        <!-- Serviços Interativos - SMS -->  		
		<xsl:param name="is_servint"/>		
		
        <!-- ******************************* --> 
        <!-- * Special Number Verification * --> 
        <!-- ******************************* --> 
        <xsl:variable name="callNumber" select="@N"/>
		<xsl:variable name="originalNumber" select="document('../SpecialCallNumber.xml')/document/number[contains($callNumber,@originalNumber)]/@originalNumber"/>        
	    <xsl:variable name="showNumberTemp" select="document('../SpecialCallNumber.xml')/document/number[contains($callNumber,@originalNumber)]/@showNumber"/>
	    <xsl:variable name="showNumber" select="concat(substring-before($callNumber,$originalNumber),$showNumberTemp)"/>		
		
        <!-- Se for dado de chamada ou desconto, mostre -->        <xsl:if test="($desconto='TRUE' or @SN!='1')">
        
          <xsl:choose>
        	<xsl:when test="$is_online='TRUE'">
        	
	            <!-- Data da chamada -->
				<xsl:text>&#9;</xsl:text>	            
				<xsl:text>&#9;</xsl:text>
				<xsl:text>&#9;</xsl:text>								
	            <xsl:value-of select="@DT"/>
	            <xsl:text>&#9;</xsl:text>
	            <!-- Horario da chamada -->
	            <xsl:value-of select="@TM"/>
	            <xsl:text>&#9;</xsl:text>
	            <xsl:text>&#9;</xsl:text>	            
	            <!-- Valor da chamada -->
	            <xsl:call-template name="VALOR-OU-ZERO">
	                <xsl:with-param name="value">
	                    <xsl:value-of select="@V"/>
	                </xsl:with-param>
	            </xsl:call-template>
	            <xsl:text>&#13;&#10;</xsl:text>        	
        	
        	</xsl:when>

            <!-- Serviços Interativos - SMS -->          	
        	<xsl:when test="$is_servint='TRUE'">        	
	            <!-- Data da chamada -->
				<xsl:text>&#9;</xsl:text>	            
	            <xsl:value-of select="@DS"/>
				<xsl:text>&#9;</xsl:text>								
	            <xsl:value-of select="@DT"/>
	            <xsl:text>&#9;</xsl:text>
	            <!-- Horario da chamada -->
	            <xsl:value-of select="@TM"/>
	            <xsl:text>&#9;</xsl:text>
	            <xsl:text>&#9;</xsl:text>	            
	            <!-- Valor da chamada -->
	            <xsl:call-template name="VALOR-OU-ZERO">
	                <xsl:with-param name="value">
	                    <xsl:value-of select="@V"/>
	                </xsl:with-param>
	            </xsl:call-template>
	            <xsl:text>&#13;&#10;</xsl:text>        	        	
        	</xsl:when>
        	
        	<xsl:otherwise>	            <!-- Data da chamada -->	            <xsl:value-of select="@DT"/>	            <xsl:text>&#9;</xsl:text>	            <!-- Horario da chamada -->	            <xsl:value-of select="@TM"/>	            <xsl:text>&#9;</xsl:text>	            <!-- Decide se a origem da chamada deve ser impressa -->	            <xsl:if test="$use_call_origin_city='TRUE'">	                <!-- Origem da chamada -->	                <xsl:value-of select="@SC"/>	                <!-- Devemos por uma "/" se a origem e o destino não forem strings vazias -->	                <xsl:if test="(string-length(@SC) &gt; 0) and (string-length(@DN) &gt; 0)">	                    <xsl:text>/</xsl:text>                                	                </xsl:if>	            </xsl:if>	            <!-- Destino -->	            <xsl:choose>	                <xsl:when test="starts-with(@N,'0300')">	                    <xsl:value-of select="@SC"/>	                </xsl:when>	                <xsl:otherwise>	                    <xsl:value-of select="@DN"/>	                </xsl:otherwise>	            </xsl:choose>	            <xsl:text>&#9;</xsl:text>	            <!-- Número do telefone chamado/recebido -->	            <xsl:if test="$use_dialed_number='TRUE'">	                <xsl:choose>
	                	<xsl:when test="string-length($showNumber) &gt; 0">
	                       	<xsl:value-of select="$showNumber"/>                	
	                	</xsl:when>
	                	<xsl:otherwise>
	                       <xsl:value-of select="@N"/>
	                	</xsl:otherwise>
	                </xsl:choose>					
	            </xsl:if>	            <xsl:text>&#9;</xsl:text>	            <!-- Tipo da chamada (Local/Longa Distância/....) -->	            <xsl:choose>
	              	<xsl:when test="$is_idcd='Y'">
	                    <xsl:text>Ilimitado no dia</xsl:text>                        		
	              	</xsl:when>            	                <xsl:when test="(@TP='LOCAL') and (@CL='M')">	                    <xsl:text>Local/Celular</xsl:text>	                </xsl:when>	                <xsl:otherwise>	                    <xsl:choose>	                        <xsl:when test="@TP='LOCAL'">	                            <xsl:text>Local</xsl:text>	                        </xsl:when>	                        <xsl:otherwise>	                            <xsl:text>Longa Distância</xsl:text>	                        </xsl:otherwise>	                    </xsl:choose>	                </xsl:otherwise>	            </xsl:choose>		            <xsl:text>&#9;</xsl:text>	            <!-- Duração da chamada, em minutos -->
	           	<xsl:if test="$is_idcd!='Y'">            		            <xsl:value-of select="@DR"/>
		        </xsl:if>	            <xsl:text>&#9;</xsl:text>	            <!-- Valor da chamada -->	            <xsl:call-template name="VALOR-OU-ZERO">	                <xsl:with-param name="value">	                    <xsl:value-of select="@V"/>	                </xsl:with-param>	            </xsl:call-template>	            <xsl:text>&#13;&#10;</xsl:text>
	            
			</xsl:otherwise>    
          </xsl:choose>             </xsl:if>              <!-- Se for dado de interconexão, mostre -->        <xsl:if test="($desconto='FALSE' and (@SN='1' and @V!='0,00'))">            <xsl:text>&#9;</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>&#9;</xsl:text>            <xsl:text>Interconexão</xsl:text>            <xsl:text>&#9;</xsl:text>            <!-- Valor da interconexão -->            <xsl:value-of select="@V"/>            <xsl:text>&#13;&#10;</xsl:text>        </xsl:if>    </xsl:template></xsl:stylesheet>