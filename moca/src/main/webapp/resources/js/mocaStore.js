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
		error: function(errorMsg) {
			console.log("카페상세정보 수정실패", errorMsg);
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