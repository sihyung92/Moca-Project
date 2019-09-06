<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>

<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.min.css">
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery.raty.js"/>"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#taste').raty({
			  scoreName:  'entity.score',
			  number:     5
			});
			$('#mood').raty({
				  scoreName:  'entity.score',
				  number:     5
				});
			$('#price').raty({
				  scoreName:  'entity.score',
				  number:     5
			});

		})
	</script>
<style>


</style>
	<title>Home</title>
</head>
<body>


<div id="taste"></div>
<div id="mood"></div>
<div id="price"></div>



</body>



</html>
