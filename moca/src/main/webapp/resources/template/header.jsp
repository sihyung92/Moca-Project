<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- kss 공통 header  -->
    
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
      
        //미리 설정할 사항들
        $('#nav-static-height').css('height','60px');
        
        $('.modal-dialog').css('overflow-y','initial');
        $('.modal-body').css('height','100%');
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
    });
    
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
                            <textarea id="info-rule" readonly="readonly">회원약관


제 1 장 총칙

제1조(목적)

이 약관은 ○○ 코리아(이하 "회사")가 운영하는 마이○○ 사이트(이하 "사이트"라 한다)를 이용함에 있어 회사와 이용자의 권리. 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.


제 2 조 (약관의 효력과 변경)

1. 귀하가 본 약관 내용에 동의하는 경우, 사이트의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 본 약관이 우선적으로 적용됩니다.

2. 사이트는 본 약관을 사전 고지 없이 변경할 수 있고, 변경된 약관은 사이트 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다. 이용자가 변경된 약관에 동의하지 않는 경우, 이용자는 본인의 회원등록을 취소(회원탈퇴)할 수 있으며 계속 사용의 경우는 약관 변경에 대한 동의로 간주됩니다.

제 3 조 (약관 외 준칙)

1. 본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회심의규정, 정보통신 윤리강령, 프로그램보호법 및 기타 관련 법령의 규정에 의합니다.

제 4 조 (용어의 정의)

본 약관에서 사용하는 용어의 정의는 다음과 같습니다.

1. 이용자 : 본 약관에 따라 사이트가 제공하는 서비스를 받는 자.

2. 가입 : 사이트가 제공하는 신청서 양식에 해당 정보를 기입하고, 본 약관에 동의하여 서비스 이용계약을 완료시키는 행위.

3. 회원 : 사이트에 개인 정보를 제공하여 회원 등록을 한 자로서 사이트가 제공하는 서비스를 이용할 수 있는 자. 사이트의 회원은 14세 이상의 회원, 14세 미만 회원, 해외거주자 회원으로 구분됩니다.

4. 비밀번호 : 이용자와 회원ID가 일치하는지를 확인하고 통신상의 자신의 비밀보호를 위하여 이용자 자신이 선정한 문자와 숫자의 조합.

5. 탈퇴 : 회원이 이용계약을 종료시키는 행위.


제 2 장 서비스 제공 및 이용

제 5 조 (이용계약의 성립)

1. 이용계약은 신청자가 온라인으로 사이트에서 제공하는 소정의 가입신청 양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다.

2. 사이트는 다음 각 호에 해당하는 이용계약에 대하여는 가입을 취소할 수 있습니다.

1) 다른 사람의 명의를 사용하여 신청하였을 때
2) 이용계약 신청서의 내용을 허위로 기재하였거나 신청하였을 때
3) 다른 사람의 사이트 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 때
4) 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우
5) 기타 사이트가 정한 이용신청요건이 미비 되었을 때

제 6 조 (회원정보 사용에 대한 동의)

1. 회원의 개인정보는 공공기관의 개인정보보호에 관한 법률에 의해 보호됩니다.

2. 회원 정보는 다음과 같이 사용, 관리, 보호됩니다.
1) 개인정보의 사용 : 사이트는 서비스 제공과 관련해서 수집된 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 단, 전기통신기본법 등 법률의 규정에 의해 국가기관의 요구가 있는 경우, 범죄에 대한 수사상의 목적이 있거나 정보통신윤리 위원회의 요청이 있는 경우 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우, 귀하가 사이트에 제공한 개인정보를 스스로 공개한 경우에는 그러하지 않습니다.
2) 개인정보의 관리 : 귀하는 개인정보의 보호 및 관리를 위하여 서비스의 개인정보관리에서 수시로 귀하의 개인정보를 수정/삭제할 수 있습니다.
3) 개인정보의 보호 : 귀하의 개인정보는 오직 귀하만이 열람/수정/삭제 할 수 있으며, 이는 전적으로 귀하의 ID와 비밀번호에 의해 관리되고 있습니다. 따라서 타인에게 본인의 ID와 비밀번호를 알려주어서는 안되며, 작업 종료 시에는 반드시 로그아웃 해주시기 바랍니다.

3. 회원이 본 약관에 따라 이용신청을 하는 것은, 사이트가 신청서에 기재된 회원정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다.

제 7 조 (사용자의 정보 보안)

1. 가입 신청자가 사이트 서비스 가입 절차를 완료하는 순간부터 귀하는 입력한 정보의 비밀을 유지할 책임이 있으며, 회원의 ID와 비밀번호를 사용하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있습니다.

2. ID와 비밀번호에 관한 모든 관리의 책임은 회원에게 있으며, 회원의 ID나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 사이트에 신고하여야 합니다. 신고를 하지 않음으로 인한 모든 책임은 회원 본인에게 있습니다.

3. 이용자는 사이트 서비스의 사용 종료 시 마다 정확히 접속을 종료해야 하며, 정확히 종료하지 아니함으로써 제3자가 귀하에 관한 정보를 이용하게 되는 등의 결과로 인해 발생하는 손해 및 손실에 대하여 사이트는 책임을 부담하지 아니합니다.

제 8 조 (서비스의 중지)

1. 사이트는 이용자가 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지할 수 있습니다.

제 9 조 (서비스의 변경 및 해지)

1. 사이트는 귀하가 서비스를 이용하여 기대하는 손익이나 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지 않으며, 회원이 본 서비스에 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관하여는 책임을 지지 않습니다.

2. 사이트는 서비스 이용과 관련하여 가입자에게 발생한 손해 중 가입자의 고의, 과실에 의한 손해에 대하여 책임을 부담하지 아니합니다.

제 10 조 (게시물의 저작권)

1. 귀하가 게시한 게시물의 내용에 대한 권리는 귀하에게 있습니다.

2. 사이트는 게시된 내용을 사전 통지 없이 편집, 이동할 수 있는 권리를 보유하며, 게시판운영원칙에 따라 사전 통지 없이 삭제할 수 있습니다.

3. 귀하의 게시물이 타인의 저작권을 침해함으로써 발생하는 민, 형사상의 책임은 전적으로 귀하가 부담하여야 합니다.

4. 사이트가 작성한 저작물에 대한 저작권 기타 지적재산권은 사이트에 귀속합니다.

5. 이용자는 사이트를 이용함으로써 얻은 정보를 사이트의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.

제 11 조 (광고주와의 거래)

사이트는 본 서비스상에 게재되어 있거나 본 서비스를 통한 광고주의 판촉활동에 회원이 참여하거나 교신 또는 거래의 결과로서 발생하는 모든 손실 또는 손해에 대해 책임을 지지 않습니다.

제 3 장 의무 및 책임

제 12 조 (사이트의 의무)

1. 사이트는 회원의 개인 신상 정보를 본인의 승낙 없이 타인에게 누설, 배포하지 않습니다. 다만, 전기통신관련법령 등 관계법령에 의하여 관계 국가기관 등의 요구가 있는 경우에는 그러하지 아니합니다.

제 13 조 (회원의 의무)

1. 회원 가입 시에 요구되는 정보는 정확하게 기입하여야 합니다. 또한 이미 제공된 귀하에 대한 정보가 정확한 정보가 되도록 유지, 갱신하여야 하며, 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.

2. 회원은 사이트의 사전 승낙 없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.

제 4 장 기타

제 14 조 (양도금지)

1. 회원이 서비스의 이용권한, 기타 이용계약 상 지위를 타인에게 양도, 증여할 수 없습니다.

제 15 조 (손해배상)

1. 사이트는 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 사이트가 고의로 행한 범죄행위를 제외하고 이에 대하여 책임을 부담하지 아니합니다.

제 16 조 (면책조항)

1. 사이트는 회원이나 제3자에 의해 표출된 의견을 승인하거나 반대하거나 수정하지 않습니다. 사이트는 어떠한 경우라도 회원이 서비스에 담긴 정보에 의존해 얻은 이득이나 입은 손해에 대해 책임이 없습니다.

2. 사이트는 회원간 또는 회원과 제3자간에 서비스를 매개로 하여 물품거래 혹은 금전적 거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 회원이 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않습니다.

제 17 조 (재판관할)

1. 사이트와 이용자간에 발생한 전자거래 분쟁에 관한 소송은 민사소송법상의 관할법원에 제기합니다.
2. 사이트와 이용자간에 제기된 전자거래 소송에는 한국 법을 적용합니다.


부 칙
1. (시행일) 본 약관은 2003년 1월 1일부터 시행됩니다.

                                
                                
                                
                                
                                
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
                            <textarea id="info-rule-selective" readonly="readonly">회원약관


제 1 장 총칙

제1조(목적)

이 약관은 ○○ 코리아(이하 "회사")가 운영하는 마이○○ 사이트(이하 "사이트"라 한다)를 이용함에 있어 회사와 이용자의 권리. 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.


제 2 조 (약관의 효력과 변경)

1. 귀하가 본 약관 내용에 동의하는 경우, 사이트의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 본 약관이 우선적으로 적용됩니다.

2. 사이트는 본 약관을 사전 고지 없이 변경할 수 있고, 변경된 약관은 사이트 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다. 이용자가 변경된 약관에 동의하지 않는 경우, 이용자는 본인의 회원등록을 취소(회원탈퇴)할 수 있으며 계속 사용의 경우는 약관 변경에 대한 동의로 간주됩니다.

제 3 조 (약관 외 준칙)

1. 본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회심의규정, 정보통신 윤리강령, 프로그램보호법 및 기타 관련 법령의 규정에 의합니다.

제 4 조 (용어의 정의)

본 약관에서 사용하는 용어의 정의는 다음과 같습니다.

1. 이용자 : 본 약관에 따라 사이트가 제공하는 서비스를 받는 자.

2. 가입 : 사이트가 제공하는 신청서 양식에 해당 정보를 기입하고, 본 약관에 동의하여 서비스 이용계약을 완료시키는 행위.

3. 회원 : 사이트에 개인 정보를 제공하여 회원 등록을 한 자로서 사이트가 제공하는 서비스를 이용할 수 있는 자. 사이트의 회원은 14세 이상의 회원, 14세 미만 회원, 해외거주자 회원으로 구분됩니다.

4. 비밀번호 : 이용자와 회원ID가 일치하는지를 확인하고 통신상의 자신의 비밀보호를 위하여 이용자 자신이 선정한 문자와 숫자의 조합.

5. 탈퇴 : 회원이 이용계약을 종료시키는 행위.


제 2 장 서비스 제공 및 이용

제 5 조 (이용계약의 성립)

1. 이용계약은 신청자가 온라인으로 사이트에서 제공하는 소정의 가입신청 양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다.

2. 사이트는 다음 각 호에 해당하는 이용계약에 대하여는 가입을 취소할 수 있습니다.

1) 다른 사람의 명의를 사용하여 신청하였을 때
2) 이용계약 신청서의 내용을 허위로 기재하였거나 신청하였을 때
3) 다른 사람의 사이트 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 때
4) 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우
5) 기타 사이트가 정한 이용신청요건이 미비 되었을 때

제 6 조 (회원정보 사용에 대한 동의)

1. 회원의 개인정보는 공공기관의 개인정보보호에 관한 법률에 의해 보호됩니다.

2. 회원 정보는 다음과 같이 사용, 관리, 보호됩니다.
1) 개인정보의 사용 : 사이트는 서비스 제공과 관련해서 수집된 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 단, 전기통신기본법 등 법률의 규정에 의해 국가기관의 요구가 있는 경우, 범죄에 대한 수사상의 목적이 있거나 정보통신윤리 위원회의 요청이 있는 경우 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우, 귀하가 사이트에 제공한 개인정보를 스스로 공개한 경우에는 그러하지 않습니다.
2) 개인정보의 관리 : 귀하는 개인정보의 보호 및 관리를 위하여 서비스의 개인정보관리에서 수시로 귀하의 개인정보를 수정/삭제할 수 있습니다.
3) 개인정보의 보호 : 귀하의 개인정보는 오직 귀하만이 열람/수정/삭제 할 수 있으며, 이는 전적으로 귀하의 ID와 비밀번호에 의해 관리되고 있습니다. 따라서 타인에게 본인의 ID와 비밀번호를 알려주어서는 안되며, 작업 종료 시에는 반드시 로그아웃 해주시기 바랍니다.

3. 회원이 본 약관에 따라 이용신청을 하는 것은, 사이트가 신청서에 기재된 회원정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다.

제 7 조 (사용자의 정보 보안)

1. 가입 신청자가 사이트 서비스 가입 절차를 완료하는 순간부터 귀하는 입력한 정보의 비밀을 유지할 책임이 있으며, 회원의 ID와 비밀번호를 사용하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있습니다.

2. ID와 비밀번호에 관한 모든 관리의 책임은 회원에게 있으며, 회원의 ID나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 사이트에 신고하여야 합니다. 신고를 하지 않음으로 인한 모든 책임은 회원 본인에게 있습니다.

3. 이용자는 사이트 서비스의 사용 종료 시 마다 정확히 접속을 종료해야 하며, 정확히 종료하지 아니함으로써 제3자가 귀하에 관한 정보를 이용하게 되는 등의 결과로 인해 발생하는 손해 및 손실에 대하여 사이트는 책임을 부담하지 아니합니다.

제 8 조 (서비스의 중지)

1. 사이트는 이용자가 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지할 수 있습니다.

제 9 조 (서비스의 변경 및 해지)

1. 사이트는 귀하가 서비스를 이용하여 기대하는 손익이나 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지 않으며, 회원이 본 서비스에 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관하여는 책임을 지지 않습니다.

2. 사이트는 서비스 이용과 관련하여 가입자에게 발생한 손해 중 가입자의 고의, 과실에 의한 손해에 대하여 책임을 부담하지 아니합니다.

제 10 조 (게시물의 저작권)

1. 귀하가 게시한 게시물의 내용에 대한 권리는 귀하에게 있습니다.

2. 사이트는 게시된 내용을 사전 통지 없이 편집, 이동할 수 있는 권리를 보유하며, 게시판운영원칙에 따라 사전 통지 없이 삭제할 수 있습니다.

3. 귀하의 게시물이 타인의 저작권을 침해함으로써 발생하는 민, 형사상의 책임은 전적으로 귀하가 부담하여야 합니다.

4. 사이트가 작성한 저작물에 대한 저작권 기타 지적재산권은 사이트에 귀속합니다.

5. 이용자는 사이트를 이용함으로써 얻은 정보를 사이트의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.

제 11 조 (광고주와의 거래)

사이트는 본 서비스상에 게재되어 있거나 본 서비스를 통한 광고주의 판촉활동에 회원이 참여하거나 교신 또는 거래의 결과로서 발생하는 모든 손실 또는 손해에 대해 책임을 지지 않습니다.

제 3 장 의무 및 책임

제 12 조 (사이트의 의무)

1. 사이트는 회원의 개인 신상 정보를 본인의 승낙 없이 타인에게 누설, 배포하지 않습니다. 다만, 전기통신관련법령 등 관계법령에 의하여 관계 국가기관 등의 요구가 있는 경우에는 그러하지 아니합니다.

제 13 조 (회원의 의무)

1. 회원 가입 시에 요구되는 정보는 정확하게 기입하여야 합니다. 또한 이미 제공된 귀하에 대한 정보가 정확한 정보가 되도록 유지, 갱신하여야 하며, 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.

2. 회원은 사이트의 사전 승낙 없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.

제 4 장 기타

제 14 조 (양도금지)

1. 회원이 서비스의 이용권한, 기타 이용계약 상 지위를 타인에게 양도, 증여할 수 없습니다.

제 15 조 (손해배상)

1. 사이트는 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 사이트가 고의로 행한 범죄행위를 제외하고 이에 대하여 책임을 부담하지 아니합니다.

제 16 조 (면책조항)

1. 사이트는 회원이나 제3자에 의해 표출된 의견을 승인하거나 반대하거나 수정하지 않습니다. 사이트는 어떠한 경우라도 회원이 서비스에 담긴 정보에 의존해 얻은 이득이나 입은 손해에 대해 책임이 없습니다.

2. 사이트는 회원간 또는 회원과 제3자간에 서비스를 매개로 하여 물품거래 혹은 금전적 거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 회원이 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않습니다.

제 17 조 (재판관할)

1. 사이트와 이용자간에 발생한 전자거래 분쟁에 관한 소송은 민사소송법상의 관할법원에 제기합니다.
2. 사이트와 이용자간에 제기된 전자거래 소송에는 한국 법을 적용합니다.


부 칙
1. (시행일) 본 약관은 2003년 1월 1일부터 시행됩니다.

                                
                                
                                
                                
                                
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
