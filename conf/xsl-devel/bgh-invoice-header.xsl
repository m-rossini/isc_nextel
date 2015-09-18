<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
	xmlns:number="xalan://br.com.auster.nextel.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:double="xalan://br.com.auster.nextel.xsl.extensions.DoubleFunctions"
    extension-element-prefixes="xalan number aggregates date string sql double"
    exclude-result-prefixes="xalan number aggregates date string sql double"
    version="1.0">



    <xsl:template name="header">

        <xsl:variable name="nr_invoice"   select="null"/>

        <xsl:variable name="customerId"   select="RECIPIENT/@CUSTOMER_ID"/>

        <xsl:variable name="jurdicCode"   select="RFF/REFERENCE[@CODE='GC']/@VALUE1"/>
        <xsl:variable name="costCenterID" select="RFF/REFERENCE[@CODE='CC']/@VALUE1"/>

        <xsl:variable name="costCenter"   select="document('CCToBillType.xml')/document/region[costCenter/@jurdicCode=$jurdicCode]/costCenter[@id=$costCenterID]"/>
        <!-- REGION CODE -->
        <xsl:variable name="cd_location"  select="substring(document('CCToBillType.xml')/document/region[costCenter/@jurdicCode=$jurdicCode]/@code,1,1)"/>
        <!-- INVOICE NUMBER -->
		<xsl:variable name="nr_inv"   select="/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-PAYMENT']/RFF/REFERENCE[@CODE='IV']/@VALUE1"/>

        <!-- INVOICE XML VERSION -->
        <xsl:attribute name="VERSION">
            <xsl:value-of select="'5'"/>
        </xsl:attribute>
        <!-- CUSTOMER ID -->
        <xsl:attribute name="ID">
            <xsl:value-of select="$customerId"/>
        </xsl:attribute>
        <xsl:apply-templates select="NAD[@TYPE='IV']/PARTY" mode="header"/>
        <!-- SPECIAL RULE - REGIME ESPECIAL P/ BOLETO/NOTA FISCAL (Y=Yes/N=No) -->
        <xsl:attribute name="SR">
            <xsl:value-of select="$costCenter/@hasSpecialRule"/>
        </xsl:attribute>
        <!-- COSTCENTER ID -->
        <xsl:attribute name="CID">
            <xsl:value-of select="$costCenterID"/>
        </xsl:attribute>
        <!-- JURISDICTION CODE -->
        <xsl:attribute name="JC">
            <xsl:value-of select="$jurdicCode"/>
        </xsl:attribute>
        <!-- REGION -->
        <xsl:attribute name="CD_LOCATION">
            <xsl:value-of select="$cd_location"/>
        </xsl:attribute>
        <!-- Manutenção MIT -->
        <!-- Tanto OHXACT como NR_INVOICE possuem o mesmo valor, solicitação da equipe de MIT (Possui ISDM) -->
        <!-- INVOICE NUMBER -->
         <!-- <xsl:attribute name="NR_INVOICE"> -->
            <!-- NR_INVOICE = HORA_ATUAL + NR_INVOICE - suprir problema de duplicidade de NR_INVOICE -->
            <!-- <xsl:value-of select="$nr_invoice"/> - OLD --> 
            <!-- <xsl:value-of select="concat(date:getTime(),'0000000000')+ $nr_inv"/> -->
         <!-- </xsl:attribute> -->
        <!-- CITY -->
        <xsl:attribute name="CT">
            <xsl:value-of select="$costCenter/@city"/>
        </xsl:attribute>
        <!-- STATE -->
        <xsl:attribute name="ST">
            <xsl:value-of select="RFF/REFERENCE[@CODE='ST']/@VALUE1"/>
        </xsl:attribute>
        <!-- ISSUE DATE -->
        <xsl:attribute name="I">
            <xsl:call-template name="dateFormat">
                <xsl:with-param name="date" select="DTM/DATE_TIME[@QUALIFIER='3']"/>
                <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
            </xsl:call-template>
        </xsl:attribute>
        <!-- START DATE -->
        <xsl:attribute name="S">
            <xsl:call-template name="dateFormat">
                <xsl:with-param name="date"    select="DTM/DATE_TIME[@QUALIFIER='167']"/>
                <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
            </xsl:call-template>
        </xsl:attribute>
        <!-- END DATE -->
        <xsl:attribute name="E">
            <xsl:call-template name="dateFormat">
                <xsl:with-param name="date"    select="DTM/DATE_TIME[@QUALIFIER='168']"/>
                <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
            </xsl:call-template>
        </xsl:attribute>
        <!-- FINANCIAL CUSTOMER CODE (MAGNUS) -->
        <xsl:attribute name="M">
            <xsl:value-of select="RFF/REFERENCE[@CODE='JD']/@VALUE1"/>
        </xsl:attribute>
        <!-- BILLING CUSTOMER CODE (BSCS) -->
        <xsl:attribute name="B">
            <xsl:value-of select="RFF/REFERENCE[@CODE='IT']/@VALUE1"/>
        </xsl:attribute>
        <!-- INVOICE PAYMENT DEADLINE -->
        <xsl:attribute name="D">
            <xsl:call-template name="dateFormat">
                <xsl:with-param name="date"    select="/TIMM/UNB[BGM/DOCUMENT/@TYPE='BCH-PAYMENT']/DTM/DATE_TIME[@QUALIFIER='13']"/>
                <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
            </xsl:call-template>
        </xsl:attribute>
        <!-- BILLCYCLE NUMBER -->
        <xsl:attribute name="BCN">
            <xsl:value-of select="BGM[DOCUMENT/@INVOICE='380']/TELCO/@CYCLE"/>
        </xsl:attribute>
        <!-- BILLCYCLE DATE -->
        <xsl:attribute name="BCD">
            <xsl:call-template name="dateFormat">
                <xsl:with-param name="date"    select="DTM/DATE_TIME[@QUALIFIER='3']"/>
                <xsl:with-param name="pattern" select="'dd/MM/yyyy'"/>
            </xsl:call-template>
        </xsl:attribute>
        <!-- Manutenção MIT -->
        <!-- Seleciona o valor do OHXACT e NR_INVOICE -->
        <!-- 
            <xsl:variable name="ohxact" select="sql:query('bscs', 'Ohxact', $customerId)"/>        
             -->
        <!-- OHXACT -->
        <!-- Manutenção MIT -->
        <xsl:attribute name="OH">
        <!-- 
            <xsl:value-of select="$ohxact/record/@OHXACT"/>
           -->
        </xsl:attribute>
        <!-- INVOICE NUMBER -->
        <!-- Manutenção MIT --> 
         <xsl:attribute name="NR_INVOICE">
         <!-- 
            <xsl:value-of select="$ohxact/record/@OHXACT"/>
             -->
         </xsl:attribute>
        
    </xsl:template>


    
    <xsl:template match="PARTY" mode="header">
        <!-- CUSTOMER -->  
        <xsl:attribute name="C">
            <xsl:value-of select="@ADDRESS1"/>
        </xsl:attribute>
        <!-- CONTACT NAME -->
        <xsl:attribute name="N">
            <xsl:value-of select="@NAME"/>
        </xsl:attribute>
        <!-- ADDRESS 1 -->
        <xsl:attribute name="A1">
            <xsl:value-of select="@ADDRESS2"/>
        </xsl:attribute>
        <!-- ADDRESS 2 -->
        <xsl:attribute name="A2">
            <xsl:value-of select="@ADDRESS3"/>
        </xsl:attribute>
        <!-- ADDRESS 3 -->
        <xsl:attribute name="A3">
            <xsl:value-of select="@LINE"/>
        </xsl:attribute>
    </xsl:template>


    
</xsl:stylesheet>
