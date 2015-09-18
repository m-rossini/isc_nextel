<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:febraban="xalan://br.com.auster.nextel.xsl.extensions.FebrabanVariable"
                xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
                xmlns:xalan="http://xml.apache.org/xalan"
                extension-element-prefixes="xalan febraban string"
                exclude-result-prefixes="xalan febraban string"
                version="1.0">

    <!-- ************************************ -->
    <!-- * templates usados para preencher início de linha, valores, rateplan * -->
    <!-- ************************************ -->
    <xsl:template name="FLEET">
        <xsl:choose>
            <xsl:when test="@TP = 'AMP'">
                <xsl:value-of select="febraban:rightPad(@IMEI,25)"/>
                <xsl:variable name="null" select="string:setValue('fleet',febraban:rightPad(@IMEI,25))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(@IMEI,25)"/>
                <xsl:variable name="null" select="string:setValue('fleet',febraban:rightPad(@IMEI,25))"/>
                <!--                <xsl:value-of select="febraban:rightPad(concat(@FID,'*',@MID),25)"/>
                <xsl:variable name="null" select="string:setValue('fleet',febraban:rightPad(concat(@FID,'*',@MID),25))"/>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="RATEPLAN">
        <xsl:variable name="null" select="string:setValue('rateplan', '')"/>
        <xsl:for-each select="CHARGES/CHG/SVC">
            <xsl:if test="@ST='a' or @ST='m'">
                <xsl:variable name="null" select="string:setValue('rateplan', febraban:convertAccents(@TR))"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:variable name="testRateplan" select="string:getValue('rateplan')"/>
        <xsl:if test="$testRateplan = ''">
            <xsl:variable name="null" select="string:setValue('rateplan', febraban:convertAccents(CHARGES/CHG/SVC[position()=1]/@TR))"/>
        </xsl:if>
        <xsl:value-of select="febraban:rightPad(substring(string:getValue('rateplan'),1,15),15)"/>
        <xsl:variable name="null" select="string:setValue('rateplan', febraban:rightPad(substring(string:getValue('rateplan'),1,15),15))"/>
    </xsl:template>
    
    <xsl:template name="CHAVE">
        <xsl:param name="key"/>
        <xsl:variable name="null" select="string:setValue('key',$key)"/>
        <xsl:variable name="null" select="string:setValue('inicio', febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@S))"/>
        <xsl:variable name="null" select="string:setValue('vencto', febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@D))"/>
        <xsl:variable name="null" select="string:setValue('fim', febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@E))"/>
        <xsl:variable name="null" select="string:setValue('emissao', febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@I))"/>
        <xsl:variable name="fleet">
            <xsl:call-template name="FLEET"/>
        </xsl:variable>
        <!-- <xsl:variable name="null" select="string:setValue('fleet', $fleet)"/> -->
        <xsl:variable name="null" select="string:setValue('cnl', febraban:repeatChars(' ',5))"/>
        <xsl:choose>
        <xsl:when test="not(starts-with(@N,'#'))">
            <xsl:variable name="null" select="string:setValue('numero',febraban:rightPad(@N,12))"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="null" select="string:setValue('numero',concat(febraban:rightPad(' ',2),febraban:rightPad(@N,10)))"/>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="rate">
            <xsl:call-template name="RATEPLAN"/>
        </xsl:variable>
        <xsl:variable name="null" select="string:setValue('ratepla',febraban:convertAccents(febraban:rightPad($rate,15)))"/>
        <xsl:variable name="null" select="string:setValue('degrau',febraban:repeatChars(' ',2))"/>
    </xsl:template>

    <xsl:template name="VALOR">
        <xsl:param name="valor"/>
        <xsl:choose>
            <xsl:when test="starts-with($valor,'-')">
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'+'"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="febraban:leftPad(febraban:replaceChars($valor,'.,-',''),13,'0')"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>

    <xsl:template name="VALOR-SEMSINAL">
        <xsl:param name="valor"/>
        <xsl:value-of select="febraban:leftPad(febraban:replaceChars($valor,'.,-',''),13,'0')"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>

    <xsl:template name="SINAL-VALOR">
        <xsl:param name="valor"/>
        <xsl:choose>
            <xsl:when test="starts-with($valor,'-')">
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'+'"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>

    <!-- *********************************** -->
    <!-- * Templates para linhas 0, 1, 5 e 9 * -->
    <!-- *********************************** -->
    <xsl:template name="HEADER">
        <xsl:param name="key"/>

        <febraban:reset/>

        <!-- linha 0 -->
        <xsl:value-of select="$key"/>
        <xsl:value-of select="$delimiter"/>
        <!-- contador -->
        <xsl:value-of select="febraban:leftPad(febraban:getCounter(),12,string('0'))"/> 
        <xsl:value-of select="$delimiter"/>
        <!-- data de geração do arq -->
        <!-- xsl:value-of select="febraban:americanDate()"/-->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@I)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- operadora -->
        <xsl:value-of select="febraban:rightPad('NEXTEL',15)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- estado -->
        <xsl:value-of select="string('SP')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- código do cliente -->
        <!-- xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/CUSTOMER/@B,'.,/-',''),15)"/ -->

		<!-- EHO: Exibir nro do cgc no arquivo febraban linha 0 -->
        <xsl:choose>
            <xsl:when test="(count(/INVOICE/BILL/TELECOM/NF) &gt; 0)">
                <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/BILL/TELECOM/NF/CLIENTE/@ID,'.,/-',''),15)"/> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad('',15)"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:value-of select="$delimiter"/>
        <!-- nome do cliente -->
        <xsl:value-of select="febraban:rightPad(/INVOICE/CUSTOMER/@C,40)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- CGC -->
		<!-- EHO: Exibir nro do cgc no arquivo febraban linha 0 -->
        <xsl:choose>
            <xsl:when test="(count(/INVOICE/BILL/TELECOM/NF) &gt; 0)">
                <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/BILL/TELECOM/NF/CLIENTE/@ID,'.,/-',''),15)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad('',15)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- id. conta única -->
        <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/CUSTOMER/@B,'.,/-',''),25)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data de vencto -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@D)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data de emissão -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@I)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',201)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>
    
    <xsl:template name="CONTA-RESUMO">
    
        <xsl:param name="key"/>
        <!-- linha 1 -->
        <xsl:value-of select="$key"/>
        <xsl:value-of select="$delimiter"/>
        <!-- contador -->
        <xsl:value-of select="febraban:leftPad(febraban:getCounter(),12,'0')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- id. conta única -->
        <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/CUSTOMER/@B,'.,/-',''),25)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data vencto -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@D)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data emissão -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@I)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- id. único do recurso -->
        <xsl:call-template name="FLEET"/>
        <!-- cnl do recurso -->
        <xsl:value-of select="febraban:repeatChars(' ',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- nome da localidade -->
        <xsl:value-of select="febraban:rightPad(febraban:convertAccents(/INVOICE/CUSTOMER/@CT),25)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- DDD + num. telefone -->
        <xsl:value-of select="febraban:rightPad(@N,12)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- tipo de serviço -->
        <xsl:value-of select="string('SME ')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- descrição do tipo de serviço -->
        <xsl:value-of select="febraban:rightPad('SERVICO MOVEL ESPECIALIZADO',35)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- característica do recurso -->
        <xsl:call-template name="RATEPLAN"/>
        <!-- degrau, velocidade, unidade do recurso; início e fim do período da assinatura-->
        <xsl:value-of select="febraban:repeatChars(' ',27)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- início período do serviço medido -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@S)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- fim período do serviço medido -->
        <xsl:value-of select="febraban:convertDateToAAAAMMDD(/INVOICE/CUSTOMER/@E)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- unidade de consumo -->
        <xsl:value-of select="febraban:repeatChars(' ',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- <xsl:value-of select="febraban:repeatChars('0',7)"/> -->
        <!-- colocar a somatória dos minutos -->
        <!-- xsl:value-of select="febraban:leftPad(number(febraban:replaceChars(CALLS/HOME/@DNF,'.,','')) + number(febraban:replaceChars(CALLS/ROAMING/@DNF,'.,','')),7,'0')"/ -->
        <xsl:variable name="consumo" select="round(number(febraban:replaceChars(CALLS/HOME/@DNF_M,',.','.')) + number(febraban:replaceChars(CALLS/ROAMING/@DNF_M,',.','.')))"/>
        <xsl:value-of select="febraban:leftPad(febraban:replaceChars($consumo,'.',''),7,'0')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal valor consumo -->
        <xsl:value-of select="'+'"/>
        <xsl:value-of select="$delimiter"/>
        <!-- valor consumo -->
        <xsl:value-of select="febraban:repeatChars('0',13)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal e valor assinatura -->
        <xsl:call-template name="VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="@M"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- alíquota -->
        <xsl:value-of select="febraban:repeatChars(' ',2)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal icms -->
        <xsl:value-of select="'+'"/>
        <xsl:value-of select="$delimiter"/>
        <!-- valor icms -->
        <xsl:value-of select="febraban:repeatChars('0',13)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal valor total de impostos -->
        <xsl:value-of select="'+'"/>
        <xsl:value-of select="$delimiter"/>
        <!-- valor total de impostos -->
        <xsl:value-of select="febraban:repeatChars('0',13)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- num. nota fiscal -->
		<!-- EHO: Exibir nro da NF no arquivo febraban linha 1 -->
        <xsl:value-of select="febraban:rightPad(/INVOICE/BILL/TELECOM/NF/@NR,12)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal e valor da conta -->
        <xsl:call-template name="VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="@T"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',36)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>

    <xsl:template name="DESCONTOS">
        <xsl:param name="ramo"/>
        <xsl:param name="key"/>
        <xsl:param name="tipo"/>
        <!--        <string:reset/>-->
        <xsl:variable name="null" select="string:setValue('key',$key)"/>

        <xsl:choose>
            <xsl:when test="$tipo = 1">
                <xsl:if test="(count($ramo/CHG/descendant::SVC/DCT) &gt; 0)">
                    <!--            <xsl:call-template name="CHAVE">
                        <xsl:with-param name="key" select="$key"/>
                    </xsl:call-template> -->
        
                    <xsl:apply-templates select="$ramo/CHG/descendant::SVC/DCT" mode="OCC"/>
                </xsl:if>
                <xsl:if test="(count($ramo/CHG/descendant::SVC[starts-with(@V,'-')]) &gt; 0)">
                    <!--            <xsl:call-template name="CHAVE">
                        <xsl:with-param name="key" select="$key"/>
                    </xsl:call-template> -->
        
                    <xsl:apply-templates select="$ramo/CHG/descendant::SVC[starts-with(@V,'-')]" mode="OCC"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="count($ramo/OCC) &gt; 0">
                    <!--  <xsl:call-template name="CHAVE">
                        <xsl:with-param name="key" select="$key"/>
                    </xsl:call-template> -->
        
                    <xsl:apply-templates select="$ramo/descendant::OCC" mode="OCC"/>
                </xsl:if>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="OCC|DCT|SVC" mode="OCC">

        <!-- Atualiza o contador -->
        <xsl:variable name="null" select="string:setValue('contador', febraban:leftPad(febraban:getCounter(),12,string('0')))"/>
        <!-- linha 5 -->
        <xsl:value-of select="string:getValue('key')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- contador -->
        <xsl:value-of select="string:getValue('contador')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data de vencto -->
        <xsl:value-of select="string:getValue('vencto')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data de emissão -->
        <xsl:value-of select="string:getValue('emissao')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- id. único por recurso -->
        <xsl:choose>
            <xsl:when test="name()='OCC'">
                <xsl:value-of select="febraban:repeatChars(' ',25)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string:getValue('fleet')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- id. conta única -->
        <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/CUSTOMER/@B,'.,/-',''),25)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- cnl do recurso -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- ddd + número -->
        <xsl:value-of select="string:getValue('numero')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- grupo da categoria -->
        <xsl:choose>
            <xsl:when test="name()='DCT'">
                <xsl:value-of select="'DSC'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'CRD'"/>                
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- descrição do grupo da categoria -->
        <xsl:choose>
            <xsl:when test="name()='SVC'">
                <xsl:choose>
                    <xsl:when test="(@ID='DISPP' or @ID='TELAL' or @ID='ME')">
                        <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@TR),80)"/> 
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@DS),80)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@DS),80)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal valor ligação -->
        <xsl:call-template name="SINAL-VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="@V"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- base de cálculo do desconto -->
        <xsl:value-of select="febraban:repeatChars('0',13)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- percentual de desconto -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- valor da ligação -->
        <xsl:call-template name="VALOR-SEMSINAL">
            <xsl:with-param name="valor">
                <xsl:value-of select="@V"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- data início do acerto -->
        <xsl:variable name="anoServ" select="substring(/INVOICE/CUSTOMER/@D,7)"/>
        <xsl:variable name="mesVenc" select="substring(/INVOICE/CUSTOMER/@D,4,2)"/>
        <xsl:variable name="mesServ" select="substring(@S,4)"/>
        <xsl:choose>
            <xsl:when test="name()='SVC'">
                <xsl:choose>
                    <!--                    <xsl:when test="($mesServ = '12') and ($mesVenc = '01')"> -->
                    <xsl:when test="($mesVenc = '01')">
                        <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@S,'/',($anoServ - 1)))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@S,'/', $anoServ ))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string:getValue('inicio')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- hora início do acerto -->
        <xsl:value-of select="febraban:repeatChars('0',6)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data fim do acerto -->
        <xsl:variable name="anoServ" select="substring(/INVOICE/CUSTOMER/@D,7)"/>
        <xsl:variable name="mesVenc" select="substring(/INVOICE/CUSTOMER/@D,4,2)"/>
        <xsl:variable name="mesServ" select="substring(@E,4)"/>
        <xsl:choose>
            <xsl:when test="name()='SVC'">
                <xsl:choose>
                    <xsl:when test="($mesServ = '12') and ($mesVenc = '01')">
                        <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@E,'/',($anoServ - 1)))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@E,'/', $anoServ ))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name()='DCT'">
                <xsl:value-of select="string:getValue('fim')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:convertDateToAAAAMMDD(@DT)"/>                
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- hora fim do acerto -->
        <xsl:value-of select="febraban:repeatChars('0',6)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- classe do serviço -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',106)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>

    <xsl:template name="TRAILLER">
        <xsl:param name="contratos"/>
        <xsl:param name="key"/>
        <xsl:param name="total"/>
        <string:reset/>
        
        <xsl:call-template name="CHAVE">
            <xsl:with-param name="key" select="$key"/>
        </xsl:call-template>
        
        <!-- Atualiza o contador -->
        <xsl:variable name="null" select="string:setValue('contador', febraban:leftPad(febraban:getCounter(),12,string('0')))"/>
        <!-- linha 9 -->
        <xsl:value-of select="string:getValue('key')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- contador -->
        <xsl:value-of select="string:getValue('contador')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- código do cliente -->
		<!-- EHO: Exibir nro do cgc no arquivo febraban linha 9 -->
        <xsl:choose>
            <xsl:when test="(count(/INVOICE/BILL/TELECOM/NF) &gt; 0)">
                <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/BILL/TELECOM/NF/CLIENTE/@ID,'.,/-',''),15)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad('',15)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- id. conta única -->
        <xsl:value-of select="febraban:rightPad(febraban:replaceChars(/INVOICE/CUSTOMER/@B,'.,/-',''),25)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data vencto -->
        <xsl:value-of select="string:getValue('vencto')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data emissão -->
        <xsl:value-of select="string:getValue('emissao')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- qtdade de registros -->
        <xsl:value-of select="string:getValue('contador')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- qtdade de recursos -->
        <xsl:value-of select="febraban:leftPad($contratos,12,string('0'))"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal + valor do total -->
        <xsl:call-template name="VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="$total"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',243)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>

</xsl:stylesheet>