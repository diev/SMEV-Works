<?xml version="1.0" encoding="UTF-8"?>
<!-- General Unified Transmission Data Format GUTDF v3.0 -->
<!-- Редакция от 2024-10-29 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="windows-1251"/>
<xsl:strip-space elements="*" />
<xsl:variable name="apos">'</xsl:variable>

<xsl:template match="/Document/Source">
    <xsl:value-of select="concat(
    /Document/Source//shortName, ', ',
    /Document/Source//sourceCreditInfoDate)" />
</xsl:template>

<xsl:template match="Data">
    <xsl:apply-templates select="." mode="tree" />
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="Data" mode="tree"><!-- root -->
    <xsl:apply-templates mode="tree" />
</xsl:template>

<xsl:template match="Subject_UL" mode="tree">
    <xsl:text>&#xA;&#xA;</xsl:text>
    <xsl:value-of select="concat(
    Title/UL_1_Name/shortName, ', ',
    Title/UL_4_Tax//taxNum)" />
    <xsl:apply-templates select="Events" mode="tree" />
</xsl:template>

<xsl:template match="Subject_FL" mode="tree">
    <xsl:text>&#xA;&#xA;</xsl:text>
    <xsl:value-of select="concat(
    Title//FL_1_Name/lastName, ' ',
    Title//FL_1_Name//firstName, ' ',
    Title//FL_1_Name//middleName, ', ',
    Title/FL_3_Birth/birthDate)" />
    <xsl:apply-templates select="Events" mode="tree" />
</xsl:template>

<xsl:template match="Events" mode="tree"><!-- root2 -->
    <xsl:apply-templates mode="tree" />
</xsl:template>

<xsl:template match="*" mode="tree"><!-- element -->

    <xsl:call-template name="check-flag">
        <xsl:with-param name="elem-name" select="local-name()" />
    </xsl:call-template>

    <xsl:apply-templates select="@*" mode="tree" />
    <xsl:apply-templates mode="tree" />
</xsl:template>

<xsl:template match="@*" mode="tree"><!-- attribute -->
    <xsl:text /><xsl:value-of select="local-name()" />=<xsl:value-of select="." /><xsl:text />
    <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="text()" mode="tree"><!-- text -->
    <!--xsl:value-of select="." /-->
    <xsl:call-template name="escape-ws">
        <xsl:with-param name="text" select="." />
    </xsl:call-template>
</xsl:template>

<xsl:template name="elem-tree">
    <xsl:text>&#xA;</xsl:text>
    <xsl:for-each select="ancestor::*">
        <xsl:choose>
            <xsl:when test="following-sibling::node()"><xsl:text>  </xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>  </xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    <!--
    <xsl:choose>
        <xsl:when test="parent::node() and ../child::node()"><xsl:text> </xsl:text></xsl:when>
        <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
    </xsl:choose>
    -->
</xsl:template>

<xsl:template name="check-flag">
    <xsl:param name="elem-name" />

    <xsl:variable name="before"><xsl:value-of select="substring-before($elem-name, '_')" /></xsl:variable>
    <xsl:variable name="after"><xsl:value-of select="substring-after($elem-name, '_')" /></xsl:variable>

    <xsl:choose>
        <xsl:when test="$after=1">
            <xsl:call-template name="elem-tree" />

            <xsl:call-template name="pad">
                <xsl:with-param name="text" select="$before" />
            </xsl:call-template>
            <xsl:text>+</xsl:text>
        </xsl:when>
        <xsl:when test="$after=0">
            <!-- optional (-) -->
            <xsl:call-template name="elem-tree" />

            <xsl:call-template name="pad">
                <xsl:with-param name="text" select="$before" />
            </xsl:call-template>
            <xsl:text>-</xsl:text>
            <!-- optional (-) -->
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="elem-tree" />

            <xsl:call-template name="pad">
                <xsl:with-param name="text" select="$elem-name" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="pad">
    <xsl:param name="text" />
    <xsl:value-of select="substring(concat($text, '                         '), 1, 25)" />
</xsl:template>

<xsl:template name="escape-ws">
    <xsl:param name="text" />
    <xsl:choose>
        <xsl:when test="contains($text, '\')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '\')" />
            </xsl:call-template>
            <xsl:text>\\</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '\')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($text, $apos)">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, $apos)" />
            </xsl:call-template>
            <xsl:text>\'</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, $apos)" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($text, '&#xA;')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '&#xA;')" />
            </xsl:call-template>
            <!-- <xsl:text>\n</xsl:text> -->
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#xA;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($text, '&#x9;')">
            <xsl:value-of select="substring-before($text, '&#x9;')" />
            <!-- <xsl:text>\t</xsl:text> -->
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#x9;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
