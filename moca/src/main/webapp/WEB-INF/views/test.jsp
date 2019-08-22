<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<title>moca</title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<style type="text/css">
	.carousel-inner .active.left {
  left: -33%;
}
.carousel-inner .next {
  left: 33%;
}
.carousel-inner .prev {
  left: -33%;
}
.carousel-control.left,
.carousel-control.right {
  background-image: none;
}
.carousel-multi .carousel-inner > .item {
  transition: 500ms ease-in-out left;
}
.carousel-multi .carousel-inner > .item > .media-card {
/*   background: #f33; */
  border-right: 10px solid #fff;
  display: table-cell;
  width: 1%;
}
.carousel-multi .carousel-inner > .item > .media-card:last-of-type {
/*   border-right: none; */
	border-right: 10px solid #fff;
}
.carousel-multi .carousel-inner .active {
  display: table;
}
.carousel-multi .carousel-inner .active.left {
  left: -33%;
}
.carousel-multi .carousel-inner .active.right {
  left: 33%;
}
.carousel-multi .carousel-inner .next {
  left: 33%;
}
.carousel-multi .carousel-inner .prev {
  left: -33%;
}
@media all and (transform-3d), (-webkit-transform-3d) {
  .carousel-multi .carousel-inner > .item {
    transition: 500ms ease-in-out all;
    backface-visibility: visible;
    transform: none!important;
  }
}
	
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 
	<!-- jqm 사용시 <script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>	-->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js"/>"> </script> 
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js"/>"></script>
	<!-- mocaStore -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaStore.js"/>"></script>
	
	<script type="text/javascript">
	//Allows bootstrap carousels to display 3 items per page rather than just one
	$(document).ready(function() {
	$('.carousel.carousel-multi .item').each(function () {
		var next = $(this).next();
		if (!next.length) {
			next = $(this).siblings(':first');
		}
		next.children(':first-child').clone().attr("aria-hidden", "true").appendTo($(this));

		if (next.next().length > 0) {
			next.next().children(':first-child').clone().attr("aria-hidden", "true").appendTo($(this));
		}
		else {
			$(this).siblings(':first').children(':first-child').clone().appendTo($(this));
		}
	});
	});
	</script>
</head>

<body>
	<div id="carousel-example-multi" class="carousel carousel-multi slide">
  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#carousel-example-multi" data-slide-to="0" class="active"></li>
    <li data-target="#carousel-example-multi" data-slide-to="1"></li>
    <li data-target="#carousel-example-multi" data-slide-to="2"></li>
    <li data-target="#carousel-example-multi" data-slide-to="3"></li>
    <li data-target="#carousel-example-multi" data-slide-to="4"></li>
    <li data-target="#carousel-example-multi" data-slide-to="5"></li>
  </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">
    <div class="item active">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

    <div class="item ">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

    <div class="item ">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

    <div class="item ">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

    <div class="item ">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

    <div class="item ">
      <div class="media media-card">
        <a href="#x"><img src="http://placehold.it/500x500" alt="Image" class="img-responsive"></a>
      </div>
    </div>

  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-example-multi" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-example-multi" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
</body>

</html>
