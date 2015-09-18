<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



  <xsl:template name="getBoletoType">
    <xsl:choose>
      <xsl:when test="count(ITENS) = 1">
        <xsl:text>C</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>D</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="COMPRAS">
    <xsl:value-of select="$CP_startKey" />
    <xsl:variable name="type">
      <xsl:call-template name="getBoletoType"/>
    </xsl:variable>
    <xsl:value-of select="$type" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:choose>
      <xsl:when test="$type = 'D'">
        <xsl:apply-templates select="ITENS/IT" mode="compras">
          <xsl:with-param name="itemPrefix" select="concat($CP_prefix,$BO_C_prefix)"/>
        </xsl:apply-templates>
        <xsl:value-of select="concat($CP_prefix,$BO_C_prefix,$BO_endKey)" />
        <xsl:value-of select="@T" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:when>
    </xsl:choose>
    
    <xsl:variable name="itemPrefix">
      <xsl:choose>
        <xsl:when test="$type = 'D'">
          <xsl:value-of select="concat($CP_prefix,$BO_D_prefix)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($CP_prefix,$BO_C_prefix)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="ITENS">
      <xsl:apply-templates select="BOLETO">
        <xsl:with-param name="key-prefix" select="$itemPrefix" />
      </xsl:apply-templates>
      <xsl:apply-templates select="IT" mode="compras">
        <xsl:with-param name="itemPrefix" select="$itemPrefix"/>
      </xsl:apply-templates>
      <xsl:value-of select="concat($itemPrefix,$BO_endKey)" />
      <xsl:value-of select="@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@V" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:for-each>

    <xsl:value-of select="$CP_endKey" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="IT" mode="compras">
    <xsl:param name="itemPrefix"/>
    <xsl:value-of select="concat($itemPrefix,$BO_itemKey)" />
    <xsl:value-of select="@DT" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DS" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@QT" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@LO" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NF" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@T" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="concat(@NRP,'/',@QTP)" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:variable name="firstAP" select="AP[position() = 1]" />
    <xsl:value-of select="$firstAP/@IMEI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@SIM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@FID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@TEL" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="AP[position() &gt; 1]">
      <xsl:with-param name="keyPrefix" select="$itemPrefix" />
    </xsl:apply-templates>

    <xsl:value-of select="concat($itemPrefix,$BO_itemEndKey)" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="AP">
    <xsl:param name="keyPrefix" />
    <xsl:value-of select="concat($keyPrefix,$BO_apKey)" />
    <xsl:value-of select="@IMEI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@SIM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@FID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@TEL" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="MULTAS">
    <xsl:value-of select="$MT_startKey" />
    <xsl:variable name="type">
      <xsl:call-template name="getBoletoType"/>
    </xsl:variable>
    <xsl:value-of select="$type" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:choose>
      <xsl:when test="$type = 'D'">
        <xsl:apply-templates select="ITENS/IT" mode="multas">
          <xsl:with-param name="itemPrefix" select="concat($MT_prefix,$BO_C_prefix)"/>
        </xsl:apply-templates>
        <xsl:value-of select="concat($MT_prefix,$BO_C_prefix,$BO_endKey)" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:when>
    </xsl:choose>
    
    <xsl:variable name="itemPrefix">
      <xsl:choose>
        <xsl:when test="$type = 'D'">
          <xsl:value-of select="concat($MT_prefix,$BO_D_prefix)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($MT_prefix,$BO_C_prefix)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="ITENS">
      <xsl:apply-templates select="BOLETO">
        <xsl:with-param name="key-prefix" select="$itemPrefix" />
      </xsl:apply-templates>
      <xsl:apply-templates select="IT" mode="multas">
        <xsl:with-param name="itemPrefix" select="$itemPrefix"/>
      </xsl:apply-templates>
      <xsl:value-of select="concat($itemPrefix,$BO_endKey)" />
      <xsl:value-of select="@V" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:for-each>

    <xsl:value-of select="$MT_endKey" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="IT" mode="multas">
    <xsl:param name="itemPrefix"/>
    <xsl:value-of select="concat($itemPrefix,$BO_itemKey)" />
    <xsl:value-of select="@DT" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DS" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:variable name="firstAP" select="AP[position() = 1]" />
    <xsl:value-of select="$firstAP/@IMEI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@SIM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@FID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@TEL" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="AP[position() &gt; 1]">
      <xsl:with-param name="keyPrefix" select="$itemPrefix" />
    </xsl:apply-templates>

    <xsl:value-of select="concat($itemPrefix,$BO_itemEndKey)" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>



  <xsl:template match="NEGOC">
    <xsl:value-of select="$NG_startKey" />
    <xsl:variable name="type">
      <xsl:call-template name="getBoletoType"/>
    </xsl:variable>
    <xsl:value-of select="$type" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:choose>
      <xsl:when test="$type = 'D'">
        <xsl:apply-templates select="ITENS/IT" mode="negoc">
          <xsl:with-param name="itemPrefix" select="concat($NG_prefix,$BO_C_prefix)"/>
        </xsl:apply-templates>
        <xsl:value-of select="concat($NG_prefix,$BO_C_prefix,$BO_endKey)" />
        <xsl:value-of select="@T" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:when>
    </xsl:choose>
    
    <xsl:variable name="itemPrefix">
      <xsl:choose>
        <xsl:when test="$type = 'D'">
          <xsl:value-of select="concat($NG_prefix,$BO_D_prefix)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($NG_prefix,$BO_C_prefix)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="ITENS">
      <xsl:apply-templates select="BOLETO">
        <xsl:with-param name="key-prefix" select="$itemPrefix" />
      </xsl:apply-templates>
      <xsl:apply-templates select="IT" mode="negoc">
        <xsl:with-param name="itemPrefix" select="$itemPrefix"/>
      </xsl:apply-templates>
      <xsl:value-of select="concat($itemPrefix,$BO_endKey)" />
      <xsl:value-of select="@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@V" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:for-each>

    <xsl:value-of select="$NG_endKey" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


  <xsl:template match="IT" mode="negoc">
    <xsl:param name="itemPrefix"/>
    <xsl:value-of select="concat($itemPrefix,$BO_itemKey)" />
    <xsl:value-of select="@DT" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@NR" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@T" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="concat(@NRP,'/',@QTP)" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@V" />
    <xsl:value-of select="$delimiter" />
    <xsl:variable name="firstAP" select="AP[position() = 1]" />
    <xsl:value-of select="$firstAP/@IMEI" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@SIM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@FID" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$firstAP/@TEL" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />

    <xsl:apply-templates select="AP[position() &gt; 1]">
      <xsl:with-param name="keyPrefix" select="$itemPrefix" />
    </xsl:apply-templates>

    <xsl:value-of select="concat($itemPrefix,$BO_itemEndKey)" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>



</xsl:stylesheet>