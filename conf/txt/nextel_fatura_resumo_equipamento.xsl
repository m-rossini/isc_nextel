<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan"
                version="1.0">

    <!-- ***************************** -->
    <!-- * Dados de cada equipamento * -->
    <!-- ***************************** -->
    <xsl:template name="RESUMO-EQUIPAMENTO">

        <!-- Resumo por equipamento -->
        <xsl:for-each select="DETAILS/SUBSCRIBER/CONTRACT">
            <xsl:value-of select="$RE_startKey"/>
	        <xsl:choose>
			    <xsl:when test="@TP = 'AMP'">
	                  <xsl:value-of select="@IMEI"/>
		        </xsl:when>
		        <xsl:otherwise>	                  
	                <xsl:value-of select="@FID"/>
	                <xsl:if test="not(string-length(@FID) = 0)">
	                    <xsl:text>*</xsl:text>
	                </xsl:if>
	                <xsl:value-of select="@MID"/>
	            </xsl:otherwise>
	        </xsl:choose>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="HIFENIZAR">
                <xsl:with-param name="number">
                    <xsl:value-of select="@N"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="substring(@U, 1, $userNameMaxLength)"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="@M"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="@A"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <!-- xsl:with-param name="value" select="SERVICES/SVC[@TP='U' and @ID='DISPP']/@V"/ -->
                <xsl:with-param name="value" select="DISPATCH/@V"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="CALLS/HOME/@V"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="CALLS/ROAMING/@V"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="@O"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:call-template name="VALOR-OU-ZERO">
                <xsl:with-param name="value" select="@T"/>
            </xsl:call-template>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="@ID"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="$newline"/>
        </xsl:for-each>

        <!-- Subtotais -->
        <xsl:value-of select="$RE_endKey"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@M"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@A"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@D"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/HOME/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/ROAMING/@T"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@O"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:call-template name="VALOR-OU-ZERO">
            <xsl:with-param name="value" select="SUMMARY/@S"/>
        </xsl:call-template>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="$newline"/>

        <!-- Serviços adicionais corporativos. Só mostra se houver algum -->
        
        <!-- Ajustes -->
        <xsl:choose>
            <xsl:when test="DETAILS/SUBSCRIBER/OTHER/OCC">
                <!-- Para cada serviço adicional corporativo -->
                <xsl:for-each select="DETAILS/SUBSCRIBER/OTHER/OCC">
                    <xsl:value-of select="$RE_occOtherStartKey"/>
                    <xsl:value-of select="@DT"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="substring(@DS, 1, 60)"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value" select="@V"/>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
                <xsl:value-of select="$RE_occOtherEndKey"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="DETAILS/SUBSCRIBER/OTHER/@T"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$RE_occOtherEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Créditos -->
		<xsl:choose>
            <xsl:when test="DETAILS/SUBSCRIBER/CREDITS/OCC">
                <!-- Para cada serviço adicional corporativo -->
                <xsl:for-each select="DETAILS/SUBSCRIBER/CREDITS/OCC">
                    <xsl:value-of select="$RE_occCreditStartKey"/>
                    <xsl:value-of select="@DT"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="substring(@DS, 1, 60)"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value" select="@V"/>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
                <xsl:value-of select="$RE_occCreditEndKey"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="DETAILS/SUBSCRIBER/CREDITS/@T"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$RE_occCreditEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

		<!-- Juros/Multas -->
		<xsl:choose>
            <xsl:when test="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/OCC">
                <!-- Para cada serviço adicional corporativo -->
                <xsl:for-each select="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/OCC">
                    <xsl:value-of select="$RE_occPenaltyInterestStartKey"/>
                    <xsl:value-of select="@DT"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="substring(@DS, 1, 60)"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:call-template name="VALOR-OU-ZERO">
                        <xsl:with-param name="value" select="@V"/>
                    </xsl:call-template>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
                <xsl:value-of select="$RE_occPenaltyInterestEndKey"/>
                <xsl:call-template name="VALOR-OU-ZERO">
                    <xsl:with-param name="value" select="DETAILS/SUBSCRIBER/PENALTY_INTERESTS/@T"/>
                </xsl:call-template>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$RE_occPenaltyInterestEndKey"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>