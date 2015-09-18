<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- Cabeçalho -->
    <xsl:variable name="headerKey"                   select="'1000    '"/>

    <!-- RF = Resumo Fatura -->
    <xsl:variable name="RF_startKey"                 select="'1100    '"/>
    <xsl:variable name="RF_messagesKey"              select="'1200    '"/>
    <xsl:variable name="RF_messagesEndKey"           select="'1298    '"/>

    <!-- RE = Resumo Equipamento -->
    <xsl:variable name="RE_startKey"                 select="'1300    '"/>
    <xsl:variable name="RE_endKey"                   select="'1301    '"/>
    <xsl:variable name="RE_occOtherStartKey"         select="'1320    '"/>
    <xsl:variable name="RE_occOtherEndKey"           select="'1321    '"/>
    <xsl:variable name="RE_occCreditStartKey"        select="'1330    '"/>
    <xsl:variable name="RE_occCreditEndKey"          select="'1331    '"/>
    <xsl:variable name="RE_occPenaltyInterestStartKey" select="'1340    '"/>
    <xsl:variable name="RE_occPenaltyInterestEndKey"   select="'1341    '"/>

    <!-- DF = Detalhe Fatura -->
    <xsl:variable name="DF_startKey"                 select="'1400    '"/>
    <xsl:variable name="DF_monthlyFeeKey"            select="'1500    '"/>
    <xsl:variable name="DF_monthlyFeeEndKey"         select="'1501    '"/>
    <xsl:variable name="DF_additionalServicesKey"    select="'1600    '"/>
    <xsl:variable name="DF_additionalServicesEndKey" select="'1601    '"/>
    <xsl:variable name="DF_dispatchKey"              select="'1700    '"/>
    <xsl:variable name="DF_dispatchEndKey"           select="'1701    '"/>
    <xsl:variable name="DF_homeCallsKey"             select="'1800    '"/>
    <xsl:variable name="DF_homeCallsEndKey"          select="'1801    '"/>
    <xsl:variable name="DF_roamingCallsKey"          select="'1900    '"/>
    <xsl:variable name="DF_roamingCallsEndKey"       select="'1901    '"/>
    <xsl:variable name="DF_nextelOnlineStartKey"     select="'2000    '"/>
    <xsl:variable name="DF_circuitDataKey"           select="'2010    '"/>
    <xsl:variable name="DF_verticalSolutionsKey"     select="'2020    '"/>
    <xsl:variable name="DF_packetDataKey"            select="'2030    '"/>
    <xsl:variable name="DF_torpedoKey"               select="'2040    '"/>
    <xsl:variable name="DF_downloadsKey"             select="'2050    '"/>
    <xsl:variable name="DF_locatorKey"             	 select="'2060    '"/>    
    <xsl:variable name="DF_downloadsDescritivoKey"   select="'2051    '"/>
    <xsl:variable name="DF_nextelOnlineEndKey"       select="'2098    '"/>
    <xsl:variable name="DF_endKey"                   select="'1402    '"/>

    <!-- DC = Detalhe Conta -->
    <xsl:variable name="DC_startKey"                select="'2100    '"/>
    <xsl:variable name="DC_IntDirectConnectKey"		select="'2110    '"/>
    <xsl:variable name="DC_IntDirectConnectEndKey"	select="'2111    '"/>
    <xsl:variable name="DC_DailyLocatorKey"			select="'2120    '"/>
    <xsl:variable name="DC_DailyLocatorEndKey"		select="'2121    '"/>
    <!-- Serviços Interativos - SMS -->    
    <xsl:variable name="DC_InteractiveServKey"		select="'2130    '"/>
    <xsl:variable name="DC_InteractiveServEndKey"	select="'2131    '"/>    
    <!-- Fim Serviços Interativos - SMS -->
    <xsl:variable name="DC_localHomeKey"            select="'2200    '"/>
    <xsl:variable name="DC_localHomeEndKey"         select="'2201    '"/>
    <xsl:variable name="DC_longHomeKey"             select="'2300    '"/>
    <xsl:variable name="DC_longHomeEndKey"          select="'2301    '"/>
    <xsl:variable name="DC_recCollectHomeKey"       select="'2310    '"/>
    <xsl:variable name="DC_recCollectHomeEndKey"    select="'2311    '"/>
    <xsl:variable name="DC_receivedHomeKey"         select="'2400    '"/>
    <xsl:variable name="DC_receivedHomeEndKey"      select="'2401    '"/>
    <xsl:variable name="DC_internationalHomeKey"    select="'2500    '"/>
    <xsl:variable name="DC_internationalHomeEndKey" select="'2501    '"/>
    <xsl:variable name="DC_z300HomeKey"             select="'2510    '"/>
    <xsl:variable name="DC_z300HomeEndKey"          select="'2511    '"/>
    <xsl:variable name="DC_dialedRoamingKey"        select="'2600    '"/>
    <xsl:variable name="DC_dialedRoamingEndKey"     select="'2601    '"/>
    <xsl:variable name="DC_z300RoamingKey"          select="'2610    '"/>
    <xsl:variable name="DC_z300RoamingEndKey"       select="'2611    '"/>
    <xsl:variable name="DC_receivedRoamingKey"      select="'2700    '"/>
    <xsl:variable name="DC_receivedRoamingEndKey"   select="'2701    '"/>
    <xsl:variable name="DC_recCollectRoamingKey"    select="'2800    '"/>
    <xsl:variable name="DC_recCollectRoamingEndKey" select="'2801    '"/>
    <xsl:variable name="DC_discountHomeKey"         select="'2810    '"/>
    <xsl:variable name="DC_discountHomeEndKey"      select="'2811    '"/>
    <xsl:variable name="DC_discountRoamingKey"      select="'2820    '"/>
    <xsl:variable name="DC_discountRoamingEndKey"   select="'2821    '"/>
    <xsl:variable name="DC_endKey"                  select="'2198    '"/>

    <!-- EX = Extrato -->
    <xsl:variable name="EX_startKey"                select="'9100    '"/>
    <xsl:variable name="EX_devKey"                  select="'9110    '"/>
    <xsl:variable name="EX_devEndKey"               select="'9111    '"/>
    <xsl:variable name="EX_pgtoKey"                 select="'9120    '"/>
    <xsl:variable name="EX_pgtoEndKey"              select="'9121    '"/>
    <xsl:variable name="EX_atualKey"                select="'9130    '"/>
    <xsl:variable name="EX_atualEndKey"             select="'9131    '"/>
    <xsl:variable name="EX_futKey"                  select="'9140    '"/>
    <xsl:variable name="EX_futEndKey"               select="'9141    '"/>
    <xsl:variable name="EX_msgsKey"                 select="'9150    '"/>
    <xsl:variable name="EX_msgsLineKey"             select="'9151    '"/>
    <xsl:variable name="EX_endKey"                  select="'9198    '"/>
    
    <!-- IF = Informacoes Importantes -->
    <xsl:variable name="IF_startKey"                select="'9200    '"/>
    <xsl:variable name="IF_lineKey"                 select="'9201    '"/>
    <xsl:variable name="IF_endKey"                  select="'9298    '"/>
     
    <!-- BO = Boleto Consolidado Telecom/Compras/Multas/Negociacoes -->
    <xsl:variable name="BO_C_prefix"                select="'8'"/>
    <xsl:variable name="BO_D_prefix"                select="'9'"/>
    <xsl:variable name="BO_startKey"                select="'0    '"/>
    <xsl:variable name="BO_sacadoKey"               select="'1    '"/>
    <xsl:variable name="BO_instrKey"                select="'2    '"/>
    <xsl:variable name="BO_instrEndKey"             select="'3    '"/>
    <xsl:variable name="BO_itemKey"                 select="'4    '"/>
    <xsl:variable name="BO_apKey"                   select="'5    '"/>
    <xsl:variable name="BO_itemEndKey"              select="'6    '"/>
    <xsl:variable name="BO_endKey"                  select="'9    '"/>
       
    <!-- CP = Compras -->
    <xsl:variable name="CP_prefix"                  select="'93'"/>
    <xsl:variable name="CP_startKey"                select="'9300    '"/>
    <xsl:variable name="CP_endKey"                  select="'9398    '"/>
    
    <!-- MT = Multas -->
    <xsl:variable name="MT_prefix"                  select="'94'"/>
    <xsl:variable name="MT_startKey"                select="'9400    '"/>
    <xsl:variable name="MT_endKey"                  select="'9498    '"/>
    
    <!-- NG = Negociacoes -->
    <xsl:variable name="NG_prefix"                  select="'95'"/>
    <xsl:variable name="NG_startKey"                select="'9500    '"/>
    <xsl:variable name="NG_endKey"                  select="'9598    '"/>
    
    <!-- TC = Telecom ; NF = Nota Fiscal ; BA = Boleto Arrecadacao -->
    <xsl:variable name="TC_prefix"                  select="'96'"/>
    <xsl:variable name="TC_startKey"                select="'9600    '"/>
    <xsl:variable name="TC_NF_Key"                  select="'9610    '"/>
    <xsl:variable name="TC_NF_clienteKey"           select="'9611    '"/>
    <xsl:variable name="TC_NF_emitenteKey"          select="'9612    '"/>
    <xsl:variable name="TC_NF_itemKey"              select="'9620    '"/>
    <xsl:variable name="TC_NF_itemEndKey"           select="'9621    '"/>
    <xsl:variable name="TC_NF_obsKey"               select="'9630    '"/>
    <xsl:variable name="TC_NF_obsEndKey"            select="'9631    '"/>
    <xsl:variable name="TC_NF_msgsKey"              select="'9640    '"/>
    <xsl:variable name="TC_NF_msgsEndKey"           select="'9641    '"/>
    <xsl:variable name="TC_NF_endKey"               select="'9659    '"/>
    
    <xsl:variable name="TC_BA_startKey"             select="'9670    '"/>
    <xsl:variable name="TC_BA_message1Key"          select="'9671    '"/>
    <xsl:variable name="TC_BA_message2Key"          select="'9672    '"/>
    <xsl:variable name="TC_BA_message3Key"          select="'9673    '"/>
    <xsl:variable name="TC_BA_message4Key"          select="'9674    '"/>
    <xsl:variable name="TC_BA_message5Key"          select="'9675    '"/>
    <xsl:variable name="TC_BA_message6Key"          select="'9676    '"/>
    <xsl:variable name="TC_BA_endKey"               select="'9679    '"/>
    
    <xsl:variable name="TC_endKey"                  select="'9698    '"/>

    <!-- Final da Fatura -->
    <xsl:variable name="invoiceEndKey"              select="'1498    '"/>
    <!-- Final do Cliente -->
    <xsl:variable name="finalKey"                   select="'99      '"/>

</xsl:stylesheet>
