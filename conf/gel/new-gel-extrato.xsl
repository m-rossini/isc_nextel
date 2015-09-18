<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt" 
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
  extension-element-prefixes="xalan string" 
  exclude-result-prefixes="lxslt xalan string"
  version="1.0">

  <xsl:variable name="devSum" select="sum(/GEL/BILL/DEV/@V) div 100"/>
  <xsl:variable name="pgtoSum" select="sum(/GEL/BILL/PGTO/@V) div 100"/>
  <xsl:variable name="atualSum" select="sum(/GEL/BILL/ATUAL/@V) div 100"/>
  <xsl:variable name="futSum" select="sum(/GEL/BILL/FUT/@V) div 100"/>

  <xsl:template name="EXTRATO">
    <xsl:variable name="null" select="string:setValue('IM', '0')" />
    <xsl:variable name="null" select="string:setValue('IM-BAL', '0')" />
    <xsl:variable name="null" select="string:setValue('IM-ATUAL', '0')" />
    <xsl:variable name="null" select="string:setValue('IM-DEMO', '0')" />
    <xsl:variable name="null" select="string:setValue('IM-FUT', '0')" />
    <EXTRATO>
      <xsl:if test="DEV or PGTO or ATUAL">
        <xsl:call-template name="EXT-DEMO" />
      </xsl:if>
      <xsl:if test="FUT">
        <xsl:call-template name="EXT-FUT" />
      </xsl:if>
      <MSGS>
        <M>
          <xsl:text>Caro cliente, os valores descritos no extrato são </xsl:text>
          <xsl:text>transações realizadas através de boleto ou cheque. </xsl:text>
          <xsl:text>Transações realizadas pelo cartão de crédito não são consideradas.</xsl:text>
        </M>
        <xsl:if test="string:getValue('IM-BAL') != '0'">
          
          <M>
            <xsl:attribute name="IM">
              <xsl:value-of select="string:getValue('IM-BAL')" />
            </xsl:attribute>
            <xsl:text>Constam em aberto em nossos sistemas, até a data de emissão desta </xsl:text>
            <xsl:text>fatura, os valores dos títulos descritos acima. Para mais informações, </xsl:text>
            <xsl:text>ligue em nossa Central de Atendimento *611 grátis do </xsl:text>
            <xsl:text>seu Nextel ou 4004-6611 (Tarifa Local). Caso os valores </xsl:text>
            <xsl:text>já tenham sido pagos, desconsiderar essas informações.</xsl:text>
          </M>
        </xsl:if>
        <xsl:if test="string:getValue('IM-ATUAL') != '0'">
          
          <M>
            <xsl:attribute name="IM">
              <xsl:value-of select="string:getValue('IM-ATUAL')" />
            </xsl:attribute>
            <xsl:text>O(s) boleto(s) enviado(s) nessa fatura não contempla(m) os </xsl:text>
            <xsl:text>saldos em aberto (caso existam) de faturas anteriores. </xsl:text>
            <xsl:text>O pagamento desta fatura não quita débitos anteriores.</xsl:text>
          </M>
        </xsl:if>
        <xsl:if test="string:getValue('IM-DEMO') != '0'">
          <M>
            <xsl:attribute name="IM">
              <xsl:value-of select="string:getValue('IM-DEMO')" />
            </xsl:attribute>
            <xsl:text>Demonstrativo de saldos em aberto de meses </xsl:text>
            <xsl:text>anteriores mais os valores da Fatura Atual.</xsl:text>
          </M>
        </xsl:if>
        <xsl:if test="string:getValue('IM-FUT') != '0'">
          <M>
            <xsl:attribute name="IM">
              <xsl:value-of select="string:getValue('IM-FUT')" />
            </xsl:attribute>
            <xsl:text>Constam em nossos sistemas Lançamentos Futuros conforme </xsl:text>
            <xsl:text>negociações anteriores referentes a valores em aberto </xsl:text>
            <xsl:text>e/ou compra de aparelhos e acessórios. </xsl:text>
            <xsl:text>Pagamentos efetuados com cheque somente serão </xsl:text>
            <xsl:text>considerados quitados após a compensação.</xsl:text>
          </M>
        </xsl:if>
        <M>
          <xsl:text>Qualquer dúvida ou para pagamento de saldos anteriores </xsl:text>
          <xsl:text>entre em contato com nossa Central de Atendimento ao </xsl:text>
          <xsl:text>Cliente *611 grátis do seu Nextel ou 4004-6611 (Tarifa Local). </xsl:text>
          <xsl:text>Informações detalhadas da fatura disponíveis também no site www.nextel.com.br.</xsl:text>
        </M>
      </MSGS>
    </EXTRATO>
  </xsl:template>

  <xsl:template name="EXT-DEMO">
  
    <!-- indice de mensagens -->
    <xsl:if test="(DEV and $devSum != 0) or (PGTO and $pgtoSum != 0)">
      <xsl:variable name="null" select="string:setValue('IM-BAL', string:setValue('IM', string:getValue('IM') + 1))"/>
    </xsl:if>
    <xsl:if test="ATUAL and $atualSum != 0">
      <xsl:variable name="null" select="string:setValue('IM-ATUAL', string:setValue('IM', string:getValue('IM') + 1))"/>
    </xsl:if>
    <xsl:if test="(DEV and $devSum != 0) or (PGTO and $pgtoSum != 0) or (ATUAL and $atualSum != 0)">
      <xsl:variable name="null" select="string:setValue('IM-DEMO', string:setValue('IM', string:getValue('IM') + 1))"/>
    </xsl:if>
    
    <DEMO>
      <xsl:attribute name="T">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="$devSum + $pgtoSum + $atualSum" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:if test="string:getValue('IM-DEMO') != '0'">
        <xsl:attribute name="IM">
          <xsl:value-of select="string:getValue('IM-DEMO')" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="DEV or PGTO">
        <BAL>
          <xsl:attribute name="T">
            <xsl:call-template name="decimalFormat">
              <xsl:with-param name="value" select="$devSum + $pgtoSum" />
            </xsl:call-template>
          </xsl:attribute>
          <!-- NAO VAI TER POR ENQUANTO
          <xsl:attribute name="IM">
            <xsl:value-of select="string:getValue(('IM-BAL')" />
          </xsl:attribute>
          -->

          <xsl:if test="DEV">
            <DEV>
              <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                  <xsl:with-param name="value" select="$devSum" />
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="DT">
                <xsl:value-of select="DEV/@DT" />
              </xsl:attribute>
              <xsl:if test="$devSum != 0 and string:getValue('IM-BAL') != '0'">
                <xsl:attribute name="IM">
                  <xsl:value-of select="string:getValue('IM-BAL')" />
                </xsl:attribute>
              </xsl:if>
              <xsl:apply-templates select="DEV" />
            </DEV>
          </xsl:if>

          <xsl:if test="PGTO">
            <PGTO>
              <xsl:attribute name="T">
                <xsl:call-template name="decimalFormat">
                  <xsl:with-param name="value" select="$pgtoSum" />
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="DT">
                <xsl:value-of select="PGTO/@DT" />
              </xsl:attribute>
              <xsl:if test="$pgtoSum != 0 and string:getValue('IM-BAL') != '0'">
                <xsl:attribute name="IM">
                  <xsl:value-of select="string:getValue('IM-BAL')" />
                </xsl:attribute>
              </xsl:if>
              <xsl:apply-templates select="PGTO" />
            </PGTO>
          </xsl:if>
        </BAL>
      </xsl:if>

      <ATUAL>
        <xsl:attribute name="T">
          <xsl:call-template name="decimalFormat">
            <xsl:with-param name="value" select="$atualSum" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:if test="string:getValue('IM-ATUAL') != '0'">
          <xsl:attribute name="IM">
            <xsl:value-of select="string:getValue('IM-ATUAL')" />
          </xsl:attribute>
        </xsl:if>
        <GRP>
          <xsl:attribute name="DT">
            <xsl:value-of select="ATUAL/@DT" />
          </xsl:attribute>
          <xsl:attribute name="DV">
            <xsl:value-of select="ATUAL/@DV" />
          </xsl:attribute>
          <xsl:apply-templates select="ATUAL" />
        </GRP>
      </ATUAL>
    </DEMO>
  </xsl:template>

  <xsl:template match="DEV">
    <IT>
      <xsl:attribute name="DS">
        <xsl:value-of select="@DS" />
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </IT>
  </xsl:template>

  <xsl:template match="PGTO">
    <IT>
      <xsl:attribute name="DS">
        <xsl:value-of select="@DS" />
      </xsl:attribute>
      <xsl:attribute name="VF">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@VF div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="VP">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@VP div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </IT>
  </xsl:template>

  <xsl:template match="ATUAL">
    <IT>
      <xsl:attribute name="DS">
        <xsl:value-of select="@DS" />
      </xsl:attribute>
      <xsl:attribute name="NB">
        <xsl:value-of select="@NB" />
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </IT>
  </xsl:template>

  <xsl:template name="EXT-FUT">
    <FUT>
      <xsl:attribute name="T">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="$futSum" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="DT">
        <xsl:value-of select="FUT/@DT" />
      </xsl:attribute>
      <xsl:if test="FUT and $futSum != 0">
        <xsl:variable name="null" select="string:setValue('IM-FUT', string:setValue('IM', string:getValue('IM') + 1))"/>
        <xsl:attribute name="IM">
          <xsl:value-of select="string:getValue('IM-FUT')" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="FUT" />
    </FUT>
  </xsl:template>

  <xsl:template match="FUT">
    <IT>
      <xsl:attribute name="DS">
        <xsl:value-of select="@DS" />
      </xsl:attribute>
      <xsl:attribute name="NRP">
        <xsl:value-of select="@NRP" />
      </xsl:attribute>
      <xsl:attribute name="NRPV">
        <xsl:value-of select="@NRPV" />
      </xsl:attribute>
      <xsl:attribute name="VPV">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@VPV div 100"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="V">
        <xsl:call-template name="decimalFormat">
          <xsl:with-param name="value" select="@V div 100"/>
        </xsl:call-template>
      </xsl:attribute>
    </IT>
  </xsl:template>

</xsl:stylesheet>
