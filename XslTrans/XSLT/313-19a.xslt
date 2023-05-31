<?xml version="1.0" encoding="UTF-8"?>
<!-- 313-19 Сведения о снятии ФЛ с учета в налоговых органах в связи со смертью, представляемых в банки, сообщившие информацию о счетах ФЛ -->
<!-- Редакция от 2023-05-31 -->

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tns="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1"
  xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
  exclude-result-prefixes="xsl x">

  <xsl:output method="xml" omit-xml-declaration="no" standalone="no" encoding="UTF-8" indent="yes"/>

  <xsl:param name="guid"/><!-- XslArgumentList() used -->
    
  <xsl:variable name="ourIS"><xsl:value-of select="//x:Recipient/text()"/></xsl:variable>
  <xsl:variable name="reqId"><xsl:value-of select="//x:clientId/text()"/></xsl:variable>
  <xsl:variable name="askId"><xsl:value-of select="//tns:UVSMERTFLRequest/@ИдЗапрос"/></xsl:variable>

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

             <xsl:element name="tns:UVSMERTFLResponse" namespace="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1">
               <xsl:attribute name="ИдЗапрос"><xsl:value-of select="$askId"/></xsl:attribute>
               <xsl:element name="tns:РезОбраб" namespace="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1">
                 <xsl:attribute name="ИдДок"><xsl:value-of select="$askId"/></xsl:attribute>
                 <xsl:attribute name="КодОбр">01</xsl:attribute>
               </xsl:element>
             </xsl:element>

           </tns:MessagePrimaryContent>
          </tns:content>
        </tns:ResponseContent>
      </tns:ResponseMessage>
    </tns:ClientMessage>

  </xsl:template>
</xsl:transform>
