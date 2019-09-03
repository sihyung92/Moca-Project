<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 카페 추천 캐러샐 -->
	<c:forEach items="${storesList}" var="store" varStatus="status">
		<c:if test="${not empty store}">		
			<c:set var="length" value="${fn:length(store)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listNames[index]}"/>
	 		<div class="row mocaPick">
				<div class="col-md-12">
					<h5>${name} <span class="glyphicon glyphicon-home" aria-hidden="true"></span></h5>
				</div>
				<div class="col-md-12 carousel slide" id="mocaPick_${index}" data-ride="carousel">
				  <!-- Indicators -->
				  <ol class="carousel-indicators">
				    <li data-target="#mocaPick_${index}" data-slide-to="0" class="active"></li>
				    <c:if test="${length gt 5}">
				   	 	<li data-target="#mocaPick_${index}" data-slide-to="1"></li>
				    </c:if>
				    <c:if test="${length gt 10}">
				    	<li data-target="#mocaPick_${index}" data-slide-to="2"></li>
				    </c:if>
				  </ol>		
				  <!-- Wrapper for slides -->
				  <div class="carousel-inner" role="listbox">
				    <div class="item active">
				     <ul class="item-inner" style="list-style:none">
				     	<c:forEach items="${store}" var="bean" begin="0" end="4" > 					     	
					     	<li><a href="./stores/${bean.store_Id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${bean.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${bean.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${bean.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${bean.reviewCnt}
							     		</h5>
						     			<h6>${bean.roadAddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${bean.storeImg1}<c:if test="${bean.storeImg1 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main1">
					     		<img src="${bean.storeImg2}<c:if test="${bean.storeImg2 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main2">
					     		<img src="${bean.storeImg3}<c:if test="${bean.storeImg3 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main3">					     	
					     	</a></li>					     	
				     	</c:forEach>
				     </ul>	
				    </div>
				    <c:if test="${length gt 5}">
				    <div class="item">
				     <ul class="item-inner" style="list-style:none">
				     	<c:set var="end">9</c:set>
				     	<c:if test="${length lt 10}"><c:set var="end">${length-1 }</c:set></c:if>
				     	<c:forEach items="${store}" var="bean" begin="${end-4 }" end="${end }">
					     	<li><a href="./stores/${bean.store_Id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${bean.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${bean.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${bean.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${bean.reviewCnt}
							     		</h5>
						     			<h6>${bean.roadAddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${bean.storeImg1}<c:if test="${bean.storeImg1 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main1">
					     		<img src="${bean.storeImg2}<c:if test="${bean.storeImg2 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main2">
					     		<img src="${bean.storeImg3}<c:if test="${bean.storeImg3 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main3">					     	
					     	</a></li>	
				     	</c:forEach> 
				     </ul>		
				    </div>
				    </c:if>     
				    <c:if test="${length gt 10}">	
					   <div class="item">		    
					     <ul class="item-inner" style="list-style:none">
					     	<c:forEach items="${store}" var="bean" begin="${length-5 }" end="${length-1 }"> 
						     <li><a href="./stores/${bean.store_Id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${bean.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${bean.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${bean.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${bean.reviewCnt}
							     		</h5>
						     			<h6>${bean.roadAddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${bean.storeImg1}<c:if test="${bean.storeImg1 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main1">
					     		<img src="${bean.storeImg2}<c:if test="${bean.storeImg2 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main2">
					     		<img src="${bean.storeImg3}<c:if test="${bean.storeImg3 eq null}">${defaultImg }</c:if>" alt="${bean.name }_main3">					     	
					     	</a></li>
					     	</c:forEach>
					     </ul>		     
					    </div> 
					</c:if> 	  		   
					  </div>	
				  <!-- Controls -->
				  <a class="left carousel-control" href="#mocaPick_${index}" role="button" data-slide="prev">
				    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
				    <span class="sr-only">Previous</span>
				  </a>
				  <a class="right carousel-control" href="#mocaPick_${index}" role="button" data-slide="next">
				    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
				    <span class="sr-only">Next</span>
				  </a>
				</div>
			</div>
		</c:if>
	</c:forEach>