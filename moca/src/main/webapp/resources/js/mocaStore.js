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
	console.log(param);

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
			console.log("카페상세정보 수정성공");
			//카페 정보 바꿔주기
			if (param.wifi == '0') {
				$('#wifiInfo').html('없음');
			} else if (param.wifi == '1') {
				$('#wifiInfo').html('있음');
			} else if (param.wifi == '-1') {
				$('#wifiInfo').html('');
			}

			if (param.parkingLot == '0') {
				$('#parkingLotInfo').html('없음');
			} else if (param.parkingLot == '1') {
				$('#parkingLotInfo').html('있음');
			} else if (param.parkingLot == '-1') {
				$('#parkingLotInfo').html('');
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
			console.log(i,fileBuffer[i]);
		}
	}
	
	var storeImgFormObj = $(form).serializeObject();
	console.log(storeImgFormObj,storeImgFormData);
	

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
			console.log('ajax 통신 성공');
			
			location.reload();
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
		}
	})

}

