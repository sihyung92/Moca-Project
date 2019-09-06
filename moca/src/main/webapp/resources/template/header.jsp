<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- kss 공통 header  -->
    
<!--//css 설정-->
    <style type="text/css">
        #Login-Modal .modal-body {
            max-height: 350px;
            overflow-y: auto;
        }
        .modal-open #Login-Modal{
            overflow-y: hidden;
        }
        .sns-login-btn * {
            width: 268px;
            height: 59.15px;
        }
        #Login-Modal-dialog{
            width: 300px;
            height: 300px;
        }
    </style>
    
<!-- naver API -->
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"></script>
<!-- kakao API -->
    <script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

    <script type='text/javascript'>    
    $(document).ready(function(){    	
        //테스트용 코드 자리
        
        //미리 설정할 사항들
        $('#nav-static-height').css('height','60px');
        
        $('.modal-dialog').css('overflow-y','initial');
       // $('.modal-body').css('height','100%');
        $('.modal-body').css('overflow-y','auto');
        
        $('.close').click(function(event){
            $('.modal').hide();
        });
        
        //본코드 (공통)  
        //1. 처음 페이지 접속시 로그인 상태를 확인하여 플로필을 띄워줄지 login 버튼을 띄워줄지.
        var userInfo;
        var info={
            "platformType":"NULL_VAL"
        };
        userInfo = '${sessionScope.login.platformType}';
        if(userInfo.isUndefined || userInfo==''){
            userInfo = {
                "account_id":"0",
                "followCount":"0",
                "reviewCount":"0",
                "platformId":"0",
                "nickname":"",
                "platformType":"NULL_VAL",
                "profileImage":"",
                "thumbnailImage":"",
                "email":"",
                "gender":"0",
                "barista":"",
                "birthday":""
            };
            info = {
                "account_id":"0",
                "followCount":"0",
                "reviewCount":"0",
                "platformId":"0",
                "nickname":"",
                "platformType":"NULL_VAL",
                "profileImage":"",
                "thumbnailImage":"",
                "email":"",
                "gender":"0",
                "barista":"",
                "birthday":""
            };
        }else if('${sessionScope.login.platformType}'!='NULL_VAL'){
            info={
                "platformType":"VALUE"
            }
            userInfo={
                "platformType":"VALUE"
            };
        }
              
        if(JSON.stringify(info.platformType)=='"NULL_VAL"'){     
            $('.just-use-user').css('display','none');        
        }else if(JSON.stringify(userInfo.platformType)=='"NULL_VAL"'){
            $('.just-use-user').css('display','none');    
        }else{

            
            var uiGender = '${sessionScope.login.gender}';
            var uiBirthday = '${sessionScope.login.birthday}';
            var uiBarista = '${sessionScope.login.barista}';
                        
            //처음 로그인했거나 필수 수집정보가 없을 경우
            /* if(uiGender==0 || uiBarista==0 || uiBirthday==null){
              
                alert('moca에 오신것을 환영합니다!\n\n\n moca를 회원으로 이용하기 위해서는 개인정보 수집 및 처리에 동의해주셔야 원활한 이용이 가능합니다.\n\n\n'
                      +'moca의 모든 서비스를 제공받으시려면 [선택] 정보 제공에 동의해주세요');
                $('#essential-info').hide();
                $('#selective-info').hide();
                $('#input-info-Modal').show();
                
                //모달 칸 구분선
                $('.custom-width-line').css('height','1');
                $('.custom-width-line').css('background-color','gray');
                
                //약관 텍스트에어리어 초기화
                $('#info-rule').css('resize','none');
                $('#info-rule').css('width','100%');
                $('#info-rule').css('height','200px');
                
                $('#info-rule-selective').css('resize','none');
                $('#info-rule-selective').css('width','100%');
                $('#info-rule-selective').css('height','200px');
                
                //약관 동의시 약관 크기 수정
                $('#essentialYes').click(function(){
                    $('#info-rule').css('height','50px');
                    $('#essential-info').show();
                });
                $('#essentialNo').click(function(){
                    $('#info-rule').css('height','200px');
                });
                $('#selectiveYes').click(function(){
                    $('#info-rule-selective').css('height','50px');
                    $('#selective-info').show();
                });
                $('#selectiveNo').click(function(){
                    $('#info-rule-selective').css('height','200px');
                });
            } */
                                
            var userName = '${sessionScope.login.nickname}';                
            var thumbnailImg = null;

            if('${sessionScope.login.thumbnailImage}'==null){
                thumbnailImg = '/moca/resources/imgs/nonProgileImage.png';
            }else{
                thumbnailImg = '${sessionScope.login.thumbnailImage}'; 
            }
            $('#replace-to-userName').replaceWith('<li><a href="#"><img id="profile-icon" alt="" src="'+thumbnailImg+'"/> '+userName+'님♡'+'</a></li>');
            $('#replace-to-icon').replaceWith('<li></li>');
            $('#replace-to-logout').replaceWith('<li><a href="#" id="moca-logout">로그아웃</a></li>');

            //로그아웃 이벤트를 달아줌.
            $('#moca-logout').click(kakaoLogout);

            //CSS part
            $('#replace-to-userName').css('display','none');

            $('#profile-icon').css('width','27px');
            $('#profile-icon').css('height','27px');
            $('#profile-icon').css('display','inline-block');
            $('#profile-icon').css('border-top-left-radius','50% 50%');
            $('#profile-icon').css('border-top-right-radius','50% 50%');
            $('#profile-icon').css('border-bottom-left-radius','50% 50%');
            $('#profile-icon').css('border-bottom-right-radius','50% 50%');
        }
        
        //로그인 기능 처리
    	kakaoLogin();
    	naverLogin();
       
        //설문 버튼 처리
        
    });
    
    
    //함수 정의
    function redirToHome(){
    	location.replace("http://localhost:8080/moca/home2")
	}
    function f5(){
    	location.reload();
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
                        console.log(errorMsg);
                        alert(JSON.stringify(errorMsg));
                        
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

    //ajax통신의 error status에 따른 처리
    var respondHttpStatus = function(status){
    	if(status==429){ //Too Many Requests(업로드 파일 갯수 초과)		
			alert("업로드에 실패했습니다. 파일은 10개까지만 등록가능합니다.");
		}else if(status==415){ //Unsupported Media Type(이미지 파일을 업로드 하지 않았을때)		
			alert("사진 파일만 업로드 가능합니다.");
		}else if(status==423){ // Locked(로그인 안된 경우)
			$('.modal').modal('hide')		
			alert("로그인 후 이용가능합니다.");
			$('#Login-Modal').modal('show')
		}else{
			console.log('ajax 통신 실패', status);
		}
    }
    </script>
<!-- kss 공통 header -->

<nav class="navbar navbar-default" id="nav-static-height" >
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="<c:url value="/"/>">moca</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
	      <form class="navbar-form navbar-left" action="stores">
	        <div class="form-group">
	          <input type="text" name="keyword" class="form-control" placeholder="Search" size="50">
	          <input type="hidden" name="x" class="lng"/>
			  <input type="hidden" name="y" class="lat"/>		
			  <input type="hidden" name="filter" value="distance"/>
	        </div>
	        <button type="submit" class="btn btn-default">Submit</button>
	      </form>
        <ul class="nav navbar-nav navbar-right">
            <li ><a href="#">moca의 카페가 되어주세요!</a></li>
            <li id="replace-to-userName"></li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Mypage<span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="/moca/mypage" class="just-use-user">플로필</a></li>
                    <li><a href="#" class="just-use-user">내 포인트</a></li>
                    <li><a href="#" class="just-use-user">내 리뷰 보기</a></li>
                    <li><a href="#" class="just-use-user">관심 카페 리스트</a></li>
                    <li role="separator" class="divider just-use-user"></li>
                    <li id="replace-to-logout"></li>
                    <li id="replace-to-icon"><a id="login-btn" data-toggle="modal" data-target="#Login-Modal" role="button">Sign In</a></li>
                </ul>
            </li>
        </ul>
      </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
    
    <!-- Modal -->
    <div class="modal fade" id="Login-Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" id="Login-Modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">소셜 로그인</h4>
                </div>
                <div class="modal-body">
                    <!-- 로그인 해당부분 -->
                    <div id="naverIdLogin" class="sns-login-btn"></div><br>
                    <div id="kakao-login-btn" class="sns-login-btn"></div>
                </div>
                <div class="modal-footer">
                    <!-- 확인 버튼 필요 없음 
<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
<button type="button" class="btn btn-primary">Save changes</button>
-->
                    <span>모카는 SNS 로그인을 지원하고 있습니다.</span>
                </div>
            </div>
        </div>
    </div>
    
    <div id="info-modal">
		<jsp:include page="../../resources/template/modal.jsp" flush="true"></jsp:include>
	</div>
    
</nav>
