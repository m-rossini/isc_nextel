<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">    <!-- ************************************ -->    <!-- * Resumo da fatura de cada usu�rio * -->    <!-- ************************************ -->    <xsl:template name="DETALHE-FATURA">        <!-- Mensalidade. Mostra esse bloco s� se houver alguma -->        <xsl:if test="count(CHARGES/CHG[@TP='A']/SVC[@ID='DISPP' or @ID='TELAL' or @ID='ME']) &gt; 0">            <!-- primeira linha do cabe�alho da mensalidade -->            <xsl:text>MENSALIDADE</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>            <!-- segunda linha do cabe�alho da mensalidade -->            <xsl:text>Per�odo</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Plano de servi�o</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Cobran�a Proporcional</xsl:text>            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>            <xsl:text>VALOR R$</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>            <xsl:for-each select="CHARGES/CHG[@TP='A']/SVC[@ID='DISPP' or @ID='TELAL' or @ID='ME']">
               <!-- Per�odo de Cobran�a/Devolu��o -->                <xsl:if test="string-length(@S) &gt; 0">                    <xsl:value-of select="@S"/>                    <xsl:text> a </xsl:text>                    <xsl:value-of select="@E"/>                </xsl:if>                <xsl:text>&#9;&#9;</xsl:text>                <!-- Descri��o do plano de servi�o -->                <xsl:value-of select="@TR"/>                <xsl:text>&#9;&#9;</xsl:text>                <!-- Se o status do servi�o for 'd' (desativado) ou 's' (suspenso), -->                <!-- isto � uma pro-rata de devolu��o                               -->                <xsl:if test="@ST='d' or @ST='s'">                    <xsl:text>Devolu��o </xsl:text>                    <xsl:value-of select="@ND"/>                    <xsl:text> dia(s)</xsl:text>                </xsl:if>                <!-- Se o status do servi�o for 'm' (modificado), -->                <!-- isto � uma pro-rata de cobran�a              -->                <xsl:if test="@ST='m'">                    <xsl:text>Cobran�a </xsl:text>                    <xsl:value-of select="@ND"/>                    <xsl:text> dia(s)</xsl:text>                </xsl:if>                <!-- Se o status do servi�o for 'a' (ativado), isto � uma cobran�a normal de         -->                <!-- mensalidade, e n�o uma pro-rata - sendo assim, nenhum texto ser� mostrado aqui. -->                <xsl:text>&#9;</xsl:text>                <!-- Valor da mensalidade/pro-rata -->                <xsl:call-template name="VALOR-OU-ZERO">                    <xsl:with-param name="value">                        <xsl:value-of select="@V"/>                    </xsl:with-param>                </xsl:call-template>                <xsl:text>&#13;&#10;</xsl:text>            </xsl:for-each>            <xsl:text>&#13;&#10;</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Subtotal</xsl:text>            <xsl:text>&#9;&#9;&#9;&#9;&#9;&#9;</xsl:text>            <!-- Subtotal de mensalidades -->            <xsl:call-template name="VALOR-OU-ZERO">                <xsl:with-param name="value">                    <xsl:value-of select="@M"/>                </xsl:with-param>            </xsl:call-template>            <xsl:text>&#13;&#10;</xsl:text>        </xsl:if>        <xsl:variable name="onlineServices" select="CHARGES/CHG[@TP='A' or @TP='S' or @TP='U']/SVC[((@TP='A' or @TP='S') or (@TP='U' and @ID='CDIC')) and not (@ID='DISPP' or @ID='TELAL' or @ID='ME' or @ID='CLIRB' or @ID='CIRDT' or @ID='NMSIM' or @ID='NMPLS' or @ID='NMBAS' or @ID='SMST' or @ID='WP' or @ID='TWM' or @ID='WPTWM' or @ID='N200K' or @ID='MDD3' or @ID='N1200' or @ID='N2200' or @ID='N4200' or @ID='N5200' or @ID='N2300' or @ID='N3300' or @ID='N4300' or @ID='N5300' or @ID='N1600' or @ID='N2600' or @ID='N3600' or @ID='N4600' or @ID='N5600' or @ID='N11MB' or @ID='N21MB' or @ID='N31MB' or @ID='N41MB' or @ID='N51MB' or @ID='N13MB' or @ID='N23MB' or @ID='N33MB' or @ID='N43MB' or @ID='N53MB' or @ID='N110M' or @ID='N210M' or @ID='N310M' or @ID='N410M' or @ID='N510M' or @ID='MDD1' or @ID='MDD2' or @ID='MDD4' or @ID='MDD4' or @ID='N1300' or @ID='EQON' or @ID='NOWAS' or @ID='LONEX' or @ID='AGBKP' or @ID='EQLOC' or @ID='ITAUW' or @ID='ITAUA' or @ID='E930' or @ID='DOWN' or @ID='DOWNS' or @ID='GPSDA')]"/>        <!-- Servi�os adicionais/Servi�os de terceiros. Mostra esse bloco s� se houver algum -->        <xsl:if test="count($onlineServices) &gt; 0">            <!-- primeira linha do cabe�alho de servi�os adicionais -->            <xsl:text>SERVI�OS ADICIONAIS</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>            <!-- segunda linha do cabe�alho de servi�os adicionais -->            <xsl:text>Per�odo</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Plano de Servi�o</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Cobran�a Proporcional</xsl:text>            <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>            <xsl:text>VALOR R$</xsl:text>            <xsl:text>&#13;&#10;</xsl:text>            <!-- Mostra todos os servi�os adicionais desse aparelho -->            <xsl:for-each select="$onlineServices">                <!-- Per�odo de Cobran�a/Devolu��o -->                <xsl:if test="string-length(@S) &gt; 0">                   <xsl:value-of select="@S"/>                   <xsl:text> a </xsl:text>                   <xsl:value-of select="@E"/>                </xsl:if>                <!-- Descri��o do servi�o -->                <xsl:text>&#9;&#9;</xsl:text>                <xsl:value-of select="@DS"/>                <xsl:text>&#9;</xsl:text>                <!-- Se o status do servi�o for 'd' (desativado) ou 's' (suspenso), -->                <!-- isto � uma pro-rata de devolu��o                               -->                <xsl:if test="@ST='d' or @ST='s'">                    <xsl:text>Devolu��o </xsl:text>                    <xsl:value-of select="@ND"/>                    <xsl:text> dia(s)</xsl:text>                </xsl:if>                <!-- Se o status do servi�o for 'm' (modificado), -->                <!-- isto � uma pro-rata de cobran�a              -->                <xsl:if test="@ST='m' and not (@TP='U' and @ID='CDIC' and @ND='0')">                                    <xsl:text>Cobran�a </xsl:text>                    <xsl:value-of select="@ND"/>                    <xsl:text> dia(s)</xsl:text>                </xsl:if>                <!-- Se o status do servi�o for 'a' (ativado), isto � uma cobran�a normal de         -->                <!-- mensalidade, e n�o uma pro-rata - sendo assim, nenhum texto ser� mostrado aqui. -->                <xsl:text>&#9;&#9;</xsl:text>                <!-- Valor do servi�o/pro-rata -->
                
				<xsl:choose>
					<xsl:when test="@TP='U' and @ID='CDIC'">
						<!--CDI Di�rio aplicando o desconto -->																					
						<xsl:call-template name="VALOR-OU-ZERO">
							<xsl:with-param name="value">
								<xsl:choose>
									<xsl:when test="translate(DCT/@V, ',' , '.') &lt; 0">
										<xsl:value-of select="translate( format-number( translate(@V, ',' , '.') + translate(DCT/@V, ',' , '.'), '#,##0.00'), '.' , ',')"/>
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
                
                <!-- Descontos -->
				<xsl:if test="not (@TP='U' and @ID='CDIC')">                        	                <xsl:for-each select="DCT">	                    <!-- Descri��o do desconto -->	                    <xsl:value-of select="@DS"/>	                    <xsl:text>&#9;&#9;&#9;&#9;</xsl:text>	                    <!-- Valor do desconto -->	                    <xsl:call-template name="VALOR-OU-ZERO">	                        <xsl:with-param name="value">	                            <xsl:value-of select="@V"/>	                        </xsl:with-param>	                    </xsl:call-template>	                </xsl:for-each>
	            </xsl:if>                <xsl:text>&#13;&#10;</xsl:text>            </xsl:for-each>            <xsl:text>&#13;&#10;</xsl:text>            <xsl:text>&#9;&#9;</xsl:text>            <xsl:text>Subtotal</xsl:text>            <xsl:text>&#9;&#9;&#9;&#9;&#9;&#9;</xsl:text>            <!-- Valor total de servi�os adicionais -->            <xsl:call-template name="VALOR-OU-ZERO">                <xsl:with-param name="value">                    <xsl:value-of select="@A"/>                </xsl:with-param>            </xsl:call-template>            <xsl:text>&#13;&#10;</xsl:text>
       </xsl:if>        <!-- Conex�o direta Nextel. Mostra esse bloco s� se houver algum -->        <xsl:if test="count(DISPATCH/DISPP) &gt; 0">            <!-- Cabe�alho (gen�rico para servi�os de chamadas, como r�dio e telefonia) -->            <xsl:call-template name="HEADER-SERVICO">                <xsl:with-param name="title">CONEX�O DIRETA NEXTEL</xsl:with-param>            </xsl:call-template>            <!-- Mostra os planos referentes a Conex�o Direta Nextel para este aparelho -->            <xsl:for-each select="DISPATCH/DISPP">                <xsl:call-template name="ROW-SERVICO">                    <xsl:with-param name="col_1">                        <xsl:value-of select="@DS"/>                    </xsl:with-param>                    <xsl:with-param name="col_2">                        <xsl:value-of select="@DR_M"/>                    </xsl:with-param>                    <xsl:with-param name="col_3">                        <xsl:value-of select="@F_M"/>                    </xsl:with-param>                    <xsl:with-param name="col_4">                        <xsl:value-of select="@CH_M"/>                    </xsl:with-param>                    <xsl:with-param name="col_5">                        <xsl:value-of select="@V"/>                    </xsl:with-param>                </xsl:call-template>            </xsl:for-each>                                                  <!-- Subtotal -->            <xsl:call-template name="SUBTOTAL-SERVICO">                <xsl:with-param name="col_1">                    <xsl:value-of select="DISPATCH/@DR_M"/>                </xsl:with-param>                <xsl:with-param name="col_2">                    <xsl:value-of select="DISPATCH/@F_M"/>                </xsl:with-param>                <xsl:with-param name="col_3">                    <xsl:value-of select="DISPATCH/@CH_M"/>                </xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="DISPATCH/@V"/>                </xsl:with-param>            </xsl:call-template>            <xsl:text>&#13;&#10;</xsl:text>        </xsl:if>        <!-- <xsl:if test="CALLS/HOME/@DNF!='0,00' or CALLS/HOME/@CH!='0,00' or CALLS/HOME/@V!='0,00'"> -->
        <xsl:if test="CALLS/HOME/@DNF!='0:00' or CALLS/HOME/@DNF!='0,00' or CALLS/HOME/@CH!='0:00' or  CALLS/HOME/@CH!='0,00' or CALLS/HOME/@V!='0,00'">        
            <xsl:call-template name="HEADER-SERVICO">                <xsl:with-param name="title">CHAMADAS DE TELEFONIA DENTRO DA �REA DE REGISTRO</xsl:with-param>            </xsl:call-template>            <!-- Chamadas locais -->            <xsl:call-template name="ROW-SERVICO">                <xsl:with-param name="col_1">Local</xsl:with-param>                <xsl:with-param name="col_2">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@DA"/>                </xsl:with-param>                <xsl:with-param name="col_3">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@FA"/>                </xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@CHA"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@VA"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>                </xsl:with-param>            </xsl:call-template>
            <!-- Interconex�o para chamadas locais -->            <xsl:call-template name="ROW-INTERCONEXAO">                <xsl:with-param name="col_1">Interconex�o</xsl:with-param>                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@CHT"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LOCAL/@VT"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>               </xsl:with-param>            </xsl:call-template>            <!-- Chamadas de longa dist�ncia -->            <xsl:call-template name="ROW-SERVICO">                <xsl:with-param name="col_1">Longa Dist�ncia</xsl:with-param>                <xsl:with-param name="col_2">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@DA"/>                </xsl:with-param>                <xsl:with-param name="col_3">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@FA"/>                </xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@CHA"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@VA"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>                </xsl:with-param>            </xsl:call-template>                       <!-- Interconex�o para chamadas longa -->            <xsl:call-template name="ROW-INTERCONEXAO">                <xsl:with-param name="col_1">Interconex�o</xsl:with-param>                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@CHT"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/LONG_DISTANCE/@VT"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>                </xsl:with-param>            </xsl:call-template>                        <!-- Chamadas internacionais -->            <xsl:call-template name="ROW-SERVICO">                <xsl:with-param name="col_1">Internacional</xsl:with-param>                <xsl:with-param name="col_2">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@DA"/>                </xsl:with-param>                <xsl:with-param name="col_3">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@FA"/>                </xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@CHA"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@VA"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>                </xsl:with-param>            </xsl:call-template>                        <!-- Interconex�o para chamadas internacionais -->            <xsl:call-template name="ROW-INTERCONEXAO">                <xsl:with-param name="col_1">Interconex�o</xsl:with-param>                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>                <xsl:with-param name="col_4">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@CHT"/>                </xsl:with-param>                <xsl:with-param name="col_5">                    <xsl:value-of select="CALLS/HOME/OUTGOING/INTERNATIONAL/@VT"/>                </xsl:with-param>                <xsl:with-param name="col_6">                    <xsl:value-of select="@PP"/>                </xsl:with-param>            </xsl:call-template>                        <!-- Chamadas recebidas -->
            <xsl:call-template name="ROW-SERVICO">
                <xsl:with-param name="col_1">Recebidas</xsl:with-param>
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
            
            <!-- Interconex�o para chamadas recebidas a cobrar -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">Interconex�o</xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
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
            
            <!-- Chamadas internacionais -->
            <xsl:call-template name="ROW-SERVICO">
                <xsl:with-param name="col_1">Internacional</xsl:with-param>
                <xsl:with-param name="col_2">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@DA"/>
                </xsl:with-param>
                <xsl:with-param name="col_3">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@FA"/>
                </xsl:with-param>
                <xsl:with-param name="col_4">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@CHA"/>
                </xsl:with-param>
                <xsl:with-param name="col_5">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@VA"/>
                </xsl:with-param>
                <xsl:with-param name="col_6">
                    <xsl:value-of select="@PP"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <!-- Interconex�o para chamadas internacionais -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">Interconex�o </xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_4">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@CHT"/>
                </xsl:with-param>
                <xsl:with-param name="col_5">
                    <xsl:value-of select="CALLS/HOME/INCOMING/INTERNATIONAL/@VT"/>
                </xsl:with-param>
                <xsl:with-param name="col_6">
                    <xsl:value-of select="@PP"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <!-- Servi�o 0300 -->
            <xsl:call-template name="ROW-SERVICO">
                <xsl:with-param name="col_1">Servi�o 0300</xsl:with-param>
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
            
            <!-- Interconex�o para servi�o 0300 -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">Interconex�o</xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
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
                <xsl:with-param name="col_1">Desconto Promo��o Me Liga</xsl:with-param>
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

            <xsl:text>&#13;&#10;</xsl:text>

        </xsl:if>

        <!-- Chamadas de telefonia fora da �rea de registro. S� mostra se houver alguma -->
        <!-- <xsl:if test="CALLS/ROAMING/@DNF!='0,00' or CALLS/ROAMING/@CH!='0,00' or CALLS/ROAMING/@V!='0,00'"> -->
        <xsl:if test="CALLS/ROAMING/@DNF!='0:00' or CALLS/ROAMING/@DNF!='0,00' or CALLS/ROAMING/@CH!='0:00' or CALLS/ROAMING/@CH!='0,00' or CALLS/ROAMING/@V!='0,00'">
            
            <xsl:call-template name="HEADER-SERVICO">
                <xsl:with-param name="title">CHAMADAS DE TELEFONIA FORA DA �REA DE REGISTRO (Roaming)</xsl:with-param>
            </xsl:call-template>

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
            
            <!-- Interconex�o para chamadas originadas em roaming -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">
                    <xsl:text>Interconex�o</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
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
                    <xsl:text> Recebidas a Cobrar</xsl:text>
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
            
            <!-- Interconex�o para chamadas recebidas a cobrar em roaming -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">
                    <xsl:text>Interconex�o</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
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
            
            <!-- Servi�o 0300 em roaming -->
            <xsl:call-template name="ROW-SERVICO">
                <xsl:with-param name="col_1">
                    <xsl:text>Servi�o 0300</xsl:text>
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
            
            <!-- Interconex�o para servi�o 0300 em roaming -->
            <xsl:call-template name="ROW-INTERCONEXAO">
                <xsl:with-param name="col_1">
                    <xsl:text>Interconex�o</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="col_2"><!-- EMPTY FIELD --></xsl:with-param>
                <xsl:with-param name="col_3"><!-- EMPTY FIELD --></xsl:with-param>
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
                <xsl:with-param name="col_1">Desconto Promo��o Me Liga</xsl:with-param>
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

            <xsl:text>&#13;&#10;</xsl:text>

        </xsl:if>

        <!-- Servi�os de Dados (Nextel OnLine). Mostra esse bloco s� se houver algum -->
        <xsl:if test="(count(SERVICES/ONLINE) &gt; 0) or (count(SERVICES/TORPEDO) &gt; 0) or (count(SERVICES/DOWNLOADS) &gt; 0)">
            
            <!-- Primeira linha do cabe�alho da mensalidade -->
            <xsl:text>NEXTEL ONLINE (SERVI�OS DE DADOS)</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>

            <!-- Servi�o Circuit Data (transmiss�o de dados por circuito) -->
            <xsl:if test="count(SERVICES/ONLINE[@ID='CIRDT']) &gt; 0">

                <!-- Cabe�alho circuit data -->
                <xsl:text>&#9;&#9;</xsl:text>
                <xsl:text>Quantidade</xsl:text>
                <xsl:text>&#9;&#9;</xsl:text>
                <xsl:text>Unidade de Medida</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>VALOR R$</xsl:text>
                <xsl:text>&#13;&#10;</xsl:text>

                <xsl:text>Transmiss�o de Dados por Circuito</xsl:text>
                <xsl:text>&#9;</xsl:text>
                
                <!-- quantidade utilizada -->
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@Q"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:text>&#9;</xsl:text>
                <xsl:text>min</xsl:text>
                <xsl:text>&#9;</xsl:text>

                <!-- valor a pagar -->
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@V"/>
                    </xsl:with-param>
                </xsl:call-template>

            </xsl:if>

            <!-- Mostra os servi�os de transmiss�o de dados por pacote desse aparelho, se houver -->
            <xsl:if test="count(SERVICES/ONLINE[not (@ID='CIRDT')]) &gt; 0">

                <!-- Cabe�alho -->
                <xsl:text>Transmiss�o de Dados por Pacote</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>Per�odo</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>Cobran�a Proporcional</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>VALOR R$</xsl:text>
                <xsl:text>&#13;&#10;</xsl:text>

                <xsl:for-each select="SERVICES/ONLINE[not (@ID='CIRDT')]">

                    <!-- Descri��o do servi�o -->
                    <xsl:value-of select="@DS"/>

                    <xsl:text>&#9;</xsl:text>

                    <!-- Per�odo de Cobran�a/Devolu��o -->
                    <xsl:value-of select="@S"/>
                    <xsl:text> a </xsl:text>
                    <xsl:value-of select="@E"/>

                    <xsl:text>&#9;</xsl:text>

                    <!-- Se o status do servi�o for 'd' (desativado) ou 's' (suspenso), -->
                    <!-- isto � uma pro-rata de devolu��o                               -->
                    <xsl:if test="@ST='d' or @ST='s'">
                        <xsl:text>Devolu��o </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <!-- Se o status do servi�o for 'm' (modificado), -->
                    <!-- isto � uma pro-rata de cobran�a              -->
                    <xsl:if test="@ST='m'">
                        <xsl:text>Cobran�a </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <!-- Se o status do servi�o for 'a' (ativado), isto � uma cobran�a normal de         -->
                    <!-- mensalidade, e n�o uma pro-rata - sendo assim, nenhum texto ser� mostrado aqui. -->

                    <xsl:text>&#9;</xsl:text>

                    <!-- Valor da mensalidade/pro-rata -->
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:text>&#13;&#10;</xsl:text>
                </xsl:for-each>

            </xsl:if>

            <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
            <!-- Mostra os servi�os de torpedo desse aparelho, se houver -->                
            <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
            <!-- <xsl:if test="count(SERVICES/TORPEDO) &gt; 0"> -->
<!-- EHO: Mudan�a mms outras operadoras -->
        <xsl:if test="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='DRin' or @ID='MMSI']"> 
<!--              <xsl:if test="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='MMSI']"> -->
                <!-- Cabe�alho -->
                <xsl:text>Envio de Mensagens</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>Per�odo</xsl:text>
                <xsl:text>&#9;&#9;</xsl:text>
                <xsl:text>Quantidade</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>V.UNIT. R$</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>VALOR R$</xsl:text>
                <xsl:text>&#13;&#10;</xsl:text>

       			<!-- <xsl:variable name="torpedoDet">
       				<xsl:for-each select="SERVICES/descendant::TORPEDO">
       					<xsl:copy-of select="." />
       				</xsl:for-each>
       			</xsl:variable> -->

       			<!-- <xsl:variable name="rowtorpedoDet" select="$torpedoDet" /> -->
   				<!-- <xsl:apply-templates select="$rowtorpedoDet/descendant::TORPEDO"> -->
       			<!-- 	<xsl:apply-templates select="SERVICES//TORPEDO"> -->
<!-- EHO: Mudan�a mms outras operadoras -->
  			 	<xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='DRin' or @ID='MMSI']"> 
<!--         	<xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='MMSI']"> -->
   					<xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />
   					<xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />
   				</xsl:apply-templates>
            </xsl:if>


            <!-- Mostra o servi�o de download desse aparelho, se houver -->
            <xsl:if test="count(SERVICES/DOWNLOADS) &gt; 0">

                <!-- Cabe�alho -->
                <xsl:text>NEXTEL DOWNLOADS</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>Per�odo</xsl:text>
                <xsl:text>&#9;&#9;</xsl:text>
                <xsl:text>Quantidade</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:text>VALOR R$</xsl:text>
                <xsl:text>&#13;&#10;</xsl:text>

                <!-- Descri��o do servi�o -->
                <xsl:value-of select="SERVICES/DOWNLOADS/@DS"/>
                <xsl:text>&#9;</xsl:text>
                <!-- Per�odo de Cobran�a -->
                <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                <xsl:text> a </xsl:text>
                <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                <xsl:text>&#9;</xsl:text>
                <!-- Quantidade -->
                <xsl:value-of select="SERVICES/DOWNLOADS/@Q"/>
                <xsl:text>&#9;</xsl:text>
                <!-- Valor total -->
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="SERVICES/DOWNLOADS/@V"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:text>&#13;&#10;</xsl:text>
                <xsl:call-template name="DOWN"/>
            </xsl:if>
            
            <!-- ################ LOCALIZADOR DIARIO ################# -->
            <!-- Mostra o servi�o localizador di�rio, se houver -->
            <xsl:if test="SERVICES/SVC/@ID='LOLGT'" >
				<xsl:call-template name="LOLGT"/>
            </xsl:if>
            <!-- ############## FIM LOCALIZADOR DIARIO ############### -->
            

            <xsl:text>&#9;&#9;</xsl:text>
            <xsl:text>Subtotal</xsl:text>
            <xsl:text>&#9;&#9;</xsl:text>
            
            <!-- Valor total a pagar de servi�os de dados -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@O"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>

        </xsl:if>

        <!-- Total do usu�rio -->
        <xsl:text>&#9;&#9;&#9;&#9;&#9;&#9;&#9;</xsl:text>
        <xsl:text>TOTAL DO USU�RIO</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="@T"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#13;&#10;</xsl:text>
        
    </xsl:template>


    <!-- ****************************************************** -->
    <!-- * Cabe�alho de cada listagem dos servi�os utilizados * -->
    <!-- ****************************************************** -->

    <xsl:template name="HEADER-SERVICO">
        <xsl:param name="title"/>

        <xsl:value-of select="$title"/>
        <xsl:text>&#13;&#10;</xsl:text>

        <xsl:text>Tipo de Chamada</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Total(min)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Franquia Utilizada(min)</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Minutos a Pagar</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>VALOR R$</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>

    </xsl:template>


    <!-- *********************************************************************************** -->
    <!-- * Cada linha indica um servi�o. Os valores das colunas s�o par�metros do template * -->
    <!-- *********************************************************************************** -->
    <xsl:template name="ROW-SERVICO">

        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <xsl:param name="col_5"/>
        <xsl:param name="col_6">N</xsl:param>

        <!-- S� mostra se houver minutos -->
        <!-- <xsl:if test="($col_2!='0,00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')"> -->
        <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_2!='0,00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')">

            <!-- Tipo de chamada (Local/Longa Dist�ncia/Internacional/....) -->
            <xsl:value-of select="$col_1"/>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Dura��o total de chamadas sem contabilizar as gratuitas -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_2"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Franquia utilizada -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_3"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#9;&#9;</xsl:text>
            
            <!-- Quantidade de minutos a pagar -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_4"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Valor a pagar -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_5"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- *********************************************************************************** -->
    <!-- * Cada linha indica um servi�o. Os valores das colunas s�o par�metros do template * -->
    <!-- *********************************************************************************** -->
    <xsl:template name="ROW-INTERCONEXAO">

        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <xsl:param name="col_5"/>
        <xsl:param name="col_6">N</xsl:param>

        <!-- S� mostra se houver minutos -->
        <!-- <xsl:if test="($col_2!='0,00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')"> -->
        <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_2!='0,00' and $col_2!='') or ($col_5!='0:00' and $col_5!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')">

            <!-- Descri��o do servi�o (String "Interconex�o") -->
            <xsl:value-of select="$col_1"/>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Texto livre (normalmente vazio) -->
            <xsl:value-of select="$col_2"/>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Texto livre (normalmente vazio) -->
            <xsl:value-of select="$col_3"/>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Quantidade de minutos a pagar -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_4"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#9;&#9;</xsl:text>

            <!-- Valor a pagar -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="$col_5"/>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:text>&#13;&#10;</xsl:text>
        </xsl:if>

    </xsl:template>


    <!-- ********************************************************************************* -->
    <!-- * Mostra a linha de subtotal. Os valores das colunas s�o par�metros do template * -->
    <!-- ********************************************************************************* -->
    <xsl:template name="SUBTOTAL-SERVICO">
        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>

        <xsl:text>Subtotal</xsl:text>

        <xsl:text>&#9;</xsl:text>

        <!-- Dura��o total de chamadas sem contabilizar as gratuitas -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_1"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- Franquia utilizada -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_2"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>

        <!-- Quantidade de minutos a pagar -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_3"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#9;</xsl:text>
        
        <!-- Valor a pagar -->
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_4"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:text>&#13;&#10;</xsl:text>

    </xsl:template>

    <!-- ######## Downloads  ######## -->
    <xsl:template name="DOWN">
        <xsl:call-template name="REP-DW">
            <xsl:with-param name="downCalls" select="SERVICES/DOWNLOADS/descendant::DL"/>
        </xsl:call-template>
    </xsl:template>
    <!-- tabela repetivel -->
    <xsl:template name="REP-DW">
        <xsl:param name="downCalls"/>
        <!-- Descritivo  downloads -->
        <xsl:text>Downloads - Descritivo</xsl:text>
        <xsl:text>&#9;&#9;</xsl:text>
        <xsl:text>Data</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Hora</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Nome</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Tipo</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>V. UNIT. R$</xsl:text>
        <xsl:text>&#13;&#10;</xsl:text>
        <xsl:apply-templates select="$downCalls"> 
             <xsl:sort select="@MN" data-type="number"/>
         </xsl:apply-templates>
     </xsl:template>
     
     <!-- linhas do download -->
     <xsl:template match="DL">
         <xsl:text>&#9;&#9;</xsl:text>
         <xsl:value-of select="@DT"/>
         <xsl:text>&#9;</xsl:text>
         <xsl:value-of select="@TM"/>
         <xsl:text>&#9;</xsl:text>
         <xsl:value-of select="@DS"/>
         <xsl:text>&#9;</xsl:text>
         <xsl:value-of select="@T"/>
         <xsl:text>&#9;</xsl:text>
         <xsl:call-template  name="VALOR-OU-ZERO">
             <xsl:with-param name="value" select="@VU"/>
         </xsl:call-template>
         <xsl:text>&#13;&#10;</xsl:text>
     </xsl:template>
    <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
    <!-- Mostra os servi�os de torpedo desse aparelho, se houver -->                
    <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
    <xsl:template match="SVC">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
            <!-- Descri��o do servi�o -->
            <xsl:value-of select="@DS"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Per�odo de Cobran�a -->
            <xsl:value-of select="$start"/>
            <xsl:text> a </xsl:text>
            <xsl:value-of select="$end"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Quantidade-->
            <xsl:value-of select="@Q"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Valor unit. -->
            <!-- <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@U"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>&#9;</xsl:text> -->
       		<xsl:if test="@ID!='SMSSI'">		                         
            	<xsl:call-template name="VALOR-OU-ZERO">
                	<xsl:with-param name="value">
<!-- EHO: promo��o 5 sms -->
                        <!-- <xsl:value-of select="@U"/> -->
          <xsl:if test="@Q='0'">
                        <xsl:value-of select="translate(format-number((translate(@V, ',' , '.') div 1), '##0.00'), '.' , ',')"/>
          </xsl:if>
          <xsl:if test="@Q!='0'">
                        <xsl:value-of select="translate(format-number((translate(@V, ',' , '.') div translate(@Q, ',' , '.')), '##0.00'), '.' , ',')"/>
          </xsl:if>
                    </xsl:with-param>                  
              	</xsl:call-template>
        	</xsl:if>                                	
       		<xsl:if test="@ID='SMSSI'">		                         
            	<xsl:call-template name="VALOR-OU-ZERO">
                	<xsl:with-param name="value">
   		    			<xsl:text> - </xsl:text>      		    	
                    </xsl:with-param>                                     
            	</xsl:call-template>
        	</xsl:if>     
            <xsl:text>&#9;</xsl:text>        	                           	
            <!-- Valor total -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="@V"/>
                </xsl:with-param>
            </xsl:call-template>
       	<xsl:text>&#13;&#10;</xsl:text>
    </xsl:template>
    
    <!-- ################ Localizador Di�rio####################  -->                
    <xsl:template name="LOLGT">
            <!-- Cabe�alho -->
            <xsl:text>Localizador Nextel</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>Per�odo</xsl:text>
            <xsl:text>&#9;&#9;</xsl:text>
            <xsl:text>Quantidade</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text></xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>VALOR R$</xsl:text>
            <xsl:text>&#13;&#10;</xsl:text>    
    
            <!-- Descri��o do servi�o -->
            <xsl:value-of select="CALLS/ONLINE/SVC/@DS"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Per�odo de Cobran�a -->
            <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
            <xsl:text> a </xsl:text>
            <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Quantidade-->
            <xsl:value-of select="CALLS/ONLINE/SVC/@Q"/>
            <xsl:text>&#9;</xsl:text>
            <!-- Valor total -->
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value">
                    <xsl:value-of select="CALLS/ONLINE/SVC/@V"/>
                </xsl:with-param>
            </xsl:call-template>
       		<xsl:text>&#13;&#10;</xsl:text>
    </xsl:template>    
<!-- conf/html/xml_txt/nextel_fatura_detalhe_fatura.xsl -->    
 </xsl:stylesheet>