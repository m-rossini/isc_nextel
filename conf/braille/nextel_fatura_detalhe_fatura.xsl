<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:febraban="xalan://br.com.auster.nextel.xsl.extensions.FebrabanVariable"
                xmlns:string="xalan://br.com.auster.nextel.xsl.extensions.StringVariable"
                xmlns:xalan="http://xml.apache.org/xalan"
                extension-element-prefixes="xalan febraban string"
                exclude-result-prefixes="xalan febraban string"
                version="1.0">
    <!-- variáveis diversas -->
    <xsl:variable name="delimiter"  select="'    '"/>
    <xsl:variable name="delimiter0" select="';'"/>    
    <xsl:variable name="delimiter1" select="' '"/>        
 
    <xsl:template name="BRAILLE">
        <xsl:param name="key"/>
        <febraban:reset/>
        <xsl:value-of select="$key"/>
        <xsl:value-of select="$delimiter"/>
        <!-- Cabeçalho -->               
        <xsl:text>Informações resumidas sobre a Fatura Nextel</xsl:text>        
        <xsl:value-of select="$delimiter0"/> 
        <!-- Nome do Cliente -->       
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@C)"/>
        <xsl:value-of select="$delimiter0"/>
        <!-- Código do Cliente -->       
        <xsl:text>Código do Cliente:</xsl:text>           
        <xsl:value-of select="$delimiter1"/>        
        <xsl:value-of select="/INVOICE/CUSTOMER/@B"/>        
        <xsl:value-of select="$delimiter0"/>
        <!-- Logradouro / Nro / Complemento / Bairro -->               
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A1)"/>        
        <xsl:value-of select="$delimiter1"/>
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A2)"/>       
        <xsl:value-of select="$delimiter0"/>        
        <!-- CEP / Cidade / UF -->                       
        <xsl:value-of select="normalize-space(/INVOICE/CUSTOMER/@A3)"/>
        <xsl:value-of select="$delimiter0"/>        
        <!-- CNPJ / CPF -->                       
        <xsl:text>CNPJ/CPF:</xsl:text>           
        <xsl:value-of select="$delimiter1"/>        
        <xsl:value-of select="/INVOICE/BILL/TELECOM/NF/CLIENTE/@ID"/>
        <xsl:value-of select="$delimiter0"/>        
        <!-- Emissão -->                   
        <xsl:text>Dados da Fatura de:;Nextel Telecomunicações Ltda.</xsl:text>                
        <xsl:value-of select="$delimiter0"/>        
        <!-- Data de Vencimento da Fatura -->                   
        <xsl:text>Data de Vencimento:;</xsl:text>          
        <!-- <xsl:value-of select="/INVOICE/CUSTOMER/@D"/> -->
        <xsl:value-of select="/INVOICE/BILL/TELECOM/NF/@DV"/>        
        <xsl:value-of select="$delimiter0"/>                
        <!-- Valor da Fatura (Telecom+Equipamentos+Negociações) -->                   
        <xsl:text>Valor da Fatura:;</xsl:text>  
        <xsl:value-of select="SUMMARY/@T"/>                        
        <xsl:value-of select="$delimiter0"/>                
        <!-- Juros -->                   
        <xsl:text>Juros:;</xsl:text>  
        <xsl:if test="/INVOICE/BILL/TELECOM/BOLETO/INSTR_BANC/I"> 
        <xsl:apply-templates select="/INVOICE/BILL/TELECOM/BOLETO/INSTR_BANC/I">
            <xsl:with-param name="BrailleKey" select="$BO_instrKey" />  
        </xsl:apply-templates>
        </xsl:if>
        <xsl:value-of select="$delimiter0"/>                        
        <!-- Reaviso -->                   
        <xsl:text>Reaviso:;Não é um reaviso</xsl:text>                                                             
        <xsl:call-template name="PRINT-LINEFEED"/>
    </xsl:template>    
</xsl:stylesheet>