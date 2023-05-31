<?xml version="1.0" encoding="UTF-8"?>
<!-- 313-19 Сведения о снятии ФЛ с учета в налоговых органах в связи со смертью, представляемых в банки, сообщившие информацию о счетах ФЛ -->
<!-- Редакция от 2023-05-31 -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tns="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1"
    xmlns:fnst="urn://x-artefacts-fns-uvsmertfl/types/313-19/4.0.1"
    xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
    exclude-result-prefixes="xsl tns fnst x">

    <xsl:output method="html" doctype-public="html" indent="yes"/>

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

        <html lang="ru">
            <head>
                <!--meta charset="utf-8"/-->
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>313-19</title>
                <style type="text/css">
                    <xsl:text>body{margin:10pt;font-size:11px;}</xsl:text>
                    <xsl:text>h1{margin:10pt;font-weight:bold;font-size:14pt;text-align:center;}</xsl:text>
                    <xsl:text>h2{background-color:#eee;font-weight:bold;font-size:12pt;border-top:#000 1pt solid;padding:2pt 2pt 2pt 10pt;}</xsl:text>
                    <xsl:text>.rectangle{border:#000 1pt solid;margin-left:auto;margin-right:0;padding:2pt;width:60%;}</xsl:text>
                    <xsl:text>.items th{font-weight:bold;text-align:right;}</xsl:text>
                    <xsl:text>.items td{padding-left:10pt;}</xsl:text>
                    <xsl:text>.accounts th{font-weight:normal;padding-left:10pt;text-align:left;text-decoration:underline;}</xsl:text>
                    <xsl:text>.accounts td{padding-left:10pt;}</xsl:text>
                </style>
                <style type="text/css" media="print">
                    <xsl:text>body{margin:0;}</xsl:text>
                </style>
            </head>
          
            <body>
                <h1><xsl:text>СВЕДЕНИЯ В КРЕДИТНЫЕ ОРГАНИЗАЦИИ О СНЯТИИ С УЧЕТА В</xsl:text><br/>
                    <xsl:text>НАЛОГОВОМ ОРГАНЕ ФИЗИЧЕСКОГО ЛИЦА - ВЛАДЕЛЬЦА СЧЕТА</xsl:text><br/>
                    <xsl:text>НА ОСНОВАНИИ СВЕДЕНИЙ О СМЕРТИ</xsl:text></h1>

                <div class="rectangle">
                    <table class="items" width="100%">
                        <tbody>
                            <tr>
                                <th>Message Id</th>
                                <td>
                                    <xsl:value-of select="//x:MessageId/text()"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Отправлено</th>
                                <td>
                                    <xsl:call-template name="formatDateTime">
                                        <xsl:with-param name="dateTime" select="//x:SendingDate/text()"/>
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div>
                    <h2>Клиент</h2>

                    <table class="items" width="100%">
                        <col width="20%"/>
                        <col width="50%"/>
                        <col width="10%"/>
                        <col width="20%"/>
                        <tbody>
                            <tr>
                                <th>Фамилия</th>
                                <td>
                                    <xsl:value-of select="//fnst:Фамилия/text()"/>
                                </td>
                                <th>ИНН</th>
                                <td>
                                    <xsl:value-of select="//tns:UVSMERTFLRequest/@ИННФЛ"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Имя</th>
                                <td>
                                    <xsl:value-of select="//fnst:Имя/text()"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Отчество</th>
                                <td>
                                    <xsl:value-of select="//fnst:Отчество/text()"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div>
                    <h2>Акты гражданского состояния</h2>

                    <table class="items" width="100%">
                        <col width="20%"/>
                        <col width="20%"/>
                        <col width="15%"/>
                        <col width="10%"/>
                        <col width="15%"/>
                        <col width="20%"/>
                        <tbody>
                            <tr>
                                <th>Дата рождения</th>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаРожд"/>
                                    </xsl:call-template>
                                    <xsl:text>Пр. </xsl:text><xsl:value-of select="//tns:UVSMERTFLRequest/@ПрДатаРожд"/>
                                </td>
                                <th></th>
                                <td></td>
                                <th></th>
                                <td></td>
                            </tr>
                            <tr>
                                <th>Дата смерти</th>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаСмерт"/>
                                    </xsl:call-template>
                                    <xsl:text>Пр. </xsl:text><xsl:value-of select="//tns:UVSMERTFLRequest/@ПрДатаСмерт"/>
                                </td>
                                <th>Дата записи</th>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаЗапис"/>
                                    </xsl:call-template>
                                </td>
                                <th>Номер записи</th>
                                <td>
                                    <xsl:value-of select="//tns:UVSMERTFLRequest/@НомерЗапис"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6"><br/></td>
                            </tr>
                            <tr>
                                <th>Наименование ЗАГС</th>
                                <td colspan="5">
                                    <xsl:value-of select="//tns:UVSMERTFLRequest/@НаимЗАГС"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Код ЗАГС</th>
                                <td>
                                    <xsl:value-of select="//tns:UVSMERTFLRequest/@КодЗАГС"/>
                                </td>
                                <th>Дата снятия</th>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="yyyy-mm-dd" select="//tns:UVSMERTFLRequest/@ДатаСнят"/>
                                    </xsl:call-template>
                                </td>
                                <th></th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div>
                    <h2>Удостоверение личности</h2>

                    <table class="items" width="100%">
                        <col width="20%"/>
                        <col width="80%"/>
                        <tbody>
                            <tr>
                                <th>Код документа</th>
                                <td>
                                    <xsl:value-of select="//tns:УдЛичнФЛ/@КодВидДок"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Серия и номер</th>
                                <td>
                                    <xsl:value-of select="//tns:УдЛичнФЛ/@СерНомДок"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Дата выдачи</th>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="yyyy-mm-dd" select="//tns:УдЛичнФЛ/@ДатаДок"/>
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div>
                    <h2>Счета</h2>
                    
                    <table class="accounts" width="100%">
                        <col width="25%"/>
                        <col width="10%"/>
                        <col width="65%"/>
                        <thead>
                            <tr>
                                <th>Номер</th>
                                <th>Валюта</th>
                                <th>Открыт</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//tns:СвОткрСчет">
                                <tr>
                                    <td>
                                        <xsl:value-of select="@НомСчет"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="@ВалСч"/>
                                    </td>
                                    <td>
                                         <xsl:call-template name="formatDate">
                                             <xsl:with-param name="yyyy-mm-dd" select="@ДатаОткрСч"/>
                                         </xsl:call-template>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
                
            </body>
        </html>

    </xsl:template>
</xsl:stylesheet>
