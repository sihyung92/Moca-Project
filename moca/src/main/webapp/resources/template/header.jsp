<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- kss 공통 header -->
    
    <style type="text/css">
        .modal .modal-body {
            max-height: 350px;
            overflow-y: auto;
        }
        .modal-open .modal{
            overflow-y: hidden;
        }
    </style>
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
        
        //미리 설정할 사항들
                
        $('.modal-dialog').css('overflow-y','initial');
        $('.modal-body').css('height','100%');
        $('.modal-body').css('overflow-y','auto');

        $('.close').click(function(event){
            $('.modal').hide();
        });
        //본코드 (공통)  
        //1. 처음 페이지 접속시 로그인 상태를 확인하여 플로필을 띄워줄지 login 버튼을 띄워줄지.
    	$.ajax({
    		type: 'post',
			url: '/moca/session',
			contentType: "application/json; charset=UTF-8",
			error: function(errorMsg) {
                     
            },
			success: function(userInfo) {
                //로그인 하기전 (혹은 로그아웃 후) 시점
                if(userInfo.platformType=="NON-CONNECTED"){
                	//CSS part
                    $('#login-session-btn').css('background-color','orange');//추후삭제
                	
                    $('.just-use-user').css('display','none');
                    
                //로그인후 세션 얻은 시점
                }else{
                    var uiGender = userInfo.gender;
                    var uiBirthday = userInfo.birthday;
                    var uiBarista = userInfo.barista;
                    
                    //처음 로그인했거나 필수 수집정보가 없을 경우
                    if(uiGender==0 || uiBarista==0 || uiBirthday==null){
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
                    }
                    
                    console.log('gen'+uiGender+' bir'+uiBirthday+' Bar'+uiBarista);
                    
                    var userName = userInfo.nickname;
                    alert(userInfo.nickname);
                    alert(userName);
                    var thumbnailImg = null;
                    
                    if(userInfo.thumbnailImage==null){
                        thumbnailImg = '/moca/resources/imgs/nonProgileImage.png';
                    }else{
                        thumbnailImg = userInfo.thumbnailImage; 
                    }
                    $('#replace-to-userName').replaceWith('<li><a href="#"><img id="profile-icon" alt="" src="'+thumbnailImg+'"/> '+userName+'님♡'+'</a></li>');
                    $('#replace-to-icon').replaceWith('<li></li>');
                    $('#replace-to-logout').replaceWith('<li><a href="#" id="moca-logout">로그아웃</a></li>');
                    
                    //로그아웃 이벤트를 달아줌.
                    $('#moca-logout').click(kakaoLogout);
                    
                    //CSS part
                    $('#login-session-btn').css('background-color','orange');//추후삭제
                    $('#replace-to-userName').css('display','none');
                    
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
    	
        
        //로그인 기능 처리
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
                    alert(JSON.stringify(res));
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
                      alert(JSON.stringify(res.properties.nickname)+JSON.stringify(res.properties.profile_image)+JSON.stringify(res.properties.thumbnail_image)+JSON.stringify(res.kakao_account.email));
                      alert(JSON.stringify(param));
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
     	<li ><a href="#">moca의 카페가 되어주세요!</a></li>
        <li id="replace-to-userName"></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Mypage <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a id="login-session-btn">(추후삭제)'login'세션 확인</a></li>
            <li><a href="#" class="just-use-user">계정 정보 확인</a></li>
            <li><a href="#" class="just-use-user">내 포인트</a></li>
            <li><a href="#" class="just-use-user">내 리뷰 보기</a></li>
            <li><a href="#" class="just-use-user">관심 카페 리스트</a></li>
            
            <li role="separator" class="divider"></li>
            <li id="replace-to-logout"></li>
            <li id="replace-to-icon"><a id="login-btn" data-toggle="modal" data-target="#Login-Modal" role="button">Sign In</a></li>
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
    
    <!-- 필수정보 입력받을 모달 -->
        <div class="modal" id="input-info-Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document" style="overflow-y: scroll; max-height:85%;  margin-top: 50px; margin-bottom:50px;">
				<div class="modal-content">
			      	
                    <div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="myModalLabel">moca 이용을 위한 기초 정보 제공</h4>
					</div>
			      	
                    <div class="modal-body">
                        <div>
                            <label for="essential-info">[필수]정보 수집 및 활용에 관한 동의</label><br>
                            <textarea id="info-rule" readonly="readonly">약관인데요오오 약관들이 써질건데오오오...
                            </textarea>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-agree" id="essentialYes"> 동의합니다
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-agree" id="essentialNo"> 동의하지 않습니다 (약관 확장) 
                            </label>                              
                            <br><br>
                            <div class="custom-width-line"></div><br>
                        </div>
                        <div>                                    
                            <label for="selective-info">[선택]정보 수집 및 활용에 관한 동의</label><br>
                            <textarea id="info-rule-selective" readonly="readonly">약관인데요오오 약관들이 써질건데오오오...
                            </textarea>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-selective-agree" id="selectiveYes"> 동의합니다
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-selective-agree" id="selectiveNo"> 동의하지 않습니다 (약관 확장) 
                            </label>                              
                        </div>                        
                        
                        <form id="essential-info"><br>
                            <div class="custom-width-line"></div><br>
                            <div class="form-group">
                                <!-- 카페 관련 업종 확인 -->
                                <label for="isBarista">[필수]현재 '카페'관련 업종에 종사하시나요?</label><br>
                                <label class="radio-inline">
                                    <input type="radio" name="isBarista" id="isBaristaYes" value="2"> 네
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="isBarista" id="isBaristaNo" value="1"> 아니요
                                </label><br><br>
                                
                                <!-- 성별 -->
                                <label for="gender">[필수]당신의 성별을 알려주세요 </label><br>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="male" value="1"> 남
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="female" value="2"> 여
                                </label><br><br>
                                
                                <!-- 생일 -->
                                <label for="gender">[필수]당신의 생일을 알려주세요 </label><br>
                                <input type="date" name="birthday" id="birthday" value="1993-01-01">
                                <br><br>

                                <!-- email -->
                                <label for="exampleInputEmail1">[필수]이메일 주소</label>
                                <input type="email" class="form-control" id="exampleInputEmail1" placeholder="이메일을 입력하세요">
                                
                                <div id="selective-info">
                                    <br><div class="custom-width-line"></div>
                                    <br>
                                    
                                    <!-- 선호도 질문 1 -->
                                    <label for="SQ1">선호도 질문 1</label><br>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ1" id="SQ1_1" value="1"> 거의없다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ1" id="SQ1_2" value="2"> 조금없다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ1" id="SQ1_1" value="1"> 보통이다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ1" id="SQ1_2" value="2"> 조금있다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ1" id="SQ1_2" value="2"> 매우있다
                                    </label><br><br>
                                    
                                    <!-- 선호도 질문 2 -->
                                    <label for="SQ2">선호도 질문 2</label><br>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ2" id="SQ2_1" value="1"> 거의없다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ2" id="SQ2_2" value="2"> 조금없다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ2" id="SQ2_3" value="3"> 보통이다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ2" id="SQ2_4" value="4"> 조금있다
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="SQ2" id="SQ2_5" value="5"> 매우있다
                                    </label><br><br>
                                    
                                </div>
                            </div>
                            <button type="submit" class="btn btn-default">제출</button>
                        </form>
                    </div>
                
                    <div class="modal-footer">                      
                    </div>
                </div>
			</div>
		</div>
</nav>
