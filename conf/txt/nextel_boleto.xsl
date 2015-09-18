<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:barcode="xalan://br.com.auster.nextel.xsl.extensions.BarCode"
                xmlns:phonenumber="xalan://br.com.auster.nextel.xsl.extensions.PhoneNumber"
                exclude-result-prefixes="xalan barcode phonenumber"
                version="1.0">

    <xsl:template match="BILL">

        <xsl:variable name="jurdicCode"   select="/INVOICE/CUSTOMER/@JC"/>
        <xsl:variable name="costCenterID" select="/INVOICE/CUSTOMER/@CID"/>

        <xsl:value-of select="$BO_startKey"/>
        <xsl:choose>
            <xsl:when test="/INVOICE/CUSTOMER/@SR = 'Y'">
                <xsl:text>S</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>N</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="PRINT-LINEFEED"/>

        <xsl:if test="SERVICES">

            <xsl:if test="SERVICES/FIRST">
                <xsl:value-of select="$BO_firstServiceRecordKey"/>
                <xsl:apply-templates select="SERVICES/FIRST"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

            <xsl:if test="SERVICES/SECOND">
                <xsl:value-of select="$BO_secondServiceRecordKey"/>
                <xsl:apply-templates select="SERVICES/SECOND"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

        </xsl:if>

        <xsl:if test="TELECOM">

            <xsl:if test="TELECOM/FIRST">
                <xsl:value-of select="$BO_firstTelecomRecordKey"/>
                <xsl:apply-templates select="TELECOM/FIRST"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

            <xsl:if test="TELECOM/SECOND">
                <xsl:value-of select="$BO_secondTelecomRecordKey"/>
                <xsl:apply-templates select="TELECOM/SECOND"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

            <xsl:if test="TELECOM/THIRD">
                <xsl:value-of select="$BO_thirdTelecomRecordKey"/>
                <xsl:apply-templates select="TELECOM/THIRD"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

            <xsl:for-each select="TELECOM/FOURTH">
                <xsl:value-of select="$BO_fourthTelecomRecordKey"/>
                <xsl:apply-templates select="."/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:for-each>

            <xsl:if test="TELECOM/FIFTH">
                <xsl:value-of select="$BO_fifthTelecomRecordKey"/>
                <xsl:apply-templates select="TELECOM/FIFTH"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

            <xsl:if test="TELECOM/SIXTH">
                <xsl:value-of select="$BO_sixthTelecomRecordKey"/>
                <xsl:apply-templates select="TELECOM/SIXTH"/>
                <xsl:call-template name="PRINT-LINEFEED"/>
            </xsl:if>

        </xsl:if>

    </xsl:template>



    <xsl:template match="FIRST">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@AC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@RSE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CB"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NB"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CM"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DM"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@C"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CBDV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@FV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@LP1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@LP2"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IB1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IB2"/>
        <xsl:value-of select="$delimiter"/>
<!-- EHO: abatimento e desconto -->        
        <xsl:value-of select="@IB3"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@PT"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@PH"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@PV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@TIMP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@BSCS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NBSCS"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>



    <xsl:template match="SECOND">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@ND"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@P"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NN"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CL"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="VO/@INT"/>
            <xsl:with-param name="decimalPart" select="VO/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CED"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@E"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@B"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CEP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CI"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@ES"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@S"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IB1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IB2"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IB3"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@BSCS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@LD"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="barcode:buildBarCode(@CBB)"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:value-of select="$delimiter"/>
<!--   EHO: abatimento e desconto  - Retenção de 9,45% - Cliente Governo   --> 
          <xsl:value-of select="@VDA"/>    
          <xsl:value-of select="$delimiter"/>    
        <xsl:value-of select="@NBSCS"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>



    <xsl:template match="THIRD">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:if test="../SIXTH/@HC">
            <xsl:value-of select="../FOURTH/@NN"/>
        </xsl:if>
        <xsl:if test="not(../SIXTH/@HC)">
            <xsl:value-of select="@NN"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@S"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(N/text())"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="N/@E"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="N/@NO"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@PV"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@EC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CEP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@C"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGCC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IEC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DIP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DFP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@VE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="BCICMS/@INT"/>
            <xsl:with-param name="decimalPart" select="BCICMS/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>

        <xsl:if test="number($date) &gt;= number($dateFIX)">
            <xsl:text>Vide*</xsl:text>
        </xsl:if>
        <xsl:if test="number($date) &lt; number($dateFIX)">
            <xsl:call-template name="BUILD-NUMBER">
                <xsl:with-param name="integerPart" select="AICMS/@INT"/>
                <xsl:with-param name="decimalPart" select="AICMS/@DEC"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="VICMS/@INT"/>
            <xsl:with-param name="decimalPart" select="VICMS/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="VTN/@INT"/>
            <xsl:with-param name="decimalPart" select="VTN/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGCE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IEE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@UFC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CFO"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@UFE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@ST"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CUF1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CUF2"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NP"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@BSCS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@OB1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@OB2"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@OB3"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@OB4"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@M1"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@M2"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NBSCS"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>



    <xsl:template match="FOURTH">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NN"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@S"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@SI"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@DI"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="QI/@INT"/>
            <xsl:with-param name="decimalPart" select="QI/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="VU/@INT"/>
            <xsl:with-param name="decimalPart" select="VU/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="BUILD-NUMBER">
            <xsl:with-param name="integerPart" select="VTI/@INT"/>
            <xsl:with-param name="decimalPart" select="VTI/@DEC"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGCE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IEE"/>
        <xsl:if test="number($date) &gt;= number($dateFIX)">
            <xsl:value-of select="$delimiter"/>
            <xsl:if test="not(AII/@DEC = '')">
                <xsl:call-template name="BUILD-NUMBER">
                    <xsl:with-param name="integerPart" select="AII/@INT"/>
                    <xsl:with-param name="decimalPart" select="AII/@DEC"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@BSCS"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NBSCS"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>



    <xsl:template match="FIFTH">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@NN"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@S"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CC"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@CGCE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@IEE"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@M"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@BSCS"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>

    <xsl:template match="SIXTH">
        <xsl:value-of select="@TR"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="@HC"/>
        <xsl:value-of select="$delimiter"/>
    </xsl:template>


    <!-- Monta um número a partir de uma parte inteira e outra decimal -->
    <xsl:template name="BUILD-NUMBER">
        <xsl:param name="integerPart" select="'0'"/>
        <xsl:param name="decimalPart" select="'00'"/>
        <xsl:value-of select="concat($integerPart, $decimalSeparator, $decimalPart)"/>
    </xsl:template>



</xsl:stylesheet>