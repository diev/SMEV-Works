<?xml version="1.0" encoding="UTF-8"?>
<!-- 310-71 Запрос на уточнение информации о суммах выплаченных физическому лицу процентов по вкладам (остаткам на счетах) -->
<!-- Редакция от 2023-06-01 -->

<xsl:stylesheet version="1.0"
    xmlns:tns="urn://x-artefacts-fns-nalflproc/root/310-71/4.0.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
    exclude-result-prefixes="tns xsl x">

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
        ЗАПРОС НА УТОЧНЕНИЕ ИНФОРМАЦИИ О СУММАХ ВЫПЛАЧЕННЫХ
        ФИЗИЧЕСКОМУ ЛИЦУ ПРОЦЕНТОВ ПО ВКЛАДАМ (ОСТАТКАМ НА СЧЕТАХ)

        Вид сведений:  310-71

        Message Id:    <xsl:value-of select="//x:MessageId/text()"/>
        Отправлено:    <xsl:call-template name="formatDateTime">
            <xsl:with-param name="dateTime" select="//x:SendingDate/text()"/>
        </xsl:call-template>

        ИдЗапрос:      <xsl:value-of select="//tns:NALFLPROCRequest/@ИдЗапрос"/>
        ИдЗапросПост:  <xsl:value-of select="//tns:NALFLPROCRequest/@ИдЗапросПост"/>
        КодНО:         <xsl:value-of select="//tns:NALFLPROCRequest/@КодНО"/>
        МнемонПост:    <xsl:value-of select="//tns:NALFLPROCRequest/@МнемонПост"/>
        Период:        <xsl:value-of select="//tns:NALFLPROCRequest/@Период"/>
        
        СведБанк

        ИНН:           <xsl:value-of select="//tns:СведБанк/@ИНН"/>
        КПП:           <xsl:value-of select="//tns:СведБанк/@КПП"/>
        НаимБанк:      <xsl:value-of select="//tns:СведБанк/@НаимБанк"/>

        СведУточн

        ПорядНом  ВидЗапр  НомКорр
        <xsl:for-each select="//tns:СведУточн">
        <xsl:value-of select="@ПорядНом"/><xsl:text>         </xsl:text>
        <xsl:value-of select="@ВидЗапр"/><xsl:text>        </xsl:text>
        <xsl:value-of select="@НомКорр"/><xsl:text>
        </xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
