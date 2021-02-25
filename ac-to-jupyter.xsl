<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="exsl str"
>

    <xsl:output method="html" encoding="UTF-8"/>

    <xsl:param name="target" select="/pretext/book/chapter[1]/section[1]"/>

    <xsl:template match="/">
        <xsl:apply-templates select="/pretext/book/chapter[1]/section[1]"/>
    </xsl:template>

    <xsl:template match="chapter" mode="name">
      <xsl:text>Chapter </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="chapter" mode="number">
      <xsl:apply-templates select="./ancestor::book" mode="number"/>.<xsl:number from="//book" level="any" count="chapter"/>
    </xsl:template>

    <xsl:template match="section">
        <h1><xsl:apply-templates match="section" mode="name"/></h1>
    </xsl:template>
    <xsl:template match="section" mode="name">
      <xsl:text>Section </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="section" mode="number">
      <xsl:apply-templates select="./ancestor::chapter" mode="number"/>.<xsl:number from="//chapter" level="any" count="section"/>
    </xsl:template>

    <xsl:template match="subsection" mode="name">
      <xsl:text>Subsection </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="subsection" mode="number">
      <xsl:apply-templates select="./ancestor::section" mode="number"/>.<xsl:number from="//section" level="any" count="subsection"/>
    </xsl:template>



    <!-- Supported PreTeXt elements -->

    <xsl:template match="exploration|activity" mode="number">
      <xsl:apply-templates select="./ancestor::section" mode="number"/>.<xsl:number from="//section" level="any" count="exploration|activity"/>
    </xsl:template>
    <xsl:template match="exploration" mode="name">
      <xsl:text>Preview Activity </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="activity" mode="name">
      <xsl:text>Activity </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
    </xsl:template>

    <xsl:template match="p">
        <span>
            <xsl:apply-templates select="text()|*"/>
        </span>
    </xsl:template>

    <xsl:template match="sidebyside">
        <div class="sidebyside">
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>

    <xsl:template match="ol">
        <ol>
            <xsl:apply-templates select="li"/>
        </ol>
    </xsl:template>

    <xsl:template match="ul">
        <ul>
            <xsl:apply-templates select="li"/>
        </ul>
    </xsl:template>

    <xsl:template match="li">
        <xsl:apply-templates select="text()|*"/>
    </xsl:template>

    <xsl:template match="image">
        <div>
            <img>
                <xsl:attribute name="src"><xsl:value-of select="@source"/>.svg</xsl:attribute>
            </img>
        </div>
    </xsl:template>
    <xsl:template match="figure">
        <div>
            <figure>
                <figcaption>
                    <b><xsl:apply-templates select="." mode="name"/>.</b>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="caption"/>
                </figcaption>
                <xsl:apply-templates select="image"/>
            </figure>
        </div>
    </xsl:template>
    <xsl:template match="table">
        <div>
            <table>
                <caption>
                    <b><xsl:apply-templates select="." mode="name"/>.</b>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="caption"/>
                </caption>
                <xsl:apply-templates select="tabular/row"/>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="tabular">
        <div>
            <table>
                <xsl:apply-templates select="row"/>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="row">
        <tr>
          <xsl:apply-templates select="cell" mode="markdown"/>
        </tr>
    </xsl:template>
    <xsl:template match="cell">
        <td>
            <xsl:apply-templates select="text()|*" mode="markdown"/>
        </td>
    </xsl:template>
    <xsl:template match="caption">
        <xsl:apply-templates select="text()|*"/>
    </xsl:template>

    <xsl:template match="fn">
        <span class="fn">
            (<xsl:apply-templates select="text()|*" />)
        </span>
    </xsl:template>
    <xsl:template match="q">
        <span class="q">
            "<xsl:apply-templates select="text()|*" />"
        </span>
    </xsl:template>
    <xsl:template match="m">
        <span class="m">
            $<xsl:apply-templates select="text()|*" />$
        </span>
    </xsl:template>
    <xsl:template match="me">
        <span class="me">
            $$<xsl:apply-templates select="text()|*" />$$
        </span>
    </xsl:template>
    <xsl:template match="md">
        <span class="md">
            $$\begin{align*}<xsl:apply-templates select="text()|*" />\end{align*}$$
        </span>
    </xsl:template>
    <xsl:template match="mrow">
        <xsl:apply-templates select="text()"/>\\
    </xsl:template>
    <xsl:template match="fillin">
        <span class="fillin">
            <xsl:apply-templates select="text()|*" />
        </span>
        <xsl:apply-templates select="text()"/>\\
    </xsl:template>

    <xsl:template match="table|figure|definition|example" mode="number">
        <xsl:apply-templates select="./ancestor::section" mode="number"/>.<xsl:number from="//section" level="any" count="table|figure|definition|example"/>
    </xsl:template>
    <xsl:template match="table" mode="name">
        <xsl:text>Table </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="figure" mode="name">
        <xsl:text>Figure </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="definition" mode="name">
        <xsl:text>Definition </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
    </xsl:template>
    <xsl:template match="example" mode="name">
        <xsl:text>Example </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
    </xsl:template>

    <xsl:template match="xref">
        <xsl:apply-templates select="//*[@xml:id=current()/@ref]" mode="name"/>
    </xsl:template>

</xsl:stylesheet>
