<?xml version="1.0" encoding="UTF-8"?>
<!-- ВС2. Предоставление информации, необходимой для перевода денежных средств, или информации о начислении -->
<!-- Редакция от 2023-06-01 -->

<xsl:stylesheet version="1.0"
    xmlns:npd="urn://x-artefacts-rec-ru/PayService/PayDocinfo/1.0.0"
    xmlns:pd="http://x-artefacts-rec-ru/PayService/PayDoc/1.0.0"
    xmlns:com="http://x-artefacts-rec-ru/PayService/Common/1.0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
    exclude-result-prefixes="xsl x">

    <xsl:output method="text" encoding="windows-1251"/>

    <xsl:template name="formatDate"><!-- 2023-05-16 -->
        <xsl:param name="yyyy-mm-dd"/>
        <xsl:choose>
            <xsl:when test="string-length($yyyy-mm-dd)>0">
                <xsl:variable name="yyyy" select="substring-before($yyyy-mm-dd, '-')"/>
                <xsl:variable name="mm-dd" select="substring-after($yyyy-mm-dd, '-')"/>
                <xsl:variable name="mm" select="substring-before($mm-dd, '-')"/>
                <xsl:variable name="dd" select="substring-after($mm-dd, '-')"/>
                <xsl:value-of select="concat($dd, '.', $mm, '.', $yyyy)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formatDateTime"><!-- 2023-05-16T10:38:02.041+03:00 -->
        <xsl:param name="dateTime"/>
        <xsl:variable name="yyyy" select="substring($dateTime, 1, 4)"/>
        <xsl:variable name="mm" select="substring($dateTime, 6, 2)"/>
        <xsl:variable name="dd" select="substring($dateTime, 9, 2)"/>
        <xsl:variable name="time" select="substring($dateTime, 12, 5)"/>
        <xsl:variable name="tz" select="substring($dateTime, 24, 6)"/>
        <xsl:value-of select="concat($dd, '.',$mm, '.', $yyyy, ' ', $time, ' ', $tz)"/>
    </xsl:template>

    <xsl:template match="/">
        ПРЕДОСТАВЛЕНИЕ ИНФОРМАЦИИ, НЕОБХОДИМОЙ ДЛЯ ПЕРЕВОДА
        ДЕНЕЖНЫХ СРЕДСТВ, ИЛИ ИНФОРМАЦИИ О НАЧИСЛЕНИИ        

        Вид сведений:  urn://x-artefacts-rec-ru/PayService/PayDocinfo

        Message Id:    <xsl:value-of select="//x:MessageId/text()"/>
        Отправлено:    <xsl:call-template name="formatDateTime">
            <xsl:with-param name="dateTime" select="//x:SendingDate/text()"/>
        </xsl:call-template>

        PayDocData

        amount         <xsl:value-of select="//npd:PayDocData/@amount"/>
        tax            <xsl:value-of select="//npd:PayDocData/@tax"/>
        amountTax      <xsl:value-of select="//npd:PayDocData/@amountTax"/>
        amountToPay    <xsl:value-of select="//npd:PayDocData/@amountToPay"/>
        currencyCode   <xsl:value-of select="//npd:PayDocData/@currencyCode"/>
        invoiceDate    <xsl:call-template name="formatDate"><xsl:with-param name="yyyy-mm-dd" select="//npd:PayDocData/@invoiceDate"/></xsl:call-template>
        invoiceID      <xsl:value-of select="//npd:PayDocData/@invoiceID"/>
        purpose        <xsl:value-of select="//npd:PayDocData/@purpose"/>

        Payer

        inn            <xsl:value-of select="//pd:PayerOrg/@inn"/>
        payerName      <xsl:value-of select="//pd:PayerOrg/@payerName"/>

        Payee

        inn            <xsl:value-of select="//pd:Payee/@inn"/>
        payeeName      <xsl:value-of select="//pd:Payee/@payeeName"/>
        personalAcc    <xsl:value-of select="//com:PayeeAccountInfo/@personalAcc"/>
        bik            <xsl:value-of select="//com:Bank/@bik"/>
    </xsl:template>
</xsl:stylesheet>
