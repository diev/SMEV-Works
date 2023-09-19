<?xml version="1.0" encoding="UTF-8"?>
<!-- ВС6. Предоставление запроса на получение информации об исполнении распоряжения о переводе денежных средств -->
<!-- Редакция от 2023-06-01 -->

<xsl:stylesheet version="1.0"
    xmlns:ep="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0"
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
        ПРЕДОСТАВЛЕНИЕ ЗАПРОСА НА ПОЛУЧЕНИЕ ИНФОРМАЦИИ
        ОБ ИСПОЛНЕНИИ РАСПОРЯЖЕНИЯ О ПЕРЕВОДЕ ДЕНЕЖНЫХ СРЕДСТВ

        Вид сведений:  urn://x-artefacts-rec-ru/PayService/ExecPay

        Message Id:    <xsl:value-of select="//x:MessageId/text()"/>
        Отправлено:    <xsl:call-template name="formatDateTime">
            <xsl:with-param name="dateTime" select="//x:SendingDate/text()"/>
        </xsl:call-template>

        ConfirmPaymentInfo

        amount         <xsl:value-of select="//ep:ConfirmPaymentInfo/@amount"/>
        accDocDate     <xsl:call-template name="formatDate"><xsl:with-param name="yyyy-mm-dd" select="//ep:ConfirmPaymentInfo/@accDocDate"/></xsl:call-template>
        chargeOffDate  <xsl:call-template name="formatDate"><xsl:with-param name="yyyy-mm-dd" select="//ep:ConfirmPaymentInfo/@chargeOffDate"/></xsl:call-template>

        Payer

        inn            <xsl:value-of select="//ep:Payer/@inn"/>
        personalAcc    <xsl:value-of select="//ep:Payer/@personalAcc"/>
    </xsl:template>
</xsl:stylesheet>
