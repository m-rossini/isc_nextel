<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
	xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:double="xalan://br.com.auster.nextel.xsl.extensions.DoubleFunctions"
    xmlns:duration="xalan://br.com.auster.nextel.xsl.extensions.DurationFormat"
    xmlns:req="xalan://br.com.auster.dware.graph.Request"
    xmlns:map="xalan://java.util.Map"
    extension-element-prefixes="xalan number aggregates date string sql double duration"
    exclude-result-prefixes="xalan number aggregates date string sql double duration req map"
    version="1.0">

    <xsl:output method="xml" encoding="ISO-8859-1" /> 
    
    <xsl:param name="req:request"/>
    
    <xsl:preserve-space elements="M I"/>
	
    <xsl:include href="bgh-invoice-header.xsl"/>

    <xsl:template match="/TIMM">
        <xsl:call-template name="resetComponents"/>

        <xsl:variable name="requestAtts" select="req:getAttributes($req:request)" />
        <xsl:variable name="billsuppressFlag" select="map:get($requestAtts, 'billsuppress')" />

        <!-- processing customer invoice -->
        <xsl:if test="not($billsuppressFlag) or $billsuppressFlag != 'S'">
        	<xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-PAYMENT']" mode="INVOICE"/>
        </xsl:if>

        <xsl:element name="CUSTOMER">
            <xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']" mode="BALANCE"/>
            <xsl:if test="not($billsuppressFlag) or $billsuppressFlag != 'S'">
              <xsl:apply-templates select="UNB[BGM/DOCUMENT/@TYPE='BCH-SUMSHEET']" mode="SUMSHEET"/>
            </xsl:if>
        </xsl:element>
 
        <!-- cleaning up our mess -->
        <xsl:call-template name="resetComponents"/>
    </xsl:template>

    <xsl:template match="UNB" mode="INVOICE">

		<number:setValue name="valorBC" value="0"/>
        <number:setValue name="valorDC" value="0"/>
        <number:setValue name="totalBC" value="0"/>
        <number:setValue name="totalDC" value="0"/>
        <number:setValue name="ajusteDesconto" value="0"/>

        <xsl:for-each select="LIN1[TAX[@TYPE='1']]">
            <xsl:variable name="valor" select="number(TAX/DETAIL/@CODE)"/>
            <xsl:variable name="generally" select="string(TAX/@GENERALLY)"/>
            <!-- Rules for ICMS discounting:
              Valor Bruto calculado = Valor liquido(MOA 125) / (1 - Aliquota de ICMS(campo C243-5279 do segmento TAX)),  
              Valor Bruto calculado = 20,82 / (1 - 0,25) = 20,82 / 0,75 = 27,76
              BC = 27,76
              Desconto ICMS - DC
              DC = 27,76 - 20,82 = 6,94
              DC = BC - MOA 125
            -->
            <xsl:if test="not(starts-with($valor,'NaN'))">
                <xsl:if test="starts-with($generally,'Z')">
                    <xsl:variable name="null" select="number:setValue('valorBC',number:ceil(MOA/AMOUNT[@TYPE='125']/@VALUE div (1 - number:round(number:parse($valor) div 100.0,2)) ,2))"/>
                    <xsl:variable name="null" select="number:setValue('totalBC', number:getValue('totalBC') + number:getValue('valorBC'))"/>
                    <xsl:variable name="null" select="number:setValue('valorDC', number:getValue('valorBC') - number:round(number:parse(MOA/AMOUNT[@TYPE='125']/@VALUE),2))"/> 
                    <xsl:variable name="null" select="number:setValue('totalDC', number:getValue('totalDC') + number:getValue('valorDC'))"/>
                </xsl:if>
            </xsl:if>

            </xsl:for-each>
    </xsl:template>


    <xsl:template match="UNB" mode="BALANCE">
      <xsl:call-template name="header" />
      <!-- MESSAGES -->
      <aggregates:reset aggregate="msgs" />
      <xsl:for-each select="descendant::FTX[@QUALIFIER='ADV']">
        <xsl:variable name="msg"
          select="concat(LITERAL/@TEXT1, LITERAL/@TEXT2, LITERAL/@TEXT3, LITERAL/@TEXT4, LITERAL/@TEXT5)" />
        <xsl:variable name="null" select="aggregates:addKey('msgs', 'msg', $msg)" />
        <aggregates:assembleKey aggregate="msgs" />
      </xsl:for-each>
      <xsl:element name="MESSAGES">
        <xsl:for-each select="aggregates:getKeys('msgs')/key">
          <!-- <xsl:sort order="descending" select="aggregates:getKey('msgs', @value, 'msg')" /> -->
          <!-- <xsl:sort order="ascending" select="aggregates:getKey('msgs', @value, 'msg')" />  -->        
          <xsl:sort order="ascending" select="aggregates:getKey('msgs', @value, 'msg')" />            
          <xsl:variable name="msg" select="aggregates:getKey('msgs', @value, 'msg')" />
          <xsl:choose>
            <xsl:when test="starts-with($msg,'^')">
              <xsl:element name="M">
                <xsl:value-of select="substring($msg, 2)" />
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="I">
                <xsl:value-of select="$msg" />
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:element>
    </xsl:template>


    <xsl:template match="UNB" mode="SUMSHEET">

        <!-- OTHER CREDITS AND CHARGES -->
		<number:setValue name="totalOccs" value="0"/>
        <number:setValue name="totalOthers" value="0"/>
        <number:setValue name="totalCredits" value="0"/>
        <number:setValue name="totalPenaltyInterests" value="0"/>  

        <!-- DETAILS -->
        <xsl:element name="DETAILS">

            <!-- SUBSCRIBER -->
            <xsl:element name="SUBSCRIBER">

                <aggregates:reset aggregate="occ"/>
                <xsl:for-each select="LIN1">

                    <!-- CONTRACT -->
                    <xsl:for-each select="CONTRACT">
						<xsl:copy-of select="."/>
                    </xsl:for-each>

                </xsl:for-each>

		<!-- TOTAL OTHER/CREDITS/PANALTY-INTERESTS and TOTAL of ALL OCCs -->		
 		<xsl:for-each select="LIN1/OCC">
 			<xsl:variable name="null" select="number:setValue('totalOccs', number:getValue('totalOccs') + double:sum(@V))"/>
 			<xsl:choose>
 				<xsl:when test="starts-with(@DS,'Pagamento em duplicidade')">
					<xsl:variable name="null" select="number:setValue('totalCredits', number:getValue('totalCredits') + double:sum(@V))"/> 	    
				</xsl:when>
				<xsl:when test="starts-with(@DS, 'Juros fatura')
		    			  or starts-with(@DS, 'Multa fatura')"> 
    				<xsl:variable name="null" select="number:setValue('totalPenaltyInterests', number:getValue('totalPenaltyInterests') + double:sum(@V))"/>					
				</xsl:when>
				<xsl:otherwise>
    				<xsl:variable name="null" select="number:setValue('totalOthers', number:getValue('totalOthers') + double:sum(@V))"/>					
				</xsl:otherwise>					
			</xsl:choose>
        </xsl:for-each> 
				
		<!-- OCC OTHER -->			
        <xsl:element name="OTHER">	 
	        <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalOthers')"/>
                </xsl:call-template>	        
	         </xsl:attribute> 	                          	            			
		    <xsl:for-each select="LIN1/OCC">
	    		<xsl:if test="not (starts-with(@DS,'Pagamento em duplicidade'))
	    						and not (starts-with(@DS, 'Juros fatura'))
	    						and not (starts-with(@DS, 'Multa fatura'))">	  	    
					<xsl:element name="OCC">			
					   <xsl:attribute name="DS">
						<xsl:value-of  select="@DS"/>
					   </xsl:attribute>
					   <xsl:attribute name="DT">
						<xsl:value-of select="date:format(@DT, 'yyyyMMdd', 'dd/MM/yyyy')"/>
					   </xsl:attribute>
				 	   <xsl:attribute name="V">
						<xsl:value-of select="@V"/>
					   </xsl:attribute>
					</xsl:element>
				</xsl:if>
            </xsl:for-each> 
        </xsl:element>                                         
                
  		<!-- OCC CREDITS -->  		
        <xsl:element name="CREDITS">            
	        <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalCredits')"/>
                </xsl:call-template>		        
	         </xsl:attribute> 	  
    		<xsl:for-each select="LIN1/OCC">
			    <xsl:if test="starts-with(@DS,'Pagamento em duplicidade')">
					<xsl:element name="OCC">			
					   <xsl:attribute name="DS">
					   	<xsl:value-of  select="@DS"/>
					   </xsl:attribute>
					   <xsl:attribute name="DT">
						<xsl:value-of select="date:format(@DT, 'yyyyMMdd', 'dd/MM/yyyy')"/>
					   </xsl:attribute>
				 	   <xsl:attribute name="V">
						<xsl:value-of select="@V"/>
					   </xsl:attribute>
					</xsl:element>
				</xsl:if>
         	 </xsl:for-each>
        </xsl:element>
        
        <!-- OCC PENALTY/INTERESTS -->   
        <xsl:element name="PENALTY_INTERESTS">           
	        <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalPenaltyInterests')"/>
                </xsl:call-template>			        
	         </xsl:attribute> 	                         
    		<xsl:for-each select="LIN1/OCC">
			    <xsl:if test="starts-with(@DS, 'Juros fatura')
			    			  or starts-with(@DS, 'Multa fatura')"> 	   
					<xsl:element name="OCC">			
					   <xsl:attribute name="DS">
					   	<xsl:value-of  select="@DS"/>
					   </xsl:attribute>
					   <xsl:attribute name="DT">
						<xsl:value-of select="date:format(@DT, 'yyyyMMdd', 'dd/MM/yyyy')"/>
					   </xsl:attribute>
				 	   <xsl:attribute name="V">
						<xsl:value-of select="@V"/>
					   </xsl:attribute>
					</xsl:element>
				</xsl:if>
         	 </xsl:for-each>
        </xsl:element>
                
        </xsl:element>

        </xsl:element>

        <!-- INVOICE SUMMARY -->
        <xsl:element name="SUMMARY">

			<xsl:variable name="null" select="number:setValue('totalSubscriber', double:sum(LIN1/CONTRACT/@T))"/>
			
            <!-- Verificando e ajustando valores de desconto de ICMS -->
            <xsl:if test="(number:getValue('totalDC')!= 0) and (number:getValue('totalBC')!= 0)">
                <xsl:variable name="null" select="number:setValue('ajusteDesconto', number:getValue('totalDC') - (number:getValue('totalSubscriber') + number:getValue('totalOccs') - number:parse(/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']/descendant::MOA/AMOUNT[@TYPE='967']/@VALUE)))"/>
                <xsl:variable name="null" select="number:setValue('totalDC', number:getValue('totalDC') - number:getValue('ajusteDesconto'))"/>
                <xsl:variable name="null" select="number:setValue('totalBC', number:getValue('totalBC') - number:getValue('ajusteDesconto'))"/>
            </xsl:if>		
			
            <!-- TOTAL VALUE -->
            <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-BALANCE']/descendant::MOA/AMOUNT[@TYPE='967']/@VALUE"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- SUBSCRIBERS SUBTOTAL (WITHOUT OCC) -->
            <xsl:attribute name="S">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" 
                        select="number:getValue('totalSubscriber')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- SUBSCRIBERS SUBTOTAL (WITH OCC) -->
            <xsl:attribute name="SS">
				<!--xsl:value-of select="double:sum(LIN1/CONTRACT/@T) + number:getValue('totalOthers')"/-->
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" 
                        select="number:getValue('totalSubscriber') + double:sum(LIN1/OCC/@V)"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- MONTHLY FEE -->
            <xsl:attribute name="M">
                <xsl:call-template name="decimalFormat">
					<xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/@M)"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- DISPATCH TOTAL -->
            <xsl:attribute name="D">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/DISPATCH/@V)"/>
                </xsl:call-template>
            </xsl:attribute>
            
            <!-- DISPATCH DURATION (minutes) -->
            <xsl:variable name="DD" select="double:sum(LIN1/CONTRACT/DISPATCH/@DR_M)"/>
            <xsl:attribute name="DD">
                <xsl:value-of select="duration:formatFromMinutes($DD)"/>
                <!--xsl:with-param name="value" select="number:getValue('minutosConexaoDireta')"/-->
            </xsl:attribute>
            <xsl:attribute name="DD_M">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="$DD"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- ADDITIONAL SERVICES -->
            <xsl:attribute name="A">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/@A)"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- NEXTEL ONLINE -->
            <xsl:attribute name="O">
                <xsl:call-template name="decimalFormat">
					<xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/@O)"/>
                </xsl:call-template>
            </xsl:attribute>
            
            <!-- OTHER CREDITS AND CHARGES (OTHER/CREDITS/PENALTY-INTEREST) TOTAL -->
            <xsl:attribute name="C">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalOthers')"/>
                </xsl:call-template>
            </xsl:attribute>                                                             
            <xsl:attribute name="C1">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalCredits')"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="C2">
                <xsl:call-template name="decimalFormat">
                    <xsl:with-param name="value" select="number:getValue('totalPenaltyInterests')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- DISCOUNTS OF ICMS -->
            <xsl:attribute name="DICMS">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="0 - number:getValue('totalDC')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- VALOR BRUTO -->
            <xsl:attribute name="TOTALBC">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="number:getValue('totalBC')"/>
                </xsl:call-template>
            </xsl:attribute>

            <!-- TOTAL Torpedo Nextel-->
            <xsl:attribute name="TP">
                <xsl:call-template name="decimalFormat">
                   <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/SERVICES/TORPEDO/@V)"/>
  				   <!--xsl:with-param name="value" select="number:getValue('totalTorpedo')"/-->
                </xsl:call-template>
            </xsl:attribute>
      
            <!-- CALLS INSIDE LOCAL AREA -->
            <xsl:element name="HOME">
                <!-- TOTAL -->
                <xsl:attribute name="T">
					<!-- chamadasDentro -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- LOCAL CALLS -->
                <xsl:attribute name="LC">
					<!-- chamadasLocais -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/OUTGOING/LOCAL/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- LONG DISTANCE CALLS -->
                <xsl:attribute name="LD">
					<!-- chamadasLonga -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/OUTGOING/LONG_DISTANCE/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED CALLS -->
                <xsl:attribute name="R">
					<!-- chamadasRecebidas -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/INCOMING/RECEIVED/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED COLLECT CALLS -->
                <xsl:attribute name="RC">
					<!-- chamadasRecebidasCobrar -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/INCOMING/COLLECT/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- INTERNATIONAL CALLS -->
                <xsl:attribute name="I">
					<!-- chamadasInternacionais -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/OUTGOING/INTERNATIONAL/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- 0300 CALLS -->
                <xsl:attribute name="Z3">
					<!-- chamadasZ300 -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/OUTGOING/Z300/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- DISCOUNTS CALLS -->
                <xsl:attribute name="DC">
					<!-- chamadasDescontos -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/HOME/INCOMING/DISCOUNTS/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL DURATION (minutes) -->
                <xsl:variable name="TD" select="double:sum(LIN1/CONTRACT/CALLS/HOME/@DNF_M)"/>
                <xsl:attribute name="TD">
					<!-- minutosChamadasDetrno -->
                    <xsl:value-of select="duration:formatFromMinutes($TD)"/>
                </xsl:attribute>
                <xsl:attribute name="TD_M">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="$TD"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
      
            <!-- CALLS OUTSIDE LOCAL AREA (ROAMING) -->
            <xsl:element name="ROAMING">
                <!-- TOTAL -->
                <xsl:attribute name="T">
					<!-- chamadasFora -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- DIALED CALLS -->
                <xsl:attribute name="D">
					<!-- chamadasForaOriginadas -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/OUTGOING/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED CALLS -->
                <xsl:attribute name="R">
					<!-- chamadasForaRecebidas -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/INCOMING/RECEIVED/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- RECEIVED COLLECT CALLS -->
                <xsl:attribute name="RC">
					<!-- chamadasForaRecebidasCobrar -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/INCOMING/COLLECT/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- 0300 CALLS -->
                <xsl:attribute name="Z3">
					<!-- chamadasForaZ300 -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/OUTGOING/Z300/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <!-- DIALED WITHOUT 0300 CALLS -->
                <xsl:attribute name="DNOZ3">
					<!-- chamadasForaOriginadas - chamadasForaZ300 -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" 
                          select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/OUTGOING/@V) - double:sum(LIN1/CONTRACT/CALLS/ROAMING/OUTGOING/Z300/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- DISCOUNTS CALLS -->
                <xsl:attribute name="DC">
					<!-- chamadasForaDescontos -->
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/INCOMING/DISCOUNTS/@V)"/>
                    </xsl:call-template>
                </xsl:attribute>

                <!-- TOTAL DURATION (minutes) -->
                <xsl:variable name="TD" select="double:sum(LIN1/CONTRACT/CALLS/ROAMING/@DNF_M)"/>
                <xsl:attribute name="TD">
					<!-- minutosChamadasFora -->
                    <xsl:value-of select="duration:formatFromMinutes($TD)"/>
                </xsl:attribute>
                <xsl:attribute name="TD_M">
                    <xsl:call-template name="decimalFormat">
                        <xsl:with-param name="value" select="$TD"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>

        </xsl:element>

    </xsl:template>

    <xsl:template name="setDateAggregateKey">
        <xsl:param name="aggregate"/>
        <xsl:param name="name"/>
        <xsl:param name="date"/>
        <xsl:param name="pattern"/>
		<!--
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:variable name="null" select="aggregates:addKey($aggregate, $name, date:format($date/DATE, string:getValue('_datePattern'), $pattern))"/>
		-->
        <xsl:variable name="null" select="aggregates:addKey($aggregate, $name, $date/DATE, $pattern)"/>
    </xsl:template>

    <xsl:template name="setDateVariable">
        <xsl:param name="name"/>
        <xsl:param name="date"/>
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:variable name="null" select="date:setValue($name, $date/DATE, string:getValue('_datePattern'))"/>
    </xsl:template>

    <xsl:template name="datePattern">
        <xsl:param name="formatId"/>
        <xsl:choose>
            <xsl:when test="$formatId = '102'">
                <string:setValue name="_datePattern" value="yyyyMMdd"/>
            </xsl:when>
            <xsl:when test="$formatId = '101'">
                <string:setValue name="_datePattern" value="yyMMdd"/>
            </xsl:when>
            <xsl:when test="$formatId = '609'">
                <string:setValue name="_datePattern" value="yyMM"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="null" select="string:setValue('_datePattern', date:getDefaultPattern())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
			
    <xsl:template name="dateFormat">
        <xsl:param name="date"/>
        <xsl:param name="pattern"/>
        <xsl:call-template name="datePattern">
            <xsl:with-param name="formatId" select="$date/@FORMAT"/>
        </xsl:call-template>
        <xsl:value-of select="date:format($date/DATE, string:getValue('_datePattern'), $pattern)"/>
    </xsl:template>

    <xsl:template name="decimalFormat">
        <xsl:param name="value"/>
        <xsl:call-template name="dotComma">
            <xsl:with-param name="value" select="format-number(number:round($value, 2), '#,##0.00')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="numberFormat">
        <xsl:param name="value"/>
        <xsl:call-template name="dotComma">
            <xsl:with-param name="value" select="format-number($value, '#,##0')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="dotComma">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '.')">
                <xsl:value-of select="concat( translate(substring-before($value, '.'), ',', '.'), ',', substring-after($value, '.') )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate($value, ',', '.')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="resetComponents">
        <date:reset pattern="yyyyMMdd"/>
        <number:reset/>
        <!--string:reset/-->
        <aggregates:reset/>
        <!--nodelist:reset/-->
    </xsl:template>

</xsl:stylesheet>