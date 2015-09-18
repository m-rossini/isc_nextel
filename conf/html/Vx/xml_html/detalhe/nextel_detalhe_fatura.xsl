<?xml version="1.0" encoding="ISO-8859-1"?>
                <xsl:call-template name="HEADER1-SERVICO">
                                <xsl:text>Cobran�a </xsl:text>
                        
							<xsl:choose>
								<xsl:when test="@TP='U' and @ID='CDIC'">
									<!--CDI Di�rio aplicando o desconto -->																					
									<xsl:call-template name="VALOR-OU-ZERO">
                                    	<xsl:with-param name="value">
	                                	    <xsl:choose>
							            	    <xsl:when test="translate( translate(DCT/@V, '.',''), ',' , '.') &lt; 0">
	                                               <xsl:value-of select="translate( format-number( translate( translate(@V, '.',''), ',' , '.') + translate( translate(DCT/@V, '.',''), ',' , '.'), '#,##0.00'), '.' , ',')"/>
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

                        </td>

                    <!-- Desconto -->
	                    <xsl:for-each select="DCT">
	                        <tr>
                    </xsl:if>
                <tr>
            <!-- Demonstra��o das Informa��es Conex�o Direta Nextel -->
            <!-- XML gerado pelo ISC -->
            <xsl:if test="count(DISPATCH/DISPP/DR_M)&gt;0">                 
            </xsl:if>                  
             <xsl:if test="not (DISPATCH/DISPP/DR_M)&gt;0">                
                <xsl:for-each select="DISPATCH/DISPP">
                    <xsl:call-template name="ROW-SERVICO">
                        <xsl:with-param name="col_1">
                            <xsl:value-of select="@DS"/>
                        </xsl:with-param>
                        <xsl:with-param name="col_2">
                            <xsl:value-of select="@DR"/>
                        </xsl:with-param>
                        <xsl:with-param name="col_3">
                            <xsl:value-of select="@F"/>
                        </xsl:with-param>
                        <xsl:with-param name="col_4">
                            <xsl:value-of select="@CH"/>
                        </xsl:with-param>
                        <xsl:with-param name="col_5">
                            <xsl:value-of select="@V"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:call-template name="SUBTOTAL-SERVICO">
                    <xsl:with-param name="col_1">
                        <xsl:value-of select="DISPATCH/@DR"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_2">
                        <xsl:value-of select="DISPATCH/@F"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_3">
                        <xsl:value-of select="DISPATCH/@CH"/>
                    </xsl:with-param>
                    <xsl:with-param name="col_4">
                        <xsl:value-of select="DISPATCH/@V"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>                 

                <tr>
            <xsl:if test="(CALLS/HOME/@DNF!='0:00' and CALLS/HOME/@DNF!='0,00') or (CALLS/HOME/@CH!='0:00' and CALLS/HOME/@CH!='0,00') or CALLS/HOME/@V!='0,00'">                        
            <xsl:if test="(CALLS/ROAMING/@DNF!='0:00' and CALLS/ROAMING/@DNF!='0,00') or (CALLS/ROAMING/@CH!='0:00' and CALLS/ROAMING/@CH!='0,00') or CALLS/ROAMING/@V!='0,00'">                        

                <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
                <!-- Mostra os servi�os de torpedo desse aparelho, se houver -->                
                <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
                <!-- <xsl:if test="count(SERVICES/TORPEDO) &gt; 0"> -->
                <xsl:if test="CALLS/ONLINE/SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='MMSI']">
                    <tr>
                        <td width="5%" class="text2" height="24">&#160;</td>
                        <td class="text2" height="24">
                            <b>Envio de Mensagens</b>
                        </td>
                        <td width="2%" class="text2" height="24">&#160;</td>
                        <td width="16%" class="text2" height="24" align="center">
                            <b>Per�odo</b>
                        </td>
                        <td width="2%" class="text2" height="24">&#160;</td>
                        <td width="6%" class="text2" height="24" align="center">
                            <b>Quantidade</b>
                        </td>
                        <td width="2%" class="text2" height="24">&#160;</td>
                        <td width="8%" class="text2" height="24" align="center">
                            <b>V. UNIT. R$</b>
                        </td>
                        <td width="2%" class="text2" height="24">&#160;</td>
                        <td width="15%" class="text2" height="24" align="right">
                            <b>VALOR R$</b>
                        </td>
                        <td width="4%" class="text2" height="24">&#160;</td>
                    </tr>
       				<xsl:apply-templates select="CALLS/ONLINE//SVC[@ID='TP' or @ID='SMSSI' or @ID='MMST' or @ID='MMSI']">
       					<xsl:with-param name="start" select="/INVOICE/CUSTOMER/@S" />
       					<xsl:with-param name="end" select="/INVOICE/CUSTOMER/@E" />
       				</xsl:apply-templates>
                </xsl:if>                  
                <!-- ############## FIM TORPEDO TP/SMS/MMS ################## -->  
                
                <!-- ################ LOCALIZADOR DIARIO ################# -->
                <!-- Mostra o servi�o localizador di�rio, se houver -->
                <xsl:if test="SERVICES/SVC/@ID='LOLGT'" >
                        <xsl:call-template name="LOLGT"/>
                </xsl:if>
                <!-- ############## FIM LOCALIZADOR DIARIO ############### -->
                  

        <xsl:if test="($col_2!='0:00' and $col_2!='') or ($col_2!='0,00' and $col_2!='') or ($col_5!='0:00' and $col_5!='') or ($col_5!='0,00' and $col_5!='') or ($col_6='Y' and $col_4!='0:00' and $col_4!='') or ($col_6='Y' and $col_4!='0,00' and $col_4!='')">
    <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
    <!-- Linha Detalhe do Torpedo -->                
    <!-- ################ TORPEDO TP/SMS/MMS ####################  -->                
    <!-- <xsl:template match="TORPEDO"> -->
    <xsl:template match="SVC">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <tr>
            <td width="5%" class="text2" height="24">&#160;</td>
            <td class="text2" height="24">
                <xsl:value-of select="@DS"/>
            </td>
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="16%" class="text2" height="24" align="center">
                <xsl:value-of select="$start"/>
                <xsl:text> a </xsl:text>
                <xsl:value-of select="$end"/>                            
            </td>
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="6%" class="text2" height="24" align="center">
                <xsl:value-of select="@Q"/>
            </td>

       		<xsl:if test="@ID!='SMSSI'">            
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="8%" class="text2" height="24" align="center">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <!-- <xsl:value-of select="@U"/> -->
                        <xsl:value-of select="translate(format-number((translate(@V, ',' , '.') div translate(@Q, ',' , '.')), '##0.00'), '.' , ',')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
        	</xsl:if>    
       		<xsl:if test="@ID='SMSSI'">		                                 	
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="8%" class="text2" height="24" align="center">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:text> - </xsl:text>      		    	
                    </xsl:with-param>
                </xsl:call-template>
            </td>
        	</xsl:if>              
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="15%" class="text2" height="24" align="right">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="@V"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td width="4%" class="text2" height="24">&#160;</td>
        </tr>
    </xsl:template>
    
    <!-- ######## Localizador Di�rio  ######## -->
    <xsl:template name="LOLGT">
        <!-- Descritivo  downloads -->
        <tr>
            <td width="10%" class="text2" height="24">&#160;</td>
            <td width="20%" class="text2" height="24">
                <b>Localizador Nextel</b>
            </td>
            <td width="1%" class="text2" height="24" align="center">
                <b>Per�odo</b>
            </td>
            <td width="1%" class="text2" height="24" align="center">
                <b>Quantidade</b>
            </td>
            <td width="28%" class="text2" height="24" align="center">
            </td>
            <td width="10%" class="text2" height="24" align="center">
            </td>
            <td width="15%" class="text2" height="24" align="center">&#160;</td>
            <td width="10%" colspan="2" class="text2" height="24" align="center">&#160;</td>
            <td width="35%" class="text2" height="24" align="right" nowrap="">
                <b></b>
            </td>
            <td width="3%" class="text2" height="10">&#160;</td>
        </tr>
        <tr>
            <td width="5%" class="text2" height="24">&#160;</td>
            <td class="text2" height="24">
                <xsl:value-of select="CALLS/ONLINE/SVC/@DS"/>
            </td>
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="16%" class="text2" height="24" align="center">
                <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                <xsl:text> a </xsl:text>
                <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>                            
            </td>
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="6%" class="text2" height="24" align="center">
                <xsl:value-of select="CALLS/ONLINE/SVC/@Q"/>
            </td>

            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="8%" class="text2" height="24" align="center">
            </td>
            <td width="2%" class="text2" height="24">&#160;</td>
            <td width="15%" class="text2" height="24" align="right">
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value">
                        <xsl:value-of select="CALLS/ONLINE/SVC/@V"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td width="4%" class="text2" height="24">&#160;</td>
        </tr>        
    </xsl:template>
    
    
</xsl:stylesheet>