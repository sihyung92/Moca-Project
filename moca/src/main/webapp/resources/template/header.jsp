<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- kss 공통 header -->
<!-- naver API -->
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"></script>
<!-- kakao API -->
    <script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<script type='text/javascript'>
    
    $(document).ready(function(){
        //테스트용 코드 자리
        $('#login-session-btn').click(function(){
            $.ajax({
                type:'post',
                url:'/moca/session',
                contentType:"application/json; charset=UTF-8",
                error: function(errorMsg){},
                success: function(userInfo){
                    if(userInfo.platformType=="NON-CONNECTED"){
                        alert('NULL');
                    }else{
                        alert(JSON.stringify(userInfo));
                    }
                }
            });
        });
        
        //테스트용 코드 자리
        
        //본코드 (공통)  
        //1. 처음 페이지 접속시 로그인 상태를 확인하여 플로필을 띄워줄지 login 버튼을 띄워줄지.
    	$.ajax({
    		type: 'post',
			url: '/moca/session',
			contentType: "application/json; charset=UTF-8",
			error: function(errorMsg) {},
			success: function(userInfo) {
                if(userInfo.platformType=="NON-CONNECTED"){
                    
                }else{
                    var userName = userInfo.nickname.slice(1,-1);
                    var thumbnailImg = null;
                    
                    if(userInfo.thumbnailImage==null){
                        thumbnailImg = '/moca/resources/imgs/nonProgileImage.png';
                    }else{
                        thumbnailImg = userInfo.thumbnailImage.slice(1,-1); 
                    }
                    $('#replace-to-userName').replaceWith('<li><a href="#"><img id="profile-icon" alt="" src="'+thumbnailImg+'"/> '+userName+'님♡'+'</a></li>');
                    $('#replace-to-icon').replaceWith('<li></li>');
                    $('#replace-to-logout').replaceWith('<li><a href="#" id="moca-logout">로그아웃</a></li>');
                    
                    //로그아웃 이벤트를 달아줌.
                    $('#moca-logout').click(kakaoLogout);
                    
                    $('#profile-icon').css('width','27px');
                    $('#profile-icon').css('height','27px');
                    $('#profile-icon').css('display','inline-block');
                    $('#profile-icon').css('border-top-left-radius','50% 50%');
                    $('#profile-icon').css('border-top-right-radius','50% 50%');
                    $('#profile-icon').css('border-bottom-left-radius','50% 50%');
                    $('#profile-icon').css('border-bottom-right-radius','50% 50%');
                }
			}
    	});
    	
    	kakaoLogin();
    	naverLogin();
    });
    
    function redirToHome(){
    	location.replace("http://localhost:8080/moca/home2")
	}
    function f5(){
    	location.reload();
    }
    function daumLogout(){
        location.replace("https://logins.daum.net/accounts/logout.do");
    }
    
	//kakao login
    function kakaoLogin(){
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
	        	  
	    			  var acc_Id = JSON.stringify(res.id);
	    			  var param = {
	    					  //MySQL db속 account table의 accId가 INT라서 우선 이 값으로 설정 (구분값으로 생각하면 됨)
		        			"account_id":"1111111111",
		        			"followCount":"0",
		        			"reviewCount":"0",
		        			"platformId":JSON.stringify(res.id),
		        			"nickname":JSON.stringify(res.properties.nickname),
		        			"platformType":"kakao",
		        			"profileImage":JSON.stringify(res.properties.profile_image),
		        			"thumbnailImage":JSON.stringify(res.properties.thumbnail_image),
		        			"email":JSON.stringify(res.kakao_account.email),
		        			"token":Kakao.Auth.getAccessToken()
	        			};
	        	$.ajax({
					type: 'post',
					url: '/moca/login/'+acc_Id,
					contentType: "application/json; charset=UTF-8",
					datatype: "json",
					data: JSON.stringify(param),
					error: function(errorMsg) {
						alert('로그인에 실패하셨습니다. 다시 시도해주세요 (로그인 지속적 불가시 관리자에게 문의)');
					},
					success: function(data) {
						
						//console.log("로그인 성공");
						//redirToHome();
						f5();
					}
				});
	          },
	          fail: function(error) {
	        	  
	            alert(JSON.stringify(error));
	            
	          },
	        });
	      },
	      fail: function(err) {
	        alert(JSON.stringify(err));
	      }
	    });    	
    }
	
    function kakaoLogout(){

    	$.ajax({
					type: 'post',
					url: '/moca/logout',
					contentType: "application/json; charset=UTF-8",
					error: function(errorMsg) {
						alert('이미 로그아웃되어 있습니다.');

				   		Kakao.Auth.logout();
						f5();
					},
					success: function(fromServer) {
						
				   		Kakao.Auth.logout();
                        alert('     ※ 모카를 이용해주셔서 감사합니다! ※\n          다른 계정으로 로그인하려면\n          해당 SNS계정을 로그아웃 해주세요');
						f5();
					}
				});
    }
    
    //Naver Login
    function naverLogin(){
        var naverLogin = new naver.LoginWithNaverId(
            {
                clientId: "Ku_XOqso7r1UgfC0sTeH",
                callbackUrl: "http://localhost:8080/moca/naverLogin",
                isPopup: false, /* 팝업을 통한 연동처리 여부 */
                loginButton: {color: "green", type: 3, height: 60} /* 로그인 버튼의 타입을 지정 */
            }
        );

        /* 설정정보를 초기화하고 연동을 준비 */
        naverLogin.init();
    }
    </script>
<!-- kss 공통 header -->

<nav class="navbar navbar-default">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">moca</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <form class="navbar-form navbar-left">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search" size="50">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
     	<li><a href="#">moca의 카페가 되어주세요!</a></li>
        <li id="replace-to-icon"><a id="login-btn" data-toggle="modal" data-target="#Login-Modal" role="button">Login</a></li>
        <li id="replace-to-userName"><a href="#">회원가입</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Mypage <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a id="login-session-btn">'login'세션 확인</a></li>
            <li><a href="#">Another action 1</a></li>
            <li><a href="#">Another action 2</a></li>
            <li><a href="#">Another action 3</a></li>
            <li><a href="#">Another action 4</a></li>
            <li><a href="#" id="">Something else here</a></li>
            <li id="replace-to-logout"></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
 
  <!-- Modal -->
		<div class="modal fade" id="Login-Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
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
</nav>
