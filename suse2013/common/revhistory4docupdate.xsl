<?xml version="1.0" encoding="UTF-8"?>
<!--
   Purpose:

   Parameters:

   Input:
     DocBook 5 document
   
   Dependencies:
     - none ATM

   Prerequisites:
     Whenever you want a docupdate, do the following:
     
     1. Add role="docupdate" in your appendix
     2. Create one or more sect1's with a revision attribute. The revision
        attribute needs to be a unique value, typically something which
        describes your release like "12GA", "12SP1", "12SP2", etc.
     3. Add your <revhistory> inside <info> in your chapter.
        Each <revision> must contain a revision attribute which the unique
        value from step 2.
     4. Add as many <revision>s as you like. However, keep in mind these
        recommendations:
        a. Add the latest entry as first child.
        b. Insert whatever you like inside <revision>. Usually an
           <itemizedlist> works quite well to list all your changes for this
           release
        c. When the <revhistory> grows, try to keep readability high. Maybe
           it's a good idea to move old entries into a separate file and
           xinclude them.

   Implementation Details:
   

   Output:
     DocBook5
   
   Author:    Thomas Schraitle <toms@opensuse.org>
   Copyright (C) 2012-2015 SUSE Linux GmbH

-->
<!DOCTYPE xsl:stylesheet
[
  <!ENTITY db5ns "http://docbook.org/ns/docbook">
]>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="exsl d">

  <xsl:output indent="yes"/>

  <xsl:template match="node() | @*" name="copy">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:appendix[@role='docupdate']">   
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="docupdate"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="docupdate">
    <xsl:message>Ignoring <xsl:value-of select="local-name(.)"/></xsl:message>
  </xsl:template>

  <xsl:template match="d:title|d:info|d:para[. != '']" mode="docupdate">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <!-- Only investigate sections with an revision attribute -->
  <xsl:template match="d:sect1[@revision]" mode="docupdate">
    <xsl:param name="allrevisions" select="//d:info/d:revhistory/d:revision"/>
    <xsl:variable name="rev" select="@revision"/>
    <xsl:variable name="revgroup" select="$allrevisions[@revision=$rev]"/>

    <xsl:choose>
      <xsl:when test="count($revgroup) > 0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates
            select="node()[not(self::d:para[. = ''])]"/>
          <xsl:message>Grouping with =><xsl:value-of
              select="concat($rev, ':', count($revgroup))"
            /></xsl:message>
          <variablelist>
            <xsl:apply-templates select="$revgroup" mode="docupdate">
              <xsl:sort select="@revision" order="descending"/>
            </xsl:apply-templates>
          </variablelist>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Ignoring <xsl:value-of select="$rev"
          /></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:revhistory" mode="docupdate">
    <xsl:variable name="division" select="ancestor::d:info/parent::*"/>
    <xsl:message>
   revhistory
     <xsl:value-of select="concat(local-name($division), ' id=', $division/@xml:id)"/>
    </xsl:message>
    <xsl:comment>
      # <xsl:value-of select="d:revision/@revision"/>
      # parent=<xsl:value-of select="concat(local-name($division), ' id=', $division/@xml:id, '&#10;')"/>
    </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="d:revision/d:date" mode="docupdate">
    <xsl:text>(Released </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="d:revhistory/d:revision" mode="docupdate">
    <xsl:variable name="division" select="ancestor::d:info/parent::*"/>
    <xsl:message>  revision = <xsl:value-of select="@revision"/> in <xsl:value-of 
      select="concat(local-name($division), ' id=', $division/@xml:id, '&#10;')"/></xsl:message>
    
      <varlistentry>
        <term>
          <xsl:choose>
            <xsl:when test="$division/self::d:book">General</xsl:when>
            <xsl:otherwise>
              <xref linkend="{$division/@xml:id}"/>
            </xsl:otherwise>
          </xsl:choose>
        </term>
        <listitem>
          <xsl:copy-of select="d:revdescription/node()"/>
        </listitem>
      </varlistentry>
  </xsl:template>

</xsl:stylesheet>