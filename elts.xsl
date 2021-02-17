<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="exsl str"
>

  <xsl:import href="./ac-to-jupyter.xml"/>
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:param name="eltname" select="'Unnamed'"/>

  <xsl:template match="/">
    <xsl:call-template name="minimize">
        <xsl:with-param name="data">
          {"nbformat": 4,"nbformat_minor": 0,"cells": [
            <xsl:call-template name="jupyter-cell">
              <xsl:with-param name="first-cell">true</xsl:with-param>
              <xsl:with-param name="source">
                <xsl:call-template name="css"/>
                <xsl:call-template name="newcommands"/>
                &lt;h1&gt;<xsl:value-of select="$eltname"/> - ELT Individual Workbook&lt;/h1&gt;
              </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="//section"/>
          ]}
        </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="section">
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="source">
        &lt;h2&gt;<xsl:value-of select="@number"/>&#160;<xsl:value-of select="title"/>&lt;/h2&gt;
        &lt;div&gt;<xsl:apply-templates select="." mode="link"/>&lt;/div&gt;
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select=".//exploration"/>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="source">
        &lt;h3&gt;<xsl:value-of select="@number"/> Team Activities&lt;/h3&gt;
        &lt;p&gt;Add link to team activities below:&lt;/p&gt;
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="editable">true</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="source">
        &lt;h3&gt;<xsl:value-of select="@number"/> Homework&lt;/h3&gt;
        &lt;p class="todo"&gt;TODO implement homework&lt;/p&gt;
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="editable">true</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="source">
        &lt;h3&gt;<xsl:value-of select="@number"/> Quiz&lt;/h3&gt;
        &lt;p&gt;Insert photo of a "mastered quiz" below:&lt;/p&gt;
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="jupyter-cell">
      <xsl:with-param name="editable">true</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="section" mode="number">
    <xsl:value-of select="@number"/>
  </xsl:template>

</xsl:stylesheet>