<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lxslt="http://xml.apache.org/xslt"
	xmlns:number="xalan://br.com.auster.common.xsl.extensions.NumberVariable"
    xmlns:aggregates="xalan://br.com.auster.nextel.xsl.extensions.Aggregates"
    xmlns:sql="xalan://br.com.auster.common.xsl.extensions.SQL"
    xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
    xmlns:date="xalan://br.com.auster.nextel.xsl.extensions.BGHDateVariable"
    xmlns:xalan="http://xml.apache.org/xalan"
    extension-element-prefixes="xalan number aggregates date string sql"
    exclude-result-prefixes="xalan number string date sql aggregates"
    version="1.0">

    <xsl:template name="header">

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
        <!-- INVOICE NUMBER -->
        <xsl:attribute name="NR_INVOICE">
            <!-- NR_INVOICE = HORA_ATUAL + NR_INVOICE - suprir problema de duplicidade de NR_INVOICE -->
            <!-- <xsl:value-of select="$nr_invoice"/> - OLD -->
            <xsl:value-of select="concat(date:getTime(),'0000000000')+ $nr_inv"/>
        </xsl:attribute>
        <!-- CITY -->
        <xsl:attribute name="CT">
            <xsl:value-of select="$costCenter/@city"/>
            <!-- xsl:value-of select="sql:getField('bscs', 'CityByCustomer', 'city', $customerId)"/ -->
        </xsl:attribute>
        <!-- STATE -->
        <xsl:attribute name="ST">
            <xsl:value-of select="RFF/REFERENCE[@CODE='ST']/@VALUE1"/>
        </xsl:attribute>
        <!-- ISSUE DATE -->
        <xsl:attribute name="I">
            <xsl:call-template name="setDateVariable">
                <xsl:with-param name="name" select="'invoiceStartDate'"/>
                <xsl:with-param name="date" select="DTM/DATE_TIME[@QUALIFIER='3']"/>
            </xsl:call-template>
            <xsl:value-of select="date:format(date:getValue('invoiceStartDate'), 'dd/MM/yyyy')"/>
        </xsl:attribute>
        <xsl:variable name="null"
            select="date:setValue('invoiceEndDate', date:getInvoiceEndDate(date:getValue('invoiceStartDate')))"/>
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
        <!-- OHXACT -->
        <xsl:attribute name="OH">
        <!-- @TOKEN@
            <xsl:value-of select="sql:query('bscs', 'Ohxact', $customerId)/record/@OHXACT"/>
        @TOKEN@ -->
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