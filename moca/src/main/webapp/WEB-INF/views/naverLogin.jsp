<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="kr">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- JQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
<!-- Optional theme -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
	<title>NaverLoginSDK</title>
</head>

<body>

	<!-- callback -->
	처리중입니다.
	<!-- 이 페이지에서는 callback을 처리하고 바로 main으로 redirect하기때문에 이 메시지가 보이면 안됩니다. -->

	<!-- (1) LoginWithNaverId Javscript SDK -->
	<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>


	<!-- (2) LoginWithNaverId Javscript 설정 정보 및 초기화 -->
	<script>
		var naverLogin = new naver.LoginWithNaverId(
			{
				clientId: "{Ku_XOqso7r1UgfC0sTeH}",
				callbackUrl: "{}",
				isPopup: false,
				callbackHandle: true
				/* callback 페이지가 분리되었을 경우에 callback 페이지에서는 callback처리를 해줄수 있도록 설정합니다. */
			}
		);

		/* (3) 네아로 로그인 정보를 초기화하기 위하여 init을 호출 */
		naverLogin.init();

		/* (4) Callback의 처리. 정상적으로 Callback 처리가 완료될 경우 main page로 redirect(또는 Popup close) */
		window.addEventListener('load', function () {
			naverLogin.getLoginStatus(function (status) {
				if (status) {
					/* (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 */
					var acc_Id = naverLogin.user.getId();
					
					var email = naverLogin.user.getEmail();
                    var name = '"'+naverLogin.user.getNickName()+'"';
                    var profileImage = '"'+naverLogin.user.getProfileImage()+'"';
                    //var birthday = naverLogin.user.getBirthday();
                    var uniqId = naverLogin.user.getId();
                    //var age = naverLogin.user.getAge();
                    var token = naverLogin.accessToken;
					if( email == undefined || email == null || name == undefined || name == null) {
						alert("이메일은 필수정보입니다. 정보제공을 동의해주세요.");
						/* (5-1) 사용자 정보 재동의를 위하여 다시 네아로 동의페이지로 이동함 */
						naverLogin.reprompt();
						return;
					}
                    
                    var param = {
	    					  //MySQL db속 account table의 accId가 INT라서 우선 이 값으로 설정 (구분값으로 생각하면 됨)
		        			"account_id":"1111111111",
		        			"followCount":"0",
		        			"reviewCount":"0",
		        			"platformId":uniqId,
		        			"nickname":name,
		        			"platformType":"naver",
		        			"profileImage":profileImage,
		        			"thumbnailImage":profileImage,
		        			"email":email,
		        			"token":toString(token)
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
                        }
                    });

					window.location.replace("http://" + window.location.hostname + ( (location.port==""||location.port==undefined)?"":":" + location.port) + "/moca/stores/1");
				} else {
					console.log("callback 처리에 실패하였습니다.");
				}
			});
		});
	</script>
</body>

</html>