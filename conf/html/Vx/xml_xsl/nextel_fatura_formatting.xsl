<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:include href="../xml_txt/nextel_fatura_financials.xsl"/>

  <xsl:variable name="newline" select="'&#10;'" />
  
  <xsl:variable name="blanks"    select="'                                                                                                                                                      '"/>
  <xsl:variable name="rule"      select="'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'"/>
  <xsl:variable name="thickRule" select="'============================================================================================================================================================================================================================================================================================================'"/>
  <xsl:variable name="titleRule" select="'############################################################################################################################################################################################################################################################################################################'"/>
  <xsl:variable name="lineWidth" select="120"/>
  <xsl:variable name="HR" select="substring($rule,1,$lineWidth)"/>
  <xsl:variable name="THICK-HR" select="substring($thickRule,1,$lineWidth)"/>
  <xsl:variable name="TITLE-HR" select="substring($titleRule,1,$lineWidth)"/>
  
  <xsl:variable name="colSep" select="'^'"/>
  <xsl:variable name="spacer" select="'&#9;'"/>
  
  
  <!-- ############################### -->
  <!-- 2-column tables                 -->
  <!-- ############################### -->
  
  <xsl:template name="format2Col">
    <xsl:param name="col-1"/>
    <xsl:param name="col-2"/>
    <xsl:value-of select="concat($col-1,$spacer,$col-2)"/>
    <!-- 
    <xsl:call-template name="printAsString">
      <xsl:with-param name="text" select="$col-1"/>
    </xsl:call-template>
    <xsl:value-of select="$spacer"/>
    <xsl:call-template name="printAsString">
      <xsl:with-param name="text" select="$col-2"/>
    </xsl:call-template>
     -->
  </xsl:template>
  
  
  <!-- ############################### -->
  <!-- Multi-column tables             -->
  <!-- ############################### -->
    
  <xsl:template name="getFixedWidths">
    <xsl:param name="widths"/>
    <xsl:param name="width" select="$lineWidth"/>
    <xsl:param name="totalWidth" select="0"/>
    <xsl:param name="isFirst" select="true()"/>
    <!-- do nothing for .xls generation -->
  </xsl:template>


  <xsl:template name="formatFixedCols">
    <xsl:param name="cols" />
    <xsl:param name="fixed-widths" />
    <xsl:param name="width" select="$lineWidth" />
    <xsl:param name="totalWidth" select="0" />
    <xsl:param name="isFirst" select="true()" />
    <xsl:call-template name="formatCol">
      <xsl:with-param name="cols" select="$cols" />
      <xsl:with-param name="widths" select="$fixed-widths" />
      <xsl:with-param name="width" select="$width" />
      <xsl:with-param name="totalWidth" select="$totalWidth" />
      <xsl:with-param name="isFirst" select="$isFirst" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="formatCol">
    <xsl:param name="cols"/>
    <xsl:param name="widths"/>
    <xsl:param name="width" select="$lineWidth"/>
    <xsl:param name="totalWidth" select="0"/>
    <xsl:param name="isFirst" select="true()"/>
    <xsl:variable name="hasMoreCols" select="contains($cols,$colSep)"/>
    <xsl:variable name="col">
      <xsl:choose>
        <xsl:when test="$hasMoreCols">
          <xsl:value-of select="substring-before($cols,$colSep)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$cols"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$col"/>
    <!-- 
    <xsl:call-template name="printAsString">
      <xsl:with-param name="text" select="$col"/>
    </xsl:call-template>
     -->
    <xsl:if test="$hasMoreCols">
      <xsl:value-of select="$spacer"/>
      <xsl:call-template name="formatCol">
        <xsl:with-param name="cols" select="substring-after($cols,$colSep)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <!-- ############################### -->
  <!-- Simple text formatting          -->
  <!-- ############################### -->
  
  <!--  não utilizado pelos arquvos .xls -->
  <xsl:template name="formatCenter">
    <xsl:param name="text"/>
    <xsl:param name="width" select="$lineWidth"/>
    <xsl:value-of select="$text"/>
    <!-- 
    <xsl:call-template name="printAsString">
      <xsl:with-param name="text" select="$text"/>
    </xsl:call-template>
     -->
  </xsl:template>
  
  <xsl:template name="formatText">
    <xsl:param name="text"/>
    <xsl:param name="width" select="$lineWidth" />
    <xsl:choose>
      <xsl:when test="contains($text,'#')">
        <xsl:call-template name="formatParagraph">
          <xsl:with-param name="text" select="substring-before($text,'#')"/>
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
        <xsl:value-of select="$newline" />
        <xsl:call-template name="formatText">
          <xsl:with-param name="text" select="substring-after($text,'#')"/>
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formatParagraph">
          <xsl:with-param name="text" select="$text"/>
          <xsl:with-param name="width" select="$width" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatParagraph">
    <xsl:param name="text" />
    <xsl:param name="width" select="$lineWidth" />
    <xsl:call-template name="formatLine">
      <xsl:with-param name="text" select="normalize-space($text)" />
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="formatLine">
    <xsl:param name="text" />
    <xsl:param name="buffer" />
    <xsl:param name="bufferLength" select="0" />
    <xsl:param name="width" select="$lineWidth" />
    <xsl:variable name="previous" select="substring-before($text,' ')" />
    <xsl:variable name="previousLength" select="string-length($previous)" />
    <xsl:variable name="next" select="substring-after($text,' ')" />
    <xsl:choose>
      <xsl:when test="($bufferLength + $previousLength + 1) &gt; $width">
        <xsl:value-of select="$buffer" />
        <xsl:value-of select="$newline" />
        <xsl:call-template name="formatLine">
          <xsl:with-param name="text" select="$next" />
          <xsl:with-param name="buffer" select="$previous" />
          <xsl:with-param name="bufferLength" select="$previousLength" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="not($previous) or not($next)">
        <xsl:if test="$buffer">
          <xsl:value-of select="concat($buffer,' ')" />
          <xsl:if test="($bufferLength + string-length($text) + 1) &gt; $width">
            <xsl:value-of select="$newline" />
          </xsl:if>
        </xsl:if>
        <xsl:value-of select="$text" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formatLine">
          <xsl:with-param name="text" select="$next" />
          <xsl:with-param name="buffer">
            <xsl:if test="$buffer">
              <xsl:value-of select="concat($buffer,' ')" />
            </xsl:if>
            <xsl:value-of select="$previous" />
          </xsl:with-param>
          <xsl:with-param name="bufferLength">
            <xsl:choose>
              <xsl:when test="$buffer">
                <xsl:value-of select="$bufferLength + 1 + $previousLength" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$previousLength" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="printTitle">
    <xsl:param name="text"/>
    <xsl:value-of select="$TITLE-HR"/>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$text"/>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$TITLE-HR"/>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>
  
  
  <xsl:template name="printTotal">
    <xsl:param name="text"/>
    <xsl:param name="total"/>
    <xsl:value-of select="$THICK-HR"/>
    <xsl:value-of select="$newline" />
    <xsl:call-template name="format2Col">
      <xsl:with-param name="col-1" select="$text"/>
      <xsl:with-param name="col-2" select="$total" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$THICK-HR"/>
    <xsl:value-of select="$newline" />
    <xsl:value-of select="$newline" />
  </xsl:template>
  
  
  <xsl:template name="printAsString">
    <xsl:param name="text"/>
    <xsl:value-of select="concat('&#x0022;',$text,'&#x0022;')"/>
  </xsl:template>

</xsl:stylesheet>