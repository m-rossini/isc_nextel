<?xml version="1.0" encoding="ISO-8859-1"?>
 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="NOTA_FISCAL_TELECOM">
  <tr>
    <td colspan="39"><img src="images/Nextel_07.gif" width="640" height="1"/></td>
    <td><img src="images/spacer.gif" width="1" height="1"/></td>
  </tr>
  <tr>
    <td height="2"><img src="images/Nextel_85.gif" width="5" height="125"/></td>
    <td colspan="38" height="2" valign="top">
      <table width="617" border="0" cellspacing="0" cellpadding="0" height="99">
        <tr>
          <td align="left" valign="top" width="280" height="60">
            <table width="280" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top" class="Fonte_06"> 
                	<img src="images/spacer.gif" width="8" height="1"/>
                  	<!--xsl:if test="/INVOICE/CUSTOMER/@ST='SP'"-->
                  		<img src="images/logo_black_New.gif"/>
                  	<br/>
                  	<img src="images/spacer.gif" height="1" width="12"/>
                  		<span class="Fonte_06_Light">www.nextel.com.br</span>
                  	<br/>
                  	<br/>
                  	<img src="images/spacer.gif" height="1" width="12"/>
                  	<span class="Fonte_06_Light">
	                    <!-- SP address -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
	                        <!-- Grande São Paulo: 3748-1212 - Outras Localidades: 0800 90 50 40 - Fax 113748-1252 -->
	                        Grande São Paulo: 4004-6611 - Outras Localidades: 0800 90 50 40 - Fax: 11 4004-1201
	                    </xsl:if>
	                    <!-- RJ address -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
	                  			0800 90 50 40 - FAX (0XX11)3748-1252
	                    </xsl:if>
	                    <!-- MG address -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                    
	                  			Tel. (0XX31)3228-1400 - Fax: (0XX31)3228-1470
	                    </xsl:if>
	                    <!-- SC address -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">
	                 			Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
	                    </xsl:if>
	                    <!-- BSB address -->
	                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">                        
	                  			Central de Atendimento: *611 (ligue grátis do seu celular)
	                    </xsl:if>
	                    <!-- PR address -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
	                  			Fone: (0XX41)3025-8000 - Fax: (0XX41)3025-8238
	                    </xsl:if>
	                    <!-- GO address -->
	                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
	                 			Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
	                    </xsl:if>                    
	                    <!-- BA address -->	                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                        	                 			Central de Atendimento ao Cliente: *611 (ligue grátis do seu Nextel) ou (11)4004-6611	                    </xsl:if>
						<!-- PE address -->
	                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">                        
	                 			Central de Atendimento ao Cliente: *611 (Ligue Grátis do seu Nextel) ou 4004-6611
	                    </xsl:if>
	                    <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
	                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
	                 			Central de Atendimento: *611 (ligue grátis do seu celular) ou 4004-6611
	                    </xsl:if>	                                   		</span>
               		
			    	<br/>
			    	<img src="images/spacer.gif" height="1" width="12"/>
			    		<span class="Fonte_07">Nextel Telecomunicações Ltda</span>
			    	<br/>
			    	<img src="images/spacer.gif" height="1" width="12"/>
                    <!-- SP address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                        <!--
			    		<span class="Fonte_06_Light">Av. Maria Coelho Aguiar, 215 Bloco D - 6º Andar - Cj. A</span> -->
			    		<span class="Fonte_06_Light">Al. Santos, 2356 e 2364</span>
                    </xsl:if>
                    <!-- RJ address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
			    		<span class="Fonte_06_Light">Av. Pres. Vargas, 3.131 - 11º andar - sl. 1102 - parte</span>
                    </xsl:if>
                    <!-- SC address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">                    
			    		<span class="Fonte_06_Light">Rua Souza França, 52 - Centro</span>
                    </xsl:if>
                    <!-- BSB address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">        
                    <span class="Fonte_06_Light">SB Norte Quadra 01 - Bl. B nº 14 - 13º / 14º Andares</span>
                    </xsl:if>
                    <!-- MG address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">
			    		<span class="Fonte_06_Light">Rua Inconfidentes, 1180</span>
                    </xsl:if>
                    <!-- PR address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
			    		<span class="Fonte_06_Light">Rua Augusto Stresser, 453</span>
                    </xsl:if>
                    <!-- GO address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
			    		<span class="Fonte_06_Light">Av.República do Líbano, 1770 - Qd.E-2 Lt.29</span>
                    </xsl:if>                                        <!-- BA address -->                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">			    		<span class="Fonte_06_Light">Av.Antonio Carlos Magalhães, 3213 - salas 1107 a 1110 - Brotas</span>                    </xsl:if>                    <!-- PE address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">
			    		<span class="Fonte_06_Light">Rua Agenor Lopes, 277 - sala 302</span>
                    </xsl:if>
                    <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
			    		<span class="Fonte_06_Light">Av.Carlos Gomes, 413 - Auxiliadora</span>
                    </xsl:if>
                    
                    
				<br/>
				<img src="images/spacer.gif" height="1" width="12"/>
                <!-- SP address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                    <!-- <span class="Fonte_06_Light">Jd. São Luis - São Paulo - SP - CEP 05805-000</span> -->
                    <span class="Fonte_06_Light">Cerqueira César São Paulo - SP - CEP 01418-200</span>
                    </xsl:if>
                    <!-- RJ address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
			    		<span class="Fonte_06_Light">Cidade Nova - Rio de Janeiro - RJ - CEP 20210-030</span>
                    </xsl:if>
                    <!-- SC address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">                                        
			    		<span class="Fonte_06_Light">Florianópolis - SC - CEP 88015-480</span>
                    </xsl:if>
                    <!-- BSB address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">                        
			    		<span class="Fonte_06_Light">CEP: 70040-010 - Asa Norte - Brasília - DF</span>
                    </xsl:if>
                    <!-- MG address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                    
			    		<span class="Fonte_06_Light">Bairro Funcionários - Belo Horizonte - MG - CEP 30140-120</span>
                    </xsl:if>
                    <!-- PR address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
			    		<span class="Fonte_06_Light">Alto da Glória - Curitiba - PR - CEP 80030-340</span>
                    </xsl:if>
                    <!-- GO address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
			    		<span class="Fonte_06_Light"> CEP 74115-030 - Setor Oeste - Goiânia - GO</span>
                    </xsl:if>                                        <!-- BA address -->                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                        			    		<span class="Fonte_06_Light"> Salvador - Bahia - CEP 40280-000</span>                    </xsl:if>                    
                    <!-- PE address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">                        
			    		<span class="Fonte_06_Light">51021-110 - Boa Viagem - Recife - PE</span>
                    </xsl:if>                    
                    <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
			    		<span class="Fonte_06_Light">Porto Alegre - RS - CEP 90480-000</span>
                    </xsl:if>
                    
				<br/>
				<img src="images/spacer.gif" height="1" width="12"/>
                <!-- SP address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                        <span class="Fonte_06_Light">CNPJ 66.970.229/0001-67 - Inscr. Estadual: 114.166.101.115</span>
                    </xsl:if>
                    <!-- RJ address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0011-39 - Inscr.Estadual: 85.727.028</span>
                    </xsl:if>
                    <!-- SC address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0039-30 - Inscr.Estadual: 254.971.750</span>
                    </xsl:if>
                    <!-- MG address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                    
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0021-00 - Inscr.Estadual: 062.956.363.0199</span>
                    </xsl:if>
                    <!-- BSB address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">                        
                    <span class="Fonte_06_Light">CNPJ 66.970.229/0018-05 - CF/DF: 07.404.653/002-20</span>
                    </xsl:if>
                    <!-- PR address -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0017-24 - Inscr.Estadual: 90.194.059-20</span>
                    </xsl:if>
                    <!-- GO address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0019-96 - Inscr.Estadual: 10.332.587-5</span>
                    </xsl:if>                                        <!-- BA address -->                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                        			    		<span class="Fonte_06_Light">C.N.P.J.: 66.970.229/0040-73 - Inscr.Est.: 51.338.686 NO - Inscr.Municipal: 157.942/001-78</span>                    </xsl:if>                    
                    <!-- PE address -->
                    <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">                        
			    		<span class="Fonte_06_Light">C.N.P.J.: 66.970.229/0009-14 - Inscr. Estadual: 181.001.0261944-5</span>
                    </xsl:if>                    
                    <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                    <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
			    		<span class="Fonte_06_Light">CNPJ 66.970.229/0006-71 - Inscr.Estadual: 096/2755109</span>
                    </xsl:if>
                    
                </td>
              </tr>
              <tr>
                <td align="left" class="Fonte_06" valign="top" ></td>
              </tr>
            </table>
          </td>
          <td align="left" valign="top" width="30" height="60"><img src="images/spacer.gif" width="45" height="1"/></td>
          <td align="left" valign="top" width="256" height="60">
            <table width="308" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="images/spacer.gif" width="4" height="8"/></td>
              </tr>
              <tr>
                <td class="Font_09" colspan="2">NOTA FISCAL FATURA DE TELECOMUNICAÇÕES</td>
              </tr>
              <tr>
                <td colspan="2"><img src="images/spacer.gif" width="4" height="18"/></td>
              </tr>
              <tr>
                <td class="Font_08" colspan="2">SERVIÇO MÓVEL ESPECIALIZADO REGIME ESPECIAL<br/> <!--DRTC-III-25811-->
                <!-- SP address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                    PROCESSO SF5-258118/99 de 04/04/2001 DEAT/ARE
                </xsl:if>
                <!-- RJ address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '2') or (/INVOICE/CUSTOMER/@CID = '5') or (/INVOICE/CUSTOMER/@CID = '6')">
                    PROCESSO n° E-04/346.630/99 de 12/07/99
                </xsl:if>
                <!-- SC address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '13') or (/INVOICE/CUSTOMER/@CID = '22') or (/INVOICE/CUSTOMER/@CID = '23')">                
                    PROCESSO n° GR01 7279/051 de 15/09/2005
                </xsl:if>
                <!-- MG address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                
                    PROCESSO PTA nº 16.58152.20 de 29/07/2002
                </xsl:if>
                <!-- BSB address -->
                <xsl:if test="/INVOICE/CUSTOMER/@CID = '3'">                        
                    ATO DECLARATÓRIO Nº 009/2004 - NUESP/GEESP/DITRI/SUREC/SEF
                </xsl:if>
                <!-- PR address -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
                    PROCESSO nº 2643/01 de 05/11/2001
                </xsl:if>
                <!-- GO address -->
                <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
                    TARE nº 234/05-GSF de 29/11/2005
                </xsl:if>                   <!-- BA address -->                <xsl:if test="/INVOICE/CUSTOMER/@CID = '19'">                                            PROCESSO nº 16958920054 de 21/12/2005                </xsl:if>
                <!-- PE address -->
                <xsl:if test="/INVOICE/CUSTOMER/@CID = '17'">                        
					PROCESSO Nº 9.2005.09.147338.2                    
                </xsl:if>                
                <!-- RS address -->
<!-- EHO: Novo Mercado Caxias do Sul -->
                <xsl:if test="(/INVOICE/CUSTOMER/@CID = '16') or (/INVOICE/CUSTOMER/@CID = '26') or (/INVOICE/CUSTOMER/@CID = '29')">                        
                    ATO DECLARATÓRIO DRP Nº 2007/061
                </xsl:if>
                             
                </td>

                <!-- GO address -->
                <xsl:if test="/INVOICE/CUSTOMER/@CID = '21'">                        
			    		<span class="Fonte_08" colspan="2">"DISPENSADO DE AIDF CONFORME DECRETO LEI 4852 ART. 123 INCISO II LETRA C" </span>
                </xsl:if>                    
               
              </tr>
              <tr>
                <td colspan="2"><img src="images/spacer.gif" width="4" height="18"/></td>
              </tr>
              <tr>
                <td>NOTA FISCAL Nº<img src="images/spacer.gif" width="4" height="1"/>
                                            <xsl:if test="SIXTH/@HC">
                                                <xsl:value-of select="FOURTH/@NN"/>
                                            </xsl:if>
                                            <xsl:if test="not(SIXTH/@HC)">
                                                <xsl:value-of select="THIRD/@NN"/>
                                            </xsl:if><br/>
                  DATA DE EMISSÃO <xsl:value-of select="THIRD/@DE"/><br/>
                  DATA DO VENCIMENTO <xsl:value-of select="THIRD/@DV"/></td>
                 <td width="68">
                 	<br/>
                 	<br/>
                 	SÉRIE: <xsl:value-of select="THIRD/@S"/></td>
                 </tr>
                </table>
               </td>
              </tr>
             </table>
            </td>
            <td height="2"><img src="images/spacer.gif" width="1" height="99"/></td>
           </tr>
           <tr>
           	<td colspan="39">
           		<img src="images/Nextel_07.gif" width="640" height="1"/></td>
           	<td><img src="images/spacer.gif" width="1" height="1"/></td>
           </tr>
           <tr>
           	<td colspan="39">
           		<table width="640" border="0" cellspacing="0" cellpadding="0" height="6">
           			<tr>
           				<td class="Fonte_06"><img src="images/spacer.gif" width="4" height="1"/></td>
           			</tr>
           		</table>
           	</td>
           	<td><img src="images/spacer.gif" width="1" height="6"/></td>
           </tr>
           <tr>
           	<td colspan="39"><img src="images/Nextel_00.gif" height="1"/></td>
           	<td><img src="images/spacer.gif" width="1" height="1"/></td>
           </tr>
           <tr>
           	<td colspan="30">
           		<table width="360" border="0" cellspacing="0" cellpadding="0" height="64">
           			<tr>
           				<td align="left" valign="top" height="52">
           					<table width="350" border="0" cellspacing="0" cellpadding="0">
           						<tr>
           							<td height="2" class="Fonte_06"><img src="images/spacer.gif" width="4" height="6"/></td>
           						</tr>
           						<tr>
           							<td class="Font_08"><xsl:value-of select="THIRD/@NC"/></td>
           						</tr>
           						<tr>
           							<td class="Fonte_06"><img src="images/spacer.gif" width="4" height="6"/></td>
           						</tr>
           						<tr>
           							<td class="Fonte_08_light" >
           								<b>ENDEREÇO:</b>
           								<img src="images/spacer.gif" width="4" height="1"/>
           								<xsl:value-of select="THIRD/@EC"/>
           								<img src="images/spacer.gif" width="4" height="1"/></td>
           							</tr>
           							<tr>
           								<td class="Fonte_08_light">
           									<b>CEP:</b>
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@CEP"/>
           									<img src="images/spacer.gif" width="8" height="1"/>
           									<b>MUNICIPIO:</b>
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@C"/>
           									<img src="images/spacer.gif" width="8" height="1"/>
           									<b>UF:</b>
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@UFC"/>
           								</td>
           							</tr>
           							<tr>
           								<td class="Fonte_08_light">
           									<b>C.N.P.J/C.P.F.:</b>
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@CGCC"/>
           									<xsl:text> </xsl:text>
           									<b>INSCR. ESTADUAL:
           									<img src="images/spacer.gif" width="4" height="1"/></b>
           									<xsl:value-of select="THIRD/@IEC"/>
           								</td>
           							</tr>
           							<tr>
           								<td class="Fonte_08_light">
           									<b>CLASSE DO USUÁRIO:</b> NÃO RESIDENCIAL</td>
           							</tr>
           						</table>
           					</td>
           				</tr>
           			</table>
           		</td>
           		<td><img src="images/Nextel_91.gif" width="5" height="64"/></td>
           		<td><img src="images/spacer.gif" width="7" height="64"/></td>
           		<td align="left">
           			<table width="145" border="0" cellspacing="0" cellpadding="0" height="64" align="left">
           				<tr>
           					<td align="left" valign="top" height="59">
           						<table width="145" border="0" cellspacing="0" cellpadding="0" align="left">
           							<tr>
           								<td align="left" valign="top" class="Fonte_06">
           									<img src="images/spacer.gif" width="4" height="6"/></td>
           							</tr>
           							<tr>
           								<td align="left" valign="top" class="Fonte_08_light">
           									PEDIDO:
           									<img src="images/spacer.gif" width="4" height="1"/>
                                            <xsl:if test="not(starts-with(THIRD/@CC, ' '))">
                                                <xsl:value-of select="THIRD/@PV"/>
                                            </xsl:if>
                                        </td>
           							</tr>
           							<tr>
           								<td align="left" valign="top" class="Fonte_08_light">
           									CLIENTE:
           									<img src="images/spacer.gif" width="4" height="1"/>
                                            <xsl:if test="starts-with(THIRD/@CC, ' ')">
                                                <xsl:value-of select="THIRD/@PV"/>
                                            </xsl:if>
                                            <xsl:if test="not(starts-with(THIRD/@CC, ' '))">
                                                <xsl:value-of select="THIRD/@CC"/>
                                            </xsl:if>
                                        </td>
           							</tr>
           							<tr>
           								<td align="left" valign="top" class="Fonte_08_light">
           									LEITURA DE: 
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@DIP"/></td>
           							</tr>
           							<tr>
           								<td align="left" valign="top" class="Fonte_08_light">
           									ATÉ:
           									<img src="images/spacer.gif" width="4" height="1"/>
           									<xsl:value-of select="THIRD/@DFP"/></td>
           							</tr>
           						</table>
           					</td>
           				</tr>
           			</table>
           		</td>
           		<td><img src="images/Nextel_91.gif" width="5" height="64"/></td>
           		<td><img src="images/spacer.gif" width="1" height="64"/></td>
           	</tr>
           	<tr>
           		<td colspan="39"><img src="images/Nextel_00.gif" height="1"/></td>
           		<td><img src="images/spacer.gif" width="1" height="1"/></td>
           	</tr>
           	<tr>
           		<td colspan="39" height="7">
           			<table width="640" border="0" cellspacing="0" cellpadding="0" height="13">
           				<tr>
           					<td align="left" valign="middle" class="Font_08" height="15">
           						ASSINATURA MENSAL / SERVIÇOS MEDIDOS / AJUSTES</td>
           				</tr>
           			</table>
           		</td>
           		<td height="7"><img src="images/spacer.gif" width="1" height="13"/></td>
           	</tr>
           	<tr>
           		<td colspan="39"><img src="images/Nextel_07.gif" width="640" height="1"/></td>
           		<td><img src="images/spacer.gif" width="1" height="1"/></td>
           	</tr>
           	<tr>
           		<td valign="top"><img src="images/Nextel_98.gif" width="5" height="110"/></td>
           		<td colspan="38" valign="top">
           			<table width="632" border="0" cellspacing="0" cellpadding="0" height="110">
           				<tr>
           					<td align="left" valign="top">
           						<table width="632" border="0" cellspacing="0" cellpadding="0">
           							<tr>
           								<td class="Font_08"  width="20%" height="14">
           									<img src="images/spacer.gif" width="8" height="1"/>DESCRIÇÃO</td>
           								<td class="Font_08" width="5%" align="right" height="14">*ALÍQUOTA</td>
           								<td class="Font_08" width="10%" align="right" height="14"></td>	
           								<td class="Font_08" width="16%" align="right" height="14">VALOR TOTAL R$:</td>
           							</tr>           							
						               <xsl:for-each select="FOURTH">
 					                <tr>
                                           <td width="20%" class="Font_08">
						               		<img src="images/spacer.gif" width="12" height="1"/>
						               		<xsl:value-of select="@DI"/></td>
						               	<td width="5%" align="right" class="Font_08">
                                            <xsl:if test="not(AII/@DEC = '')">
                                                <xsl:value-of select="AII/@INT"/>,<xsl:value-of select="AII/@DEC"/>%
                                            </xsl:if>
                                        </td>
                                            <td class="Font_08" width="10%" align="right" height="14"></td>	
                                        <td width="16%" align="right" class="Font_08">
                                            <xsl:value-of select="VTI/@INT"/>,<xsl:value-of select="VTI/@DEC"/></td>
						            </tr>
						               </xsl:for-each>
                                       <xsl:if test="SIXTH/@HC">
                                       <tr>
                                           <p></p><br/>
                                       </tr>
                                       <tr>
                                           <td class="Font_08"  width="30%" height="14">
                                               <img src="images/spacer.gif" width="8" height="1"/>
                                               <br/><br/><br/>
                                               Reservado ao Fisco: </td> 
                                           <td class="Font_09" width="50%" align="right" height="20">
                                               <br/><br/><br/>
                                               <xsl:value-of select="SIXTH/@HC"/></td>
                                       </tr>
                                       </xsl:if>
						          </table>
						     </td>
						</tr>
					</table>
				</td>
				<td><img src="images/spacer.gif" width="1" height="110"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_07.gif" width="640" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="39"></td>
			     <td><img src="images/spacer.gif" width="1" height="14"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_01.gif" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="7">
					<table width="132" border="0" cellspacing="0" cellpadding="0" height="35">
						<tr>
							<td align="left" valign="top" class="Fonte_08_light" height="5">BASE DE CALCULO ICMS R$</td>
						</tr>
						<tr>
							<td align="center" valign="middle" class="Fonte_08_light">
								<xsl:value-of select="THIRD/BCICMS/@INT"/>,<xsl:value-of select="THIRD/BCICMS/@DEC"/></td>
						</tr>
					</table>
				</td>
				<td><img src="images/Nextel_104.gif" width="5" height="35"/></td>
				<td><img src="images/spacer.gif" width="4" height="35"/></td>
				<td colspan="10">
					<table width="82" border="0" cellspacing="0" cellpadding="0" height="35">
						<tr>
							<td class="Fonte_08_light" height="2" align="left" valign="top">ALIQUOTA ICMS</td>
						</tr>
						<tr>
							<td class="Fonte_08_light" align="center" valign="middle">
								Vide*</td>
						</tr>
					</table>
				</td>
				<td><img src="images/Nextel_104.gif" width="5" height="35"/></td>
				<td><img src="images/spacer.gif" width="4" height="35"/></td>
				<td colspan="6">
					<table width="116" border="0" cellspacing="0" cellpadding="0" height="35">
						<tr>
							<td align="left" valign="top" class="Fonte_08_light" height="3">VALOR ICMS RS</td>
						</tr>
						<tr>
							<td valign="center" align="middle" class="Fonte_08_light">
								<xsl:value-of select="THIRD/VICMS/@INT"/>,<xsl:value-of select="THIRD/VICMS/@DEC"/></td>
						</tr>
					</table>
				</td>
				<td><img src="images/Nextel_104.gif" width="5" height="35"/></td>
				<td><img src="images/spacer.gif" width="12" height="35"/></td>
				<td colspan="4">
					<table width="143" border="0" cellspacing="0" cellpadding="0" height="35">
						<tr>
							<td class="Fonte_08_light" height="7" align="left" valign="top">
								VALOR TOTAL DA NOTA FISCAL</td>
						</tr>
						<tr>
							<td align="middle" valign="center" class="Fonte_08_light">
								<xsl:value-of select="THIRD/VTN/@INT"/>,<xsl:value-of select="THIRD/VTN/@DEC"/></td>
						</tr>
					</table>
				</td>
				<td><img src="images/Nextel_104.gif" width="5" height="35"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_01.gif" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="39" height="3">
					<table width="640" border="0" cellspacing="0" cellpadding="0" height="5">
						<tr>
							<td class="Fonte_06" height="2"><img src="images/spacer.gif" width="4" height="1"/></td>
						</tr>
					</table>
				</td>
				<td height="3"><img src="images/spacer.gif" width="1" height="5"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_07.gif" width="640" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td><img src="images/Nextel_117.gif" width="5" height="46"/></td>
				<td colspan="38">
					<table width="618" border="0" cellspacing="0" cellpadding="0" height="46">
						<tr>
							<td align="left" valign="top">
								<table width="618" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="Font_08">
											<img src="images/spacer.gif" width="8" height="1"/>OBSERVAÇÕES:</td>
									</tr>
									<tr>
										<td align="left" valign="center" height="35" class="Fonte_08_light">
											<img src="images/spacer.gif" width="16" height="1"/>
											<xsl:value-of select="THIRD/@OB1"/><br/>
											<img src="images/spacer.gif" width="16" height="1"/>
											<xsl:value-of select="THIRD/@OB2"/><br/>
											<img src="images/spacer.gif" width="16" height="1"/>
											<xsl:value-of select="THIRD/@OB3"/><br/>
											<img src="images/spacer.gif" width="16" height="1"/>
											<xsl:value-of select="THIRD/@OB4"/><br/>
                                            <img src="images/spacer.gif" width="16" height="1"/>
                                            <!-- SP address -->
                                            <xsl:if test="(/INVOICE/CUSTOMER/@CID = '7') or (/INVOICE/CUSTOMER/@CID = '8') or (/INVOICE/CUSTOMER/@CID = '9') or (/INVOICE/CUSTOMER/@CID = '10') or (/INVOICE/CUSTOMER/@CID = '12') or (/INVOICE/CUSTOMER/@CID = '15') or (/INVOICE/CUSTOMER/@CID = '18') or (/INVOICE/CUSTOMER/@CID = '21') or (/INVOICE/CUSTOMER/@CID = '1') or (/INVOICE/CUSTOMER/@CID = '28')">
                                                2ª via emitida, conforme Art. 6º, nos termos do Regime Especial. Não gera crédito de ICMS.
                                            </xsl:if>
                                            <!-- MG address -->
                                            <xsl:if test="(/INVOICE/CUSTOMER/@CID = '4') or (/INVOICE/CUSTOMER/@CID = '25')">                                            
                                                Via adicional, com todos os efeitos da via original, emitida, conforme Seção IV, Art. 8º, inciso I, nos termos do Regime Especial. 
                                            </xsl:if>
                                            <!-- PR address -->
                                            <xsl:if test="(/INVOICE/CUSTOMER/@CID = '11') or (/INVOICE/CUSTOMER/@CID = '27')">                        
                                                Cópia da 1ª via, conforme cláusula Quinta, nos termos do Regime Especial. Não gera direito a crédito.
                                            </xsl:if>
											<br/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td><img src="images/spacer.gif" width="1" height="46"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_07.gif" width="640" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="39" height="2">
					<table width="640" border="0" cellspacing="0" cellpadding="0" height="5">
						<tr>
							<td class="Fonte_06" height="2"><img src="images/spacer.gif" width="4" height="1"/></td>
						</tr>
					</table>
				</td>
				<td height="2"><img src="images/spacer.gif" width="1" height="5"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_87.gif" width="372" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="24">
					<table width="363" border="0" cellspacing="0" cellpadding="0" height="60">
						<tr>
							<td align="left" valign="top">
								<table width="367" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="left" valign="top">
											<img src="images/spacer.gif" width="4" height="1"/>
											<span class="Font_08">
											<img src="images/spacer.gif" width="4" height="1"/>
											MENSAGENS:</span></td>
									</tr>
                                    <!-- Devido à variação de alíquota de acordo com a data -->
                                    <xsl:variable name="date" select="concat(substring(FIRST/@DP,7),substring(FIRST/@DP,4,2),substring(FIRST/@DP,1,2))"/>
                                    <xsl:variable name="dateFIX" select="20040815"/>
                                    <tr>
										<td height="47" align="left" valign="center" class="Fonte_08_light">
											<img src="images/spacer.gif" width="12" height="1"/>
											<xsl:value-of select="THIRD/@M1"/><br/>
											<img src="images/spacer.gif" width="12" height="1"/>
											<xsl:value-of select="THIRD/@M2"/><br/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td><img src="images/Nextel_87.gif" width="5" height="60"/></td>
				<td colspan="11">
					<table width="255" border="0" cellspacing="0" cellpadding="0" height="60">
						<tr>
							<td align="center" valign="middle" class="2a_VIA">2a VIA</td>
						</tr>
					</table>
				</td>
				<td><img src="images/spacer.gif" width="1" height="60"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/Nextel_87.gif" width="372" height="1"/></td>
				<td><img src="images/spacer.gif" width="1" height="1"/></td>
			</tr>
			<tr>
				<td colspan="39"><img src="images/spacer.gif" width="640" height="2"/></td>
				<td><img src="images/spacer.gif" width="1" height="2"/></td>
			</tr>
    </xsl:template>

</xsl:stylesheet>