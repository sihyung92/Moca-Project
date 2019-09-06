<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="../resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="../resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="../resources/css/bootstrap-theme.css"/>
<script type="text/javascript" src="../resources/js/bootstrap.min.js"></script>
<style type="text/css">
	.panel-heading img{
		width:30px;
		height:30px;
		border-radius: 50%;
	}
	.panel-body .panel-body h3{
		color: brown;
	}
	.panel-heading h3{
		display : inline-block;
	}
	.panel-heading h4{
		margin-left : 5px;
		display : inline-block;
		color: orange;
	}
	.review-img-list a{
		display:inline-block;
		width:130px;
		height:130px;
	}
	
	.review-img-list a img{
		width:120px;
		height:120px;
	}
	
 	.label h5{
		color : black;
	}
	
	.dropdown{
		float : right;
	}
</style>
</head>
<body>
	<div id="header">
		<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	</div>
	<div id="content" class="container-fluid">
		<div class="row col-md-12">
		<c:if test="${not empty alist }">
		<c:set var="defaultThum"><c:url value="/resources/imgs/basicProfile.png"/></c:set>
	<div class="col-md-12 label">
		<h5><c:choose><c:when test="${type eq 'recent'}">최신 리뷰</c:when><c:otherwise>금주의 인기리뷰</c:otherwise></c:choose><span class="glyphicon glyphicon-home" aria-hidden="true"></span></h5>
	</div>
	<div class="dropdown">
	  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
	    정렬순서
	    <span class="caret"></span>
	  </button>
	  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
	    <li><a href="../reviewboard/best">인기순</a></li>
	    <li><a href="../reviewboard/recent">최신순</a></li>
	  </ul>
	</div>
	<div class="row panel panel-default col-md-12">
	  <div class="panel-body">
 		<c:forEach items="${alist }" var="bean">
			<div class="panel panel-default col-md-12">
			 <div class="panel-heading">
			    <h3 class="panel-title"><img src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>LV${bean.accountLevel}☕️ ${bean.nickName } </h3><h4>${bean.averageLevel}</h4>
			    <p><span class="glyphicon glyphicon-thumbs-up" aria-hidden="true">${bean.likeCount}</span><span class="glyphicon glyphicon-thumbs-down" aria-hidden="true">${bean.hateCount}</span></p>
			  </div>
			  <div class="panel-body">
			  	<h3>${bean.storeName }</h3>
			 	<p><small>${bean.writeDate }</small></p>
			  	<h4>${bean.reviewContent }</h4>
			  	<c:if test="${not empty bean.imageList }">
			  	<div class="review-img-list">
			  	<c:forEach items="${bean.imageList }" var="imgList" varStatus="status">
			  	    <a href="#" class="thumbnail">
					  	<img src="${imgList.url }" alt="${imgList.originName }">		  	
				    </a>			  	
			  	</c:forEach>
			  	</div>
			  	</c:if>
			  </div>
			</div>
		</c:forEach>
	  </div>
	</div>
	</c:if>
	</div>
</div>
</body>
</html>