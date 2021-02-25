<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="exsl str"
>

    <xsl:output method="html" encoding="UTF-8"/>

    <xsl:param name="target" select="/pretext/book/chapter[1]/section[1]"/>

    <xsl:template match="/">
        <xsl:apply-templates select="$target"/>
    </xsl:template>

    <xsl:template match="chapter" mode="name">
        <xsl:text>Chapter </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="title"/>
    </xsl:template>
    <xsl:template match="chapter" mode="number">
        <xsl:number from="//book" level="any" count="chapter"/>
    </xsl:template>

    <xsl:template match="section">
        <div>
            <h1>
                <xsl:apply-templates select="." mode="name"/>
            </h1>
            <div>
                <a>
                    <xsl:attribute name="href">
                        <xsl:apply-templates select="." mode="url"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="." mode="url"/>
                </a>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="section" mode="url">
        <xsl:text>https://activecalculus.org/prelude/</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>.html</xsl:text>
    </xsl:template>
    <xsl:template match="section" mode="name">
        <xsl:text>Section </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="title"/>
    </xsl:template>
    <xsl:template match="section" mode="number">
        <xsl:apply-templates select="./ancestor::chapter" mode="number"/>
        <xsl:text>.</xsl:text>
        <xsl:number from="//chapter" level="any" count="section"/>
    </xsl:template>

</xsl:stylesheet>
