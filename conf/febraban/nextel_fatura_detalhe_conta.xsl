<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:febraban="xalan://br.com.auster.nextel.xsl.extensions.FebrabanVariable"
                xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
                exclude-result-prefixes="xalan febraban string"
                version="1.0">

    <!-- Template para a linha 3 -->
    <xsl:template name="BILHETACAO">
        <xsl:param name="key"/>
        <string:reset/>

        <xsl:call-template name="CHAVE">
            <xsl:with-param name="key" select="$key"/>
        </xsl:call-template>

        <!-- Chamadas de telefonia dentro da área de registro -->
        <!-- Chamadas locais -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/OUTGOING/LOCAL/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'LC - DENTRO CHAMADA LOCAL'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>

        <!-- Chamadas longa distância -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/OUTGOING/LONG_DISTANCE/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'LD - DENTRO LONGA DISTANCIA'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>

        <!-- Chamadas locais recebidas a cobrar -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/INCOMING/COLLECT/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'RC - DENTRO CHAMADA RECEBIDA A COBRAR'"/>
            <xsl:with-param name="cobrar"               select="'4'"/>
            <xsl:with-param name="entrante"             select="'S'"/>
        </xsl:call-template>

        <!-- Chamadas locais recebidas -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/INCOMING/RECEIVED/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'RE - DENTRO CHAMADA RECEBIDA'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'S'"/>
        </xsl:call-template>

        <!-- Chamadas internacionais -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/OUTGOING/INTERNATIONAL/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'IN - DENTRO INTERNACIONAL'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>

        <!-- Chamadas 0300 -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/HOME/OUTGOING/Z300/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'D'"/>
            <xsl:with-param name="descrCategoria"       select="'Z3 - DENTRO SERVICO 0300'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>

        <!-- Chamadas de telefonia FORA da área de registro -->
        <!-- Chamadas Originadas -->
        <xsl:variable name="outgoingCalls">
            <xsl:for-each select="CALLS/ROAMING/OUTGOING/*[local-name()!='Z300']/descendant::CALL">
                <xsl:sort select="@MN" data-type="number"/>
                <xsl:sort select="@SN" data-type="number"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="outgoingCalls" select="xalan:nodeset($outgoingCalls)"/>
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="$outgoingCalls/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'F'"/>
            <xsl:with-param name="descrCategoria"       select="'LD - FORA CHAMADA LONGA DISTANCIA'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>
        <!-- Serviço 0300 -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/ROAMING/OUTGOING/Z300/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'F'"/>
            <xsl:with-param name="descrCategoria"       select="'Z3 - FORA SERVICO 0300'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'N'"/>
        </xsl:call-template>
        <!-- Chamadas recebidas -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/ROAMING/INCOMING/RECEIVED/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'F'"/>
            <xsl:with-param name="descrCategoria"       select="'RE - FORA CHAMADA RECEBIDA'"/>
            <xsl:with-param name="cobrar"               select="'1'"/>
            <xsl:with-param name="entrante"             select="'S'"/>
        </xsl:call-template>
        <!-- Chamadas recebidas em roaming a cobrar -->
        <xsl:call-template name="LINHA3">
            <xsl:with-param name="calls"                select="CALLS/ROAMING/INCOMING/COLLECT/descendant::CALL"/>
            <xsl:with-param name="categoria"            select="'F'"/>
            <xsl:with-param name="descrCategoria"       select="'RC - FORA CHAMADA RECEBIDA A COBRAR'"/> 
            <xsl:with-param name="cobrar"               select="'4'"/>
            <xsl:with-param name="entrante"             select="'S'"/>
        </xsl:call-template>

    </xsl:template>

    <!-- Template para imprimir as chamadas -->
    <xsl:template name="LINHA3">
        <xsl:param name="cobrar"/>
        <xsl:param name="categoria"/>
        <xsl:param name="calls"/>
        <xsl:param name="descrCategoria"/>
        <xsl:param name="entrante"/>

        <!-- Mostra cada chamada desse contrato -->
        <xsl:apply-templates select="$calls">
            <xsl:with-param name="cobrar"         select="$cobrar"/>
            <xsl:with-param name="categoria"      select="$categoria"/>
            <xsl:with-param name="descrCategoria" select="$descrCategoria"/>
            <xsl:with-param name="entrante" select="$entrante"/>
        </xsl:apply-templates>
        
    </xsl:template>

    <!-- ************************************************************************************************ -->
    <!-- * Decide se o dado a ser mostrado é de chamada ou de interconexão, mostrando-o apropriadamente * -->
    <!-- ************************************************************************************************ -->
    <xsl:template match="CALL">
        <xsl:param name="cobrar"/>
        <xsl:param name="categoria"/>
        <xsl:param name="calls"/>
        <xsl:param name="descrCategoria"/>
        <xsl:param name="entrante"/>
        <xsl:param name="key">3</xsl:param>


        <!-- Se for dado de chamada, mostre -->
        <xsl:if test="(@SN!='1') or (@SN='1' and @V!='0,00')">
            <!-- Atualiza o contador -->
            <xsl:variable name="null" select="string:setValue('contador', febraban:leftPad(febraban:getCounter(),12,string('0')))"/>
            <!-- linha 3 -->
            <xsl:value-of select="string:getValue('key')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- contador -->
            <xsl:value-of select="string:getValue('contador')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- data vencto -->
            <xsl:value-of select="string:getValue('vencto')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- data emissão -->
            <xsl:value-of select="string:getValue('emissao')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- id. único de recurso -->
            <xsl:value-of select="string:getValue('fleet')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- cnl do recurso -->
            <xsl:value-of select="string:getValue('cnl')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- ddd + número -->
            <xsl:value-of select="string:getValue('numero')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- característica do recurso -->
            <xsl:value-of select="string:getValue('rateplan')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- degrau do recurso -->
            <xsl:value-of select="string:getValue('degrau')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- data da ligação -->
            <xsl:value-of select="febraban:convertDateToAAAAMMDD(@DT)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- cnl da localidade chamada -->
            <xsl:value-of select="febraban:repeatChars(' ',5)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- Localidade da chamada -->
            <xsl:choose>
            <xsl:when test="$entrante='S'">
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@SC),25)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@DN),25)"/>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$delimiter"/>
            <!-- uf do telefone chamado -->
            <xsl:value-of select="febraban:repeatChars(' ',2)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- Código Nacional/Internacional -->
            <xsl:choose>
            <xsl:when test="starts-with($descrCategoria,'IN')">
                <xsl:value-of select="'00'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'0 '"/>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$delimiter"/>
            <!-- codigo + descrição da operadora -->
            <xsl:value-of select="febraban:repeatChars(' ',22)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- codigo país chamado -->
            <xsl:value-of select="febraban:repeatChars(' ',3)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- área/ddd -->
            <xsl:value-of select="febraban:repeatChars(' ',4)"/>
            <xsl:value-of select="$delimiter"/>

            <!-- número do tel. chamado -->
<!-- EHO: correção layout FEBRABAN (excl zero a esquerda do nro do telefone)       -->
<!--             <xsl:value-of select="febraban:rightPad(substring(@N,1,10),10)"/> -->
            <xsl:choose>
                <xsl:when test="(substring(@N,1,4)='0800') or (substring(@N,1,4)='0300') or (substring(@N,1,4)='0900') or (substring(@N,1,2)='00')"  >
                    <xsl:value-of select="febraban:rightPad(substring(@N,1,10),10)"/>
                    <xsl:value-of select="$delimiter"/>
                    <!-- conjugado do num. chamado -->
                    <xsl:variable name="tamanho" select="string-length(@N)"/> 
                    <xsl:choose>
                        <xsl:when test="$tamanho &gt; 10">
                            <xsl:value-of select="febraban:rightPad(substring(@N,11,$tamanho),2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="febraban:repeatChars(' ',2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="substring(@N,1,1)='0'">
                    <xsl:value-of select="febraban:rightPad(substring(@N,2,10),10) "/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="febraban:repeatChars(' ',2)"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="febraban:rightPad(substring(@N,1,10),10)"/>
                    <xsl:value-of select="$delimiter"/>
                    <!-- conjugado do num. chamado -->
                    <xsl:variable name="tamanho" select="string-length(@N)"/> 
                    <xsl:choose>
                        <xsl:when test="$tamanho &gt; 10">
                            <xsl:value-of select="febraban:rightPad(substring(@N,11,$tamanho),2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="febraban:repeatChars(' ',2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$delimiter"/>
            <!-- duração da chamada -->
            <xsl:variable name="tam" select="string-length(@DR_M)-1"/>
            
             <xsl:value-of select="febraban:leftPad(febraban:replaceChars(substring(@DR_M,1,$tam),',.',''),6,'0')"/>
            
            <xsl:value-of select="$delimiter"/>
            <!-- categoria -->
            <xsl:value-of select="$categoria"/>
            <xsl:value-of select="$delimiter"/>
            <!-- Análise da descrição de categoria -->
            <xsl:choose>
                <xsl:when test="@SN='1'">
                    <xsl:value-of select="febraban:rightPad(concat($descrCategoria,' INTERCONEXAO'),52)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="febraban:rightPad($descrCategoria,52)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$delimiter"/>
            <!-- horário da ligação -->
            <xsl:value-of select="febraban:replaceChars(@TM,'HM','')"/>
            <xsl:value-of select="$delimiter"/>
            <!-- tipo da chamada -->
            <xsl:value-of select="$cobrar"/>
            <xsl:value-of select="$delimiter"/>
            <!-- grupo horário tarifário -->
            <xsl:value-of select="'*'"/>
            <xsl:value-of select="$delimiter"/>
            <!-- descrição horário tarifário -->
            <xsl:value-of select="febraban:repeatChars(' ',25)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- degrau da ligação -->
            <xsl:value-of select="febraban:repeatChars('0',2)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- sinal valor da ligação -->
            <xsl:call-template name="SINAL-VALOR">
                <xsl:with-param name="valor">
                    <xsl:value-of select="@V"/>
                </xsl:with-param>
            </xsl:call-template>
            <!-- alíquota icms -->
            <xsl:value-of select="febraban:repeatChars('0',5)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- valor da ligação com impostos -->
            <xsl:call-template name="VALOR-SEMSINAL">
                <xsl:with-param name="valor">
                    <xsl:value-of select="@V"/>
                </xsl:with-param>
            </xsl:call-template>
            <!-- classe de serviço -->
            <xsl:value-of select="febraban:repeatChars('0',5)"/>
            <xsl:value-of select="$delimiter"/>
            <!-- filler -->
            <xsl:value-of select="febraban:repeatChars(' ',61)"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="PRINT-LINEFEED"/>
        </xsl:if>
    </xsl:template>

    <!-- Template para a linha 4 -->
    <xsl:template name="SERVICOS">
        <xsl:param name="key"/>
        <string:reset/>

        <xsl:call-template name="CHAVE">
            <xsl:with-param name="key" select="$key"/>
        </xsl:call-template>

        <!--Chama o template para cada serviço-->
        <xsl:call-template name="LINHA4">
            <xsl:with-param name="servicos"        select="CHARGES/CHG/descendant::SVC[not(starts-with(@V,'-'))]"/>
            <xsl:with-param name="dispatch"        select="DISPATCH/descendant::DISPP"/>
            <xsl:with-param name="torpedo"         select="SERVICES/TORPEDO"/>
            <xsl:with-param name="radio"           select="CHARGES/CHG/SVC[@ID='DISPP']"/>
        </xsl:call-template>

    </xsl:template>

    <!-- Template para imprimir os serviços -->
    <xsl:template name="LINHA4">
        <xsl:param name="servicos"/>
        <xsl:param name="dispatch"/>
        <xsl:param name="torpedo"/>
        <xsl:param name="radio"/>

        <xsl:apply-templates select="$servicos"/>
        <xsl:apply-templates select="$torpedo">
            <xsl:with-param name="radio" select="$radio[last()]"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="$dispatch">
            <xsl:with-param name="radio" select="$radio[last()]"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- template a aplicar -->
    <xsl:template match="SVC">
        <!-- Atualiza o contador -->
        <xsl:variable name="null" select="string:setValue('contador', febraban:leftPad(febraban:getCounter(),12,string('0')))"/>
        <!-- linha 4 -->
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
        <!-- id. único de recurso -->
        <xsl:value-of select="string:getValue('fleet')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- cnl do recurso -->
        <xsl:value-of select="string:getValue('cnl')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- ddd + número-->
        <xsl:value-of select="string:getValue('numero')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- característica do recurso -->
        <xsl:value-of select="string:getValue('rateplan')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data do serviço -->
        <xsl:variable name="anoServ" select="substring(/INVOICE/CUSTOMER/@D,7)"/>
        <xsl:variable name="mesVenc" select="substring(/INVOICE/CUSTOMER/@D,4,2)"/>
        <xsl:variable name="mesServ" select="substring(@E,4)"/>
        <xsl:choose>
            <xsl:when test="($mesServ = '12') and ($mesVenc = '01')">
                <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@E,'/',($anoServ - 1)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat(@E,'/', $anoServ ))"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- cnl da localidade -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- nome da localidade + uf do tel chamado + cod. nacional/int + cod. operadora + descrição operadora 
             + cod. país chamado + area/ddd + num. tel. chamado + conjugado do num. chamado -->
        <xsl:value-of select="febraban:repeatChars(' ',70)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- duração da ligação -->
        <xsl:value-of select="febraban:repeatChars('0',6)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- horário da ligação -->
        <xsl:value-of select="febraban:repeatChars(' ',6)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- grupo da categoria + descr. do grupo da categoria -->
        <xsl:choose>
            <xsl:when test="(@ID='DISPP' or @ID='TELAL' or @ID='ME')">
                <xsl:value-of select="'MEN'"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="febraban:rightPad('MENSALIDADE',30)"/>
                <xsl:value-of select="$delimiter"/>
            </xsl:when>
<!-- EHO: Mudança mms outras operadoras / AGBKP / ITAUA-->
                <xsl:when test="(@ID='CLIRB' or @ID='CIRDT' or @ID='NMSIM' or @ID='NMPLS' or @ID='NMBAS' or @ID='SMST' or @ID='WP' or @ID='TWM' or @ID='WPTWM' or @ID='N200K' or @ID='MDD3' or @ID='N1200' or @ID='N2200' or @ID='N4200' or @ID='N5200' or @ID='N2300' or @ID='N3300' or @ID='N4300' or @ID='N5300' or @ID='N1600' or @ID='N2600' or @ID='N3600' or @ID='N4600' or @ID='N5600' or @ID='N11MB' or @ID='N21MB' or @ID='N31MB' or @ID='N41MB' or @ID='N51MB' or @ID='N13MB' or @ID='N23MB' or @ID='N33MB' or @ID='N43MB' or @ID='N53MB' or @ID='N110M' or @ID='N210M' or @ID='N310M' or @ID='N410M' or @ID='N510M' or @ID='MDD1' or @ID='MDD2' or @ID='MDD4' or @ID='MDD4' or @ID='N1300' or @ID='EQON' or @ID='NOWAS' or @ID='LONEX' or @ID='AGBKP' or @ID='EQLOC' or @ID='ITAUW' or @ID='ITAUA' or @ID='E930' or @ID='TP' or @ID='DOWN' or @ID='DOWNS' or @ID='MMST' or @ID='DRin' or @ID='MMSI' or @ID='GPSDA')"> 

                <xsl:value-of select="'NON'"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="febraban:rightPad('NEXTEL ONLINE',30)"/>
                <xsl:value-of select="$delimiter"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'ADC'"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="febraban:rightPad('ADICIONAL',30)"/>
                <xsl:value-of select="$delimiter"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- categoria -->
        <xsl:choose>
            <xsl:when test="@ID='DISPP'">
                <xsl:value-of select="febraban:rightPad('ASS',3)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@ID),3)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- descrição da categoria -->
        <xsl:choose>
            <xsl:when test="@ID='DISPP'">
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@TR),40)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@DS),40)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal e valor da ligação -->
        <xsl:call-template name="VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="@V"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <!-- classe de serviço -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',74)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>

    <!-- template a aplicar -->
    <xsl:template match="DISPP|TORPEDO|DOWNLOADS">
        <xsl:param name="radio"/>
        <!-- Atualiza o contador -->
        <xsl:variable name="null" select="string:setValue('contador', febraban:leftPad(febraban:getCounter(),12,string('0')))"/>
        <!-- linha 4 -->
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
        <!-- id. único de recurso -->
        <xsl:value-of select="string:getValue('fleet')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- cnl do recurso -->
        <xsl:value-of select="string:getValue('cnl')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- ddd + número -->
        <xsl:value-of select="string:getValue('numero')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- característica do recurso -->
        <xsl:value-of select="string:getValue('rateplan')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- data do serviço -->
        <xsl:variable name="anoServ" select="substring(/INVOICE/CUSTOMER/@D,7)"/>
        <xsl:variable name="mesVenc" select="substring(/INVOICE/CUSTOMER/@D,4,2)"/>
        <xsl:variable name="mesServ" select="substring($radio/@E,4)"/>
        <xsl:choose>
            <xsl:when test="($mesServ = '12') and ($mesVenc = '01')">
                <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat($radio/@E,'/',($anoServ - 1)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:convertDateToAAAAMMDD(concat($radio/@E,'/', $anoServ ))"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- cnl da localidade -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- nome da localidade + uf do tel chamado + cod. nacional/int + cod. operadora + descrição operadora 
             + cod. país chamado + area/ddd + num. tel. chamado + conjugado do num. chamado -->
        <xsl:value-of select="febraban:repeatChars(' ',70)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- duração da ligação -->
        <!-- xsl:value-of select="febraban:repeatChars('0',6)"/ -->
        <!-- Campo duração da ligação : minutos utilizados. -->
        <xsl:choose>
            <xsl:when test="name()='DISPP'">
                <xsl:value-of select="febraban:leftPad(round(number(febraban:replaceChars(@DR_M,',.','.'))),6,'0')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:leftPad(round(number(febraban:replaceChars(@Q_M,',.','.'))),6,'0')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- horário da ligação -->
        <!-- Campo horário da ligação : minutos a cobrar. -->
        <xsl:choose>
            <xsl:when test="name()='DISPP'">
                <xsl:value-of select="febraban:leftPad(round(number(febraban:replaceChars(@CH_M,',.','.'))),6,'0')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:repeatChars(' ',6)"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:value-of select="$delimiter"/>
        <!-- grupo da categoria + descrição do grupo da categoria -->
        <xsl:choose>
        <xsl:when test="name()='DISPP'">
            <xsl:value-of select="'CDN'"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="febraban:rightPad('CONEXAO DIRETA NEXTEL',30)"/>
            <xsl:value-of select="$delimiter"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="'NON'"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="febraban:rightPad('NEXTEL ONLINE',30)"/>
            <xsl:value-of select="$delimiter"/>
        </xsl:otherwise>
        </xsl:choose>
        <!-- categoria -->
        <xsl:choose>
            <xsl:when test="name()='DISPP'">
                <xsl:value-of select="febraban:rightPad('DIS',3)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="febraban:rightPad(@ID,3)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <!-- descrição do grupo da categoria -->
        <xsl:value-of select="febraban:rightPad(febraban:convertAccents(@DS),40)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- sinal e valor da ligação -->
        <xsl:call-template name="VALOR">
            <xsl:with-param name="valor">
                <xsl:value-of select="@V"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- classe de serviço -->
        <xsl:value-of select="febraban:repeatChars('0',5)"/>
        <xsl:value-of select="$delimiter"/>
        <!-- filler -->
        <xsl:value-of select="febraban:repeatChars(' ',74)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>
<!-- conf/febraban/nextel_fatura_detalhe_conta.xsl -->  
</xsl:stylesheet>
