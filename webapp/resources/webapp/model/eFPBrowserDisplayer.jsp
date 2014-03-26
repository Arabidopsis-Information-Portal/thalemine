<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<!-- eFPBrowserDisplayer.jsp -->
<div class="basic-table">
<h3>eFP Visualization</h3>
<br />

<c:set var="object" value="${reportObject.object}"/>

<c:choose>
<c:when test="${((!empty object.chromosomeLocation && !empty object.chromosome)
                || className == 'Chromosome') && className != 'ChromosomeBand'}">


<div id="eFPBrowser" class="feature basic-table">
  <c:set var="name" value="${object.primaryIdentifier}"/>
  <c:set var="datasource" value="Developmental_Map"/>

  <c:choose>
  <c:when test="${WEB_PROPERTIES['bar.eFPBrowser.prefix'] != null}">
  <style type="text/css">
      #powerby { padding: 5px; text-align: center; }
      #powerby a { color: rgb(136, 136, 136); text-decoration: none; background-color: white; }
      #powerby img { vertical-align: middle; }
  </style>
  <div>
      <input type="hidden" id="agi" value="${name}" />
      <label for="datasource"><strong>Data Source: </strong></label>
      <select id="datasource" name="datasource">
          <option value="Abiotic_Stress">Abiotic Stress</option>
          <option value="Abiotic_Stress_At-TAX">Abiotic Stress At-TAX</option>
          <option value="Abiotic_Stress_II">Abiotic Stress II</option>
          <option value="Biotic_Stress">Biotic Stress</option>
          <option value="Biotic_Stress_II">Biotic Stress II</option>
          <option value="Chemical">Chemical</option>
          <option value="Development_RMA">Development RMA</option>
          <option value="Developmental_Map" selected="selected">Developmental Map</option>
          <option value="Developmental_Map_At-TAX">Developmental Map At-TAX</option>
          <option value="Guard_Cell">Guard Cell</option>
          <option value="Hormone">Hormone</option>
          <option value="Lateral_Root_Initiation">Lateral Root Initiation</option>
          <option value="Light_Series">Light Series</option>
          <option value="Natural_Variation">Natural Variation</option>
          <option value="Regeneration">Regeneration</option>
          <option value="Root">Root</option>
          <option value="Root_II">Root II</option>
          <option value="Seed">Seed</option>
          <option value="Tissue_Specific">Tissue Specific</option>
      </select>
      <br /><br />
      <img id="eFP-img" src="" />
  </div>
  <div id="powerby">
      <a onmouseout="this.style.backgroundColor='white';" onmouseover="this.style.backgroundColor='#f1f1d1';" title="BAR Webservices" target="_blank" href="http://bar.utoronto.ca/webservices/efp_service/efp_service.php">
          Powered by <img border="0/" src="http://bar.utoronto.ca/ntools/bbc_logo_small.gif" height="15" width="15"> BAR Webservices
      </a>
  </div>
  <script type="text/javascript">
    function loadeFPimage(ds) {
        var bar_eFPBrowser_url = "${WEB_PROPERTIES['bar.eFPBrowser.prefix']}";
        var agi = jQuery('#agi').val();
        var datasource = ds || jQuery('#datasource').val();
        if(ds !== undefined) {
            jQuery('#datasource option[value="' + ds + '"]').prop('selected', true);
        }
        var bar_eFPBrowser_params = 'request={"agi":"' + agi + '","datasource":"' + datasource + '"}';
        jQuery.ajax({
            type: "GET",
            url: bar_eFPBrowser_url,
            data: bar_eFPBrowser_params,
            success: function(data, textStatus, xhr) {
                ct = xhr.getResponseHeader("content-type");
                if(ct === "image/png") {
                    jQuery('#eFP-img').fadeOut(250, function() { jQuery(this).attr('src', bar_eFPBrowser_url + "?" + bar_eFPBrowser_params); jQuery(this).fadeIn(250); });
                } else {
                    jQuery('#eFP-img').attr('src', 'model/images/eFP_image_not_available.png');
                }
            }
        });
    }

    jQuery(document).ready(function(){
            jQuery('#datasource').bind('change', function() {
                loadeFPimage.apply(this, [undefined])
            });
        jQuery('#datasource').trigger('change');
    });
  </script>
  </c:when>
  <c:otherwise>
   	<p>There was a problem rendering the BAR eFP Browser</code>.</p>
	<script type="text/javascript">
		jQuery('#eFPBrowser').addClass('warning');
	</script>
  </c:otherwise>
  </c:choose>
</div>
</c:when>
<c:otherwise>
<div id="eFPBrowser" class="feature basic-table warning">
  <h3><fmt:message key="sequenceFeature.eFPBrowser.message"/></h3>
  <p>There was a problem rendering the BAR eFP Browser.</p>
</div>
</c:otherwise>
</c:choose>
<!-- /eFPBrowserDisplayer.jsp -->
