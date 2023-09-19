<?xml version="1.0" encoding="UTF-8"?>
<!-- ВС6. Предоставление запроса на получение информации об исполнении распоряжения о переводе денежных средств -->
<!-- Редакция от 2023-06-01 -->

<xsl:transform version="1.0"
  xmlns:ep="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0"
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

             <xsl:element name="ep:ExecPayResponse" namespace="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0">
               <xsl:attribute name="idRs">??:I_54a39db1-8753-5522-1739-bc94254ccdb4</xsl:attribute>
               <xsl:attribute name="idRq"><xsl:value-of select="//ep:ExecPayRequest/@idRq"/></xsl:attribute>
               <xsl:attribute name="timeStampRs">??:2022-05-17T10:31:55Z</xsl:attribute>
               <xsl:element name="ep:ExecPayData" namespace="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0">
                 <xsl:attribute name="paymentID">??:</xsl:attribute>
                 <xsl:attribute name="receiptDate">??:</xsl:attribute>
                 <xsl:attribute name="chargeOffDate">??:</xsl:attribute>
                 <xsl:attribute name="amount">??:</xsl:attribute>
                 <xsl:attribute name="currencyCode">??:</xsl:attribute>
                 <xsl:attribute name="purpose">??:</xsl:attribute>
                 <xsl:element name="ep:Payee" namespace="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0">
                   <xsl:attribute name="payeeName">??:</xsl:attribute>
                   <xsl:attribute name="inn">??:</xsl:attribute>
                   <xsl:element name="com:PayeeAccountInfo" namespace="http://x-artefacts-rec-ru/PayService/Common/1.0.0">
                     <xsl:attribute name="personalAcc">??:</xsl:attribute>
                     <xsl:element name="com:Bank" namespace="http://x-artefacts-rec-ru/PayService/Common/1.0.0">
                       <xsl:attribute name="bik">??:</xsl:attribute>
                     </xsl:element>
                   </xsl:element>
                 </xsl:element>
                 <xsl:element name="ep:Payer" namespace="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0">
                   <xsl:attribute name="payerName">??:</xsl:attribute>
                   <xsl:attribute name="inn">??:</xsl:attribute>
                   <xsl:element name="com:PayeeAccountInfo" namespace="http://x-artefacts-rec-ru/PayService/Common/1.0.0">
                     <xsl:attribute name="personalAcc">??:</xsl:attribute>
                     <xsl:element name="com:Bank" namespace="http://x-artefacts-rec-ru/PayService/Common/1.0.0">
                       <xsl:attribute name="bik">??:</xsl:attribute>
                     </xsl:element>
                   </xsl:element>
                 </xsl:element>
               </xsl:element>
               <xsl:element name="npd:ResultCode" namespace="urn://x-artefacts-rec-ru/PayService/PayDocinfo/1.0.0">1</xsl:element>
             </xsl:element>

<!--                 <xsl:value-of select="//npd:PayDocData/@invoiceID"/>

<ep:ExecPayResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:com="http://x-artefacts-rec-ru/PayService/Common/1.0.0" xmlns:ep="urn://x-artefacts-rec-ru/PayService/ExecPay/1.0.0" idRs="R_7eef6ad0-b9aa-494a-be07-0c27f91157b9" idRq="I_65642e42-9bc8-4c2d-bcd9-9786528a7db9" timeStampRs="2022-05-17T09:30:47Z">
	<ep:ExecPayData paymentID="60077274285462022-0000001" receiptDate="2022-05-17" chargeOffDate="2022-05-17" amount="10000" currencyCode="RUB" purpose="Тестовый платеж">
		<ep:Payee payeeName="Тестовый получатель" inn="7704441808">
			<com:PayeeAccountInfo personalAcc="40802840442034415249">
				<com:Bank bik="044525068"/>
			</com:PayeeAccountInfo>
		</ep:Payee>
		<ep:Payer payerName="Тестовый плательщик" inn="7727428546">
			<com:PayerAccountInfo personalAcc="40703840705658921366">
				<com:Bank bik="044525068"/>
			</com:PayerAccountInfo>
		</ep:Payer>
	</ep:ExecPayData>
</ep:ExecPayResponse>
-->
           </tns:MessagePrimaryContent>
          </tns:content>
        </tns:ResponseContent>
      </tns:ResponseMessage>
    </tns:ClientMessage>

  </xsl:template>
</xsl:transform>
