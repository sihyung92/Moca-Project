<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.kkssj.moca.model.entity.ResearchQuestionVo"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 필수정보 입력받을 모달 -->
        <div class="modal" id="input-info-Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document" style="overflow-y: scroll; max-height:85%;  margin-top: 50px; margin-bottom:50px;">
				<div class="modal-content">
			      	
                    <div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span id="closeBtn" aria-hidden="true">&times;</span></button>
		        		<h4 class="modal-title" id="myModalLabel">moca 이용을 위한 기초 정보 제공</h4>
					</div>
			      	
                    <div class="modal-body">
                        <div>
                            <label for="essential-info">[필수]정보 수집 및 활용에 관한 동의</label><br>
                            <textarea id="info-rule" readonly="readonly">회원약관


제 1 장 총칙

제1조(목적)

이 약관은 3K2S1C(이하 "개발팀")가 운영하는 모카(이하 "서비스"라 한다)를 이용함에 있어 개발팀(서비스 제공자)과 이용자의 권리. 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.


제 2 조 (약관의 효력과 변경)

1. 귀하가 본 약관 내용에 동의하는 경우, 사이트의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 본 약관이 우선적으로 적용됩니다.

2. 사이트는 본 약관을 사전 고지 없이 변경할 수 있고, 변경된 약관은 사이트 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다. 이용자가 변경된 약관에 동의하지 않는 경우, 이용자는 본인의 회원등록을 취소(회원탈퇴)할 수 있으며 계속 사용의 경우는 약관 변경에 대한 동의로 간주됩니다.

제 3 조 (약관 외 준칙)

1. 본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회심의규정, 정보통신 윤리강령, 프로그램보호법 및 기타 관련 법령의 규정에 의합니다.

제 4 조 (용어의 정의)

본 약관에서 사용하는 용어의 정의는 다음과 같습니다.

1. 이용자 : 본 약관에 따라 사이트가 제공하는 서비스를 받는 자.

2. 가입 : 이용자가 본 서비스에 로그인 하는 순간 SNS를 통한 로그인으로부터 정보제공에 동의하는 것을 우리 서비스의 가입으로 간주합니다.

3. 회원 (일반) : 사이트에 개인 정보를 제공하여 회원 등록을 한 자로서 사이트가 제공하는 '일반' 서비스를 이용할 수 있는 자. 제한을 두지 않습니다.

 - 3'. 회원 (매니저) : 사이트내에 일반 회원과 동일하게 등록을 한 자이며 카페를 운영 및 관리자로서 우리 서비스에 요청을통해 페이지 '관리'의 서비스를 추가로 이용할 수 있는 자 입니다. 카페의 매니저 혹은 점주로 제한합니다.

 - 일반 서비스 : '일반' 서비스라 함은 서비스를 이용하며 카페 상세페이지 내의 좋아요, 리뷰, 태그달기 등 페이지 전반의 큰 변경의 없이 이용하는 권한의 서비스를 말합니다.

 - 관리 서비스 : '관리' 서비스라 함은 서비스를 이용하며 이용자께서 속해있는 카페 페이지의 대표사진, 메뉴정보, 영업시간등 카페의 대표 정보들에대한 등록 및 수정 권한을 갖는 서비스를 말합니다.

4. 비밀번호 : '모카'는 아이디와 비밀번호에 대한 정보를 수집하지 않고 저장하지 않습니다.

5. 탈퇴 : 탈퇴 요청시 서비스가 연동되어 있는 데이터의 해당 회원의 자료를 삭제합니다. 리뷰등의 데이터는 회원정보가 삭제될 수 있으나 내용은 참고 데이터로 사용 될 수 있습니다.


제 2 장 서비스 제공 및 이용

제 5 조 (이용계약의 성립)

1. 이용계약은 신청자가 온라인으로 사이트에서 제공하는 소정의 가입신청(현재 본 동의 양식 페이지를 말합니다.) 에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다.

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
1. (시행일) 본 약관은 2019년 9월 25일부터 시행됩니다.

                                
                                
                                
                                
                                
                            </textarea>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-agree" id="essentialYes"> 동의합니다
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-agree" checked="checked" id="essentialNo"> 동의하지 않습니다 (약관 확장) 
                            </label>                              
                            <br><br>
                            <div class="custom-width-line"></div><br>
                        </div>
                        <div>                                    
                            <label for="selective-info">[선택]정보 수집 및 활용에 관한 동의</label><br>
                            <textarea id="info-rule-selective" readonly="readonly">회원약관


제 1 장 별도 수집 정보에 대한 동의

제1조(목적)

이 약관은  3K2S1C(이하 "개발팀")가 운영하는 모카(이하 "서비스"라 한다)를 이용함에 있어 더 나은 서비스를 위한 정보를 제공하는 것에 대한 약관입니다.


제 2 조 (약관의 효력과 변경)

1. 귀하가 본 약관 내용에 동의하는 경우, 사이트의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 본 약관이 우선적으로 적용됩니다.

2. 사이트는 본 약관을 사전 고지 없이 변경할 수 있고, 변경된 약관은 사이트 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다. 이용자가 변경된 약관에 동의하지 않는 경우, 이용자는 본인의 회원등록을 취소(회원탈퇴)할 수 있으며 계속 사용의 경우는 약관 변경에 대한 동의로 간주됩니다.

제 3 조 (약관 외 준칙)

1. 본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회심의규정, 정보통신 윤리강령, 프로그램보호법 및 기타 관련 법령의 규정에 의합니다.


제 2 장 서비스 제공 및 이용

제 4 조 (회원정보 사용에 대한 동의)

1. 서비스가 요구하는 정보는 공공기관의 개인정보보호에 관한 법률에 의해 보호됩니다.

2. 해당 정보는 다음과 같이 사용, 관리, 보호됩니다.

1) 개인정보의 사용 : 사이트는 서비스 제공과 관련해서 수집된 회원의 정보는 모카에서 통계적 정보로서 이용 가능합니다. 해당 정보들은 추후 서비스의 개선 및 이용자들에게 제공됩니다.
2) 개인정보의 관리 : 귀하는 개인정보의 보호 및 관리를 위하여 서비스의 개인정보관리에서 수시로 귀하의 개인정보를 수정/삭제할 수 있습니다.


3. 회원이 본 약관에 따라 이용신청을 하는 것은, 사이트가 회원이 제공하는 정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다.

제 5 조 (회원 탈퇴시의 정보 잔여에 대한 동의)

1. 본 약관에 동의를 한 사용자가 제공한 정보는 추후 본 서비스를 이용하는 이용자 본인과 타 이용자들에게 더 나은 서비스의 제공을 위해 개발팀에서 삭제하거나 서비스가 종료되기 전까지 보관될 수 있습니다.
2. 이용자 본인의 요구가 없는 한 회원 탈퇴시에는 해당 정보들은 잔여하게됩니다.
3. 이용자가 탈퇴시 정보의 삭제를 요구하는 경우 해당 정보들은 삭제됩니다.

부 칙
1. (시행일) 본 약관은 2019년 9월 25일부터 시행됩니다.

                                
                                
                                
                                
                                
                            </textarea>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-selective-agree" id="selectiveYes"> 동의합니다
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="info-rule-selective-agree" checked="checked" id="selectiveNo"> 동의하지 않습니다 (약관 확장) 
                            </label>                              
                        </div>                        
                        
                        <form action="/moca/research" method="get" id="essential-info" name="f"><br>
                            <div class="custom-width-line"></div><br>
                            <div class="form-group">
                                <!-- 카페 관련 업종 확인 -->
                                <label for="isBarista">[필수]현재 '카페'관련 업종에 종사하시나요?</label><br>
                                <label class="radio-inline">
                                    <input class="essential-collect-info" type="radio" name="barista" id="isBaristaYes" value="2"> 네
                                </label>
                                <label class="radio-inline">
                                    <input class="essential-collect-info" type="radio" name="barista" id="isBaristaNo" value="1"> 아니요
                                </label><br><br>
                                
                                <!-- 성별 -->
                                <label for="gender">[필수]당신의 성별을 알려주세요 </label><br>
                                <label class="radio-inline">
                                    <input class="essential-collect-info" type="radio" name="gender" id="male" value="1"> 남
                                </label>
                                
                                <label class="radio-inline">
                                    <input class="essential-collect-info" type="radio" name="gender" id="female" value="2"> 여
                                </label><br><br>
                                
                                <!-- 생일 -->
                                <label for="gender">[필수]당신의 생일을 알려주세요 </label><br>
                                <input class="essential-collect-info" type="date" name="birthday" id="birthday">
                                <br><br>

                                <!-- email -->
                                <!--<label for="exampleInputEmail1">[필수]이메일 주소</label>
                                <input type="email" class="form-control essential-collect-info" name="email" id="email" placeholder="이메일을 입력하세요">-->
                                
                                <div id="selective-info">
                                    <br><div class="custom-width-line"></div>
                                    <br>
                                    
                                    <!-- 선호도 질문 표현식 사용 -->
                                <%
                                    ArrayList alist = (ArrayList)session.getAttribute("qlist");
                                	if(alist!=null){
                                		for(int i=0 ;i< alist.size();i++){
                                			ResearchQuestionVo rqVo = (ResearchQuestionVo)alist.get(i);
                                %>
                                    <div>
                                    <label for="SQ<%=rqVo.getQuestion_id()%>"><%=rqVo.getQuestion() %></label><br>
                                <%
			                                if(rqVo.getAnswer()!=null){
			                                	ArrayList ans = (ArrayList)session.getAttribute("ans"+rqVo.getQuestion_id());
			                                	if(ans!=null){
                          		%>
													<div class="qArea" style="display: inline-block">
														<!-- 
														<img id="<%=i %>an1p" alt="#" src="/moca/resources/imgs/an1p.png"/><img id="<%=i %>an2p" alt="#" src="/moca/resources/imgs/an2p.png"/><img id="<%=i %>an3p" alt="#" src="/moca/resources/imgs/an3p.png"/><img id="<%=i %>an4p" alt="#" src="/moca/resources/imgs/an4p.png"/><img id="<%=i %>an5p" alt="#" src="/moca/resources/imgs/an5p.png"/>
														 -->
														 <!-- img -> label로 변경 -->
														 <div class="btn-group" data-toggle="buttons">
													<%
														for(int j=1;j<6;j++){
													%>	
														<label id="<%=i %>an<%=j %>p"class="btn btn-primary an<%=j %>p anOff"><%=j %></label>
													<%
														}
													%>
														</div>
														<input id="an<%=i %>qVal" type="hidden" name="SQ<%=rqVo.getQuestion_id() %>" value=""/>
					                                </div>
                          						
                          		<%
			                                    }
	                             			}else{
                               	%>
                               				<input id="an<%=i %>qVal" type="text" class="essential-selective-info" name="SQ<%=rqVo.getQuestion_id() %>" />
                               	<%
			                                }
			                                    out.print("</div>");
		                                	}
                                	}
                                %>
                                    
                                    <br>
                                    
                                </div>
                            </div>
                            <button type="button" class="btn btn-default" id="research-submit" >제출</button>
                            <button type="submit" class="hidden-btn">봣툰</button>
                        </form>
                    </div>
                
                    <div class="modal-footer">                      
                    </div>
                </div>
			</div>
		</div>
    
    <!-- 설문에 대한 버튼 처리 -->
    <script type="text/javascript">
        researchSubmit();
        function test(){
            $('#male').css('')
        }
        function researchSubmit(){
            $('#research-submit').click(function(){
                var account_id=''+'${sessionScope.login.account_id}';
                var barista;
                var gender;
                var birthday=''+$('#birthday').val();

                if(document.f.barista[0].checked==true){
                    barista='2';
                }
                if(document.f.barista[1].checked==true){
                    barista='1';
                }
                if(document.f.gender[0].checked==true){
                    gender='1';
                }
                if(document.f.gender[1].checked==true){
                    gender='2';
                }
                var param={
                    "account_id":account_id,
                    "barista":barista,
                    "gender":gender,
                    "birthday":birthday,
                }
                
                $.ajax({
                    type: 'post',
					url: '/moca/research',
					contentType: "application/json; charset=UTF-8",
					datatype: "json",
					data: JSON.stringify(param),
					error: function(errorMsg) {
                        
                        if(barista==null){
                            alert('카페 종사여부 항목을 체크하지 않았습니다.');
                        }
                        if(gender==null){
                            alert('성별 항목을 체크하지 않았습니다.');
                        }
                        if(birthday==''){
                            alert('생년월일을 작성하지 않았습니다.');
                        }						
					},
					success: function(data) {
                        $('.hidden-btn').click();
						//f5();
					}
                    
                });
            });
        }
               
    //설문조사시 선택지 
        selectiveProgressBar();
        $('#closeBtn').click(function(){
            alert(' ※ 정보제공에 동의하지 않으시면 이용에 제약이 있을 수 있습니다 ※ ');
        });
    //함수 정의
        function selectiveProgressBar(){
        	var idx = 50; // 적당히 큰 수
	    	for(var k=0;k<idx;k++){
	            for(var i=1;i<6;i++){
	                anpClick(i,k);
	            }
    		}
        }
        function anpClick(num,idx){
            $('#'+idx+'an'+num+'p').click(function(){
                for(var i=1;i<6;i++){
                    if(i<=num){
                        //$('#'+idx+'an'+i+'p').attr({src:"/moca/resources/imgs/an"+i+".png"});
                        $('#'+idx+'an'+i+'p').removeClass('anOff');
                    }else{
                        //$('#'+idx+'an'+i+'p').attr({src:"/moca/resources/imgs/an"+i+"p.png"});
                        $('#'+idx+'an'+i+'p').addClass('anOff');
                    }
                }
                $('#an'+idx+'qVal').val(num);
            });
        }
    </script>