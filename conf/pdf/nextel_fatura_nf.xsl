<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xalan" version="1.0">

  <xsl:variable name="location">
    <xsl:choose>
      <!-- 7,8,9,10,12,15,18,28 e 1- Mercados São Paulo -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or
                      (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or
                      (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or
                      (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or
                      (/INVOICE/CUSTOMER/@CID = '28')">
        <xsl:text>SP</xsl:text>
      </xsl:when>
      <!-- 4,5 e 6 - Mercados Rio de Janeiro -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or
                      (/INVOICE/CUSTOMER/@CID = '6')">
        <xsl:text>RJ</xsl:text>
      </xsl:when>
      <!-- 4 - Mercado Belo Horizonte e Mercado 25 - Uberlandia-->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">
        <xsl:text>MG</xsl:text>
      </xsl:when>
      <!-- 13, 22 e 23 - Mercado Santa Catarina -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '13') or
                      (/INVOICE/CUSTOMER/@CID = '22') or
                      (/INVOICE/CUSTOMER/@CID = '23')">
        <xsl:text>SC</xsl:text>
      </xsl:when>
      <!-- 3 - Mercado Brasília -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '3'">
        <xsl:text>BSB</xsl:text>
      </xsl:when>
      <!-- 11 e 27 - Mercado Curitiba -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">
        <xsl:text>PR</xsl:text>
      </xsl:when>
      <!-- 21 - Mercado Goiania -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '21'">
        <xsl:text>GO</xsl:text>
      </xsl:when>
      <!-- 19 - Mercado Salvador -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '19'">
        <xsl:text>BA</xsl:text>
      </xsl:when>
      <!-- 17 - Mercado Recife -->
      <xsl:when test="/INVOICE/CUSTOMER/@CID = '17'">
        <xsl:text>PE</xsl:text>
      </xsl:when>
      <!-- 16, 26 e 29 - Mercado Porto Alegre -->
<!-- EHO: Novo Mercado Caxias do Sul -->
      <xsl:when test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">
        <xsl:text>RS</xsl:text>
      </xsl:when>

    </xsl:choose>
  </xsl:variable>

  <xsl:template match="TELECOM">

    <xsl:if test="NF or BOLETO">

      <fo:page-sequence master-reference="nf"
                        force-page-count="no-force">

        <fo:flow flow-name="xsl-region-body">

          <!--
          <fo:block text-align="left" font-weight="bold" font-style="italic" font-size="10pt"
            space-after="5mm">
            <xsl:if test="/INVOICE/CUSTOMER/@SR = 'Y'">
              Via Adicional de Nota Fiscal - Válida Somente para Pagamento
            </xsl:if>
          </fo:block>
           -->

          <xsl:choose>
            <xsl:when test="/INVOICE/CUSTOMER/@SR = 'Y'">
              <xsl:apply-templates select="NF"/>
            </xsl:when>
          </xsl:choose>

          <!-- area em branco, reservada para o boleto -->
          <fo:block-container position="absolute"
                              top="23.5cm" bottom="27.5cm"
                              left="0cm" right="19cm">
            <fo:table table-layout="fixed" width="100%" text-align-last="justify" font-size="6pt" font-family="Helvetica">
              <fo:table-column column-width="proportional-column-width(1)"/>
              <fo:table-column column-width="proportional-column-width(1)"/>
              <fo:table-column column-width="proportional-column-width(1)"/>
			  <fo:table-column column-width="proportional-column-width(1)"/>
              <fo:table-body>
                <fo:table-row>
                	<fo:table-cell display-align="after" number-columns-spanned="4">
                    	<fo:block font-size="7pt" font-weight="bold">
                        	<xsl:text>
                        		AUTORIZAÇÃO DE DÉBITO AUTOMÁTICO EM CONTA CORRENTE
                        	</xsl:text>
                    	</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="4mm" number-columns-spanned="4">
                		<fo:block font-size="7pt">
                        	<xsl:text>
			                  "Autorizo que o pagamento da minha conta telefônica seja efetuada de acordo com os valores informados pela NEXTEL
				              através do serviço de débito automático em conta corrente no banco, agência e conta corrente por mim abaixo indicados.
				              Fico ciente de que qualquer alteração nos mesmos poderá implicar na descontinuidade do serviço de débito automático, cabendo
				              a mim realizar a solicitação de um novo cadastramento. No caso de insuficiência de saldo, estou ciente de que o débito ficará em aberto,
				              sendo da minha responsabilidade a sua quitação."
				            </xsl:text>
                    	</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="4mm" number-columns-spanned="3">
                		<fo:block>
                			<xsl:text>
                				Identificação de débito automático:&#32;
                			</xsl:text>
                			<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/@IDDA"/>
                		</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="1mm" number-columns-spanned="3">
                		<fo:block>
                			<xsl:text>
                				Nome do cliente:&#32;
                			</xsl:text>
                			<xsl:value-of select="/INVOICE/BILL/TELECOM/BOLETO_ARRECADACAO/@NC"/>
                		</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="1mm" number-columns-spanned="3">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Nome do correntista:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
             			</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				CPF/CNPJ:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                	<fo:table-cell padding-left="1mm" padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				RG:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                	<fo:table-cell padding-left="1mm" padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Orgão Emissor:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                </fo:table-row>
				<fo:table-row>
                	<fo:table-cell padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Banco:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                	<fo:table-cell padding-left="1mm" padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Agência:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                	<fo:table-cell padding-left="1mm" padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Conta corrente:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                	<fo:table-cell padding-top="1mm">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Local e Data:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                	<fo:table-cell padding-left="1mm" padding-top="1mm" number-columns-spanned="2">
                		<fo:block text-align-last="justify">
                			<xsl:text>
                				Assinatura do titular da conta corrente:&#32;
                			</xsl:text>
						 	<fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
                		</fo:block>
                	</fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
  </xsl:template>

  <!-- Nota Fiscal -->
  <xsl:template match="NF">
    <!-- Bill of Sale Header -->
    <fo:table table-layout="fixed" space-after="1mm">
      <fo:table-column column-width="9.14cm" />
      <fo:table-column column-width="9.46cm" />
      <fo:table-body border-bottom-style="solid" border-top-style="solid"
                     border-left-style="solid" border-left-width="1mm">
        <fo:table-row start-indent="2mm">
          <fo:table-cell>
            <fo:block space-after="1mm" space-before="1mm">
              <fo:external-graphic height="1cm" src="conf/pdf/nextelNew.jpg" />
            </fo:block>
            <fo:block text-align="left" font-size="4pt" font-family="Helvetica" font-weight="bold"
              space-after="2mm">
              <xsl:text>www.nextel.com.br</xsl:text>
            </fo:block>

            <xsl:choose>

            <!-- SP address -->
            <xsl:when test="$location = 'SP'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Grande São Paulo: 4004-6611 - Outras Localidades: 0800 90 50 40 - Fax: 11 4004-1201
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
                Nextel Telecomunicações Ltda
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                Al. Santos, 2356 e 2364
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                Cerqueira César São Paulo - SP - CEP 01418-200
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                CNPJ 66.970.229/0001-67 - Inscr.Estadual: 114.166.101.115
              </fo:block>
            </xsl:when>

            <!-- RJ address -->
            <xsl:when test="$location = 'RJ'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                0800 90 50 40 - FAX: (0XX11)3748-1252
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- MG address -->
            <xsl:when test="$location = 'MG'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Tel. (0XX31)3228-1400 - Fax: (0XX31)3228-1470
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- SC address -->
            <xsl:when test="$location = 'SC'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- BSB address -->
            <xsl:when test="$location = 'BSB'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento: *611 (ligue grátis do seu celular)
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- PR address -->
            <xsl:when test="$location = 'PR'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Fone: (0XX41)3025-8000 - Fax: (0XX41)3025-8238
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- GO address -->
            <xsl:when test="$location = 'GO'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- BA address -->
            <xsl:when test="$location = 'BA'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento ao Cliente: *611 (ligue grátis do seu Nextel) ou (11)4004-6611
                </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
                Nextel Telecomunicações Ltda
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                Av.Antonio Carlos Magalhães, 3213 - salas 1107 a 1110 - Brotas
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                Salvador - Bahia - CEP 40280-000
              </fo:block>
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica">
                C.N.P.J.: 66.970.229/0040-73 - Inscr.Est.: 51.338.686 NO - Inscr.Municipal: 157.942/001-78
              </fo:block>
            </xsl:when>

            <!-- PE address -->
            <xsl:when test="$location = 'PE'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento ao Cliente: *611 (Ligue Grátis do seu Nextel) ou 4004-6611
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            <!-- RS address -->
            <xsl:when test="$location = 'RS'">
              <fo:block text-align="left" font-size="4pt" font-family="Helvetica"
                text-decoration="underline">
                Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
              </fo:block>
              <fo:block text-align="left" font-size="5pt" font-family="Helvetica"
                font-weight="bold">
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
            </xsl:when>

            </xsl:choose>

          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="left" font-size="7pt" font-family="Helvetica" font-weight="bold"
              space-before="3mm" space-after="3mm">
              <xsl:text>NOTA FISCAL FATURA DE TELECOMUNICAÇÕES</xsl:text>
            </fo:block>
            <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold"
              space-after="3mm">
              <fo:block>SERVIÇO MÓVEL ESPECIALIZADO REGIME ESPECIAL</fo:block>
              <fo:block>
                <!-- Special Rule -->
                <xsl:choose>
                  <xsl:when test="$location = 'SP'">
                    PROCESSO SF5-258118/99 de 04/04/2001 DEAT/ARE
                  </xsl:when>
                  <xsl:when test="$location = 'RJ'">
                    PROCESSO nº E-04/346.630/99 de 12/07/99
                  </xsl:when>
                  <xsl:when test="$location = 'MG'">
                    PROCESSO PTA nº 16.58152.20 de 29/07/2002
                  </xsl:when>
                  <xsl:when test="$location = 'SC'">
                    PROCESSO n° GR01 7279/051 de 15/09/2005
                  </xsl:when>
                  <xsl:when test="$location = 'BSB'">
                    ATO DECLARATÓRIO Nº 009/2004 - NUESP/GEESP/DITRI/SUREC/SEF
                  </xsl:when>
                  <xsl:when test="$location = 'PR'">
                    PROCESSO nº 2643/01 de 05/11/2001
                  </xsl:when>
                  <xsl:when test="$location = 'GO'">
                    TARE nº 235/05-GSF de 29/11/2005
                  </xsl:when>
                  <xsl:when test="$location = 'BA'">
                    PROCESSO nº 16958920054 de 21/12/2005
                  </xsl:when>
                  <xsl:when test="$location = 'PE'">
                    PROCESSO Nº 9.2005.09.147338.2
                  </xsl:when>
                  <xsl:when test="$location = 'RS'">
                    ATO DECLARATÓRIO DRP Nº 2007/061
                  </xsl:when>
                </xsl:choose>
              </fo:block>

              <xsl:if test="$location = 'GO'">
                <fo:block text-align="left" font-size="6pt" font-family="Helvetica"
                  font-weight="bold" space-after="3mm">
                  "DISPENSADO DE AIDF CONFORME DECRETO LEI 4852 ART. 123 INCISO II LETRA C"
                </fo:block>
              </xsl:if>

            </fo:block>
            <fo:block text-align="left" font-size="5.5pt" font-family="Helvetica"
              space-after="3mm">
              <fo:table table-layout="fixed">
                <fo:table-column column-width="6cm" />
                <fo:table-column column-width="2cm" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2">
                      <fo:block>
                        <xsl:text>NOTA FISCAL Nº&#32;</xsl:text>
                        <xsl:value-of select="@NR" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2">
                      <fo:block>
                        <xsl:text>DATA DE EMISSÃO:&#32;</xsl:text>
                        <xsl:value-of select="@DE" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block>
                        <xsl:text>DATA DE VENCIMENTO:&#32;</xsl:text>
                        <xsl:value-of select="@DV" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>
                        <xsl:text>SÉRIE:&#32;</xsl:text>
                        <xsl:value-of select="@SR" />
                      </fo:block>
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
      <fo:table-column column-width="12.85cm" />
      <fo:table-column column-width="0.5cm" />
      <fo:table-column column-width="5.25cm" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block text-align="left" font-size="6pt" font-family="Helvetica"
              font-weight="bold">
              <fo:block space-after="2mm" space-before="2mm">
                <xsl:value-of select="CLIENTE/@N" />
              </fo:block>
              <fo:block>
                <xsl:text>ENDEREÇO:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@E" />
                </fo:inline>
              </fo:block>
              <fo:block>
                <xsl:text>CEP:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@CEP" />
                </fo:inline>
                <xsl:text>&#32;MUNICÍPIO:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@CI" />
                </fo:inline>
                <xsl:text>&#32;UF:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@ES" />
                </fo:inline>
              </fo:block>
              <fo:block>
                <xsl:text>C.N.P.J/C.P.F.:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@ID" />
                </fo:inline>
                <xsl:text>&#32;INSCR. ESTADUAL:&#32;</xsl:text>
                <fo:inline font-weight="normal">
                  <xsl:value-of select="CLIENTE/@IE" />
                </fo:inline>
              </fo:block>
              <fo:block space-after="2mm">
                <xsl:text>CLASSE DO USUÁRIO:&#32;</xsl:text>
                <fo:inline font-weight="normal">NÃO RESIDENCIAL</fo:inline>
              </fo:block>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell></fo:table-cell>

          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block text-align="left" font-size="6pt" font-family="Helvetica" space-before="2mm"
              start-indent="8mm">
              <fo:block>PEDIDO:</fo:block>
              <fo:block>
                <xsl:text>CLIENTE:&#32;</xsl:text>
                <xsl:value-of select="CLIENTE/@NR" />
              </fo:block>
              <fo:block>
                <xsl:text>PERÍODO DE:&#32;</xsl:text>
                <xsl:value-of select="@DI" />
              </fo:block>
              <fo:block>
                <xsl:text>ATÉ:&#32;</xsl:text>
                <xsl:value-of select="@DF" />
              </fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Description -->
    <fo:block start-indent="2mm" space-before="2mm" text-align="left"
      font-size="6pt" font-family="Helvetica" font-weight="bold">
      <xsl:text>ASSINATURA MENSAL / SERVIÇOS MEDIDOS / AJUSTES</xsl:text>
    </fo:block>

    <fo:table height="4.6cm" table-layout="fixed" text-align="left" font-size="6pt"
      font-family="Helvetica" font-weight="bold" border-top-style="solid"
      border-left-style="solid" border-left-width="1mm">
      <fo:table-column column-width="5cm" />
      <fo:table-column column-width="1.7cm" />
      <fo:table-column column-width="9.3cm" />
      <fo:table-column column-width="2.6cm" />
      <fo:table-body>
        <fo:table-row start-indent="2mm" height="4mm">
          <fo:table-cell display-align="center">
            <fo:block text-align="left">DESCRIÇÃO</fo:block>
          </fo:table-cell>
          <fo:table-cell display-align="center">
            <fo:block text-align="right">* ALÍQUOTA</fo:block>
          </fo:table-cell>
          <fo:table-cell display-align="center">
            <fo:block text-align="right"></fo:block>
          </fo:table-cell>
          <fo:table-cell display-align="center">
            <fo:block text-align="right">VALOR TOTAL R$:</fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:for-each select="ITENS/IT">
          <fo:table-row start-indent="3mm">
            <fo:table-cell>
              <fo:block>
                <xsl:value-of select="@DS" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align="right">
                <xsl:value-of select="@AIC" />
                <xsl:text>%</xsl:text>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align="right">
                <xsl:value-of select="@V" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>

    <!-- Hash Code -->
    <fo:table table-layout="fixed" border-bottom-style="solid" keep-with-previous="always"
      border-left-style="solid" border-left-width="1mm" space-after="1mm">
      <fo:table-column column-width="4cm" />
      <fo:table-column column-width="14.6cm" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell display-align="center">
            <fo:block text-align="left" font-size="6pt" font-family="Helvetica" font-weight="bold"
              start-indent="2mm">
              <xsl:text>Reservado ao Fisco:</xsl:text>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="left" font-size="11pt" font-family="Courier" font-weight="bold"
              space-after="2mm" start-indent="2mm">
              <xsl:value-of select="@HC" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Taxes -->
    <fo:table table-layout="fixed" space-before="2mm" space-after="1mm">
      <fo:table-column column-width="4.4cm" />
      <fo:table-column column-width="0.4cm" />
      <fo:table-column column-width="3.84cm" />
      <fo:table-column column-width="0.4cm" />
      <fo:table-column column-width="3.84cm" />
      <fo:table-column column-width="0.4cm" />
      <fo:table-column column-width="5.32cm" />
      <fo:table-body text-align="left" font-size="6pt" font-family="Helvetica">
        <fo:table-row>
          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block font-weight="bold" padding-top="0.5mm">
              <xsl:text>BASE DE CALCULO ICMS R$</xsl:text>
            </fo:block>
            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
              <xsl:value-of select="@BCIC" />
            </fo:block>
          </fo:table-cell>

          <fo:table-cell><fo:block/></fo:table-cell>

          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block text-align="left" font-size="6pt" font-weight="bold"
                      font-family="Helvetica" padding-top="0.5mm">
              <xsl:text>ALIQUOTA ICMS</xsl:text>
            </fo:block>
            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
              <xsl:text>Vide *</xsl:text>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell><fo:block/></fo:table-cell>

          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block text-align="left" font-size="6pt" font-weight="bold"
                      font-family="Helvetica" padding-top="0.5mm">
              <xsl:text>VALOR ICMS R$</xsl:text>
            </fo:block>
            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
              <xsl:value-of select="@VIC" />
            </fo:block>
          </fo:table-cell>

          <fo:table-cell><fo:block/></fo:table-cell>

          <fo:table-cell border-bottom-style="solid" border-top-style="solid"
            border-right-style="solid" border-right-width="1mm">
            <fo:block text-align="left" font-size="6pt" font-weight="bold"
                      font-family="Helvetica" padding-top="0.5mm">
              <xsl:text>VALOR TOTAL DA NOTA FISCAL</xsl:text>
            </fo:block>
            <fo:block start-indent="12mm" space-before="2mm" space-after="2mm">
              <xsl:value-of select="@V" />
            </fo:block>
          </fo:table-cell>

          <fo:table-cell><fo:block/></fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Observations -->
    <fo:table table-layout="fixed" space-before="2mm" space-after="1mm">
      <fo:table-column column-width="18.6cm" />
      <fo:table-body border-bottom-style="solid" border-top-style="solid"
                     border-left-style="solid" border-left-width="1mm"
                     text-align="left" font-size="6pt"
                     font-family="Helvetica">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-weight="bold" start-indent="2mm" padding-top="0.5mm">
              <xsl:text>OBSERVAÇÕES:</xsl:text>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row height="10mm">
          <fo:table-cell display-align="center" start-indent="3mm">
            <xsl:for-each select="OBS/O">
              <fo:block>
                <xsl:value-of select="text()" />
              </fo:block>
            </xsl:for-each>
            <fo:block>
              <xsl:choose>
                <!-- Sendo de SP e não sendo do mercado 6 - Curitiba -->
                <xsl:when test="$location = 'SP' or $location = 'GO'">
                  2ª via emitida, conforme Art. 6º, nos termos do Regime Especial. Não gera crédito de
                  ICMS.
                </xsl:when>
                <!-- Sendo do RJ e sendo do mercado 4 - Belo Horizonte -->
                <xsl:when test="$location = 'MG'">
                  Via adicional, com todos os efeitos da via original, emitida, conforme Seção IV,
                  Art. 8º, inciso I, nos termos do Regime Especial.
                </xsl:when>
                <!-- Sendo de SP e sendo do mercado 6 - Curitiba -->
                <xsl:when test="$location = 'PR'">
                  Cópia da 1ª via, conforme cláusula Quinta, nos termos do Regime Especial. Não gera
                  direito a crédito.
                </xsl:when>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Messages -->
    <fo:table table-layout="fixed" space-before="2mm"
              space-after="10mm" font-family="Helvetica">
      <fo:table-column column-width="10.77cm" />
      <fo:table-column column-width="7.83cm" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell font-size="6pt" text-align="left"
                         border-top-style="solid"
                         border-right-style="solid" border-right-width="1mm">
            <fo:block font-weight="bold" start-indent="2mm" padding-top="0.5mm">
              <xsl:text>MENSAGENS:</xsl:text>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell display-align="center" number-rows-spanned="2">
            <fo:block start-indent="2mm" text-align="center"
                      font-size="27pt" font-weight="bold">
              <xsl:text>2a VIA</xsl:text>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell font-size="6pt" text-align="left"
                         display-align="center" border-bottom-style="solid"
                         border-right-style="solid" border-right-width="1mm">
            <xsl:for-each select="MSGS/M">
              <fo:block start-indent="3mm">
                <xsl:value-of select="text()" />
              </fo:block>
            </xsl:for-each>
            <fo:block line-height="0"/>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>


</xsl:stylesheet>
