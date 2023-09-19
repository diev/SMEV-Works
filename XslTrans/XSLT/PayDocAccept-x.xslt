<?xml version="1.0" encoding="UTF-8"?>
<!-- ВС3. Предоставление информации, необходимой для перевода денежных средств с акцептом плательщика -->
<!-- Редакция от 2023-06-01 -->

<xsl:transform version="1.0"
  xmlns:npa="urn://x-artefacts-rec-ru/PayService/PayDocAccept/1.0.0"
  xmlns:pd="http://x-artefacts-rec-ru/PayService/PayDoc/1.0.0"
  xmlns:com="http://x-artefacts-rec-ru/PayService/Common/1.0.0"
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

             <xsl:element name="npa:PayDocAcceptResponse" namespace="urn://x-artefacts-rec-ru/PayService/PayDocAccept/1.0.0">
               <xsl:attribute name="idRs">??:I_54a39db1-8753-5522-1739-bc94254ccdb4</xsl:attribute>
               <xsl:attribute name="idRq"><xsl:value-of select="//npa:PayDocAcceptRequest/@idRq"/></xsl:attribute>
               <xsl:attribute name="timeStampRs">??:2022-05-17T10:31:55Z</xsl:attribute>
               <xsl:element name="npa:InvoiceID" namespace="urn://x-artefacts-rec-ru/PayService/PayDocAccept/1.0.0">
                 <xsl:value-of select="//npa:PayDocData/@invoiceID"/>
               </xsl:element>
               <xsl:element name="npa:ResultCode" namespace="urn://x-artefacts-rec-ru/PayService/PayDocAccept/1.0.0">1</xsl:element>
             </xsl:element>

           </tns:MessagePrimaryContent>
          </tns:content>
        </tns:ResponseContent>
      </tns:ResponseMessage>
    </tns:ClientMessage>

  </xsl:template>
</xsl:transform>
