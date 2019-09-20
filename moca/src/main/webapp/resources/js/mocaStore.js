var updateStore = function(store_Id) {

	var checkTel = $('input[name="tel2"]').val();
	if (checkTel != "") {
		checkTel = $('input[name="tel1"]').val() + "-" + $('input[name="tel2"]').val() + "-" + $('input[name="tel3"]').val()
	};

	//var params=$('#StoreInfoModal form').serializeObject();
	var param = {
		"wifi":$('input[name="wifi"]:checked').val(),
		"parkingLot":$('input[name="parkingLot"]:checked').val(),
		"dayOff":$('input[name="dayOff"]').val(),
		"openTime2":$('input[name="openTime"]').val(),
		"endTime2":$('input[name="endTime"]').val(),
		"tel":checkTel,
		"url":$('input[name="url"]').val()
	};

	//카페 상세정보 수정
	$.ajax({
		type: 'put',
		url: store_Id,
		contentType: "application/json; charset=UTF-8",
		datatype: "json",
		data: JSON.stringify(param),
		error: function(request,status,error) {
			respondHttpStatus(request.status);
			
		},
		success: function(data) {
			//카페 정보 바꿔주기
			if (param.wifi == '0') {
				setSvgNone($('#wifiInfo img'));
			} else if (param.wifi == '1') {
				setSvgNotNone($('#wifiInfo img'));
			} else if (param.wifi == '-1') {
				setSvgNone($('#wifiInfo img'));
			}

			if (param.parkingLot == '0') {
				setSvgNone($('#parkingLotInfo img'))
			} else if (param.parkingLot == '1') {
				setSvgNotNone($('#parkingLotInfo img'))
			} else if (param.parkingLot == '-1') {
				setSvgNone($('#parkingLotInfo img'))
			}

			$('#dayOffInfo').html(param.dayOff);
			var dash = ' - ';
			if (param.endTime2 == '') {
				dash = '';
			};
			$('#TimeInfo').html(param.openTime2 + dash + param.endTime2);
			$('#telInfo').html(param.tel);
			$('#urlInfo').html(param.url);
		}
	});
};

var setSvgNotNone =function(svgElement){
	//none 상태인가?
	if( isClickedSvg(svgElement) ){
		//none 이 없는 상태로
		toggleSvgNone(svgElement);
	}
}
var setSvgNone =function(svgElement){
	//none 상태인가?
	if( !isClickedSvg(svgElement) ){
		//none 이 없는 상태로
		toggleSvgNone(svgElement);
	}
}

//카페 이미지 수정
var editStoreImg = function(){
	//delete한 썸네일 추가
	$('#delStoreImg').val(toBeDeletedStoreImgUrls);
	$('#oldStoreImg').val(oldStoreImgUrls);
	
	//파일 추가
	var form = $('#storeImgForm')[0];

	var storeImgFormData = new FormData(form);
	
	storeImgFormData.delete('file');
	
	var fileSize = fileBuffer.length;
	
	if(fileSize >0){
		for(var i=0 ; i < fileSize ; i ++){
			storeImgFormData.append("newStoreFiles",fileBuffer[i]);
		}
	}
	
	var storeImgFormObj = $(form).serializeObject();
	
	if( isEditable ){
		
		isEditable = false;
		$('#progress_loading').show();
		
		//ajax 통신 - post방식으로 추가
		$.ajax({
			type: 'POST',
			url: '/moca/storeImg/'+storeImgFormObj.storeId,
			enctype : 'multipart/form-data',
			data: storeImgFormData,
			dataType : "json",
			contentType : false,  
			processData : false,
			cache : false,
			timeout : 600000,
			success: function(storeVo) {				
				location.reload();
			},
			error: function(request,status,error) {
				respondHttpStatus(request.status);
			}
		}).always(function(){
			//로딩바를 숨겨준다.
			$('#progress_loading').hide();
		})
	}

}

var toggleLikeStore = function(){
	var srcValue = likeStoreBtn.attr('src');
	//좋아요를 누르지 않은 경우
	if(srcValue.indexOf('-fill.svg')==-1){
		//좋아요 추가
		methodType = 'POST';
		
	}else{//이전에 좋아요를 누른경우
		//좋아요에서 삭제
		methodType = 'DELETE';
		
	}

	$.ajax({
		type: methodType,
		url: '/moca/likeStore/' + accountId,
		data : {
			storeId : storeId
		},
		success: function() {						
			toggleSvgFill(likeStoreBtn);

			if(methodType == 'POST'){
				$('#storeLikeCount').text($('#storeLikeCount').text()*1+1)
			}else if(methodType == 'DELETE'){
				$('#storeLikeCount').text($('#storeLikeCount').text()*1-1)
			}
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
		}
	})
}

var toggleFavoriteStore = function(){
	var srcValue = favoriteStoreBtn.attr('src');
	//가고 싶은 카페 누르지 않은 경우
	if(srcValue.indexOf('-fill.svg')==-1){
		//가고 싶은 카페에 추가
		methodType = 'POST';
		
	}else{//이전에 가고 싶은 카페를 누를 경우
		//가고 싶은 카페에서 삭제	
		methodType = 'DELETE';
					
	}
	$.ajax({
		type: methodType,
		url: '/moca/favoriteStore/' + accountId,
		data : {
			storeId : storeId
		},
		success: function() {

			toggleSvgFill(favoriteStoreBtn);

			if(methodType == 'POST'){
				$('#storeFavoriteCount').text($('#storeFavoriteCount').text()*1+1)
			}else if(methodType == 'DELETE'){
				$('#storeFavoriteCount').text($('#storeFavoriteCount').text()*1-1)
			}
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
		}
	})
}

//카페 이미지 로고 수정
var editStoreLogo = function(){
	//delete한 썸네일 추가
	$('#delStoreLogo').val(toBeDeletedStoreLogoUrl);
	
	//파일 추가
	var form = $('#storeLogoForm')[0];

	var storeImgFormData = new FormData(form);
	
	storeImgFormData.delete('file');
	
	
	var storeImgFormObj = $(form).serializeObject();
	
	if(storeImgFormObj.delStoreLogo == ""){
		return false;
	}
	
	if( isEditable ){
		isEditable = false;
		$('#progress_loading').show();
		
		//ajax 통신 - post방식으로 추가
		$.ajax({
			type: 'POST',
			url: '/moca/storeLogo/'+storeImgFormObj.storeId,
			enctype : 'multipart/form-data',
			data: storeImgFormData,
			dataType : "json",
			contentType : false,  
			processData : false,
			cache : false,
			timeout : 600000,
			success: function(storeVo) {
				location.reload();
			},
			error: function(request,status,error) {
				respondHttpStatus(request.status);
			}
		}).always(function(){
			//로딩바를 숨겨준다.
			$('#progress_loading').hide();
		})
		
	}


}


//storeInfo 수정확인을 누르기 전에 체크해야할 목록들
var validationOpenTimeEndTime = function(){
    //영업 시작 시간이 종료 시간보다 늦습니다. 영업시간을 다시 확인해주세요.
	openTime = $(".timePattern").eq(0).val().split(":")[0];
    var openMin = $(".timePattern").eq(0).val().split(":")[1];
    endTime = $(".timePattern").eq(1).val().split(":")[0];
    var endMin = $(".timePattern").eq(1).val().split(":")[1];
    
    if(openTime=="00" && openMin=="00" && endTime=="00" && endMin=="00"){
	    return true;
	}else if(openTime*1>=0 && openTime*1<24){
		if((endTime*1 - openTime*1)<0){
			if(endTime*1<4 && endtime*1>=0){
				if(openTime*1 - endTime*1>0){
					return true;
				}else{
					alert("영업시간을 다시 확인해주세요.");
					return false;
				}
			}else{
				alert("영업시간을 다시 확인해주세요.");					
				return false;
			}
		}else if(endTime*1 == openTime*1 && !(endTime=="" && openTime=="")){
			alert("영업시작시간과 영업종료시간은 같을 수 없습니다. 다시 확인해주세요.");
		}
		return true;
	}
}

//storeInfo 수정확인을 누르기 전에 체크해야할 목록들
var validationStoreInfoTime = function(checkTime){
	//영업시간 형식이 맞지 않습니다. 영업시간을 다시 확인해주세요.
	var timeValidation = /^([1-9]|[01][0-9]|2[0-3]):([0-5][0-9])$/;

	if(checkTime.val()==""){
	    return true;
	}
    
    if(timeValidation.test(checkTime.val())==false){
        alert("입력한 영업시간이 형식에 맞지 않습니다. 영업시간을 다시 확인해주세요.");
        checkTime.val("");
        return false;
    }
}

