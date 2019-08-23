<%@page import="com.kkssj.moca.model.entity.AccountVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<title>Login Demo - Kakao JavaScript SDK</title>
<!-- naver API -->
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"></script>
<!-- kakao API -->
    <script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<!-- JQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
<!-- Optional theme -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

    <script type='text/javascript'>
    
    $(document).ready(function(){
    	var testBtn = $('#test-btn');
    	testBtn.click(function(){
    		 //alert(sessionStorage.getItem("login"));
    		 
    		 var loginSession = JSON.parse(sessionStorage.getItem("login"));
    		 
			console.log(sessionStorage.getItem("login"));
			
    	});
    	
    	// Naver 로그인 우선 제외
		///* var naverLogin = new naver.LoginWithNaverId(
		//		{
		//			clientId: "Ku_XOqso7r1UgfC0sTeH",
		//			callbackUrl: "http://localhost:8080/moca/navercallback",
		//			isPopup: false, /* 팝업을 통한 연동처리 여부 */
		//			loginButton: {color: "green", type: 3, height: 60} /* 로그인 버튼의 타입을 지정 */
		//		}
		//	);
		//	/* 설정정보를 초기화하고 연동을 준비 */
		//	naverLogin.init(); 
			
			
			
		//kakao login
	    // 사용할 앱의 JavaScript 키를 설정해 주세요.
	    Kakao.init('e85bc4677809dd977652da6eeaac836f');
	    // 카카오 로그인 버튼을 생성합니다.
	    Kakao.Auth.createLoginButton({
	      container: '#kakao-login-btn',
	      success: function(authObj) {
	        // 로그인 성공시, API를 호출합니다.
	        Kakao.API.request({
	          url: '/v2/user/me',
	          success: function(res) {
	        	  
	        	  // alert(sessionStorage.getItem("login"));
	        	  
	        	var acc_Id = JSON.stringify(res.id);
	        	var param = {
	        			"account_id":"1111111111",
	        			"followCount":"0",
	        			"reviewCount":"0",
	        			"platformId":JSON.stringify(res.id),
	        			"nickname":JSON.stringify(res.properties.nickname),
	        			"platformType":"kakao",
	        			"profileImage":JSON.stringify(res.properties.profile_image),
	        			"thumbnailImage":JSON.stringify(res.properties.thumbnail_image),
	        			"email":JSON.stringify(res.kakao_account.email)
	    			};
	        	
	        	console.log(JSON.stringify(res));
	        	
	        	$.ajax({
					type: 'post',
					url: 'login/'+acc_Id,
					contentType: "application/json; charset=UTF-8",
					datatype: "json",
					data: JSON.stringify(param),
					error: function(errorMsg) {
						console.log("로그인 ajax 실패", errorMsg);
					},
					success: function(fromServer) {
						
						console.log("로그인 성공");
						
						sessionStorage.setItem("login",JSON.stringify(fromServer));
						redirToHome();
					}
				});
	          },
	          fail: function(error) {
	        	  
	            alert(JSON.stringify(error));
	            
	          }
	        });
	      },
	      fail: function(err) {
	        alert(JSON.stringify(err));
	      }
	    });
    });
    
    function redirToHome(){
		  location.replace("http://localhost:8080/moca/home2")
	}
    </script>
    <style type="text/css">
        /* body .modal{
        	background-color: blue;
        } */
		body .modal .modal-body,.modal-content,.modal-header{
			background-color: green;
        }
        body .modal .sns-login-btn {
        	width: 100%;
        	background-color: red;
        }
        body .modal .sns-login-btn img{
            width: 250px;
            height:50px;
            border-left:50px ;
            border-right:50px ;
        }
    </style>
</head>
<body>
    <button id="test-btn">btn</button>
<!-- grid applying -->
    <div class="row">
<!-- Button trigger modal -->
		<button id="login-btn" type="button" class="btn btn-primary col-md-offset-8" data-toggle="modal" data-target="#myModal">
		  Login
		</button>
<!-- Modal -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
			      	<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="myModalLabel">소셜 로그인</h4>
					</div>
			      	<div class="modal-body">
				        <!-- 로그인 해당부분 -->
				        	<div id="naverIdLogin" class="sns-login-btn"></div>
				        	<div id="kakao-login-btn" class="sns-login-btn"></div>
				        	
					</div>
					<div class="modal-footer">
					<!-- 확인 버튼 필요 없음 
						
				        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				        <button type="button" class="btn btn-primary">Save changes</button>
				    -->
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
	
</html>