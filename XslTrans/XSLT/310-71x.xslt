<?xml version="1.0" encoding="UTF-8"?>
<!-- 310-71 Запрос на уточнение информации о суммах выплаченных физическому лицу процентов по вкладам (остаткам на счетах) -->
<!-- Редакция от 2023-06-01 -->

<xsl:transform version="1.0"
  xmlns:tns="urn://x-artefacts-fns-nalflproc/root/310-71/4.0.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
  exclude-result-prefixes="xsl x">

  <xsl:output method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

  <xsl:param name="guid"/><!-- XslArgumentList() used -->
    
  <xsl:variable name="ourIS"><xsl:value-of select="//x:Recipient/text()"/></xsl:variable>
  <xsl:variable name="reqId"><xsl:value-of select="//x:clientId/text()"/></xsl:variable>
  <xsl:variable name="askId"><xsl:value-of select="//tns:NALFLPROCRequest/@ИдЗапрос"/></xsl:variable>

  <xsl:template match="/">

    <tns:ClientMessage xmlns:tns="urn://x-artefacts-smev-gov-ru/services/service-adapter/types">
      <tns:itSystem><xsl:value-of select="$ourIS"/></tns:itSystem>
      <tns:ResponseMessage>
        <tns:ResponseMetadata>
          <tns:clientId><xsl:value-of select="$guid"/></tns:clientId>
          <tns:replyToClientId><xsl:value-of select="$reqId"/></tns:replyToClientId>
        </tns:ResponseMetadata>
        <tns:ResponseContent>
          <tns:content>
           <tns:MessagePrimaryContent>

             <xsl:element name="tns:NALFLPROCResponse" namespace="urn://x-artefacts-fns-nalflproc/root/310-71/4.0.1">
               <xsl:attribute name="ИдЗапрос"><xsl:value-of select="$askId"/></xsl:attribute>
               <xsl:attribute name="КодОбр">10</xsl:attribute>
             </xsl:element>

           </tns:MessagePrimaryContent>
          </tns:content>
        </tns:ResponseContent>
      </tns:ResponseMessage>
    </tns:ClientMessage>

  </xsl:template>
</xsl:transform>
