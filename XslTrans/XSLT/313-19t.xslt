<?xml version="1.0" encoding="UTF-8"?>
<!-- 313-19 Сведения о снятии ФЛ с учета в налоговых органах в связи со смертью, представляемых в банки, сообщившие информацию о счетах ФЛ -->
<!-- Редакция от 2023-05-31 -->

<xsl:stylesheet version="1.0"
    xmlns:tns="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1"
    xmlns:fnst="urn://x-artefacts-fns-uvsmertfl/types/313-19/4.0.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
    exclude-result-prefixes="tns fnst xsl x">

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

    <xsl:template name="formatTime"><!-- 2023-05-16T10:38:02.041+03:00 -->
        <xsl:param name="dateTime"/>
        <xsl:value-of select="substring-after($dateTime, 'T')"/>
    </xsl:template>

    <xsl:template match="/">
        СВЕДЕНИЯ В КРЕДИТНЫЕ ОРГАНИЗАЦИИ О СНЯТИИ С УЧЕТА В
        НАЛОГОВОМ ОРГАНЕ ФИЗИЧЕСКОГО ЛИЦА - ВЛАДЕЛЬЦА СЧЕТА
        НА ОСНОВАНИИ СВЕДЕНИЙ О СМЕРТИ

        Вид сведений:  313-19

        Message Id:    <xsl:value-of select="//x:MessageId/text()"/>
        Отправлено:    <xsl:call-template name="formatDateTime">
            <xsl:with-param name="dateTime" select="//x:SendingDate/text()"/>
        </xsl:call-template>

        Клиент ИНН <xsl:value-of select="//tns:UVSMERTFLRequest/@ИННФЛ"/>

        Фамилия:       <xsl:value-of select="//fnst:Фамилия/text()"/>
        Имя:           <xsl:value-of select="//fnst:Имя/text()"/>
        Отчество:      <xsl:value-of select="//fnst:Отчество/text()"/>

        Акты гражданского состояния

        Дата рождения: <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаРожд"/>
        </xsl:call-template>  Пр. <xsl:value-of select="//tns:UVSMERTFLRequest/@ПрДатаРожд"/>
        Дата смерти:   <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаСмерт"/>
        </xsl:call-template>  Пр. <xsl:value-of select="//tns:UVSMERTFLRequest/@ПрДатаСмерт"/>
        
        Дата записи:   <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаЗапис"/>
        </xsl:call-template>  Номер записи: <xsl:value-of select="//tns:UVSMERTFLRequest/@НомерЗапис"/>
        Дата снятия:   <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаСнят"/>
        </xsl:call-template>

        Наименование ЗАГС: <xsl:value-of select="//tns:UVSMERTFLRequest/@НаимЗАГС"/>
        Код ЗАГС:      <xsl:value-of select="//tns:UVSMERTFLRequest/@КодЗАГС"/>

        Удостоверение личности

        Код документа: <xsl:value-of select="//tns:УдЛичнФЛ/@КодВидДок"/>
        Серия и номер: <xsl:value-of select="//tns:УдЛичнФЛ/@СерНомДок"/>
        Дата выдачи:   <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="//tns:УдЛичнФЛ/@ДатаДок"/>
        </xsl:call-template>

        Счета
                    
        Номер                 Валюта  Открыт
        <xsl:for-each select="//tns:СвОткрСчет">
        <xsl:value-of select="@НомСчет"/><xsl:text>  </xsl:text>
        <xsl:value-of select="@ВалСч"/><xsl:text>     </xsl:text>
        <xsl:call-template name="formatDate">
            <xsl:with-param name="yyyy-mm-dd" select="@ДатаОткрСч"/>
        </xsl:call-template>
        <xsl:text>
        </xsl:text>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
