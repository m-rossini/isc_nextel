<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
  <!-- %% DECLARAÇÕES GLOBAIS        -->
  <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
  <!-- Number formatting -->
  <xsl:decimal-format decimal-separator="," grouping-separator="."/>

  <!-- Borders & Rules -->
  <xsl:variable name="defaultRuleWidth" select="'0.3pt'"/>
  <xsl:attribute-set name="ThinBorderBefore">
    <xsl:attribute name="border-before-style">solid</xsl:attribute>
    <xsl:attribute name="border-before-width">0.1mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ThinBorderAfter">
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">0.1mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ThinBorder"
                     use-attribute-sets="ThinBorderBefore ThinBorderAfter"/>

  <!-- Colors -->
  <xsl:variable name="color_darkgray" select="'#999999'"/>
  <xsl:variable name="color_midgray" select="'#b2b2b2'"/>
  <xsl:variable name="color_gray" select="'#cccccc'"/>
  <xsl:variable name="color_lightgray" select="'#e5e5e5'"/>

  <!-- Heights -->
  <xsl:variable name="detalhe_boleto_height" select="'7mm'"/>

  <!-- Fonts -->
  <xsl:attribute-set name="DefaultFontFamily">
    <xsl:attribute name="font-family">Helvetica</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="DefaultRowFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">13pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ExtratoIntroFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">8.5pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ExtratoMessagesFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">7pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ExtratoInfoFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="BoletoNameFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">5.5pt</xsl:attribute>
    <xsl:attribute name="start-indent">1mm</xsl:attribute>
    <xsl:attribute name="padding-top">0.5mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="BoletoValueFont"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">6.5pt</xsl:attribute>
    <xsl:attribute name="start-indent">1mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="CenteredBoletoNameFont"
                     use-attribute-sets="BoletoValueFont">
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="CenteredBoletoValueFont"
                     use-attribute-sets="BoletoValueFont">
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="TableEndCell"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="padding-end">1mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="TableMiddleCell"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="text-align">right</xsl:attribute>
    <!--
    <xsl:attribute name="padding-end">4mm</xsl:attribute>
     -->
  </xsl:attribute-set>
  <xsl:attribute-set name="BoletoCellBorders">
    <xsl:attribute name="border-right-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="ExtratoTableTitleRow"
                     use-attribute-sets="DefaultRowFont">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="line-height">6mm</xsl:attribute>
    <xsl:attribute name="color">white</xsl:attribute>
    <xsl:attribute name="background-color">
      <xsl:value-of select="$color_darkgray"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ExtratoTableTitleTable"
                     use-attribute-sets="ExtratoTableTitleRow">
    <xsl:attribute name="space-before">1mm</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="ExtratoTableRow"
                     use-attribute-sets="DefaultRowFont">
  </xsl:attribute-set>

  <xsl:attribute-set name="ExtratoTableHeaderRow"
                     use-attribute-sets="ExtratoTableRow">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="ExtratoTotalsTable"
                     use-attribute-sets="DefaultRowFont">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="border-before-style">solid</xsl:attribute>
    <xsl:attribute name="border-before-width">0.4mm</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">0.4mm</xsl:attribute>
    <xsl:attribute name="padding-top">0.5mm</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="DetalhesTableRow"
                     use-attribute-sets="DefaultFontFamily">
    <xsl:attribute name="font-size">6.5pt</xsl:attribute>
    <xsl:attribute name="line-height">9pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="DetalhesTableBorderRight">
    <xsl:attribute name="border-right-style">solid</xsl:attribute>
    <xsl:attribute name="border-right-width">0.2mm</xsl:attribute>
    <xsl:attribute name="border-right-color">white</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="DetalhesTableBorderBottom">
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-width">0.2mm</xsl:attribute>
    <xsl:attribute name="border-bottom-color">white</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="DetalhesTablePadding">
    <xsl:attribute name="padding">0.5mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:variable name="userNameMaxLength" select="15"/>

</xsl:stylesheet>