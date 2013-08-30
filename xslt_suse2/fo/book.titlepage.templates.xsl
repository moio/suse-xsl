<?xml version="1.0" encoding="UTF-8"?>
<!--
  Purpose:
    Restyle book's first page and imprint page

  Author(s):  Stefan Knorr <sknorr@suse.de>,
              Thomas Schraitle <toms@opensuse.org>

  Copyright:  2013, Stefan Knorr, Thomas Schraitle

-->
<!DOCTYPE xsl:stylesheet
[
  <!ENTITY % fonts SYSTEM "fonts.ent">
  <!ENTITY % colors SYSTEM "colors.ent">
  <!ENTITY % metrics SYSTEM "metrics.ent">
  %fonts;
  %colors;
  %metrics;
]>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <!--  Book ====================================================== -->
<xsl:template name="book.titlepage.recto">
  <xsl:variable name="height">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.height"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="logo.width" select="(1 + (602 div 3395)) * &column;"/>
  <xsl:variable name="margin.start">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.margin.outer"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="unit">
    <xsl:call-template name="get.unit.from.unit">
      <xsl:with-param name="string" select="$page.height"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="logo">
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename">
        <xsl:choose>
          <xsl:when test="$format.print != 0">
            <xsl:value-of select="$booktitlepage.bw.logo"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$booktitlepage.color.logo"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cover-image">
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename">
        <xsl:choose>
          <xsl:when test="$format.print != 0">
            <xsl:value-of select="concat($styleroot,
              'images/logos/suse-logo-tail-bw.svg')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($styleroot,
              'images/logos/suse-logo-tail.svg')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <fo:block-container top="{(2 - &goldenratio;) * $height}{$unit}" left="0"
    text-align="right"
    absolute-position="fixed">
    <fo:block>
    <!-- Almost golden ratio... -->
      <fo:external-graphic content-width="{(&column; * 5) + (&gutter; * 3)}mm"
        width="{(&column; * 5) + (&gutter; * 3)}mm"
        src="{$cover-image}"/>
    </fo:block>
  </fo:block-container>

  <fo:block-container top="{$page.margin.top}"
    left="{$margin.start - ((602 div 3395) * &column;)}mm" absolute-position="fixed">
    <!-- The above calculation is not complete voodoo - the SUSE logo SVG is
         3395px wide, the first "S" of SUSE starts at 602px and the output width
         of the logo is $logo.width mm. Effectively, the Geeko tail ends up on
         the page border. -->
    <fo:block>
      <fo:external-graphic content-width="{$logo.width}mm" width="{$logo.width}mm"
        src="{$logo}"/>
    </fo:block>
  </fo:block-container>

  <fo:block-container top="0" left="0" absolute-position="fixed"
    height="{$height * (2 - &goldenratio;)}{$unit}">
    <fo:block>
    <fo:table width="{(&column; * 7) + (&gutter; * 5)}mm" table-layout="fixed"
      block-progression-dimension="auto">
      <fo:table-column column-number="1" column-width="100%"/>

      <fo:table-body>
        <fo:table-row>
          <fo:table-cell display-align="after"
            height="{$height * (2 - &goldenratio;)}{$unit}" >
            <fo:table width="{(&column; * 7) + (&gutter; * 5)}mm"
              table-layout="fixed" block-progression-dimension="auto">
              <fo:table-column column-number="1" column-width="{&column;}mm"/>
              <fo:table-column column-number="2"
                column-width="{(&column; * 6) + (&gutter; * 5)}mm"/>
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block> </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block padding-after="&gutterfragment;mm">
                      <xsl:choose>
                        <xsl:when test="bookinfo/title">
                          <xsl:apply-templates mode="book.titlepage.recto.auto.mode"
                            select="bookinfo/title"/>
                        </xsl:when>
                        <xsl:when test="info/title">
                          <xsl:apply-templates mode="book.titlepage.recto.auto.mode"
                            select="info/title"/>
                        </xsl:when>
                        <xsl:when test="title">
                          <xsl:apply-templates mode="book.titlepage.recto.auto.mode"
                            select="title"/>
                        </xsl:when>
                      </xsl:choose>
                      </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <xsl:attribute name="border-top">0.5mm solid <xsl:call-template name="dark-green"/></xsl:attribute>
                    <fo:block> </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <xsl:attribute name="border-top">0.5mm solid <xsl:call-template name="dark-green"/></xsl:attribute>
                    <fo:block padding-before="&columnfragment;mm">
                      <!-- We use the full productname here: -->
                      <xsl:apply-templates mode="book.titlepage.recto.auto.mode"
                        select="bookinfo/productname[not(@role)]"/>
                      </fo:block>
                    </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
    </fo:block>
  </fo:block-container>

  <!-- XEP needs at least one block following the normal flow, else it won't
       create a page break. This is not elegant, but works. -->
  <fo:block><fo:leader/></fo:block>
</xsl:template>

<xsl:template match="title" mode="book.titlepage.recto.auto.mode">
  <fo:block text-align="left" line-height="1.2" hyphenate="false"
    xsl:use-attribute-sets="title.font sans.bold.noreplacement title.name.color"
    font-weight="normal"
    font-size="{&ultra-large;}pt">
    <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="subtitle" mode="book.titlepage.recto.auto.mode">
  <fo:block
    xsl:use-attribute-sets="title.font" font-size="&super-large;pt"
    space-before="&gutterfragment;mm">
    <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="productname[not(@role)]" mode="book.titlepage.recto.auto.mode">
  <fo:block text-align="left" hyphenate="false"
    line-height="{$base-lineheight * 0.8}em"
    font-weight="normal" font-size="&super-large;pt"
    space-after="&gutterfragment;mm"
    xsl:use-attribute-sets="title.font sans.bold.noreplacement mid-green">
    <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="../productnumber[not(@role)]" mode="book.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="title" mode="book.titlepage.verso.auto.mode">
  <fo:block
    xsl:use-attribute-sets="book.titlepage.verso.style sans.bold"
    font-size="&x-large;pt" font-family="{$title.fontset}">
  <xsl:call-template name="book.verso.title"/>
  </fo:block>
</xsl:template>

<xsl:template match="legalnotice" mode="book.titlepage.verso.auto.mode">
  <fo:block
    xsl:use-attribute-sets="book.titlepage.verso.style" font-size="&small;pt">
    <xsl:apply-templates select="*" mode="book.titlepage.verso.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="legalnotice/para" mode="book.titlepage.verso.mode">
  <fo:block space-after="0.25em" space-before="0em">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- Part ======================================================== -->
<xsl:template match="title" mode="part.titlepage.recto.auto.mode">
  <fo:block
    xsl:use-attribute-sets="part.titlepage.recto.style sans.bold.noreplacement"
    font-size="&super-large;pt" space-before="&columnfragment;mm"
    font-family="{$title.fontset}">
    <xsl:call-template name="division.title">
      <xsl:with-param name="node" select="ancestor-or-self::part[1]"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="subtitle" mode="part.titlepage.recto.auto.mode">
  <fo:block
    xsl:use-attribute-sets="part.titlepage.recto.style sans.bold.noreplacement
    italicized.noreplacement" font-size="&xxx-large;pt"
    space-before="&gutter;mm" font-family="{$title.fontset}">
    <xsl:apply-templates select="." mode="part.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<!-- ============================================================
      Imprint page
     ============================================================
-->
<xsl:template name="book.titlepage.verso">
  <xsl:variable name="height">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.height"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="page-height">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.height"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="margin-top">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.margin.top"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="margin-bottom">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$page.margin.bottom"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="margin-bottom-body">
    <xsl:call-template name="get.value.from.unit">
      <xsl:with-param name="string" select="$body.margin.bottom"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="table.height"
    select="$page-height - ($margin-top + $margin-bottom + $margin-bottom-body)"/>
  <xsl:variable name="unit">
    <xsl:call-template name="get.unit.from.unit">
      <xsl:with-param name="string" select="$page.height"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:table table-layout="fixed" block-progression-dimension="auto"
    height="{$table.height}{$unit}"
    width="{(6 * &column;) + (5 * &gutter;)}mm">
    <fo:table-column column-number="1" column-width="100%"/>
    <fo:table-body>
      <fo:table-row>
        <fo:table-cell height="{0.4 * $table.height}{$unit}">
          <xsl:apply-templates
            select="(bookinfo/title | info/title | title)[1]"
            mode="book.titlepage.verso.auto.mode"/>
          <xsl:apply-templates
            select="(bookinfo/productname | info/productname)[not(@role)]"
            mode="book.titlepage.verso.auto.mode"/>

          <xsl:apply-templates
            select="(bookinfo/authorgroup | info/authorgroup)[1]"
            mode="book.titlepage.verso.auto.mode"/>
          <xsl:apply-templates
            select="(bookinfo/author | info/author)[1]"
            mode="book.titlepage.verso.auto.mode"/>

          <xsl:apply-templates
            select="(bookinfo/abstract | info/abstract)[1]"
            mode="book.titlepage.verso.auto.mode"/>
        </fo:table-cell>
      </fo:table-row>

      <!-- Everything else is in a second block of text at the bottom -->
      <fo:table-row>
        <fo:table-cell display-align="after" height="{0.6 * $table.height}{$unit}">

          <xsl:call-template name="date.and.revision"/>

          <xsl:apply-templates
            select="(bookinfo/corpauthor | info/corpauthor)[1]"
            mode="book.titlepage.verso.auto.mode"/>
          <xsl:apply-templates
            select="(bookinfo/othercredit | info/othercredit)[1]"
            mode="book.titlepage.verso.auto.mode"/>
          <xsl:apply-templates
            select="(bookinfo/editor | info/editor)[1]"
            mode="book.titlepage.verso.auto.mode"/>

          <xsl:call-template name="suse.imprint"/>

          <xsl:apply-templates
            select="(bookinfo/copyright | info/copyright)[1]"
            mode="book.titlepage.verso.auto.mode"/>

          <xsl:apply-templates
            select="(bookinfo/legalnotice | info/legalnotice)[1]"
            mode="book.titlepage.verso.auto.mode"/>
        </fo:table-cell>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
</xsl:template>


<xsl:template name="suse.imprint">
  <xsl:variable name="ulink.url">
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename" select="$suse.doc.url"/>
    </xsl:call-template>
  </xsl:variable>
  <fo:block xsl:use-attribute-sets="book.titlepage.verso.style"
    space-after="1.2em" space-before="1.2em">
    <fo:block line-height="{$line-height}"
      white-space-treatment="preserve"
      wrap-option="no-wrap"
      linefeed-treatment="preserve"
      white-space-collapse="false">SUSE Linux Products GmbH
Maxfeldstr. 5
90409 Nürnberg
GERMANY</fo:block>
     <fo:block><fo:basic-link external-destination="{$ulink.url}"
       xsl:use-attribute-sets="dark-green">
       <xsl:value-of select="$suse.doc.url"/>
       <xsl:call-template name="image-after-link"/>
     </fo:basic-link>
     </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="title" mode="book.titlepage.verso.auto.mode">
    <fo:block font-size="&x-large;pt"
      xsl:use-attribute-sets="book.titlepage.verso.style dark-green sans.bold.noreplacement title.font">
      <xsl:call-template name="book.verso.title"/>
    </fo:block>
</xsl:template>

<xsl:template match="productname[not(@role)]" mode="book.titlepage.verso.auto.mode">
  <fo:block xsl:use-attribute-sets="book.titlepage.verso.style"
    font-size="&large;pt" font-family="{$title.fontset}">
    <xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
    <xsl:text> </xsl:text>
    <xsl:if test="../productnumber">
      <!-- Use productnumber without role first, but fallback to
        productnumber with role
      -->
      <xsl:apply-templates mode="book.titlepage.verso.mode"
        select="(../productnumber[@role] |
                 ../productnumber[not(@role)])[last()]" />
    </xsl:if>
  </fo:block>
</xsl:template>

<xsl:template match="editor" mode="book.titlepage.verso.auto.mode">
  <fo:block font-size="&normal;pt">
    <xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="authorgroup|author" mode="book.titlepage.verso.auto.mode">
  <fo:block xsl:use-attribute-sets="title.font">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template name="date.and.revision">
  <xsl:variable name="date">
    <xsl:apply-templates select="(bookinfo/date | info/date |
      articleinfo/date)[1]"/>
  </xsl:variable>
  <xsl:variable name="revision"
    select="substring-before(substring-after((bookinfo/releaseinfo |
    info/releaseinfo | articleinfo/releaseinfo)[1], '$'), ' $')"/>
  <xsl:if test="$date != '' or $revision != ''">
    <fo:block xsl:use-attribute-sets="book.titlepage.verso.style">
      <xsl:if test="$date != ''">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'pubdate'"/>
        </xsl:call-template>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'admonseparator'"/>
        </xsl:call-template>
        <xsl:value-of select="$date"/>
        <xsl:if test="$revision != ''">
          <!-- Misappropriated but hopefully still correct everywhere. -->
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'iso690'"/>
            <xsl:with-param name="name" select="'spec.pubinfo.sep'"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    <xsl:if test="$revision != ''">
      <xsl:value-of select="$revision"/>
    </xsl:if>
  </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="date/processing-instruction('dbtimestamp')" mode="book.titlepage.verso.mode">
  <xsl:call-template name="pi.dbtimestamp"/>
</xsl:template>

</xsl:stylesheet>