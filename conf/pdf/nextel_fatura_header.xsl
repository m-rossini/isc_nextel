<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xalan="http://xml.apache.org/xalan"
  exclude-result-prefixes="xalan"
  version="1.0">

    <!-- ****************************** -->
    <!-- * O cabeçalho de cada página * -->
    <!-- ****************************** -->
	<xsl:template name="HEADER">
        <xsl:param name="title"></xsl:param>
        <xsl:param name="ommitPageNumber"></xsl:param>
        <xsl:param name="printBottomBorder"></xsl:param>
        <xsl:param name="displayDueDate"></xsl:param>
        <fo:block font-family="Helvetica">
            <fo:table table-layout="fixed" width="100%">
              <xsl:if test="$printBottomBorder">
                <xsl:attribute name="border-after-style">solid</xsl:attribute>
                <xsl:attribute name="border-after-width">0.1mm</xsl:attribute>
              </xsl:if>
                <fo:table-column column-width="87.6mm"/>
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                    <fo:table-row height="5.9cm">

                        <!-- Lado esquerdo -->
                        <fo:table-cell>
                            <fo:block space-after="2mm">
                                <fo:external-graphic src="conf/pdf/nextelNew.jpg" height="10mm" width="32mm"/>
                            </fo:block>

                            <fo:table table-layout="fixed" padding-top="1mm"
                                      xsl:use-attribute-sets="ThinBorderBefore">
                                <fo:table-column column-width="77.2mm"/>
                                <fo:table-body>
                                    <fo:table-row height="7mm">
                                        <fo:table-cell display-align="before">
                                            <fo:block font-size="6pt" font-weight="bold">
                                                <xsl:text>NEXTEL Telecomunicações Ltda.</xsl:text>
                                            </fo:block>
                                            <fo:block font-size="5pt" font-weight="normal">
                                                <xsl:text>Al. Santos, 2356/2364 - Cerqueira César - CEP 01418-200 - São Paulo - SP</xsl:text>
                                            </fo:block>
                                            <fo:block font-size="5pt" font-weight="normal">
                                                <xsl:text>C.N.P.J. 66.970.229/0001-67 - Insc. Estadual: 114.166.101.115</xsl:text>
                                            </fo:block>

                                            <!-- Endereço do cliente -->
                                            <fo:block font-size="8pt" start-indent="10mm" space-before="10mm">
                                                <fo:block>
                                                    <xsl:value-of select="/INVOICE/CUSTOMER/@C"/>
                                                </fo:block>
                                                <fo:block>
                                                    <xsl:value-of select="/INVOICE/CUSTOMER/@N"/>
                                                </fo:block>
                                                <fo:block space-before="3mm">
                                                    <xsl:value-of select="/INVOICE/CUSTOMER/@A1"/>
                                                </fo:block>
                                                <fo:block>
                                                    <xsl:value-of select="/INVOICE/CUSTOMER/@A2"/>
                                                </fo:block>
                                                <fo:block>
                                                    <xsl:value-of select="/INVOICE/CUSTOMER/@A3"/>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:table-cell>

                        <!-- Lado direito -->
                        <fo:table-cell>

                            <!-- Título do cabeçalho -->
                            <fo:table table-layout="fixed" padding-top="1mm"
                                      xsl:use-attribute-sets="ThinBorder">
                                <fo:table-column column-width="80mm"/>
                                <fo:table-column column-width="20mm"/>
                                <fo:table-body>
                                    <fo:table-row height="5mm">
                                        <fo:table-cell display-align="center">
                                            <fo:block font-size="9pt" font-weight="bold">
                                                <xsl:value-of select="$title"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell display-align="center">
                                            <fo:block text-align="end" font-size="8pt">
                                              <xsl:if test="not($ommitPageNumber)">
                                                <xsl:text>Página </xsl:text>
                                                <fo:page-number/>
                                              </xsl:if>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>

                            <!-- Dados da fatura -->
                            <fo:block font-size="8pt" start-indent="10mm" space-before="7mm">
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:text>CLIENTE:&#32;</xsl:text>
                                    </fo:inline>
                                    <xsl:value-of select="/INVOICE/CUSTOMER/@C"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:text>IDENTIFICAÇÃO DO CLIENTE:&#32;</xsl:text>
                                    </fo:inline>
                                    <xsl:value-of select="/INVOICE/CUSTOMER/@B"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:text>DATA DE EMISSÃO:&#32;</xsl:text>
                                    </fo:inline>
                                    <xsl:value-of select="/INVOICE/CUSTOMER/@I"/>
                                </fo:block>
                                <fo:block space-before="5mm">
                                    <fo:inline font-weight="bold">
                                        <xsl:text>PERÍODO DE UTILIZAÇÃO:&#32;</xsl:text>
                                    </fo:inline>
                                    <xsl:value-of select="/INVOICE/CUSTOMER/@S"/>
                                    <xsl:text>&#32;a&#32;</xsl:text>
                                    <xsl:value-of select="/INVOICE/CUSTOMER/@E"/>
                                </fo:block>

                                <!-- A data de vencimento só será apresentada quando este parâmetro for definido na chamada do template -->
                                <xsl:if test="($displayDueDate)">

                                	<!-- Deixando linha em branco, para ficar do mesmo tamanho da página para não CG -->
	                                <fo:block>
	                                    <fo:inline font-weight="bold">
	                                        <xsl:text>&#32;</xsl:text>
	                                    </fo:inline>
	                                </fo:block>

							        <!-- Vencimento -->
							        <fo:block font-family="Helvetica" font-size="10pt">
							            <fo:table table-layout="fixed" space-before="10mm">
							                <fo:table-column column-width="10cm"/>
							                <fo:table-body>
							                    <fo:table-row>
							                        <fo:table-cell display-align="center">
							                            <fo:block font-size="11pt" font-weight="bold" text-align="end">
							                                <xsl:text>VENCIMENTO:&#32;</xsl:text>
							                                <fo:inline font-weight="normal">
							                                    <xsl:value-of select="/INVOICE/CUSTOMER/@D"/>
							                                </fo:inline>
							                            </fo:block>
							                        </fo:table-cell>
							                    </fo:table-row>
							                </fo:table-body>
							            </fo:table>
							        </fo:block>
							       </xsl:if>

                            </fo:block>
                        </fo:table-cell>

                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>

	</xsl:template>


    <!-- ******************************* -->
    <!-- * Mostra os dados do contrato * -->
    <!-- ******************************* -->
    <xsl:template name="HEADER-DETALHE">

        <fo:block font-size="0pt" text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
        </fo:block>

        <fo:block font-family="Helvetica" font-size="10pt" font-weight="bold">
            <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="42mm"/>
                <fo:table-column column-width="51mm"/>
                <fo:table-column column-width="44mm"/>
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                    <fo:table-row height="0.9cm">
                        <fo:table-cell display-align="center">
                            <fo:block>
                                <xsl:text>DADOS DO USUÁRIO</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
		                    <xsl:choose>
		                      <xsl:when test="@TP = 'AMP'">
	                            <fo:block>
	                                <xsl:text>SERIAL:&#32;</xsl:text>
	                                <fo:inline font-weight="normal">
					                    <xsl:value-of select="@IMEI"/>
	                                </fo:inline>
	                            </fo:block>
		                      </xsl:when>
		                      <xsl:otherwise>
	                            <fo:block>
	                                <xsl:text>FLEET*ID:&#32;</xsl:text>
	                                <fo:inline font-weight="normal">
				                        <xsl:value-of select="@FID"/>
				                        <xsl:if test="not(string-length(@FID) = 0)">
				                            <xsl:text>*</xsl:text>
				                        </xsl:if>
				                        <xsl:value-of select="@MID"/>
	                                </fo:inline>
	                            </fo:block>
		                      </xsl:otherwise>
		                    </xsl:choose>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block>
                                <xsl:text>TELEFONE:&#32;</xsl:text>
                                <fo:inline font-weight="normal">
                                    <xsl:call-template name="HIFENIZAR">
                                        <xsl:with-param name="number">
                                            <xsl:value-of select="@N"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </fo:inline>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="center">
                            <fo:block>
                                <xsl:text>NOME:&#32;</xsl:text>
                                <fo:inline font-weight="normal">
                                    <xsl:value-of select="substring(@U, 1, $userNameMaxLength)"/>
                                </fo:inline>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>

        <fo:block font-size="0pt" text-align-last="justify">
            <fo:leader leader-pattern="rule" rule-thickness="0.1mm"/>
        </fo:block>

    </xsl:template>

</xsl:stylesheet>