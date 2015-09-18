<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="BOLETO_ARRECADACAO">
    <xsl:param name="show_bar_code" select="true()"/>

    <hr class="dashedRule"/>

    <table>
    	<tr>
            <td width="5%" height="8">
                &#160;
            </td>
    		<td>
			    <table class="table1" width="700px">
			      <col width="700px" />
			      <col width="100%" />
			      <tbody>
			        <!-- First line: logo and messages -->
			        <tr>

			          <td colspan="2">
			            <table class="table1" width="100%">
			              <col width="90px" />
			              <col width="60px" />
			              <col width="100%" />
			              <tbody>
			                <tr valign="center" style="font-weight: bold">
			                  <td class="ThinBorderRight ThinBorderBottom"  colspan="2" height="45px" valign="bottom">
			                    <img src="images/logo_black_New.gif"/>
			                  </td>
			                  <td class="ThinBorderBottom"
			                      style="font-family: Monospace; font-size: 11pt; text-align: right">
								<div class="bolValue">
					              <div>
					                <xsl:value-of select="MSGS/M3" />
					              </div>
					              <div>
					                <xsl:value-of select="MSGS/M4" />
					              </div>
					            </div>
			                  </td>
			                </tr>
			              </tbody>
			            </table>
			          </td>
			        </tr>

			        <!-- Second row -->
			        <tr id="bolRow">
			          <xsl:attribute name="class">bolRowHeight</xsl:attribute>
			          <td class="ThinBorderBottom">
			            <div class="bolName">
			             Nome do Cliente
			            </div>
			            <div class="bolValue">
			              <div>
			                <xsl:value-of select="@NC" />
			              </div>
			            </div>
			          </td>
			        </tr>

			        <!-- third row -->
			        <tr id="bolRow">
			          <td class="ThinBorderBottom">
			            <table class="table1" width="100%">
			              <col width="200px" />
			              <col width="125px" />
			              <col width="125px" />
			              <col width="125px" />
			              <col width="100%" />
			              <tbody>
			                <tr class="bolRowHeight" id="bolRow">
			                  <td class="ThinBorderRight">
			                    <div class="bolName">
			                      Identificação de Débito Automático
			                    </div>
			                    <div class="bolValue">
			                      <xsl:value-of select="@IDDA" />
			                    </div>
			                  </td>
			                  <td class="ThinBorderRight">
			                    <div class="centeredBolName">
			                      Mês de Referência
			                    </div>
			                    <div class="centeredBolValue">
			                      <xsl:value-of select="@MR" />
			                    </div>
			                  </td>
			                  <td class="ThinBorderRight">
			                    <div class="centeredBolName">
			                      Data de Emissão
			                    </div>
			                    <div class="centeredBolValue">
			                      <xsl:value-of select="@DE" />
			                    </div>
			                  </td>
			                  <td class="ThinBorderRight">
			                    <div class="centeredBolName">
			                      Data de Vencimento
			                    </div>
			                    <div class="centeredBolValue">
			                      <xsl:value-of select="@DV" />
			                    </div>
			                  </td>
			                  <td>
			                    <div class="centeredBolName">
			                      Valor
			                    </div>
			                    <div class="centeredBolValue">
			                      <xsl:value-of select="@V" />
			                    </div>
			                  </td>
			                </tr>
			              </tbody>
			            </table>
			          </td>
			        </tr>

			      </tbody>
			    </table>

			    <table class="bolName" border="0" width="700px" height="49px">

		             <tr>
		               <td style="width: 400px;">
		                 <div style="text-align: left; font-size: 10pt">
							<xsl:value-of select="@LD" />
		                 </div>
		               </td>
		               <td>
		               	<div style="text-align: center; font-size: 7pt">Autenticação Mecânica</div>
		          	   </td>
		             </tr>
			        <tr>
			          <td colspan="2">
			            <xsl:if test="$show_bar_code">
			              <div>
			                <script type="text/vbscript">
			                  document.write(WBarCode("<xsl:value-of select="@CBB"/>"))
			                </script>
			              </div>
			            </xsl:if>
			          </td>
			        </tr>
			    </table>
			</td>
		</tr>
	</table>
  </xsl:template>

</xsl:stylesheet>