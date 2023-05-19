<?xml version="1.0" encoding="UTF-8"?>
<!-- 313-19 Сведения о снятии ФЛ с учета в налоговых органах в связи со смертью, представляемых в банки, сообщившие информацию о счетах ФЛ -->

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tns="urn://x-artefacts-fns-uvsmertfl/root/313-19/4.0.1"
  xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"
  exclude-result-prefixes="xsl x msxsl user">

  <msxsl:script language="C#" implements-prefix="user">
    <![CDATA[
      public string getguid()
      {
        return Guid.NewGuid().ToString();
      }
    ]]>
  </msxsl:script>

  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:variable name="ourIS"><xsl:value-of select="//x:Recipient/text()"/></xsl:variable>
  <xsl:variable name="reqId"><xsl:value-of select="//x:clientId/text()"/></xsl:variable>
  <xsl:variable name="resId"><xsl:value-of select="user:getguid()"/><!-- XsltSettings.EnableScript = true required --></xsl:variable>
  <xsl:variable name="askId"><xsl:value-of select="//tns:UVSMERTFLRequest/@ИдЗапрос"/></xsl:variable>

  <xsl:template match="/">

    <tns:ClientMessage xmlns:tns="urn://x-artefacts-smev-gov-ru/services/service-adapter/types">
      <tns:itSystem><xsl:value-of select="$ourIS"/></tns:itSystem>
      <tns:ResponseMessage>
        <tns:ResponseMetadata>
          <tns:clientId><xsl:value-of select="$resId"/></tns:clientId>
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
