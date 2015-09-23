<!doctype html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/string-1.1" prefix="str" %>


<!-- plantOntologyDisplayer.jsp -->

<div id="plantOntology_displayer" class="collection-table">
<div class="header">
<h3>Plant Ontology</h3>
<p>Data Source: <a target="_blank" href="${WEB_PROPERTIES['PO_url']}">Plant Ontology Consortium</a></p>
</div>


<c:choose>
  <c:when test="${!empty noGoMessage }">
    <p>${noGoMessage}</p>
  </c:when>
  <c:otherwise>

    <c:choose>
      <c:when test="${!empty goTerms}">
        <table>
        <c:forEach items="${goTerms}" var="parentEntry">
          <c:set var="parentTerm" value="${parentEntry.key}" />
            <thead>

              <c:choose>
                <c:when test="${parentTerm eq 'plant anatomy'}">
                  <tr><th colspan="2">${parentTerm}: expressed in</th></tr>
                </c:when>
                <c:when test="${parentTerm eq 'plant structure development stage'}">
                  <tr><th colspan="2">${parentTerm}: expressed during</th></tr>
                </c:when>
              </c:choose>
<!--               <tr><th colspan="2">${parentTerm}</th></tr>
-->
            </thead>
            <tbody>
            <tr>
              <c:choose>
                <c:when test="${empty parentEntry.value}">
                  <tr>
                    <td class="smallnote" colspan="2"><i>No terms in this category.</i></td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach items="${parentEntry.value}" var="entry">
                    <tr>
                      <td>
                        <c:set var="term" value="${entry.key}" />
                        <html:link href="/${WEB_PROPERTIES['webapp.path']}/report.do?id=${term.id}" title="${term.description}">
                        <c:out value="${term.name}"/>
                        </html:link>&nbsp;<im:helplink text="${term.description}"/>
                      </td>
                      <td>
                        <c:set var="evidence" value="${entry.value}" />
                      <c:forEach items="${entry.value}" var="evidence">
                        <c:out value="${evidence}"/><c:if test="${!empty codes[evidence] }">&nbsp;<im:helplink text="${codes[evidence]}"/>
                        </c:if>
                        &nbsp;
                      </c:forEach>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tr>
            </tbody>
        </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
      <p style="font-style:italic;">No results</p>
    </c:otherwise>
  </c:choose>
  </c:otherwise>
</c:choose>
</div>
<!-- /plantOntologyDisplayer.jsp -->
