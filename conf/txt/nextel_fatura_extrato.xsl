<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xalan="http://xml.apache.org/xalan"
  exclude-result-prefixes="xalan"
  version="1.0">


  <xsl:template match="EXTRATO">
    <xsl:if test="DEMO or FUT">
      <xsl:value-of select="$EX_startKey" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
      
      <xsl:apply-templates select="DEMO" />
      <xsl:apply-templates select="FUT" />

      <xsl:for-each select="MSGS/M">
        <xsl:value-of select="$EX_msgsKey" />
        <xsl:value-of select="@IM" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
        <xsl:for-each select="xalan:tokenize(text(),'#')">
          <xsl:value-of select="$EX_msgsLineKey" />
          <xsl:value-of select="." />
          <xsl:value-of select="$delimiter" />
          <xsl:value-of select="$newline" />
        </xsl:for-each>
      </xsl:for-each>

      <xsl:value-of select="$EX_endKey" />
      <xsl:value-of select="DEMO/BAL/@IM" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="DEMO/BAL/@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="DEMO/@IM" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="DEMO/@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>
  </xsl:template>


  <xsl:template match="DEMO">
  
    <xsl:apply-templates select="BAL"/>
    
    <xsl:if test="ATUAL">
      <xsl:for-each select="ATUAL/GRP/IT">
        <xsl:value-of select="$EX_atualKey" />
        <xsl:value-of select="@DS" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@NB" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:for-each>
      <xsl:value-of select="$EX_atualEndKey" />
      <xsl:value-of select="ATUAL/@IM" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="ATUAL/GRP/@DT" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="ATUAL/GRP/@DV" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="ATUAL/@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>
    
  </xsl:template>
  
  
  <xsl:template match="BAL">
    <xsl:if test="DEV">
      <xsl:for-each select="DEV/IT">
        <xsl:value-of select="$EX_devKey" />
        <xsl:value-of select="@DS" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:for-each>
      <xsl:value-of select="$EX_devEndKey" />
      <xsl:value-of select="DEV/@IM" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="DEV/@DT" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="DEV/@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>
    <xsl:if test="PGTO">
      <xsl:for-each select="PGTO/IT">
        <xsl:value-of select="$EX_pgtoKey" />
        <xsl:value-of select="@DS" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@VF" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@VP" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="@V" />
        <xsl:value-of select="$delimiter" />
        <xsl:value-of select="$newline" />
      </xsl:for-each>
      <xsl:value-of select="$EX_pgtoEndKey" />
      <xsl:value-of select="PGTO/@IM" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="PGTO/@DT" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="PGTO/@T" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:if>
  </xsl:template>


  <xsl:template match="FUT">
    <xsl:for-each select="IT">
      <xsl:value-of select="$EX_futKey" />
      <xsl:value-of select="@DS" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@NRP" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@NRPV" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@VPV" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="@V" />
      <xsl:value-of select="$delimiter" />
      <xsl:value-of select="$newline" />
    </xsl:for-each>
    <xsl:value-of select="$EX_futEndKey" />
    <xsl:value-of select="@IM" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@DT" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="@T" />
    <xsl:value-of select="$delimiter" />
    <xsl:value-of select="$newline" />
  </xsl:template>


</xsl:stylesheet>