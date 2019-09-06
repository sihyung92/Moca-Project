//변수 선언부
var likeHateButton;
var btnGroup;
var likeHateCount;
var reviewId;
var clickedLikeHateButton;
var likeBtn;
var hateBtn;
var likeCount;
var hateCount;


var reviewModal;
var reviewForm;
var reviewModalBtn;
var saveReviewBtn;
var editReviewBtn;
var imgFiles;

var editReviewRow
var editBtn;
var deleteBtn;
var clickedEditBtn;
var thumbnailDeleteSpan;

var reviewFormObj;

//리뷰 개수 더보기
var quotient; //몫
var remainder; //나머지
var callNum=1; //호출 넘버

//리뷰 수정시 삭제된 이미지
var delThumbnail="";

//리뷰이미지 수정시 현재있는 이미지 개수
var maxNumForAdd = 0;
var delCnt = 0;


var reviewImg; 
var reviewsDetailModal;
var reviewThumbnailGroup;
var detailImgIdx;
var detailImgsSize;


//회원정보수정 이미지
var userImage;

//리뷰 3개씩 불러오기 startNum
var startNum = 0;
var reviewVoListLength=false;

////////////////////////////
//함수부

//변수 바인딩
var bindReviewVariable = function(){
	reviewModalBtn = $('#reviewModalBtn');
	reviewModal = $('#reviewModal');
	reviewForm = $('#reviewModal form');
	saveReviewBtn = $('#saveReviewBtn');
	editReviewBtn = $('#editReviewBtn');
	imgFiles = $('#files');
	
	editBtn = $('.btn-edit')
	deleteBtn = $('.btn-delete')
	thumbnailDeleteSpan = $('.thumbnailDeleteSpan');

	likeHateButton = $('.like-hate>.btn-group>button')
	
	//리뷰 더보기
	quotient = $('.reviewCnt').length/3;
	remainder = $('.reviewCnt').length%3;
	
	//리뷰 상세 보기
	reviewImg = $('.reviewThumbnailGroup').find('img');
	reviewsDetailModal =$('#reviewsDetailModal');
	reviewThumbnailGroup = $('#reviewThumbnailGroup');
	
	//파일버퍼 초기화
	fileBuffer = [];
	
	reviewVoListLength=false;
	
}


//리뷰 저장
var saveReview = function(fileBuffer){
	console.log("saveReviewBtn clicked",fileBuffer)
	var form = $('#reviewForm')[0];

	var reviewFormData = new FormData(form);
	
	reviewFormData.delete('file');
	
	var fileSize = fileBuffer.length;
	console.log("fileSize"+fileSize);
	console.log("save",fileBuffer);
	
	if(fileSize >0){
		for(var i=0 ; i < fileSize ; i ++){
			reviewFormData.append("file",fileBuffer[i]);
			console.log(i,fileBuffer[i]);
		}
	}
	
	console.log('formData',reviewFormData.get('file'));
	
	$.ajax({
		type: 'POST',
		enctype : 'multipart/form-data',
		url: '/moca/reviews',
		data : reviewFormData,
		dataType : "json",
		contentType : false,  
		processData : false,
		cache : false,
		timeout : 600000,
		beforeSend:function(){
			
			
	    },
		success: function(reviewVo) {
			console.log('ajax 통신 성공');
			console.log(reviewVo);
			
			//리뷰 추가(최상단에)
			addReviewInReviewContent(reviewVo);
	
			$('#reviewModal').modal("hide");		//모달창 닫기
			
			//리뷰디테일 모달창 바인딩
			reviewImg = $('.reviewThumbnailGroup').find('img');
			
			reviewImg.click(function(){
				reviewsDetailModal.modal("show");

				showDetailReviewImg(this);
			});
		
			//수정 삭제 버튼 바인딩 해줄것
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
		}
	})
}

var addReviewInReviewContent = function(reviewVo) {
	var newReview = $('#reviewTemplate').clone(true);
	newReview.css('display', '');
	newReview.removeAttr('id')
	
	var reviewerInfo = newReview.find('.reviewer-info')
	var reviewInfo = newReview.find('.review-info')
	var reviewLevel = newReview.children(".review-level")
	
	// 나중에 사진 추가할때 사용
	var reviewThumbnail = reviewInfo.children('.reviewThumbnailGroup');
	for(var i=0; i<reviewVo.imageList.length; i++){
		var oldReviewThumbnail = reviewThumbnail.html();
		reviewThumbnail.html(oldReviewThumbnail+'<div class="reviewThumbnail"><img src="'+
				reviewVo.imageList[i].thumbnailUrl
				+'" alt="Image" class="img-thumbnail" id="'+
				reviewVo.imageList[i].uu_id
				+'"></div>');
	}
	
	newReview.find('.review-id').eq(0).val(''+reviewVo.review_id);
	newReview.find('.review-id').eq(1).val(''+reviewVo.review_id);
	
	reviewerInfo.find('.reviewer-nickName').text(reviewVo.nickName) 	//닉네임
	reviewerInfo.find('.reviewer-followers').text(reviewVo.followCount) //팔로워수
	reviewerInfo.find('.reviewer-reviewse').text(reviewVo.reviewCount) 	//리뷰수
	
	/// label 옆에 input 같은거 추가할 필요가 있음
	reviewInfo.find('.reviewInfo-write-date').text((new Date(reviewVo.writeDate)).toLocaleDateString())
	reviewInfo.find('.reviewInfo-review-content').text(reviewVo.reviewContent)
	
	var likehateFormGroup = reviewInfo.children('.like-hate')
	
	//eq(0) 리뷰id, eq(1) 좋아요수, eq(2) 싫어요수
	likehateFormGroup.find('input').eq(0).val(reviewVo.review_id)
	likehateFormGroup.find('input').eq(1).val(0)
	likehateFormGroup.find('input').eq(2).val(0)
	
	
	reviewLevel.find('.taste-level').text(reviewVo.tasteLevel)
	reviewLevel.find('.price-level').text(reviewVo.priceLevel)
	reviewLevel.find('.service-level').text(reviewVo.serviceLevel)
	reviewLevel.find('.mood-level').text(reviewVo.moodLevel)
	reviewLevel.find('.convenience-level').text(reviewVo.convenienceLevel)
	reviewLevel.find('.average-level').text(reviewVo.averageLevel)

	$('.review-content').prepend(newReview);	//리뷰에 추가
}


//리뷰 데이터를 리뷰 모달로 이동 (수정 때 사용)
var reviewData2ReviewModal = function(clickedEditBtn,storeName){
	clearReviewModalData();

	reviewModal.modal("show");		//리뷰 모달창 show

	editReviewRow = $(clickedEditBtn).parents('.row').eq(0);

	//store name
	
	//마이페이지에서만 제목을 따로 등록해야하기 때문
	if(reviewModal.find('#reviewModalLabel').html="에 대한 리뷰"){
		reviewModal.find('#reviewModalLabel').html(storeName+"에 대한 리뷰");
	}
	
	
	//리뷰 아이디
	reviewModal.find('#review_id').val(editReviewRow.find('.review-id').eq(0).val());
	//스토어아이디
	reviewModal.find('#storeId').val(editReviewRow.find('.storeId').eq(0).val());
				
	//사진
	
	console.log(editReviewRow);
	var reviewImg = editReviewRow.find('.reviewThumbnailGroup').clone();
	console.log("reviewImg : ",reviewImg);
	console.log(reviewImg);
	reviewModal.find('#files').after(reviewImg);
	reviewImg.find('.reviewThumbnail img').attr('class','oldThumbnail');
	$('#reviewModal').find('.reviewThumbnail').append('<span class="glyphicon glyphicon-remove thumbnailDeleteSpan" aria-hidden="true" onclick="deleteReviewImg(this)"></span>');
	$('.thumbnailDeleteSpan').css('position','relative').css('left','-95px').css('top','-30px').css('cursor','pointer')
	.css('background-color','rgb(255,255,255,0.5)');
	
	//리뷰 내용
	reviewModal.find('#review-content').val(editReviewRow.find('.reviewInfo-review-content').text());
	
	//평점
	$.fn.raty.start(editReviewRow.find('.taste-level').text(), '#taste-level');
	$.fn.raty.start(editReviewRow.find('.price-level').text(), '#price-level');
	$.fn.raty.start(editReviewRow.find('.service-level').text(), '#service-level');
	$.fn.raty.start(editReviewRow.find('.mood-level').text(), '#mood-level');
	$.fn.raty.start(editReviewRow.find('.convenience-level').text(), '#convenience-level');
	reviewModal.find('#average-level').val( editReviewRow.find('.average-level').text())
}

//리뷰 수정
var editReview = function(){
	//delete한 썸네일 추가
	$(reviewForm).append('<input type="hidden" name="delThumbnail" value="'+delThumbnail+'"/>');
	console.log(reviewForm);
	
	//파일 추가
	var form = $('#reviewForm')[0];

	var reviewFormData = new FormData(form);
	
	reviewFormData.delete('file');
	
	var fileSize = fileBuffer.length;
	
	if(fileSize >0){
		for(var i=0 ; i < fileSize ; i ++){
			reviewFormData.append("file",fileBuffer[i]);
		}
	}
	
	reviewFormObj = $(reviewForm).serializeObject();
	console.log(reviewFormObj.review_id,reviewFormData);

	//ajax 통신 - post방식으로 추가
	$.ajax({
		type: 'POST',
		url: '/moca/reviews/'+reviewFormObj.review_id,
		enctype : 'multipart/form-data',
//		data: reviewFormObj,
		data: reviewFormData,
		dataType : "json",
		contentType : false,  
		processData : false,
		cache : false,
		timeout : 600000,
		success: function(reviewVo) {
			console.log('ajax 통신 성공',reviewVo.imageList);
			//리뷰 내용
			editReviewRow.find('.reviewInfo-review-content').text(reviewFormObj.reviewContent);
			
			// 나중에 사진 추가할때 사용
			var reviewThumbnail = editReviewRow.find('.reviewThumbnailGroup');
			reviewThumbnail.html('');
			for(var i=0; i<reviewVo.imageList.length; i++){
				var oldReviewThumbnail = reviewThumbnail.html();
				reviewThumbnail.html(oldReviewThumbnail+'<div class="reviewThumbnail"><img src="'+
						reviewVo.imageList[i].thumbnailUrl
						+'" alt="Image" class="img-thumbnail" id="'+
						reviewVo.imageList[i].uu_id
						+'"></div>');
			}
			
			//평점
			editReviewRow.find('.taste-level').text(reviewFormObj.tasteLevel);
			editReviewRow.find('.price-level').text(reviewFormObj.priceLevel);
			editReviewRow.find('.service-level').text(reviewFormObj.serviceLevel);
			editReviewRow.find('.mood-level').text(reviewFormObj.moodLevel);
			editReviewRow.find('.convenience-level').text(reviewFormObj.convenienceLevel);
			editReviewRow.find('.average-level').text(reviewVo.averageLevel);
			
			$('#reviewModal').modal("hide");	//모달창 닫기
			
			delThumbnail = "" //delThumbnail 초기화
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
		}
	})

}

var clearReviewModalData = function(){
				
	///사진(나중에 정해지면)
	imgFiles.val('');
	reviewModal.find('.reviewThumbnailGroup').remove();

	//리뷰 내용
	reviewModal.find('#review-content').val('');

	//평점
	reviewModal.find('#taste-level').val('1')
	reviewModal.find('#price-level').val('1')
	reviewModal.find('#service-level').val('1')
	reviewModal.find('#mood-level').val('1')
	reviewModal.find('#convenience-level').val('1')
	reviewModal.find('#average-level').val('1')
	
}

//리뷰 삭제
var deleteReview = function(review_id) {
	console.log(review_id);
	$.ajax({
		type: 'DELETE',
		url: '/moca/reviews/'+review_id,
		success: function() {
			console.log('ajax 통신 성공')
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
			alert("리뷰 삭제 실패")
		}
	})
}


//리뷰 사진 삭제 버튼 클릭시
var deleteReviewImg = function(deleteBtn){
	console.log(deleteBtn);
	var temp = delThumbnail;
	
	//추가해준 이미지가 아니면
	if($(deleteBtn).prev().attr('src').indexOf('blob')==-1){
		if(delThumbnail != ""){		
			delThumbnail = temp+","+$(deleteBtn).prev().attr('src');		
		}else{
			delThumbnail = temp+$(deleteBtn).prev().attr('src');		
		}		
	}
	console.log(delThumbnail);
	
	//삭제 버튼을 클릭한 이미지가 몇번째인지 (0부터)
	var fileIndex = $(deleteBtn).parent().index();	
	
	//이미 있는 이미지의 갯수가 0 이상이면
    if($(deleteBtn).parent().parent().find('.oldThumbnail').filter(':visible').length>0){
    	
    	//더 올릴수 있는 이미지의 갯수를 구함
    	maxNumForAdd = $(deleteBtn).parent().parent().find('.oldThumbnail').filter(':visible').length;
    	maxNumForAdd = maxNumForAdd-1;
    	
    	//더 올릴수 있는 파일의 갯수
	    fileIndex = fileIndex - maxNumForAdd;
	}
    console.log($(deleteBtn).parent().attr('class'));
    
    //내가 새로 추가한 이미지인 경우
    if($(deleteBtn).parent().attr('class')=='file newThumbnail reviewThumbnail'){
    	
    	//
    	var hiddenLength = $(deleteBtn).parent().prevAll().find('.newThumbnail').filter(':hidden').length;
    	fileBuffer.splice($('.newThumbnail').filter(':visible').index($(deleteBtn).parent()),1);// 삭제한 파일을 제외한 실제로 추가해야할 정보     		
    }
    
    $(deleteBtn).parent().hide();
}


//리뷰 개수 더보기
var reviewCnt = function(q,r,n){
	//먼저 3개만 보여주고 나머지는 더보기 버튼으로 클릭시 +3개씩 보여주기
	if(3*n<=q*3){
		for(var i=(n-1)*3; i<3*n; i++){ //몫*3 or 나머지
			$('.reviewCnt').eq(i).show();
		}
		if(3*n==q*3){
			//$('#moreReview').hide();
		}
	}else{
		if(n!=1){
			for(var i=(n-1)*3; i<((n-1)*3)+r; i++){ //몫*3
				$('.reviewCnt').eq(i).show();
			}
			//$('#moreReview').hide();
		}else{
			for(var i=0; i<r; i++){ //나머지
				$('.reviewCnt').eq(i).show();
			}
			//$('#moreReview').hide();
		}
	}
};


//리뷰 내용 더보기
var callReviewDataMore = function(){
	var reviewData = $('.more-review-content');
    reviewData.each( function() {
       
       var btnMoreReview = $(this).parent().siblings('.more-review-content-btn');

       if( $(this).outerHeight() > 41 ){
           
       	$(this).css({ 'height': '3em', 'overflow':'hidden' ,'text-overflow': 'ellipsis', 'display':'block' });
          $(this).addClass('moreData');
          btnMoreReview.show();
          btnMoreReview.on("click",function(){
       	   console.log("outerHeight"+$( this ).outerHeight());
             $(this).siblings('.review-content-div').find('.more-review-content').toggleClass('moreData').promise().done(function(){
                  console.log($(this).hasClass("moreData"));
                  if($(this).hasClass("moreData") === false){
                	  btnMoreReview.text("접기");
                  	$(this).css({ 'height': '100%', 'overflow':'default' ,'text-overflow': 'ellipsis', 'display':'block' });
	              }else{
	            	  btnMoreReview.text("더보기");
	            	 $(this).css({ 'height': '3em', 'overflow':'hidden' ,'text-overflow': 'ellipsis', 'display':'block' });
		          }
             });
          });
          
       }else{
           
       	btnMoreReview.hide();
       	
       }
    });
};

//좋아요 또는 싫어요 추가
var addLikeHate = function(reviewId, isLike){
	//ajax 통신 - post방식으로 추가
	$.ajax({
		type: 'POST',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공 - 좋아요')
			//ajax 통신 성공시
			
			if(isLike ==1){
				likeBtn.addClass('clicked')
				likeCount.val(Number(likeCount.val()) + 1);
			}else if(isLike == -1){
				hateBtn.addClass('clicked')
				hateCount.val(Number(hateCount.val()) + 1);
			}
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
			alert("좋아요 싫어요 추가 실패")
		}
	})

}

//좋아요 또는 싫어요 변경
var changeLikeHate = function(reviewId, isLike){
	//ajax 통신 - put 방식으로 수정
	$.ajax({
		type: 'PUT',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공')
			
			if(isLike ==1){
				hateBtn.removeClass('clicked')
				hateCount.val(Number(hateCount.val()) - 1);
				likeBtn.addClass('clicked')
				likeCount.val(Number(likeCount.val()) + 1);
			}else if( isLike == -1){
				likeBtn.removeClass('clicked')
				likeCount.val(Number(likeCount.val()) - 1);
				hateBtn.addClass('clicked')
				hateCount.val(Number(hateCount.val()) + 1);
			}
			

		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
			alert("좋아요 싫어요 변경 실패")
		}

	})
}

//좋아요 또는 싫어요 취소
var cancelLikeHate = function(reviewId, isLike){

	//ajax 통신 - delete 방식으로 삭제
	$.ajax({
		type: 'DELETE',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공')
			if(isLike ==1){
				likeBtn.removeClass('clicked')
				likeCount.val(Number(likeCount.val()) - 1);
			}else if(isLike == -1){
				hateBtn.removeClass('clicked')
				hateCount.val(Number(hateCount.val()) - 1);
			}
			
		},
		error: function(request,status,error) {
			respondHttpStatus(request.status);
			alert("취소 실패")
		}

	})

}

//리뷰 디테일 이미지를 보여줌
var showDetailReviewImg = function(clickedReviewImg){
	$('img').removeClass('clickedImg');
	//클릭한 이미지에 class 추가	
	$(clickedReviewImg).addClass('clickedImg');
	
	//섬네일 url 주소를 원본 url 주소로 변경
	var url = thumbnailUrl2Url( clickedReviewImg.src );
	
	//
	$('#reviewDetailDiv').html($('<img/>',{
		id : 'reviewDetailImg',
		src : url
	}));
	//클릭한 리뷰의 섬네일 이미지를 모달로
	reviewThumbnailGroup.html($(clickedReviewImg).parents('.reviewThumbnailGroup').html());
	
	//디테일 이미지의 인덱스
	detailImgIdx = 0;
	detailImgsSize = reviewThumbnailGroup.find('img').size();
	for(var i=0; i<detailImgsSize ; i++){
		if(reviewThumbnailGroup.find('img').eq(i).hasClass('clickedImg')){
			detailImgIdx = i;
		}
	}
	
	reviewThumbnailGroup.find('img').click(function(){
		$('img').removeClass('clickedImg')
		$(this).addClass('clickedImg');
		//섬네일 url 주소를 원본 url 주소로 변경
		var url = thumbnailUrl2Url( this.src );
		
		//
		$('#reviewDetailDiv').html($('<img/>',{
			id : 'reviewDetailImg',
			src : url
		}));
		
		for(var i=0; i<detailImgsSize ; i++){
			if(reviewThumbnailGroup.find('img').eq(i).hasClass('clickedImg')){
				detailImgIdx = i;
			}
		}
	})
	
	
}

var thumbnailUrl2Url = function(thumbnailUrl){
	var url = thumbnailUrl.split('_thumbnail')
	return url[0]+url[1];
}

//좋아요 또는 싫어요 버튼 클릭시
var bindLikeHateButtonEvent = function(clickedLikeHateButton){
		//클릭한 버튼의 리뷰에 해당하는 정보를 변수 바인딩
		//clickedLikeHateButton = $(this);
		btnGroup = clickedLikeHateButton.parent();
		reviewId = btnGroup.children('.review-id').val();
		likeBtn = btnGroup.children('.like-btn');
		hateBtn = btnGroup.children('.hate-btn');
		likeCount = btnGroup.children('.like-count');
		hateCount = btnGroup.children('.hate-count');
		
		var isLike;

		//이전 상태 판단
		if (clickedLikeHateButton.hasClass('like-btn')) {
			isLike=1;
			//좋아요 버튼을 눌렀을때 
			if (likeBtn.hasClass('clicked')) {
				//이전에 좋아요 누른 상태 > 좋아요를 누를때 = > 좋아요 취소
				console.log('이전에 좋아요 누른 상태 > 좋아요를 누를때')
				cancelLikeHate(reviewId, isLike);
			} else if (hateBtn.hasClass('clicked')) {
				//이전에 싫어요 누른 상태 > 좋아요를 누를때 = > 싫어요 취소 + 좋아요
				console.log('이전에 싫어요 누른 상태 > 좋아요를 누를때 ')
				changeLikeHate(reviewId, isLike);
			} else {
				//이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 => 좋아요
				console.log('이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 ');
				addLikeHate(reviewId,isLike);
			}
		} else if (clickedLikeHateButton.hasClass('hate-btn')) {
			isLike=-1;
			
			//싫어요 버튼을 눌렀을때 
			if (likeBtn.hasClass('clicked')) {
				//이전에 좋아요 누른 상태 > 싫어요를 누를때 = >좋아요 취소 + 싫어요
				console.log('이전에 좋아요 누른 상태 > 싫어요 누를때 ')
				changeLikeHate(reviewId, isLike);
			} else if (hateBtn.hasClass('clicked')) {
				//이전에 싫어요 누른 상태 > 싫어요를 누를때 = > 싫어요 취소
				console.log('이전에 싫어요 누른 상태 > 싫어요를 누를때 ')
				cancelLikeHate(reviewId, isLike);
			} else {
				//이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 => 싫어요
				console.log('이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 ')
				addLikeHate(reviewId, isLike);
			}
		}
};

//파일 change function
var filesChange = function(){
    const target = document.getElementsByName('file');
    
	if($(this).next().attr('class')=='reviewThumbnailGroup'){
		fileListDiv = $(this).next();
		if(fileBuffer.length==0){
			maxNumForAdd = $(fileListDiv).children().find('.oldThumbnail').filter(':visible').length
		}
    }else{
    	$(this).parent().append('<div class="reviewThumbnailGroup"></div>');
    	fileListDiv = $(this).next();
    	maxNumForAdd = 0;
	}
	
	if((fileBuffer.length*1)+maxNumForAdd>10 || (target[0].files.length*1)>10){
		alert("파일은 10개까지만 등록가능합니다.");
	}else{
        
        Array.prototype.push.apply(fileBuffer, target[0].files);
        var newFileDiv = '';
        $.each(target[0].files, function(index, file){
            const fileName = file.name;
            newFileDiv += '<div class="file newThumbnail reviewThumbnail" style="width:121px">';
            newFileDiv += '<img src="'+URL.createObjectURL(file)+'" alt="Image">'
            newFileDiv += '<span class="glyphicon glyphicon-remove removeThumbnailBtn"onclick="deleteReviewImg(this)" aria-hidden="true" style="position:relative; left:-95px; top:-30px; cursor:pointer; background-color:rgb(255,255,255,0.5);"></span>';
            newFileDiv += '</div>';
            const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
            if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
                alert("파일은 (jpg, png, gif, bmp) 형식만 등록 가능합니다.");
                fileBuffer.splice(fileBuffer.length-1, 1);
                test = fileBuffer;
                return false;
            }
        });
	}
    
    $(fileListDiv).append(newFileDiv);
    if((fileBuffer.length*1)+maxNumForAdd>10){
		alert("파일은 10개까지만 등록가능합니다.");
		//10개가 넘은 경우 넘은 파일 입력된 이미지랑 filebuffer에서 삭제
		$.each(target[0].files, function(index, file){
			var num = 0;
			if(index==0){
				num = fileBuffer.length-index;
			}
			fileBuffer.splice(fileBuffer.length-1, 1);
			$('#files').next().children().last().remove();
		});
	}
	

};

var url2PathFileName = function(imgUrl){
	return imgUrl.split('.com/')[1]
}

//스크롤 맨밑으로 내려갈 때
var scrollMaxDown = function() {
    
	startNum += 3;
	console.log(startNum);
	moreReviewList(startNum);
	/*
    var height = $(document).height();
    var height_win = $(window).height();
    
    
    if (Math.round( $(window).scrollTop()) == $(document).height() - $(window).height()) {
    	//리뷰를 3개씩 ajax로 불러오기
    	console.log("맨밑");
    	startNum += 3;
	    moreReviewList(startNum);
	    $(window).scrollTop($(document).height() - $(window).height()-100);
	} 
	*/ 
};

//리뷰 3개씩 추가
var moreReviewList = function(startNum) {
	$.ajax({
		type: 'GET',
		url: '/moca/storeReviews/' + storeId,
		async: false,
		data: {
			"startNum": startNum
		},
		success: function(reviewVoList) {
			console.log('ajax 통신 성공')
			console.log(reviewVoList);
			
			//갖고오는 이미지 length가 3개 미만일 때
			if(reviewVoList.length<3){
				$('#moreReview').hide();
				reviewVoListLength = true;
			}
			
			for(var j=0; j<reviewVoList.length; j++){
				
				var alreadyReviewExist = false;
				var reviewVo = reviewVoList[j];
				test = reviewVo;
				for(var i=0; i<$('.review-content').find('.review-id').filter(':even').length; i++){
					if(reviewVo.review_id==$('.review-content').find('.review-id').filter(':even').eq(i).val()){
						alreadyReviewExist=true;
						break;
					}
				}
				if(alreadyReviewExist==true){
					continue;
				}
				
				var newReview = $('#reviewTemplate').clone(true);
				newReview.css('display', '');
				newReview.removeAttr('id')
				
				var reviewerInfo = newReview.find('.reviewer-info')
				var reviewInfo = newReview.find('.review-info')
				var reviewLevel = newReview.children(".review-level")
				
				// 나중에 사진 추가할때 사용
				var reviewThumbnail = reviewInfo.children('.reviewThumbnailGroup');
				for(var i=0; i<reviewVo.imageList.length; i++){
					var oldReviewThumbnail = reviewThumbnail.html();
					reviewThumbnail.html(oldReviewThumbnail+'<div class="reviewThumbnail"><img src="'+
							reviewVo.imageList[i].thumbnailUrl
							+'" alt="Image" class="img-thumbnail" id="'+
							reviewVo.imageList[i].uu_id
							+'"></div>');
				}
				
				if(reviewVo.editable==0){
					newReview.find('.editDeleteGroup').remove();
				}
				
				newReview.find('.review-id').eq(0).val(''+reviewVo.review_id);
				newReview.find('.review-id').eq(1).val(''+reviewVo.review_id);
				
				reviewerInfo.find('.accountProfile').attr('src',reviewVo.thumbnailImage);
				reviewerInfo.find('.reviewer-nickName').text(reviewVo.nickName) 	//닉네임
				reviewerInfo.find('.reviewer-followers').text(reviewVo.followCount) //팔로워수
				reviewerInfo.find('.reviewer-reviews').text(reviewVo.reviewCount) 	//리뷰수
				
				reviewInfo.find('.reviewInfo-write-date').text((new Date(reviewVo.writeDate)).toLocaleDateString())
				reviewInfo.find('.reviewInfo-review-content').text(reviewVo.reviewContent)
				for(var key in test.tagMap){
					if(!key.includes('ID') && (test.tagMap[key] ==1)){
						var newTag = $('#review-tag-div').clone(true);
						newTag.css('display','');
						newTag.removeAttr('id');
						
						newTag.text('#'+key)	//값 넣어주기
						newTag.attr('href', '#')	/// search와 연결
						
						newReview.find('.review-tags-div').append(newTag);
						console.log(newTag);
					}
				}
				
				
				var likehateFormGroup = reviewInfo.children('.like-hate')
				
				//eq(0) 리뷰id, eq(1) 좋아요수, eq(2) 싫어요수
				likehateFormGroup.find('input').eq(0).val(reviewVo.review_id)
				likehateFormGroup.find('input').eq(1).val(reviewVo.likeCount)
				likehateFormGroup.find('input').eq(2).val(reviewVo.hateCount)
				
				reviewLevel.find('.taste-level').text(reviewVo.tasteLevel)
				reviewLevel.find('.price-level').text(reviewVo.priceLevel)
				reviewLevel.find('.service-level').text(reviewVo.serviceLevel)
				reviewLevel.find('.mood-level').text(reviewVo.moodLevel)
				reviewLevel.find('.convenience-level').text(reviewVo.convenienceLevel)
				reviewLevel.find('.average-level').text(reviewVo.averageLevel)

				$('.review-content').append(newReview.fadeIn(2000));	//리뷰에 추가
			}
			
			//리뷰이미지 모달 바인딩
			reviewImg = $('.reviewThumbnailGroup').find('img');
			
			reviewImg.click(function(){
				reviewsDetailModal.modal("show");

				showDetailReviewImg(this);
			});
		},
		error: function(request,status,error) {
			alert('ajax 통신 실패');
		}

	})
}



//form 형식의 내용을 js Object 형태로 변경
jQuery.fn.serializeObject = function() {
    var obj = null;
    try {
        if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
            var arr = this.serializeArray();
            if (arr) {
                obj = {};
                jQuery.each(arr, function() {
                    obj[this.name] = this.value;
                });
            }//if ( arr ) {
        }
    } catch (e) {
        alert(e.message);
    } finally {
    }
 
    return obj;
};