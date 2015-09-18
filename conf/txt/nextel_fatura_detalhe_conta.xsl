<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">
	
    <!-- *********************************** -->
    <!-- * Resumo da conta de cada usuário * -->
    <!-- *********************************** -->

    <!-- 4004-PORTO -->
    <!-- <xsl:variable name="specialCallNumbers" select="document('../html/Vx/SpecialCallNumber.xml')/document"/>  -->
    <xsl:variable name="specialCallNumbers" select="document('../xml/SpecialCallNumber.xml')/document"/>     

	<xsl:template name="DETALHE-CONTA-SRV">
        <!-- Chamadas de telefonia dentro da área de registro. Só mostra se houver alguma -->
        <xsl:if test="CALLS/IDCD/@V != '0,00'">
          <!-- Chamadas de telefonia dentro da área de registro -->
          <xsl:call-template name="CHAMADAS-SRV">
            <xsl:with-param name="item_key" select="$DC_IntDirectConnectKey" />
            <xsl:with-param name="end_key" select="$DC_IntDirectConnectEndKey" />
            <xsl:with-param name="calls" select="CALLS/IDCD/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/IDCD" />
          </xsl:call-template>
        </xsl:if>
	</xsl:template>

	<xsl:template name="DETALHE-CONTA-ONLINE">
        <!-- Nextel Online (serviços de dados). Só mostra se houver alguma -->
        <xsl:if test="CALLS/ONLINE/SVC/@ID = 'LOLGT'">
          <!-- Chamadas de telefonia dentro da área de registro -->
          <xsl:call-template name="CHAMADAS-ONLINE">
            <xsl:with-param name="item_key" select="$DC_DailyLocatorKey" />
            <xsl:with-param name="end_key" select="$DC_DailyLocatorEndKey" />
            <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='LOLGT']/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='LOLGT']" />
          </xsl:call-template>
        </xsl:if>
	</xsl:template>	
    
    <!-- ********************************** -->
    <!-- * Detalhe - Serviços Interativos * -->
    <!-- ********************************** -->	
    <!-- Serviços Interativos - SMS -->    
	<xsl:template name="DETALHE-CONTA-SRVINT">
        <!-- Nextel Online (serviços de dados). Só mostra se houver alguma -->
        <xsl:if test="CALLS/ONLINE/SVC/@ID = 'SMSSI'">
          <!-- Chamadas de telefonia dentro da área de registro -->
          <xsl:call-template name="CHAMADAS-SRVINT">
            <xsl:with-param name="item_key" select="$DC_InteractiveServKey" />
            <xsl:with-param name="end_key" select="$DC_InteractiveServEndKey" />
            <xsl:with-param name="calls" select="CALLS/ONLINE/SVC[@ID='SMSSI']/descendant::CALL" />
            <xsl:with-param name="subtotals" select="CALLS/ONLINE/SVC[@ID='SMSSI']" />
          </xsl:call-template>
        </xsl:if>
	</xsl:template>	

    <!-- ************************************************ -->
    <!-- * Mostra as chamadas CDI Diário detalhadamente * -->
    <!-- ************************************************ -->
    <xsl:template name="CHAMADAS-SRV">
        <!-- Valor da chave de cada item (chamada) -->
        <xsl:param name="item_key"/>
        <!-- Valor da chave de finalização -->
        <xsl:param name="end_key"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>
		<!-- Indica se é CDI Diário -->
		<xsl:param name="is_idcd">Y</xsl:param>
        
        <xsl:choose>
            <!-- Se houverem chamadas ou for desconto -->
            <xsl:when test="$subtotals/@V != '0,00'">
                <!-- Mostra cada chamada desse contrato -->
                <xsl:apply-templates select="$calls">
                    <xsl:with-param name="key" select="$item_key"/>
                    <xsl:with-param name="is_idcd" select="$is_idcd"/>                    
                </xsl:apply-templates>
                <!-- Subtotal -->
                <xsl:value-of select="$end_key"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="$subtotals/@V"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end_key"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    

    <!-- ************************************* -->
    <!-- * NEXTEL ONLINE (SERVIÇOS DE DADOS) * -->
    <!-- ************************************* -->
    <xsl:template name="CHAMADAS-ONLINE">
        <!-- Valor da chave de cada item (chamada) -->
        <xsl:param name="item_key"/>
        <!-- Valor da chave de finalização -->
        <xsl:param name="end_key"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>
        
        <xsl:choose>
            <!-- Se houverem chamadas ou for desconto -->
            <xsl:when test="$subtotals/@V != '0,00'">
                <!-- Mostra cada chamada desse contrato -->
                <xsl:apply-templates select="$calls">
                    <xsl:with-param name="key" select="$item_key"/>
                    <xsl:with-param name="is_online">TRUE</xsl:with-param>
                </xsl:apply-templates>
                <!-- Subtotal -->
                <xsl:value-of select="$end_key"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="$subtotals/@V"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end_key"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    

    <!-- **************************************** -->
    <!-- * NEXTEL ONLINE (SERVIÇOS INTERATIVOS) * -->
    <!-- **************************************** -->
    <!-- Serviços Interativos - SMS -->    
    <xsl:template name="CHAMADAS-SRVINT">
        <!-- Valor da chave de cada item (chamada) -->
        <xsl:param name="item_key"/>
        <!-- Valor da chave de finalização -->
        <xsl:param name="end_key"/>
        <!-- Node-set de chamadas -->
        <xsl:param name="calls"/>
        <!-- Elemento com os valores totalizados -->
        <xsl:param name="subtotals"/>
        
        <xsl:choose>
            <!-- Se houverem chamadas ou for desconto -->
            <xsl:when test="$subtotals/@V != '0,00'">
                <!-- Mostra cada chamada desse contrato -->
                <xsl:apply-templates select="$calls">
                    <xsl:with-param name="key" select="$item_key"/>
                    <xsl:with-param name="is_servint">TRUE</xsl:with-param>
                </xsl:apply-templates>
                <!-- Subtotal -->
                <xsl:value-of select="$end_key"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="$subtotals/@V"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end_key"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <!-- ============================================================================================= -->



    <xsl:template name="DETALHE-CONTA">

        <!-- Chamadas de telefonia dentro da área de registro. Só mostra se houver alguma -->
        <xsl:choose>
            <xsl:when test="CALLS/HOME/@DNF != '0:00' or (@PP='Y' and CALLS/HOME/@CH != '0:00')">            

                <!-- Chamadas de telefonia dentro da área de registro -->

                <!-- Chamadas locais -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"             select="$DC_localHomeKey"/>
                    <xsl:with-param name="end_key"              select="$DC_localHomeEndKey"/>
                    <xsl:with-param name="calls"                select="CALLS/HOME/OUTGOING/LOCAL/descendant::CALL"/>
                    <xsl:with-param name="subtotals"            select="CALLS/HOME/OUTGOING/LOCAL"/>
                    <xsl:with-param name="col_5_value"          select="'Local'"/>
                    <xsl:with-param name="use_call_origin_city" select="'FALSE'"/>
                    <xsl:with-param name="apply_mobile_check"   select="'TRUE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>
                
                <!-- Chamadas de longa distância -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_longHomeKey"/>
                    <xsl:with-param name="end_key"   select="$DC_longHomeEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/HOME/OUTGOING/LONG_DISTANCE/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/LONG_DISTANCE"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>
                
                <!-- Chamadas locais recebidas a cobrar -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"             select="$DC_recCollectHomeKey"/>
                    <xsl:with-param name="end_key"              select="$DC_recCollectHomeEndKey"/>
                    <xsl:with-param name="calls"                select="CALLS/HOME/INCOMING/COLLECT/descendant::CALL"/>
                    <xsl:with-param name="subtotals"            select="CALLS/HOME/INCOMING/COLLECT"/>
                    <xsl:with-param name="col_5_value"          select="'Local'"/>
                    <xsl:with-param name="use_call_origin_city" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>
                
                <!-- Chamadas locais recebidas -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"             select="$DC_receivedHomeKey"/>
                    <xsl:with-param name="end_key"              select="$DC_receivedHomeEndKey"/>
                    <xsl:with-param name="calls"                select="CALLS/HOME/INCOMING/RECEIVED/descendant::CALL"/>
                    <xsl:with-param name="subtotals"            select="CALLS/HOME/INCOMING/RECEIVED"/>
                    <xsl:with-param name="col_5_value"          select="'Local'"/>
                    <xsl:with-param name="use_call_origin_city" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>
                
                <!-- Chamadas internacionais -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"        select="$DC_internationalHomeKey"/>
                    <xsl:with-param name="end_key"         select="$DC_internationalHomeEndKey"/>
                    <xsl:with-param name="calls"           select="CALLS/HOME/OUTGOING/INTERNATIONAL/descendant::CALL"/>
                    <xsl:with-param name="subtotals"       select="CALLS/HOME/OUTGOING/INTERNATIONAL"/>
                    <xsl:with-param name="hifenize-number" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>

                <!-- Serviço 0300 -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_z300HomeKey"/>
                    <xsl:with-param name="end_key"   select="$DC_z300HomeEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/HOME/OUTGOING/Z300/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/HOME/OUTGOING/Z300"/>
                    <xsl:with-param name="use_call_origin_city" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DC_localHomeEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_longHomeEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_recCollectHomeEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_receivedHomeEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_internationalHomeEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_z300HomeEndKey"/>
                <xsl:value-of select="$newline"/>
                
            </xsl:otherwise>
        </xsl:choose>

        <!-- Chamadas de telefonia fora da área de registro (roaming). Só mostra se houver alguma -->
        <xsl:choose>
            <xsl:when test="CALLS/ROAMING/@DNF != '0:00' or (@PP='Y' and CALLS/ROAMING/@CH != '0:00')">            

                <!-- Chamadas Originadas -->
                <xsl:variable name="outgoingCalls">
                    <xsl:for-each select="CALLS/ROAMING/OUTGOING/*[local-name()!='Z300']/descendant::CALL">
                        <xsl:sort select="@MN" data-type="number"/>
                        <xsl:sort select="@SN" data-type="number"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="outgoingCalls" select="xalan:nodeset($outgoingCalls)"/>

                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_dialedRoamingKey"/>
                    <xsl:with-param name="end_key"   select="$DC_dialedRoamingEndKey"/>
                    <xsl:with-param name="calls"     select="$outgoingCalls/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/NO_Z300_SUMMARY"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>
                
                <!-- Serviço 0300 -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_z300RoamingKey"/>
                    <xsl:with-param name="end_key"   select="$DC_z300RoamingEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/ROAMING/OUTGOING/Z300/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ROAMING/OUTGOING/Z300"/>
                    <xsl:with-param name="use_call_origin_city" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>

                <!-- Chamadas Recebidas -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"          select="$DC_receivedRoamingKey"/>
                    <xsl:with-param name="end_key"           select="$DC_receivedRoamingEndKey"/>
                    <xsl:with-param name="calls"             select="CALLS/ROAMING/INCOMING/RECEIVED/descendant::CALL"/>
                    <xsl:with-param name="subtotals"         select="CALLS/ROAMING/INCOMING/RECEIVED"/>
                    <xsl:with-param name="use_dialed_number" select="'FALSE'"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>

                <!-- Chamadas em roaming recebidas a cobrar -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_recCollectRoamingKey"/>
                    <xsl:with-param name="end_key"   select="$DC_recCollectRoamingEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/ROAMING/INCOMING/COLLECT/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/COLLECT"/>
                    <xsl:with-param name="pre_paid" select="@PP"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DC_dialedRoamingEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_z300RoamingEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_receivedRoamingEndKey"/>
                <xsl:value-of select="$newline"/>
                <xsl:value-of select="$DC_recCollectRoamingEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Desconto de telefonia dentro da área de registro (home). Só mostra se houver alguma -->
        <xsl:choose>
            <xsl:when test="number(translate(CALLS/HOME/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
                <!-- Serviço Desconto -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_discountHomeKey"/>
                    <xsl:with-param name="end_key"   select="$DC_discountHomeEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/HOME/INCOMING/DISCOUNTS/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/HOME/INCOMING/DISCOUNTS"/>
                    <xsl:with-param name="col_5_value"          select="'Desconto'"/>
                    <xsl:with-param name="desconto">TRUE</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DC_discountHomeEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- Desconto de telefonia fora da área de registro (roaming). Só mostra se houver alguma -->
        <xsl:choose>
            <xsl:when test="number(translate(CALLS/ROAMING/INCOMING/DISCOUNTS/@CHT,',','.')) &gt; 0">
                <!-- Serviço Desconto -->
                <xsl:call-template name="CHAMADAS">
                    <xsl:with-param name="item_key"  select="$DC_discountRoamingKey"/>
                    <xsl:with-param name="end_key"   select="$DC_discountRoamingEndKey"/>
                    <xsl:with-param name="calls"     select="CALLS/ROAMING/INCOMING/DISCOUNTS/descendant::CALL"/>
                    <xsl:with-param name="subtotals" select="CALLS/ROAMING/INCOMING/DISCOUNTS"/>
                    <xsl:with-param name="col_5_value"          select="'Desconto'"/>
                    <xsl:with-param name="desconto">TRUE</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DC_discountRoamingEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>


    <!-- ************************************* -->
    <!-- * Mostra as chamadas detalhadamente * -->
    <!-- ************************************* -->
    <xsl:template name="CHAMADAS">
      <!-- Parametro para tratamento especial de impressão de descontos. -->
      <xsl:param name="desconto">FALSE</xsl:param><!-- Valor da chave de cada item (chamada) -->
      <xsl:param name="item_key" /><!-- Valor da chave de finalização -->
      <xsl:param name="end_key" /><!-- Valor a aparecer na 5a. coluna (poderá aparecer a string "/Celular" após esse valor. Ver o código) -->
      <xsl:param name="col_5_value">Longa Distância</xsl:param><!-- Node-set de chamadas -->
      <xsl:param name="calls" /><!-- Elemento com os valores totalizados -->
      <xsl:param name="subtotals" /><!-- Mostrar a origem das chamadas ou não. Por padrão mostrar -->
      <xsl:param name="use_call_origin_city">TRUE</xsl:param><!-- Mostrar o número chamado ou não. Por padrão mostrar -->
      <xsl:param name="use_dialed_number">TRUE</xsl:param><!-- Verificar/Mostrar se é uma chamada para celular ou não. Por padrão não verificar/mostrar -->
      <xsl:param name="apply_mobile_check">FALSE</xsl:param><!-- Indica se o número de telefone deve ser hifenizado -->
      <xsl:param name="hifenize_number">TRUE</xsl:param><!-- Indica se o telefone é pré-pago ou não -->
      <xsl:param name="pre_paid">N</xsl:param><!-- Indica se é CDI Diário -->
      <xsl:param name="is_idcd">N</xsl:param>

      <xsl:choose><!-- Se houverem chamadas ou for desconto --><!-- <xsl:when test="($subtotals/@DNF!='0,00' or $desconto = 'TRUE') or ($pre_paid='Y')"> -->
        <xsl:when test="($subtotals/@DNF!='0:00' or $desconto = 'TRUE') or ($pre_paid='Y')">
          <!-- Mostra cada chamada desse contrato -->
          <xsl:apply-templates select="$calls">
            <xsl:with-param name="desconto" select="$desconto" />
            <xsl:with-param name="key" select="$item_key" />
            <xsl:with-param name="use_call_origin_city" select="$use_call_origin_city" />
            <xsl:with-param name="use_dialed_number" select="$use_dialed_number" />
            <xsl:with-param name="col_5_value" select="$col_5_value" />
            <xsl:with-param name="apply_mobile_check" select="$apply_mobile_check" />
            <xsl:with-param name="hifenize_number" select="$hifenize_number" />
          </xsl:apply-templates><!-- Subtotal -->
          <xsl:value-of select="$end_key" />
          <xsl:if test="$desconto='FALSE'"><!-- and $pre_paid='N'" -->
            <xsl:call-template name="VALOR-OU-ZERO">
              <xsl:with-param name="value" select="$subtotals/@DNF" />
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$desconto='TRUE'">
            <xsl:call-template name="VALOR-OU-ZERO">
              <xsl:with-param name="value" select="$subtotals/@CHT" />
            </xsl:call-template>
          </xsl:if>
          <xsl:value-of select="$delimiter" />
          <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="$subtotals/@V" />
          </xsl:call-template>
          <xsl:value-of select="$delimiter" />
          <xsl:value-of select="$newline" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$end_key" />
          <xsl:value-of select="$newline" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>


    <!-- ************************************************************************************************ -->    
    <!-- * Decide se o dado a ser mostrado é de chamada ou de interconexão, mostrando-o apropriadamente * -->    
    <!-- ************************************************************************************************ -->    
    <xsl:template match="CALL">        
    <!-- Valor da chave -->        
    <xsl:param name="key"/>        
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
		<xsl:variable name="originalNumber" select="$specialCallNumbers/number[contains($callNumber,@originalNumber)]/@originalNumber"/>        
	    <xsl:variable name="showNumberTemp" select="$specialCallNumbers/number[contains($callNumber,@originalNumber)]/@showNumber"/>
	    <xsl:variable name="showNumber" select="concat(substring-before($callNumber,$originalNumber),$showNumberTemp)"/>		
	 
    <!-- Se for dado de chamada ou desconto, mostre -->        
    <xsl:if test="($desconto='TRUE' or @SN!='1')">     
        
		<xsl:choose>
        <xsl:when test="$is_online='TRUE'">
               
	        <xsl:value-of select="$key"/>            
	        <xsl:value-of select="@DT"/>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="@TM"/>            
	        <xsl:value-of select="$delimiter"/>      
			<xsl:call-template name="VALOR-OU-ZERO">                
	            <xsl:with-param name="value" select="@V"/>            
	        </xsl:call-template>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="$newline"/>	              
               
        </xsl:when>

        <!-- Serviços Interativos - SMS -->
        <xsl:when test="$is_servint='TRUE'">               
	        <xsl:value-of select="$key"/>            
	        <xsl:value-of select="@DS"/>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="@DT"/>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="@TM"/>            
	        <xsl:value-of select="$delimiter"/>      
			<xsl:call-template name="VALOR-OU-ZERO">                
	            <xsl:with-param name="value" select="@V"/>            
	        </xsl:call-template>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="$newline"/>	                             
        </xsl:when>

        <xsl:otherwise>
        
	        <xsl:value-of select="$key"/>            
	        <xsl:value-of select="@DT"/>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:value-of select="@TM"/>            
	        <xsl:value-of select="$delimiter"/>            
	        <xsl:if test="$use_call_origin_city='TRUE'">                
	        <xsl:value-of select="@SC"/>                
	        <xsl:if test="(string-length(@SC) &gt; 0) and (string-length(@DN) &gt; 0)">                    
	        <xsl:text>/</xsl:text>                                                
	        </xsl:if>            
	        </xsl:if>
	            <xsl:if test="$is_idcd!='Y'">	            
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
		            <xsl:value-of select="$delimiter"/>
				</xsl:if>
				                        
				 <xsl:if test="$use_dialed_number='TRUE' and $is_idcd!='Y'">                
				 <xsl:choose>                    
<!-- 				 <xsl:when test="$hifenize_number = 'TRUE'">                        
				 <xsl:call-template name="HIFENIZAR">                            
				 <xsl:with-param name="number" select="@N"/>                        
				 </xsl:call-template>                    
				 </xsl:when>                    
				 <xsl:otherwise>                        
				 <xsl:value-of select="@N"/>                    
				 </xsl:otherwise>   -->
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
			<xsl:value-of select="$delimiter"/>            
			</xsl:if>            
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
	            	<xsl:value-of select="$delimiter"/>
	            <xsl:if test="$is_idcd!='Y'">            	            
	            <xsl:call-template name="VALOR-OU-ZERO">
		            <xsl:with-param name="value" select="@DR"/>
		        </xsl:call-template>
	            <xsl:value-of select="$delimiter"/>	            
	            </xsl:if>            
	            <xsl:call-template name="VALOR-OU-ZERO">                
	            	<xsl:with-param name="value" select="@V"/>            
	            </xsl:call-template>            
	            <xsl:value-of select="$delimiter"/>            
	            <xsl:value-of select="$newline"/>
	            
		</xsl:otherwise>	
		</xsl:choose>                    
	</xsl:if>    
	            
	                        
	<!-- Se for dado de interconexão, mostre -->        
    <xsl:if test="($desconto='FALSE' and (@SN='1' and @V!='0,00'))">            
        <xsl:value-of select="$key"/>            
        <!-- EMPTY FIELD -->            
        <xsl:value-of select="$delimiter"/>            
        <!-- EMPTY FIELD -->            
        <xsl:value-of select="$delimiter"/>            
        <!-- EMPTY FIELD -->            
        <xsl:value-of select="$delimiter"/>            
        <!-- EMPTY FIELD -->            
        <xsl:value-of select="$delimiter"/>            
        <xsl:text>Interconexão</xsl:text>            
        <xsl:value-of select="$delimiter"/>            
        <!-- EMPTY FIELD -->            
        <xsl:value-of select="$delimiter"/>            
        <xsl:call-template name="VALOR-OU-ZERO">                
        <xsl:with-param name="value" select="@V"/>            
        </xsl:call-template>            
        <xsl:value-of select="$delimiter"/>            
        <xsl:value-of select="$newline"/>        
	</xsl:if>    
	</xsl:template>
</xsl:stylesheet>