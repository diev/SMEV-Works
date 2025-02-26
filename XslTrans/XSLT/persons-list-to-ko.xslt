<?xml version="1.0" encoding="UTF-8"?>
<!-- Реестр контролируемых лиц от MNSV188 -->
<!-- Редакция от 2025-02-26 -->

<xsl:transform version="1.0"
  xmlns:tns="urn://x-artefacts-rkl/persons-list-to-ko/1.0.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:x="urn://x-artefacts-smev-gov-ru/services/service-adapter/types"
  exclude-result-prefixes="xsl x">

  <xsl:output method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

  <xsl:param name="guid"/><!-- XslArgumentList() used -->
    
  <xsl:variable name="ourIS"><xsl:value-of select="//x:Recipient/text()"/></xsl:variable>
  <xsl:variable name="reqId"><xsl:value-of select="//x:clientId/text()"/></xsl:variable>

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

              <tns:Response xmlns:tns="urn://x-artefacts-rkl/persons-list-to-ko/1.0.0">
                <tns:code>0</tns:code>
                <tns:message>SUCCEEDED</tns:message>
              </tns:Response>        

            </tns:MessagePrimaryContent>
          </tns:content>
        </tns:ResponseContent>
      </tns:ResponseMessage>
    </tns:ClientMessage>

  </xsl:template>
</xsl:transform>
