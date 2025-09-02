<xslo:template mode="index_data_field" match="marc:datafield[@tag='027']">
    <z:index name="Report-number:w Identifier-standard:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='028']">
    <z:index name="Identifier-publisher-for-music:w Identifier-standard:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='030']">
    <z:index name="CODEN:w Identifier-standard:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='034']">
    <z:index name="Map-scale:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='035']">
    <z:index name="Other-control-number:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='037']">
    <z:index name="Identifier-standard:w Stock-number:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='040']">
    <z:index name="Code-institution:w Record-source:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='043']">
    <z:index name="Code-geographic:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='050']">
    <z:index name="LC-call-number:w LC-call-number:p LC-call-number:s">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='052']">
    <z:index name="Geographic-class:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='060']">
    <z:index name="NLM-call-number:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='070']">
    <z:index name="NAL-call-number:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='080']">
    <z:index name="UDC-classification:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='082']">
    <z:index name="Dewey-classification:w Dewey-classification:s">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='086']">
    <z:index name="Number-govt-pub:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='100']">
    <z:index name="Author:w Author:p Author:s Author-title:w Author-name-personal:w Name:w Name-and-title:w Personal-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='110']">
    <z:index name="Author:w Author:p Author:s Author-title:w Author-name-corporate:w Name:w Name-and-title:w Corporate-name:w Corporate-name:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='111']">
    <z:index name="Author:w Author:p Author:s Author-title:w Author-name-corporate:w Name:w Name-and-title:w Conference-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='130']">
    <z:index name="Title:w Title:p Title-uniform:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='210']">
    <z:index name="Title:w Title:p Title-abbreviated:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='211']">
    <z:index name="Title:w Title:p Title-abbreviated:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='212']">
    <z:index name="Title:w Title:p Title-other-variant:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='214']">
    <z:index name="Title:w Title:p Title-expanded:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='222']">
    <z:index name="Title:w Title:p Title-key:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='240']">
    <z:index name="Title:w Title:p Title-uniform:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='243']">
    <z:index name="Title:w Title:p Title-collective:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='245']">
    <z:index name="Title:w Title:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='246']">
    <z:index name="Title:w Title:p Title-abbreviated:w Title-expanded:w Title-former:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='247']">
    <z:index name="Title:w Title:p Title-former:w Title-other-variant:w Related-periodical:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='260']">
    <z:index name="pl:w Provider:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='264']">
    <z:index name="pl:w Provider:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='300']">
    <z:index name="Extent:w Extent:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='400']">
    <z:index name="Author:w Author-name-personal:w Name:w Personal-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='410']">
    <z:index name="Author:w Corporate-name:w Corporate-name:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='411']">
    <z:index name="Author:w Conference-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='440']">
    <z:index name="Title-series:w Title-series:p Title:w Title-series:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='490']">
    <z:index name="Title:w Title-series:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='500']">
    <z:index name="Note:w Note:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='502']">
    <z:index name="Material-type:w Dissertation-information:p Dissertation-information:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='505']">
    <z:index name="Note:w Note:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='510']">
    <z:index name="Indexed-by:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='520']">
    <z:index name="Abstract:w Abstract:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='590']">
    <z:index name="Note:w Note:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='600']">
    <z:index name="Name:w Personal-name:w Subject-name-personal:w Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='610']">
    <z:index name="Name:w Subject:w Subject:p Corporate-name:w Corporate-name:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='611']">
    <z:index name="Conference-name:w Name:w Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='630']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='650']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='651']">
    <z:index name="Name-geographic:w Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='653']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='654']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='655']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='656']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='657']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='658']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='690']">
    <z:index name="Subject:w Subject:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='700']">
    <z:index name="Author:w Author:p Author-name-personal:w Name:w Editor:w Personal-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='710']">
    <z:index name="Author:w Author:p Corporate-name:w Corporate-name:p Name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='711']">
    <z:index name="Author:w Author:p Author-name-corporate:w Name:w Conference-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='730']">
    <z:index name="Title:w Title:p Title-uniform:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='740']">
    <z:index name="Title:w Title:p Title-other-variant:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='751']">
    <z:index name="Name-geographic:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='780']">
    <z:index name="Title:w Title:p Title-former:w Related-periodical:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='785']">
    <z:index name="Title:w Title:p Title-later:w Related-periodical:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='800']">
    <z:index name="Author:w Author-name-personal:w Name:w Personal-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='810']">
    <z:index name="Author:w Corporate-name:w Corporate-name:p Author-name-corporate:w Name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='811']">
    <z:index name="Author:w Author-name-corporate:w Name:w Conference-name:w">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='830']">
    <z:index name="Title:w Title-series:w Title-series:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_data_field" match="marc:datafield[@tag='840']">
    <z:index name="Title:w Title-series:w Title-series:p">
      <xslo:variable name="raw_heading">
        <xslo:for-each select="marc:subfield">
          <xslo:if test="position() &gt; 1">
            <xslo:value-of select="substring(' ', 1, 1)"/>
          </xslo:if>
          <xslo:value-of select="."/>
        </xslo:for-each>
      </xslo:variable>
      <xslo:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_subfields" match="marc:datafield[@tag='911']">
    <xslo:for-each select="marc:subfield">
      <xslo:if test="contains('a', @code)">
        <z:index name="itemtype:w itemtype:p itype:w itype:p">
            <xslo:choose>
                <xslo:when test=". = 'a'">Chapter of a book</xslo:when>
                <xslo:when test=". = 'b'">Article of a journal</xslo:when>
                <xslo:when test=". = 'c'">Collection</xslo:when>
                <xslo:when test=". = 'd'">Review</xslo:when>
                <xslo:when test=". = 'm'">Book</xslo:when>
                <xslo:when test=". = 's'">Serial</xslo:when>
                <xslo:otherwise>
                    <xslo:value-of select="."/>
                </xslo:otherwise>
            </xslo:choose>
        </z:index>
      </xslo:if>
    </xslo:for-each>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='100']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="au:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='110']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="au:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='440']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="se:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='490']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="se:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='630']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="su-ut:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='650']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="su-to:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='651']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="su-geo:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='700']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="au:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='911']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="itype:0">
        <xslo:choose>
          <xslo:when test="marc:subfield[@code='a'] = 'a'">Chapter of a book</xslo:when>
          <xslo:when test="marc:subfield[@code='a'] = 'b'">Article of a journal</xslo:when>
          <xslo:when test="marc:subfield[@code='a'] = 'c'">Collection</xslo:when>
          <xslo:when test="marc:subfield[@code='a'] = 'd'">Review</xslo:when>
          <xslo:when test="marc:subfield[@code='a'] = 'm'">Book</xslo:when>
          <xslo:when test="marc:subfield[@code='a'] = 's'">Serial</xslo:when>
          <xslo:otherwise>
            <xslo:value-of select="marc:subfield[@code='a']"/>
          </xslo:otherwise>
        </xslo:choose>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='942']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="itype:0">
        <xslo:value-of select="marc:subfield[@code='c']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_facets" match="marc:datafield[@tag='952']">
    <xslo:if test="not(@ind1='z')">
      <z:index name="homebranch:0">
        <xslo:value-of select="marc:subfield[@code='a']"/>
      </z:index>
      <z:index name="holdingbranch:0">
        <xslo:value-of select="marc:subfield[@code='b']"/>
      </z:index>
      <z:index name="location:0">
        <xslo:value-of select="marc:subfield[@code='c']"/>
      </z:index>
      <z:index name="itype:0">
        <xslo:value-of select="marc:subfield[@code='y']"/>
      </z:index>
      <z:index name="ccode:0">
        <xslo:value-of select="marc:subfield[@code='8']"/>
      </z:index>
    </xslo:if>
  </xslo:template>
  <xslo:template mode="index_sort_title" match="marc:datafield[@tag='245']">
    <xslo:variable name="chop">
      <xslo:choose>
        <xslo:when test="not(number(@ind2))">0</xslo:when>
        <xslo:otherwise>
          <xslo:value-of select="number(@ind2)"/>
        </xslo:otherwise>
      </xslo:choose>
    </xslo:variable>
    <z:index name="Title:s">
      <xslo:value-of select="substring(marc:subfield[@code='a'], $chop+1)"/>
    </z:index>
  </xslo:template>
  <xslo:template mode="index_all" match="text()">
    <z:index name="Any:w Any:p">
      <xslo:value-of select="."/>
    </z:index>
  </xslo:template>
  <xslo:template name="chopPunctuation">
    <xslo:param name="chopString"/>
    <xslo:variable name="length" select="string-length($chopString)"/>
    <xslo:choose>
      <xslo:when test="$length=0"/>
      <xslo:when test="contains('-,.:=;!%/', substring($chopString,$length,1))">
        <xslo:call-template name="chopPunctuation">
          <xslo:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
        </xslo:call-template>
      </xslo:when>
      <xslo:when test="not($chopString)"/>
      <xslo:otherwise>
        <xslo:value-of select="$chopString"/>
      </xslo:otherwise>
    </xslo:choose>
    <xslo:text/>
  </xslo:template>
</xslo:stylesheet>