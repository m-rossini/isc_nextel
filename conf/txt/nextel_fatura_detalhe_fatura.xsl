<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">
	
    <!-- ************************************ -->
    <!-- * Resumo da fatura de cada usu�rio * -->
    <!-- ************************************ -->
    <xsl:template name="DETALHE-FATURA">

        <!-- Mensalidade. Mostra esse bloco s� se houver alguma -->
        <xsl:choose>
            <xsl:when test="CHARGES/CHG[@TP='A']/SVC[@ID='DISPP' or @ID='TELAL' or @ID='ME']">
                <!-- Mostra os dados de cada plano deste aparelho -->
                <xsl:for-each select="CHARGES/CHG[@TP='A']/SVC[@ID='DISPP' or @ID='TELAL' or @ID='ME']">
                    <xsl:value-of select="$DF_monthlyFeeKey"/>
                    <xsl:value-of select="@S"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="@E"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="@TR"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:if test="@ST='d' or @ST='s'">
                        <xsl:text>Devolu��o </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <xsl:if test="@ST='m'">
                        <xsl:text>Cobran�a </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
                <!-- Subtotal -->
                <xsl:value-of select="$DF_monthlyFeeEndKey"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="@M"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DF_monthlyFeeEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Servi�os adicionais/Servi�os de terceiros. Mostra esse bloco s� se houver algum -->
        <xsl:variable name="onlineServices" select="CHARGES/CHG[@TP='A' or @TP='S' or @TP='U']/SVC[((@TP='A' or @TP='S') or (@TP='U' and @ID='CDIC')) and not (@ID='DISPP' or @ID='TELAL' or @ID='ME' or @ID='CLIRB' or @ID='CIRDT' or @ID='NMSIM' or @ID='NMPLS' or @ID='NMBAS' or @ID='SMST' or @ID='WP' or @ID='TWM' or @ID='WPTWM' or @ID='N200K' or @ID='MDD3' or @ID='N1200' or @ID='N2200' or @ID='N4200' or @ID='N5200' or @ID='N2300' or @ID='N3300' or @ID='N4300' or @ID='N5300' or @ID='N1600' or @ID='N2600' or @ID='N3600' or @ID='N4600' or @ID='N5600' or @ID='N11MB' or @ID='N21MB' or @ID='N31MB' or @ID='N41MB' or @ID='N51MB' or @ID='N13MB' or @ID='N23MB' or @ID='N33MB' or @ID='N43MB' or @ID='N53MB' or @ID='N110M' or @ID='N210M' or @ID='N310M' or @ID='N410M' or @ID='N510M' or @ID='MDD1' or @ID='MDD2' or @ID='MDD4' or @ID='MDD4' or @ID='N1300' or @ID='EQON' or @ID='NOWAS' or @ID='LONEX' or @ID='AGBKP' or @ID='EQLOC' or @ID='ITAUW' or @ID='ITAUA' or @ID='E930' or @ID='DOWN' or @ID='DOWNS' or @ID='GPSDA')]"/>
        <xsl:choose>
            <xsl:when test="$onlineServices">
                <!-- Mostra todos os servi�os adicionais desse aparelho -->
                <xsl:for-each select="$onlineServices">
                    <xsl:value-of select="$DF_additionalServicesKey"/>
                    <xsl:value-of select="@S"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="@E"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="@DS"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:if test="@ST='d' or @ST='s'">
                        <xsl:text>Devolu��o </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <xsl:if test="@ST='m'">
                        <xsl:text>Cobran�a </xsl:text>
                        <xsl:value-of select="@ND"/>
                        <xsl:text> dia(s)</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$delimiter"/>
                    
                    <xsl:choose>
                    	<xsl:when test="@TP='U' and @ID='CDIC'">
                    	<!--CDI Di�rio aplicando o desconto -->
                    		<xsl:call-template name="VALOR-OU-ZERO">
                    			<xsl:with-param name="value">
                    		<xsl:choose>
                    			<xsl:when test="translate( translate(DCT/@V, '.',''), ',' , '.') &lt; 0">
                    				<xsl:value-of select="translate( format-number( translate( translate(@V, '.',''), ',' , '.') + translate( translate(DCT/@V, '.',''), ',' , '.'), '#,###,##0.00'), '.' , ',')"/>
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
                    
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                    <!-- Desconto -->
                   	<xsl:if test="not ('U' and @ID='CDIC')">
	                    <xsl:for-each select="DCT">
                        	<xsl:value-of select="$DF_additionalServicesKey"/>
                        	<!-- EMPTY FIELD -->
                        	<xsl:value-of select="$delimiter"/>
                        	<!-- EMPTY FIELD -->
                        	<xsl:value-of select="$delimiter"/>
                        	<xsl:value-of select="@DS"/>
                        	<xsl:value-of select="$delimiter"/>
                        	<!-- EMPTY FIELD -->
                        	<xsl:value-of select="$delimiter"/>
                        	<xsl:call-template name="VALOR-OU-ZERO">
                            	<xsl:with-param name="value">
                                	<xsl:value-of select="@V"/>
                            	</xsl:with-param>
                        	</xsl:call-template>
                        	<xsl:value-of select="$delimiter"/>
                        	<xsl:value-of select="$newline"/>
    	                </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
                <!-- Subtotal -->
                <xsl:value-of select="$DF_additionalServicesEndKey"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="@A"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DF_additionalServicesEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Conex�o direta Nextel. Mostra esse bloco s� se houver algum -->
        <xsl:choose>
            <xsl:when test="DISPATCH/DISPP">
                <!-- Mostra os planos referentes a Conex�o Direta Nextel para este aparelho -->
                <xsl:for-each select="DISPATCH/DISPP">
                    <xsl:call-template name="ROW-SERVICO">
                        <xsl:with-param name="key">
                            <xsl:value-of select="$DF_dispatchKey"/>
                        </xsl:with-param>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_dispatchEndKey"/>
                    </xsl:with-param>
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
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DF_dispatchEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        
        <!-- Chamadas de telefonia dentro da �rea de registro. S� mostra se houver alguma -->
        <xsl:choose>
            <!-- <xsl:when test="CALLS/HOME/@DNF!='0,00' or CALLS/HOME/@CH!='0,00' or CALLS/HOME/@V!='0,00'">  -->
            <xsl:when test="CALLS/HOME/@DNF!='0:00' or CALLS/HOME/@CH!='0:00' or CALLS/HOME/@V!='0,00'">            

                <!-- Chamadas locais -->
                <xsl:call-template name="ROW-SERVICO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
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

                <!-- Interconex�o para chamadas locais -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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

                <!-- Chamadas de longa dist�ncia -->
                <xsl:call-template name="ROW-SERVICO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Longa Dist�ncia</xsl:text>
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

                <!-- Interconex�o para chamadas longa dist�ncia -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
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
                
                <!-- Interconex�o para chamadas internacionais -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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

                <!-- Servi�o 0300 -->
                <xsl:call-template name="ROW-SERVICO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Servi�o 0300</xsl:text>
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

                <!-- Interconex�o para servi�o 0300 -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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

                <!-- Desconto para liga��es HOME -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Desconto Promo��o Me Liga</xsl:text>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_homeCallsEndKey"/>
                    </xsl:with-param>
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

            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DF_homeCallsEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Chamadas de telefonia fora da �rea de registro. S� mostra se houver alguma -->
        <xsl:choose>
            <!-- <xsl:when test="CALLS/ROAMING/@DNF!='0,00' or CALLS/ROAMING/@CH!='0,00' or CALLS/ROAMING/@V!='0,00'"> -->
            <xsl:when test="CALLS/ROAMING/@DNF!='0:00' or CALLS/ROAMING/@CH!='0:00' or CALLS/ROAMING/@V!='0,00'">            

                <!-- Chamadas originadas em roaming -->
                <xsl:call-template name="ROW-SERVICO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
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

                <!-- Interconex�o para chamadas originadas -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="col_2">

                    </xsl:with-param>
                    <xsl:with-param name="col_3">

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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
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

                <!-- Interconex�o para chamadas a cobrar em roaming -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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

                <!-- Servi�o 0300 em roaming -->
                <xsl:call-template name="ROW-SERVICO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Interconex�o</xsl:text>
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

                <!-- Desconto para liga��es ROAMING -->
                <xsl:call-template name="ROW-INTERCONEXAO">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsKey"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_1">
                        <xsl:text>Desconto Promo��o Me Liga</xsl:text>
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
                    <xsl:with-param name="key">
                        <xsl:value-of select="$DF_roamingCallsEndKey"/>
                    </xsl:with-param>
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

            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$DF_roamingCallsEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Servi�os de Dados (Nextel OnLine). Mostra esse bloco s� se houver algum -->
        <xsl:choose>
            <!-- <xsl:when test="SERVICES/ONLINE or SERVICES/TORPEDO or SERVICES/DOWNLOADS"> -->
            <xsl:when test="SERVICES/ONLINE or SERVICES/TORPEDO or SERVICES/DOWNLOADS or SERVICES/SVC[@ID='LOLGT']">            
                <xsl:value-of select="$DF_nextelOnlineStartKey"/>
                <xsl:value-of select="$newline"/>

                <!-- Mostra o servi�o de transmiss�o de dados por circuito desse aparelho, se houver -->
                <xsl:if test="SERVICES/ONLINE[@ID='CIRDT']">
                    <xsl:value-of select="$DF_circuitDataKey"/>
                    <xsl:text>Transmiss�o de Dados por Circuito</xsl:text>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@Q"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:text>min</xsl:text>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value">
                            <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                </xsl:if>
                
                <!-- Mostra as solu��es verticais desse cliente, se houver -->
                <!--
                     <xsl:if test="count(SERVICES/ONLINE[@ID='CIRDT']) &gt; 0">
                         <xsl:value-of select="$DF_verticalSolutionsKey"/>
                         <xsl:text>Solu��es Verticais</xsl:text>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:call-template name="VALOR-OU-ZERO">
                             <xsl:with-param name="value">
                                 <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@Q"/>
                             </xsl:with-param>
                         </xsl:call-template>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:text>min</xsl:text>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:call-template name="VALOR-OU-ZERO">
                             <xsl:with-param name="value">
                                 <xsl:value-of select="SERVICES/ONLINE[@ID='CIRDT']/@T"/>
                             </xsl:with-param>
                         </xsl:call-template>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:value-of select="$newline"/>
                     </xsl:if>
                     -->

                     <!-- Mostra os servi�os de transmiss�o de dados por pacote desse aparelho, se houver -->
                     <xsl:for-each select="SERVICES/ONLINE[not (@ID='CIRDT')]">
                       <xsl:value-of select="$DF_packetDataKey" />
                       <xsl:value-of select="@DS" />
                       <xsl:value-of select="$delimiter" />
                       <xsl:value-of select="@S" />
                       <xsl:value-of select="$delimiter" />
                       <xsl:value-of select="@E" />
                       <xsl:value-of select="$delimiter" />
                       <xsl:if test="@ST='d' or @ST='s'">
                         <xsl:text>Devolu��o</xsl:text>
                         <xsl:value-of select="@ND" />
                         <xsl:text>dia(s)</xsl:text>
                       </xsl:if>
                       <xsl:if test="@ST='m'">
                         <xsl:text>Cobran�a</xsl:text>
                         <xsl:value-of select="@ND" />
                         <xsl:text>dia(s)</xsl:text>
                       </xsl:if>
                       <xsl:value-of select="$delimiter" />
                       <xsl:call-template name="VALOR-OU-ZERO">
                         <xsl:with-param name="value">
                           <xsl:value-of select="@V" />
                         </xsl:with-param>
                       </xsl:call-template>
                       <xsl:value-of select="$delimiter" />
                       <xsl:value-of select="$newline" />
                     </xsl:for-each>
                     <!--
                          PRINT LASER MANDOU N�O ENVIAR ESTA CHAVE
                          <xsl:otherwise>
                              <xsl:value-of select="$DF_nextelOnlineEndKey"/>
                              <xsl:value-of select="$newline"/>
                          </xsl:otherwise>
                          -->

                     <!-- Torpedo SMS -->
<!-- EHO: Mudan�a mms outras operadoras -->
                 <xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='DRin' or @ID='MMSI']"> 
<!--                       <xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='MMSI']"> -->
                       <xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />
                       <xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />
                     </xsl:apply-templates>


                     <!-- Localizador Nextel Di�rio -->
<!-- EHO: corre��o localizador di�rio

                     <xsl:if test="SERVICES/SVC/@ID='LOLGT'" >
	                   <xsl:call-template name="LOLGT"/> 
	                 </xsl:if>
-->

                     <xsl:apply-templates select="CALLS/ONLINE/SVC[@ID='LOLGT']">
                       <xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />
                       <xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />
                     </xsl:apply-templates>


                     <!-- Downloads -->
                     <xsl:if test="SERVICES/DOWNLOADS">
                         <!-- Mostra o servi�o de Torpedo SMS desse aparelho, se houver -->
                         <xsl:value-of select="$DF_downloadsKey"/>
                         <xsl:value-of select="SERVICES/DOWNLOADS/@DS"/>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:call-template name="VALOR-OU-ZERO">
                             <xsl:with-param name="value">
                                 <xsl:value-of select="SERVICES/DOWNLOADS/@Q"/>
                             </xsl:with-param>
                         </xsl:call-template>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:call-template name="VALOR-OU-ZERO">
                             <xsl:with-param name="value">
                                 <xsl:value-of select="SERVICES/DOWNLOADS/@V"/>
                             </xsl:with-param>
                         </xsl:call-template>
                         <xsl:value-of select="$delimiter"/>
                         <xsl:value-of select="$newline"/>
                     </xsl:if>
                     <!-- Detalha os downloads -->
                     <xsl:apply-templates select="SERVICES/DOWNLOADS//DL">
                       <xsl:sort select="@MN" data-type="number"/>
                     </xsl:apply-templates>
                 </xsl:when>
             </xsl:choose>

             <!-- <xsl:if test="SERVICES/TORPEDO or SERVICES/ONLINE or SERVICES/DOWNLOADS "> -->
             <xsl:if test="SERVICES/TORPEDO or SERVICES/ONLINE or SERVICES/DOWNLOADS or SERVICES/SVC[@ID='LOLGT']">             
                 <!-- Subtotal -->
                 <xsl:value-of select="$DF_nextelOnlineEndKey"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="@O"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:value-of select="$newline"/>
             </xsl:if>
             
         </xsl:template>
	    <xsl:template match="SVC">
	        <xsl:param name="start" />
	        <xsl:param name="end" />

	        <xsl:if test="@ID='LOLGT'">
   	            <!-- Mostra o servi�o de Torpedo SMS desse aparelho, se houver -->
                <xsl:value-of select="$DF_locatorKey" />
                <xsl:value-of select="@DS" />
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$start" />
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$end" />
                <xsl:value-of select="$delimiter" />
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
	                   <xsl:value-of select="@Q" />
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter" />
                <xsl:call-template name="VALOR-OU-ZERO">
                   <xsl:with-param name="value">
	                  <xsl:value-of select="@V" />
                   </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$newline" />
            </xsl:if>

	        <xsl:if test="@ID!='LOLGT'">
                <!-- Mostra o servi�o de Torpedo SMS desse aparelho, se houver -->
                <xsl:value-of select="$DF_torpedoKey" />
                <xsl:value-of select="@DS" />
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$start" />
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$end" />
                <xsl:value-of select="$delimiter" />
                <xsl:call-template name="VALOR-OU-ZERO">
                   <xsl:with-param name="value">
	                  <xsl:value-of select="@Q" />
                   </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter" />
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
	                     <xsl:text>-</xsl:text>
	                  </xsl:with-param>
                   </xsl:call-template>
                </xsl:if>
                <xsl:value-of select="$delimiter" />
                <xsl:call-template name="VALOR-OU-ZERO">
                   <xsl:with-param name="value">
	                  <xsl:value-of select="@V" />
                   </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$delimiter" />
                <xsl:value-of select="$newline" />
            </xsl:if>

	    </xsl:template>

        <!-- ################ LOCALIZADOR DI�RIO ####################  -->                
<!--  
	     <xsl:template name="LOLGT">	    
	        <xsl:param name="start"/>
    	        <xsl:param name="end"/>
	              <xsl:value-of select="$DF_locatorKey"/>
	              <xsl:value-of select="CALLS/ONLINE/SVC/@DS"/>
	              <xsl:value-of select="$delimiter"/>
	              <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
	              <xsl:value-of select="$delimiter"/>
	              <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
	              <xsl:value-of select="$delimiter"/>
	              <xsl:call-template name="VALOR-OU-ZERO">
	                  <xsl:with-param name="value">
	                      <xsl:value-of select="CALLS/ONLINE/SVC/@Q"/>
	                  </xsl:with-param>
	              </xsl:call-template>
	              <xsl:value-of select="$delimiter"/>
	              <xsl:call-template name="VALOR-OU-ZERO">
	                  <xsl:with-param name="value">
	                      <xsl:value-of select="CALLS/ONLINE/SVC/@V"/>
	                  </xsl:with-param>
	              </xsl:call-template>
	              <xsl:value-of select="$delimiter"/>
	        <xsl:value-of select="$newline" />
         </xsl:template>
-->


         <!-- *********************************************************************************** -->
         <!-- * Cada linha indica um servi�o. Os valores das colunas s�o par�metros do template * -->
         <!-- *********************************************************************************** -->
         <xsl:template name="ROW-SERVICO">
             <xsl:param name="key"/>
             <xsl:param name="col_1"/>
             <xsl:param name="col_2"/>
             <xsl:param name="col_3"/>
             <xsl:param name="col_4"/>
             <xsl:param name="col_5"/>
             <xsl:param name="col_6">N</xsl:param>

             <!-- S� mostra se houver minutos -->
             <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='')">
                 <xsl:value-of select="$key"/>
                 <xsl:value-of select="$col_1"/>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_2"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_3"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_4"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_5"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:value-of select="$newline"/>
             </xsl:if>
         </xsl:template>


         <!-- *********************************************************************************** -->
         <!-- * Cada linha indica um servi�o. Os valores das colunas s�o par�metros do template * -->
         <!-- *********************************************************************************** -->
         <xsl:template name="ROW-INTERCONEXAO">
             <xsl:param name="key"/>
             <xsl:param name="col_1"/>
             <xsl:param name="col_2"/>
             <xsl:param name="col_3"/>
             <xsl:param name="col_4"/>
             <xsl:param name="col_5"/>
             <xsl:param name="col_6">N</xsl:param>

             <!-- S� mostra se houver minutos -->
             <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='')">
                 <xsl:value-of select="$key"/>
                 <xsl:value-of select="$col_1"/>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:value-of select="$col_2"/>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:value-of select="$col_3"/>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_4"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:call-template name="VALOR-OU-ZERO">
                     <xsl:with-param name="value">
                         <xsl:value-of select="$col_5"/>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="$delimiter"/>
                 <xsl:value-of select="$newline"/>
             </xsl:if>
    </xsl:template>


    <!-- ********************************************************************************* -->
    <!-- * Mostra a linha de subtotal. Os valores das colunas s�o par�metros do template * -->
    <!-- ********************************************************************************* -->
    <xsl:template name="SUBTOTAL-SERVICO">
        <xsl:param name="key"/>
        <xsl:param name="col_1"/>
        <xsl:param name="col_2"/>
        <xsl:param name="col_3"/>
        <xsl:param name="col_4"/>
        <xsl:value-of select="$key"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_1"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_2"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_3"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value">
                <xsl:value-of select="$col_4"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <!-- Template das linhas do download -->
    <xsl:template match="DL">
        <xsl:value-of select="$DF_downloadsDescritivoKey"/>
        <xsl:value-of select="@DT"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@TM"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@T"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="@VU"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>
    </xsl:template>
<!-- conf/txt/nextel_fatura_detalhe_fatura.xsl -->     
</xsl:stylesheet>