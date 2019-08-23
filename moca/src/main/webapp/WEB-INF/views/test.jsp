<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>

<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.min.css">
	<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	//여러 파일을 가지고 있는 버퍼
	var fileBuffer;
	var fileListDiv;

		$(document).ready(function() {
			console.log("onready")
			fileListDiv = $('#fileListDiv');

		    $('#files').change(function(){
		        fileBuffer = [];
		        const target = document.getElementsByName('files[]');
		        
		        Array.prototype.push.apply(fileBuffer, target[0].files);
		        var html = '';
		        $.each(target[0].files, function(index, file){
		            const fileName = file.name;
		            html += '<div class="file">';
		            html += '<img src="'+URL.createObjectURL(file)+'">'
		            html += '<span>'+fileName+'</span>';
		            html += '<span>기간 '+'<input type="text" style="width:250px/"></span>';
		            html += '<a href="#" id="removeImg">╳</a>';
		            html += '</div>';
		            const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
		            if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp" && fileEx != "wmv" && fileEx != "mp4" && fileEx != "avi"){
		                alert("파일은 (jpg, png, gif, bmp, wmv, mp4, avi) 형식만 등록 가능합니다.");
		                resetFile();
		                return false;
		            }
		            $(fileListDiv).html(html);
		        });
		 
		    });

			$(document).on('click', '#removeImg', function(){
			    const fileIndex = $(this).parent().index();
			     fileBuffer.splice(fileIndex,1);
			     fileArray.splice(fileIndex,1);
			     $('.fileList>div:eq('+fileIndex+')').remove();
			     
			    const target = document.getElementsByName('files[]');
			    console.log(fileBuffer);
			    console.log(target[0].files);
			});

		})
		
		


	</script>
	<title>Home</title>
</head>

<body>
	<h1>
		Hello world!
	</h1>
	<input multiple="multiple" name="files[]" id="files" type="file"/>
	<div id="fileListDiv">
	
	</div>

</body>

</html>
