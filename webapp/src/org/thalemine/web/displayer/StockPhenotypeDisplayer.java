package org.thalemine.web.displayer;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Properties;
import java.util.TreeSet;
import java.util.TreeMap;
import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.intermine.api.InterMineAPI;
import org.intermine.api.profile.Profile;
import org.intermine.api.query.PathQueryExecutor;
import org.intermine.api.results.ExportResultsIterator;
import org.intermine.api.results.ResultElement;
import org.intermine.bio.web.displayer.GeneSNPDisplayer.GenoSample;
import org.intermine.bio.web.displayer.GeneSNPDisplayer.SNPList;
import org.intermine.model.InterMineObject;
import org.intermine.model.bio.Gene;
import org.intermine.model.bio.Allele;
import org.intermine.objectstore.ObjectStoreException;
import org.intermine.pathquery.Constraints;
import org.intermine.pathquery.OrderDirection;
import org.intermine.pathquery.PathQuery;
import org.intermine.util.DynamicUtil;
import org.intermine.web.displayer.ReportDisplayer;
import org.intermine.web.logic.config.ReportDisplayerConfig;
import org.intermine.web.logic.results.ReportObject;
import org.intermine.web.logic.session.SessionMethods;
import org.intermine.web.util.URLGenerator;
import org.thalemine.web.domain.AlleleVO;
import org.thalemine.web.domain.PhenotypeVO;
import org.thalemine.web.domain.StockVO;
import org.thalemine.web.domain.StrainVO;
import org.thalemine.web.query.StockQueryService;
import org.thalemine.web.utils.QueryServiceLocator;
import org.thalemine.web.utils.WebApplicationContextLocator;
import org.intermine.pathquery.OuterJoinStatus;

public class StockPhenotypeDisplayer extends ReportDisplayer {

	private static final String STOCK_SERVICE = "StockQueryService";
	protected static final Logger log = Logger.getLogger(StockPhenotypeDisplayer.class);

	public StockPhenotypeDisplayer(ReportDisplayerConfig config, InterMineAPI im) {
		super(config, im);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void display(HttpServletRequest request, ReportObject reportObject) {

		Exception exception = null;
		Gene gene = null;
		Allele allele = null;
		InterMineObject object = null;
		
		String objectClassName = reportObject.getClassDescriptor().getUnqualifiedName();
		List<StockVO> resultList = new ArrayList<StockVO>();
		
		String contextURL = null;
		String stockServiceUrl = null;
		

		try {
			
			contextURL = WebApplicationContextLocator.getServiceUrl(request);
			log.info("Service Context URL:" + contextURL);

			StockQueryService stockService = (StockQueryService) QueryServiceLocator.getService(STOCK_SERVICE, request);
			stockServiceUrl = stockService.getServiceUrl();
			log.info("Stock Service Context URL:" + contextURL);
			
			objectClassName = reportObject.getClassDescriptor().getUnqualifiedName();
			
			request.setAttribute("className", objectClassName);
			log.info("Gene StockPhenotype Displayer:" + "Class Name:" + objectClassName);
			
			object = reportObject.getObject();

			if (objectClassName.equals("Gene")){
				gene = (Gene) reportObject.getObject();
				log.info("Generating StockPhenotype Report. Gene Id:" + gene.getPrimaryIdentifier());
			}else if (objectClassName.equals("Allele"))
			{
				allele = (Allele) reportObject.getObject();
				log.info("Generating StockPhenotype Report. Allele Id:" + allele.getPrimaryIdentifier());
			}else{
				throw new Exception("Unknown Object Type.");
			}

			resultList = stockService.getStocks(object, objectClassName);

		} catch (Exception e) {
			exception = e;
		} finally {

			if (exception != null) {
				log.error("Error occurred Stock/Phenotypes displayer." + ";Message:" + exception.getMessage()
						+ ";Cause:" + exception.getCause());
				return;
			} else {
				
				// Set Request Attributes		
				request.setAttribute("list", resultList);
				request.setAttribute("id", object.getId());
				request.setAttribute("contextURL",contextURL);
			    request.setAttribute("stockServiceUrl",stockServiceUrl);
			}
		}

	}

}