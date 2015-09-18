<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                exclude-result-prefixes="xalan barcode"
                version="1.0">

    <xsl:output method="xml" version="1.0" encoding="ISO-8859-1" omit-xml-declaration="no" indent="no" media-type="text/html"/>

    <xsl:template match="BILL">

        <xsl:if test="(count(SERVICES/FIRST) &gt; 0) or (count(TELECOM/FIRST) &gt; 0)">
            <fo:layout-master-set>
                <fo:simple-page-master margin-right="11.2mm" margin-left="11.2mm" margin-bottom="11.2mm" margin-top="11.2mm" page-width="21cm" page-height="29.7cm" master-name="A4-boleto">
                    <fo:region-body margin-bottom="0mm" margin-top="0mm"/>
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="boleto">
                    <fo:single-page-master-reference master-reference="A4-boleto"/>
                </fo:page-sequence-master>
            </fo:layout-master-set>

            <xsl:if test="count(SERVICES/FIRST) &gt; 0">
                <!-- If we have services -->
                <fo:page-sequence initial-page-number="1" master-reference="boleto">
                    <fo:flow flow-name="xsl-region-body">
                        <xsl:apply-templates select="SERVICES" mode="SECOND">
                            <xsl:with-param name="footer_text">
                                Ficha de Compensação
                            </xsl:with-param>
                        </xsl:apply-templates>
                        <fo:block space-before="5mm" space-after="2mm" font-size="0pt" text-align-last="justify">
                            <fo:leader leader-pattern="rule" rule-style="dashed"/>
                        </fo:block>
                        <xsl:apply-templates select="SERVICES" mode="SECOND">
                            <xsl:with-param name="header_text">
                                RECIBO DO SACADO
                            </xsl:with-param>
                            <xsl:with-param name="show_bar_code">
                                false
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:if>


            <xsl:if test="count(TELECOM/FIRST) &gt; 0">
                <!-- If we have telecom -->
                <fo:page-sequence initial-page-number="1" master-reference="boleto">
                    <fo:flow flow-name="xsl-region-body">
                        
                        <fo:block text-align="left" font-weight="bold" font-style="italic" font-size="10pt" space-after="5mm">
                            <!-- xsl:if test="/INVOICE/CUSTOMER/@SR = 'Y'">
                                 Via Adicional de Nota Fiscal - Válida Somente para Pagamento
                             < /xsl:if --> 
                        </fo:block>

                        <xsl:apply-templates select="TELECOM" mode="SECOND">
                            <xsl:with-param name="footer_text">
                                Ficha de Compensação
                            </xsl:with-param>
                        </xsl:apply-templates>
                        <fo:block space-before="5mm" space-after="2mm" font-size="0pt" text-align-last="justify">
                            <fo:leader leader-pattern="rule" rule-style="dashed"/>
                        </fo:block>
                        <xsl:choose>
                            <!-- xsl:when test="/INVOICE/CUSTOMER/@ST = 'SP' or /INVOICE/CUSTOMER/@ST = 'RJ'" -->
                            <xsl:when test="/INVOICE/CUSTOMER/@SR = 'Y'">
                                <xsl:apply-templates select="TELECOM" mode="FIRST"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="TELECOM" mode="SECOND">
                                    <xsl:with-param name="header_text">
                                        RECIBO DO SACADO
                                    </xsl:with-param>
                                    <xsl:with-param name="show_bar_code">
                                        false
                                    </xsl:with-param>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- Nota Fiscal -->
    <xsl:template match="TELECOM|SERVICES" mode="FIRST">
        <!-- Bill of Sale Header -->
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="9.14cm"/>
            <fo:table-column column-width="9.46cm"/>
            <fo:table-body border-bottom-style="solid" border-top-style="solid" border-left-style="solid"
                border-left-width="1mm">
                <fo:table-row start-indent="2mm">
                    <fo:table-cell>
                        <fo:block space-after="1mm" space-before="1mm">
                            <fo:external-graphic height="1cm" src="conf/pdf/nextelNew.jpg"/>
                        </fo:block>
                        <fo:block text-align="left" font-size="4pt" font-family="Helvetica" font-weight="bold"
                                  space-after="2mm">
                            www.nextel.com.br
                        </fo:block>

                        <!-- SP address -->
                        <!-- Sendo de SP e não sendo do mercado 6 - Curitiba -->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                Grande São Paulo: 4004-6611 - Outras Localidades: 0800 90 50 40 - Fax: 11 4004-1201 
                                <!-- Grande São Paulo: 3748-1212 - Outras Localidades: 0800 90 50 40 - Fax:113748-1252 -->
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                <!-- Av. Maria Coelho Aguiar, 215 - Bloco D - 6º Andar - Cj.A -->
                                Al. Santos, 2356 e 2364
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                <!-- Jd. São Luis - São Paulo - SP - CEP 05805-000 -->
                                Cerqueira César São Paulo - SP - CEP 01418-200
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0001-67 - Inscr.Estadual: 114.166.101.115
                            </fo:block>
                        </xsl:if>

                        <!-- RJ address -->
                        <!-- Sendo do RJ e não sendo do mercado 4 - Belo Horizonte -->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">

                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                0800 90 50 40 - FAX: (0XX11)3748-1252
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Av. Pres. Vargas, 3.131 - 11º andar - sl. 1102 - parte
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Cidade Nova - Rio de Janeiro - RJ - CEP 20210-030
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0011-39 - Inscr.Estadual: 85.727.028
                            </fo:block>
                        </xsl:if>
                        
                        <!-- MG address -->
                        <!-- Sendo mercado 4 - Belo Horizonte e mercado 25 - Uberlandia-->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                        
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                Tel. (0XX31)3228-1400 - Fax: (0XX31)3228-1470
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Rua Inconfidentes, 1180
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Bairro Funcionários - Belo Horizonte - MG - CEP 30140-120 
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0021-00 - Inscr.Estadual: 062.956.363.0199
                            </fo:block>
                        </xsl:if>
                        <!-- SC address -->
                        <!-- Sendo mercados 13, 22 e 23 - Santa Catarina -->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                               Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Rua Souza França, 52 - Centro
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Florianópolis - SC - CEP 88.015-480
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0039-30 - Inscr.Estadual: 254.971.750
                            </fo:block>
                        </xsl:if>
                        <!-- BSB address -->
                        <!-- Sendo do mercado 3 - Brasília -->
                        <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">                        
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                               Central de Atendimento: *611 (ligue grátis do seu celular)
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                SBN Norte Quadra 01 - Bl. B nº 14 - 13º / 14º Andares                       
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CEP: 70040-010 - Asa Norte - Brasília - DF 
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0018-05 - CF/DF: 07.404.653/002-20
                            </fo:block>
                        </xsl:if>

                        <!-- PR address -->
                        <!-- Sendo de SP e sendo do mercado 6 - Curitiba -->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                         
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                Fone: (0XX41)3025-8000 - Fax: (0XX41)3025-8238
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Rua Augusto Stresser, 453
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Alto da Glória - Curitiba - PR - CEP 80030-340
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0017-24 - Inscr.Estadual: 90.194.059-20
                            </fo:block>
                        </xsl:if>

                        <!-- GO address -->
                        <!-- Sendo de SP e sendo do mercado 21 - Goiania -->
                        <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611                                
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Av.República do Líbano, 1770 - Qd.E-2 Lt.29
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Setor Oeste - Goiânia - GO - CEP 74115-030
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0019-96 - Inscr.Estadual: 10.332.587-5
                            </fo:block>
                        </xsl:if>
                        
                        <!-- BA address -->                        <!-- Sendo do mercado 19 - Salvador -->                        <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                                                    <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">                                Central de Atendimento ao Cliente: *611 (ligue grátis do seu Nextel) ou (11)4004-6611                                                            </fo:block>                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">                                Nextel Telecomunicações Ltda                            </fo:block>                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">                                Av.Antonio Carlos Magalhães, 3213 - salas 1107 a 1110 - Brotas                            </fo:block>                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">                                Salvador - Bahia - CEP 40280-000                            </fo:block>                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">                                C.N.P.J.: 66.970.229/0040-73 - Inscr.Est.: 51.338.686 NO - Inscr.Municipal: 157.942/001-78                            </fo:block>                        </xsl:if>
                        
                        <!-- PE address -->
                        <!-- Sendo do mercado 17 - Recife -->
                        <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">                        
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
								Central de Atendimento ao Cliente: *611 (Ligue Grátis do seu Nextel) ou 4004-6611                            
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                NEXTEL Telecomunicações Ltda.
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                            	Rua Agenor Lopes, 277 - sala 302
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                            	51021-110 - Boa Viagem - Recife - PE
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
								C.N.P.J.: 66.970.229/0009-14 - Inscr. Estadual: 181.001.0261944-5                            
                            </fo:block>
                        </xsl:if>                        

                        <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                        <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" text-decoration="underline">
                                Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611                                
                            </fo:block>
                            <fo:block text-align="left" font-size="5pt" font-family="Helvetica" font-weight="bold">
                                Nextel Telecomunicações Ltda
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Avenida Carlos Gomes, 413 - Auxiliadora
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                Porto Alegre - RS - CEP 90480-000
                            </fo:block>
                            <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                                CNPJ 66.970.229/0006-71 - Inscr.Estadual: 096/2755109
                            </fo:block>
                        </xsl:if>

                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="left" font-size="7pt" font-family="Helvetica" font-weight="bold"
                            space-before="3mm" space-after="3mm">
                            NOTA FISCAL FATURA DE TELECOMUNICAÇÕES
                        </fo:block>
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold"
                            space-after="3mm">
                            <fo:block>SERVIÇO MÓVEL ESPECIALIZADO REGIME ESPECIAL</fo:block>
                            <fo:block>
                                <!-- Special Rule -->
                                <!-- Sendo de SP e não sendo do mercado 6 - Curitiba -->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1')">
                                    PROCESSO SF5-258118/99 de 04/04/2001 DEAT/ARE
                                </xsl:if>
                                <!-- RJ Special Rule -->
                                <!-- Sendo do RJ e não sendo do mercado 4 - Belo Horizonte -->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
                                    PROCESSO nº E-04/346.630/99 de 12/07/99
                                </xsl:if>
                                <!-- MG Special Rule -->
                                <!-- Sendo do mercado 4 - Belo Horizonte e 25 - Uberlandia-->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                                
                                    PROCESSO PTA nº 16.58152.20 de 29/07/2002
                                </xsl:if>
                                <!-- SC Special Rule -->
                                <!-- Sendo do SC - Santa Catarina -->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">
                                    PROCESSO n° GR01 7279/051 de 15/09/2005
                                </xsl:if>                                
                                <!-- BSB Special Rule -->
                                <!-- Sendo do mercado 3 - Brasília -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">
                                    ATO DECLARATÓRIO Nº 009/2004 - NUESP/GEESP/DITRI/SUREC/SEF
                                </xsl:if>
                                <!-- PR Special Rule -->
                                <!-- Sendo de SP e sendo do mercado 6 - Curitiba -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '11'">                        
                                    PROCESSO nº 2643/01 de 05/11/2001
                                </xsl:if>
                                <!-- GO Special Rule -->
                                <!-- Sendo de SP e sendo do mercado 21 - Goiania -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
                                    TARE nº 235/05-GSF de 29/11/2005
                                </xsl:if>                                                                
                                <!-- BA Special Rule -->                                
                                <!-- Sendo do mercado 19 - Salvador -->                                
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                                    
                                    PROCESSO nº 16958920054 de 21/12/2005                                
                                </xsl:if>                                                                
                                <!-- PE Special Rule -->
                                <!-- Sendo do mercado 17 - Recife -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">
									PROCESSO Nº 9.2005.09.147338.2                                
                                </xsl:if>
                                <!-- RS Special Rule -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
                                    ATO DECLARATÓRIO DRP Nº 2007/061
                                </xsl:if>                                
                                
                            </fo:block>

                           <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
                               <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold" space-after="3mm">
                                  "DISPENSADO DE AIDF CONFORME DECRETO LEI 4852 ART. 123 INCISO II LETRA C"
                               </fo:block>
                           </xsl:if>

                        </fo:block>
                        <fo:block text-align="left" font-size="5.5pt" font-family="Helvetica" space-after="3mm">
                            <fo:table table-layout="fixed">
                                <fo:table-column column-width="6cm"/>
                                <fo:table-column column-width="2cm"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell number-columns-spanned="2">
                                            <fo:block>NOTA FISCAL Nº
                                            <xsl:if test="SIXTH/@HC">
                                                <xsl:value-of select="FOURTH/@NN"/>
                                            </xsl:if>
                                            <xsl:if test="not(SIXTH/@HC)">
                                                <xsl:value-of select="THIRD/@NN"/>
                                            </xsl:if>
                                        </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell number-columns-spanned="2">
                                            <fo:block>DATA DE EMISSÃO: <xsl:value-of select="THIRD/@DE"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block>DATA DE VENCIMENTO: <xsl:value-of select="THIRD/@DV"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block>SÉRIE: <xsl:value-of select="THIRD/@S"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Customer data -->
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="12.85cm"/>
            <fo:table-column column-width="0.5cm"/>
            <fo:table-column column-width="5.25cm"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold">
                            <fo:block space-after="2mm" space-before="2mm">
                                <xsl:value-of select="THIRD/@NC"/>
                            </fo:block>
                            <fo:block>
                                ENDEREÇO: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@EC"/></fo:inline>
                            </fo:block>
                            <fo:block>
                                CEP: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@CEP"/></fo:inline>
                                MUNICÍPIO: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@C"/></fo:inline>
                                UF: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@UFC"/></fo:inline>
                            </fo:block>
                            <fo:block>
                                C.N.P.J/C.P.F.: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@CGCC"/></fo:inline>
                                INSCR. ESTADUAL: 
                                <fo:inline font-weight="normal"><xsl:value-of select="THIRD/@IEC"/></fo:inline>
                            </fo:block>
                            <fo:block space-after="2mm">
                                CLASSE DO USUÁRIO: 
                                <fo:inline font-weight="normal">NÃO RESIDENCIAL</fo:inline>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>

                    <fo:table-cell>
                    </fo:table-cell>

                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica"
                            space-before="2mm" start-indent="8mm">
                            <fo:block>PEDIDO:</fo:block>
                            <fo:block>CLIENTE:  <xsl:value-of select="THIRD/@PV"/>
                            <!-- <xsl:value-of select="THIRD/@CC"/> --></fo:block>
                            <fo:block>LEITURA DE: <xsl:value-of select="THIRD/@DIP"/></fo:block>
                            <fo:block>ATÉ: <xsl:value-of select="THIRD/@DFP"/></fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Devido à variação de alíquota de acordo com a data -->
        <xsl:variable name="date" select="concat(substring(FIRST/@DP,7),substring(FIRST/@DP,4,2),substring(FIRST/@DP,1,2))"/>
        <xsl:variable name="dateFIX" select="20040110"/>

        <!-- Description -->
        <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold">
            ASSINATURA MENSAL / SERVIÇOS MEDIDOS / AJUSTES
            <fo:table table-layout="fixed" height="4.6cm" border-top-style="solid" 
                border-left-style="solid" border-left-width="1mm" space-before="1mm">
                <fo:table-column column-width="5cm"/>
                <fo:table-column column-width="1.7cm"/>
                <fo:table-column column-width="9.3cm"/>
                <fo:table-column column-width="2.6cm"/>
                <fo:table-body>
                    <fo:table-row start-indent="2mm">
                        <fo:table-cell display-align="center">
                            <fo:block text-align="left">DESCRIÇÃO</fo:block>
                        </fo:table-cell>
                        <xsl:if test="number($date) &gt;= number($dateFIX)">
                            <fo:table-cell display-align="center">
                                <fo:block text-align="right">* ALÍQUOTA</fo:block>
                            </fo:table-cell>
                        </xsl:if>
                        <xsl:if test="number($date) &lt; number($dateFIX)">
                            <fo:table-cell display-align="center">
                                <fo:block text-align="right"></fo:block>
                            </fo:table-cell>
                        </xsl:if>
                        <fo:table-cell display-align="center">
                            <fo:block text-align="right"></fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block text-align="right">VALOR TOTAL R$:</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:for-each select="FOURTH">
                        <fo:table-row start-indent="3mm">
                            <fo:table-cell>
                                <fo:block><xsl:value-of select="@DI"/></fo:block>
                            </fo:table-cell>
                            <xsl:if test="number($date) &gt;= number($dateFIX)">
                                <fo:table-cell>
                                    <fo:block text-align="right">
                                        <xsl:if test="not(AII/@DEC = '')">
                                            <xsl:value-of select="AII/@INT"/>,<xsl:value-of select="AII/@DEC"/> %
                                        </xsl:if>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:if>
                            <xsl:if test="number($date) &lt; number($dateFIX)">
                                <fo:table-cell>
                                    <fo:block text-align="right"></fo:block>
                                </fo:table-cell>
                            </xsl:if>
                            <fo:table-cell>
                                <fo:block></fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="right">
                                    <xsl:value-of select="VTI/@INT"/>,<xsl:value-of select="VTI/@DEC"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>

            <!-- Hash Code -->
            <fo:table table-layout="fixed"  border-bottom-style="solid" keep-with-previous="always"
                border-left-style="solid" border-left-width="1mm" space-after="3mm">
                <fo:table-column column-width="4cm"/>
                <fo:table-column column-width="14.6cm"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell display-align="center">
                            <fo:block text-align="left" font-size="6pt" font-family="Helvetica" 
                                font-weight="bold" start-indent="2mm">
                                Reservado ao Fisco:
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="left" font-size="11pt" font-family="Courier" 
                                font-weight="bold" space-after="2mm" start-indent="2mm">
                                <xsl:value-of select="SIXTH/@HC"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>

        <!-- Taxes -->
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="4.4cm"/>
            <fo:table-column column-width="0.4cm"/>
            <fo:table-column column-width="3.84cm"/>
            <fo:table-column column-width="0.4cm"/>
            <fo:table-column column-width="3.84cm"/>
            <fo:table-column column-width="0.4cm"/>
            <fo:table-column column-width="5.32cm"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica">
                            BASE DE CALCULO ICMS R$
                            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
                                <xsl:value-of select="THIRD/BCICMS/@INT"/>,<xsl:value-of select="THIRD/BCICMS/@DEC"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>

                    <fo:table-cell>
                    </fo:table-cell>

                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica">
                            ALIQUOTA ICMS
                            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
                                <xsl:if test="number($date) &gt;= number($dateFIX)">
                                    Vide *
                                 </xsl:if>
                                <xsl:if test="number($date) &lt; number($dateFIX)">
                                    <xsl:value-of select="THIRD/AICMS/@INT"/>,<xsl:value-of select="THIRD/AICMS/@DEC"/>
                                </xsl:if>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                    
                    <fo:table-cell>
                    </fo:table-cell>

                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica">
                            VALOR ICMS R$
                            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
                                <xsl:value-of select="THIRD/VICMS/@INT"/>,<xsl:value-of select="THIRD/VICMS/@DEC"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>

                    <fo:table-cell>
                    </fo:table-cell>

                    <fo:table-cell border-bottom-style="solid" border-top-style="solid" border-right-style="solid"
                        border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica">
                            VALOR TOTAL DA NOTA FISCAL
                            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
                                <xsl:value-of select="THIRD/VTN/@INT"/>,<xsl:value-of select="THIRD/VTN/@DEC"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>

                    <fo:table-cell>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Observations -->
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="18.6cm"/>
            <fo:table-body border-bottom-style="solid" border-top-style="solid" border-left-style="solid"
                border-left-width="1mm">
                <fo:table-row>
                    <fo:table-cell display-align="center">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica" 
                            font-weight="bold" space-after="2mm">
                            <fo:block space-after="2mm" start-indent="2mm">OBSERVAÇÕES:</fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@OB1"/>
                            </fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@OB2"/>
                            </fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@OB3"/>
                            </fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@OB4"/>
                            </fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <!-- Sendo de SP e não sendo do mercado 6 - Curitiba -->
                                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '21') or (/INVOICE/CUSTOMER/@CID = '1')">
                                    2ª via emitida, conforme Art. 6º, nos termos do Regime Especial. Não gera crédito de ICMS.
                                </xsl:if>
                                <!-- Sendo do RJ e sendo do mercado 4 - Belo Horizonte -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '4'">
                                    Via adicional, com todos os efeitos da via original, emitida, conforme Seção IV, Art. 8º, inciso I, nos termos do Regime Especial. 
                                </xsl:if>
                                <!-- Sendo de SP e sendo do mercado 6 - Curitiba -->
                                <xsl:if test="/INVOICE/CUSTOMER/@CID = '11'">                        
                                    Cópia da 1ª via, conforme cláusula Quinta, nos termos do Regime Especial. Não gera direito a crédito.
                                </xsl:if>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Messages -->
        <fo:table table-layout="fixed" space-before="1mm" space-after="1mm">
            <fo:table-column column-width="10.77cm"/>
            <fo:table-column column-width="7.83cm"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell display-align="center" border-bottom-style="solid" border-top-style="solid" 
                        border-right-style="solid" border-right-width="1mm">
                        <fo:block text-align="left" font-size="6pt" font-family="Helvetica" 
                            font-weight="bold" space-after="2mm">
                            <fo:block space-after="2mm" start-indent="2mm">MENSAGENS:</fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@M1"/>
                            </fo:block>
                            <fo:block start-indent="3mm" font-weight="normal">
                                <xsl:value-of select="THIRD/@M2"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell display-align="center">
                        <fo:block start-indent="2mm" text-align="center" font-size="27pt" 
                            font-family="Helvetica" font-weight="bold">
                            2a VIA
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- Boleto -->
    <xsl:template match="TELECOM|SERVICES" mode="SECOND">
        <xsl:param name="header_text">
            <xsl:value-of select="SECOND/@LD"/>
        </xsl:param>
        <xsl:param name="show_bar_code">true</xsl:param>
        <xsl:param name="footer_text"/>
        <fo:table table-layout="fixed">
            <fo:table-column column-width="14cm"/>
            <fo:table-column column-width="4.6cm"/>
            <fo:table-body>
                <!-- First line: Bank info and bar code number -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="2">
                        <fo:table table-layout="fixed">
                            <fo:table-column column-width="35.5mm"/>
                            <fo:table-column column-width="16.0mm"/>
                            <fo:table-column column-width="134.0mm"/>
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell display-align="center" border-bottom-style="solid">
                                        <fo:block start-indent="2mm" text-align="left" 
                                            font-weight="bold" font-size="9pt" font-family="Courier">
                                            <xsl:value-of select="FIRST/@NB"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell display-align="center" border-right-style="solid" 
                                        border-left-style="solid" border-bottom-style="solid">
                                        <fo:block text-align="center" 
                                            font-weight="bold" font-size="11pt" font-family="Courier">
                                            <xsl:value-of select="FIRST/@CB"/>-<xsl:value-of select="substring(FIRST/@CBDV, 4, 1)"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell display-align="center" border-bottom-style="solid">
                                        <fo:block text-align="right" 
                                            font-weight="bold" font-size="11pt" font-family="Courier">
                                            <!-- xsl:value-of select="barcode:buildFieldLine(SECOND/@CBB)"/ -->
                                            <xsl:value-of select="$header_text"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Second row -->
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                        <fo:block start-indent="1mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            Local de Pagamento
                        </fo:block>
                        <fo:block start-indent="1mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                            <fo:block><xsl:value-of select="FIRST/@LP1"/></fo:block>
                            <fo:block><xsl:value-of select="FIRST/@LP2"/></fo:block>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" font-size="5.5pt" font-family="Helvetica">
                            Vencimento
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" font-size="6.5pt" font-family="Helvetica">
                            <xsl:value-of select="SECOND/@DV"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Third row -->
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                        <fo:block start-indent="1mm" text-align="left" font-size="5.5pt" font-family="Helvetica">
                            Cedente/Sacador
                        </fo:block>
                        <fo:block start-indent="1mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                            <xsl:value-of select="FIRST/@RSE"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" font-size="5.5pt" font-family="Helvetica">
                            Agência Código Cedente
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-size="6.5pt" font-family="Helvetica">
                            <xsl:value-of select="FIRST/@AC"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Fourth row -->
                <fo:table-row>
                    <fo:table-cell>
                        <fo:table table-layout="fixed">
                            <fo:table-column column-width="3.5cm"/>
                            <fo:table-column column-width="3.84cm"/>
                            <fo:table-column column-width="1.63cm"/>
                            <fo:table-column column-width="1.63cm"/>
                            <fo:table-column column-width="3.4cm"/>
                            <fo:table-body>

                                <fo:table-row height="0.6cm">
                                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Data do Documento
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="FIRST/@DP"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Nº do Documento
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="SECOND/@ND"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Esp.Doc.
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="SECOND/@CED"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Aceite
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Data do Movimento
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="SECOND/@DE"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            Nosso Número
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-size="6.5pt" font-family="Helvetica">
                            <xsl:value-of select="SECOND/@NN"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Fifth row -->
                <fo:table-row>
                    <fo:table-cell>
                        <fo:table table-layout="fixed">
                            <fo:table-column column-width="3.5cm"/>
                            <fo:table-column column-width="2.66cm"/>
                            <fo:table-column column-width="1.76cm"/>
                            <fo:table-column column-width="3.64cm"/>
                            <fo:table-column column-width="2.44cm"/>
                            <fo:table-body>
                                <fo:table-row height="0.6cm">
                                    <fo:table-cell  border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Uso do Banco
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                            <!-- xsl:value-of select="FIRST/@DP"/ -->
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell  border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Carteira
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="FIRST/@C"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell  border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Espécie
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                            <xsl:value-of select="FIRST/@DM"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell  border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Quantidade
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell  border-right-style="solid" border-bottom-style="solid">
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Valor
                                        </fo:block>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (=) Valor do Documento
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                            <xsl:value-of select="SECOND/VO/@INT"/>,<xsl:value-of select="SECOND/VO/@DEC"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Sixth row -->
                <fo:table-row>
                    <!-- Left side -->
                    <fo:table-cell number-rows-spanned="6" border-bottom-style="solid" border-right-style="solid">
                        <fo:table table-layout="fixed">
                            <fo:table-column column-width="13cm"/>
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block start-indent="1mm" text-align="left" 
                                            font-size="5.5pt" font-family="Helvetica">
                                            Instruções (todas as informações deste bloqueto são de exclusiva responsabilidade do Cedente)
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row height="2.5cm">
                                    <fo:table-cell display-align="center">
                                        <fo:block start-indent="2mm" text-align="left" 
                                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
<!-- EHO: abatimento e desconto - (mensagem IB3)-->        
                                            <fo:block><xsl:value-of select="FIRST/@IB1"/></fo:block>
                                            <fo:block><xsl:value-of select="FIRST/@IB2"/></fo:block>
                                            <fo:block><xsl:value-of select="FIRST/@IB3"/></fo:block>
                                            <fo:block><xsl:value-of select="SECOND/@IB1"/></fo:block>
                                            <fo:block><xsl:value-of select="SECOND/@IB2"/></fo:block>
                                            <fo:block><xsl:value-of select="SECOND/@IB3"/></fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Right side -->
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (-) Desconto/Abatimento
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (-) Outras Deduções
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (+) Mora/Multa
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (+) Outros Acréscimos
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row height="0.6cm">
                    <fo:table-cell border-bottom-style="solid">
                        <fo:block start-indent="3mm" text-align="left" 
                            font-size="5.5pt" font-family="Helvetica">
                            (=) Valor Cobrado
                        </fo:block>
                        <fo:block start-indent="8mm" text-align="left" 
                            font-weight="bold" font-size="6.5pt" font-family="Helvetica">
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Seventh row -->
        <fo:block text-align="left" font-size="5.5pt" font-family="Helvetica">
            Sacado
        </fo:block>
        <fo:block start-indent="12mm" text-align="left" font-weight="bold" font-size="6.5pt" font-family="Helvetica">
            <fo:block><xsl:value-of select="SECOND/@NE"/></fo:block>
            <fo:block><xsl:value-of select="SECOND/@E"/></fo:block>
            <fo:block>
                <xsl:value-of select="SECOND/@CEP"/> - 
                <xsl:value-of select="SECOND/@CI"/> - 
                <xsl:value-of select="SECOND/@ES"/>
            </fo:block>
        </fo:block>

        <!-- Eighth row: Bar code -->
        <fo:block text-align="left" font-size="5.5pt" font-family="Helvetica">
            Sacador/Avalista
        </fo:block>
        <fo:block text-align="left" font-size="5.5pt" font-family="Helvetica" border-top-style="solid">
            <fo:table table-layout="fixed" height="13mm">
                <fo:table-column column-width="13.6cm"/>
                <fo:table-column column-width="5cm"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <!-- xsl:value-of select="SECOND/@CBB"/ -->
                            <xsl:if test="$show_bar_code = 'true'">
                                <fo:block>
                                    <xsl:for-each select="barcode:drawBarCode(SECOND/@CBB)/bar">
                                        <xsl:if test="@color = '0' and @width = '0'">
                                            <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/1.gif"/>
                                        </xsl:if>
                                        <xsl:if test="@color = '0' and @width = '1'">
                                            <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/1.gif"/>
                                        </xsl:if>
                                        <xsl:if test="@color = '1' and @width = '0'">
                                            <fo:external-graphic height="13mm" width="0.32mm" src="conf/pdf/2.gif"/>
                                        </xsl:if>
                                        <xsl:if test="@color = '1' and @width = '1'">
                                            <fo:external-graphic height="13mm" width="0.77mm" src="conf/pdf/2.gif"/>
                                        </xsl:if>
                                    </xsl:for-each>                                
                                </fo:block>
                            </xsl:if>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block start-indent="2mm" text-align="right" 
                                font-weight="bold" font-size="10pt" font-family="Helvetica">
                                <xsl:value-of select="$footer_text"/>
                            </fo:block>
                            <fo:block text-align="right" font-size="7pt" font-family="Helvetica">
                                Autenticação Mecânica
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
