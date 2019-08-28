package com.kkssj.moca.controller;

import java.sql.SQLException;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

import com.kkssj.moca.model.entity.StoreVo;

import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(StoreController.class);

	@Inject
	StoreService storeService;
	
	
	////////////////////////
	//store

 	//처음 상세페이지로 접속, vo 객체로 받기
	@PostMapping("/stores")
	public String addStore(@ModelAttribute StoreVo storeVo, Model model){
		logger.info("getStoreId");

		// 여기서 스토어ID가 있으면(0이 아니면) -> insert 안하고, 스토어ID가 없으면 insert 해야함
		logger.debug("storeId : " + storeVo.getStore_Id());

		// 없으면 insert
		// 거짓 insert가 쓸때없이 많이 일어났을 때 ALTER TABLE STORE AUTO_INCREMENT=변경할값;으로 seq 초기화
		if (storeVo.getStore_Id() == 0) {
			logger.debug("스토어 ID가 없습니다");

			// category 분류 후 분류된 카테고리로 set storeVo
			storeVo.setCategory(changeCategory(storeVo.getCategory(), storeVo.getName()));
			logger.debug(storeVo.getCategory());
			logger.debug(storeVo.toString());
			storeVo = storeService.addStore(storeVo);
			logger.debug(storeVo.toString());
		}
		
 		return "redirect:stores/"+storeVo.getStore_Id();
	}


	// 리다이렉트로 상세페이지로
	@GetMapping("/stores/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model){
		logger.debug("storeId : " + storeId + " - getStore");
		
		AccountVo accountVo = new AccountVo();
		accountVo.setAccount_id(1);

		StoreVo storeVo = storeService.getStore(storeId, accountVo.getAccount_id());
		logger.debug(storeVo.toString());

		// 이때 storeVo에 store_id 값이 없으면 해당페이지 없다는 view 리턴
		if (storeVo.getStore_Id() == 0) {
			// return "에러페이지";
		}

		model.addAttribute("accountVo", accountVo);

		model.addAttribute("reviewVoList", storeService.getReviewList(accountVo.getAccount_id(), storeId));

		model.addAttribute("storeVo", storeVo);
		
		//storeImg의 개수에 따라 리뷰 이미지 vo 받아오기
		model.addAttribute("StoreImgList", storeService.getStoreImgList(storeId));
		
		model.addAttribute("storeInfoHistory", storeService.getStoreInfoHistory(storeId));

		return "store_detail";
	}
	
	@PutMapping("/stores/{storeId}")
	public ResponseEntity updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo){
		
		//회원만 가능하게 로그인 기능 구현되면 붙여넣을 것
		//if(session.getAttribute("login")!==null) {
			
		//}

		storeVo.setStore_Id(storeId);
		logger.debug("storeId : " + storeId + " - updateStore");
		logger.debug(storeVo.toString());

		// 수정한 사람의 Id가 필요
		int accountId = 1; // session에서 얻어오기

		// edit store에서 store update, storeinfohistory insert
		int isSuccess = storeService.editStore(accountId, storeVo);

		if (isSuccess > 0) {
			// 성공
			return ResponseEntity.status(HttpStatus.OK).body(storeService.getStoreInfoHistory(storeId));
		} else {
			// 실패
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

	}
	
	////////////////////////
	//카페 좋아요
    @PostMapping(value ="/likeStore/{accountId}")
    public ResponseEntity addLikeStore(@PathVariable("accountId") int accountId, @RequestParam int storeId) throws Exception{
    	///세션과 pathVari로 받은 accountId 비교
		AccountVo accountVo = new AccountVo();
    	accountVo.setAccount_id(1);

    	int result = storeService.addLikeStore(storeId, accountVo.getAccount_id());
		
		if(result == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
    @DeleteMapping(value ="/likeStore/{accountId}")
    public ResponseEntity deleteLikeStore(@PathVariable("accountId") int accountId, @RequestParam int storeId) throws Exception{
    	//세션과 pathVari로 받은 accountId 비교
		AccountVo accountVo = new AccountVo();
    	accountVo.setAccount_id(1);

		int result = storeService.deleteLikeStore(storeId, accountVo.getAccount_id());
		
		if(result == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
	
	////////////////////////
	//카페 즐겨 찾기
    @PostMapping(value ="/favoriteStore/{accountId}")
    public ResponseEntity addFavoriteStore(@PathVariable("accountId") int accountId, @RequestParam int storeId ) throws Exception{
    	///세션과 pathVari로 받은 accountId 비교
		AccountVo accountVo = new AccountVo();
    	accountVo.setAccount_id(1);

    	int result = storeService.addFavoriteStore(storeId, accountVo.getAccount_id());
		
		if(result == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
    @DeleteMapping(value ="/favoriteStore/{accountId}")
    public ResponseEntity deleteFavoriteStore(@PathVariable("accountId") int accountId, @RequestParam int storeId ) throws Exception{
    	///세션과 pathVari로 받은 accountId 비교
		AccountVo accountVo = new AccountVo();
    	accountVo.setAccount_id(1);

		int result = storeService.deleteFavoriteStore(storeId, accountVo.getAccount_id());
		
		if(result == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
	
	
	////////////////////////
	//review 
	
	//리뷰 입력, 서버에 파일 업로드
    @ResponseBody
    @PostMapping(value ="/reviews")
    public ResponseEntity addReview(@RequestParam("file") MultipartFile[] files, HttpSession session, ReviewVo reviewVo) throws Exception{
    	if(files.length>10) {
    		return new ResponseEntity<>(HttpStatus.TOO_MANY_REQUESTS);
    	}
    	//사용자 개정 등록(세션에서 왔다고 가정)
    	AccountVo accountVo = (AccountVo)session.getAttribute("login");
    	accountVo = new AccountVo();
    	accountVo.setNickname("songhae");
    	accountVo.setAccount_id(1);
        
        reviewVo.setAccountId(accountVo.getAccount_id());
        logger.debug(reviewVo.toString());
		
        for (int i = 0; i < files.length; i++) {
			logger.debug(files[i].getName());
		}
		reviewVo = storeService.addReview(reviewVo,files);
		
		if(reviewVo != null) {
			logger.debug(reviewVo.toString());
			return new ResponseEntity<>(reviewVo,HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
    
	
	//리뷰 수정
	@PostMapping("/reviews/{review_id}")
	@ResponseBody
	public ResponseEntity editReview(@RequestParam("file") MultipartFile[] newFiles, 
			@RequestParam("delThumbnail") String delThumbnails, ReviewVo reviewVo) {
		String[] delThumbnail = delThumbnails.split(",");
		if((newFiles.length+delThumbnail.length)>10) {
    		return new ResponseEntity<>(HttpStatus.TOO_MANY_REQUESTS);
    	}
		logger.debug(reviewVo.toString());
		logger.debug(delThumbnails);
		//세션이 작동했다고 가정
		reviewVo.setAccountId(1);
		
		for (int i = 0; i < newFiles.length; i++) {
			logger.debug(newFiles[i].getName());
		}
		
		//json으로 수정 내용 전송
		reviewVo = storeService.editReview(reviewVo, newFiles, delThumbnails);
		
		//받는 쪽에서 refresh하게
		if(reviewVo!=null) {
			return new ResponseEntity<>(reviewVo, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	// 리뷰 삭제
	@DeleteMapping("/reviews/{review_id}")
	public ResponseEntity deleteReview(@PathVariable("review_id") int review_id){
		// 사용자 확인
		int accountId = 1;
		
		ReviewVo reviewVo = new ReviewVo();
		reviewVo.setAccountId(accountId);
		reviewVo.setReview_id(review_id);
		
		int isDelete = storeService.deleteReview(reviewVo);
		
		if(isDelete==1) {			
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	
	////////////////////////
	//likeHate

	// 좋아요싫어요 추가
	@PostMapping("/likeHates/{review_id}")
	public ResponseEntity addLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		//계정 정보를 받아오고
		int accountId =1;
		
		if(storeService.addLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

	}

	// 좋아요싫어요 수정
	// 서버에 server.xml에 Connector 태그에 parseBodyMethods
	// <Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1"
	// redirectPort="8443" parseBodyMethods="POST,PUT,DELETE"/> 추가
	@PutMapping("/likeHates/{review_id}")
	public ResponseEntity editLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		
		//계정 정보를 받아오고
		int accountId =1;
		
		if(storeService.editLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}

	// 좋아요 싫어요 삭제
	@DeleteMapping("/likeHates/{review_id}")
	public ResponseEntity  deleteLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {		
		//계정 정보를 받아오고
		int accountId =1;	

		if(storeService.deleteLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}


	
	//리뷰 좋아요수 동기화(나중에 put 방식으로 변경)
	@GetMapping("/reviewsLikeHate")
	public String syncReviewLikeHate() {
		
		int result = storeService.syncReviewLikeHate();
		
		//일단 페이지 띄워야 하니까 
		return "redirect:../stores/"+1;
	}



	public String changeCategory(String category, String name) {
		// 포함되면 해당 카테고리로 변환
		// 프랜차이즈(카테고리), 애견(카테고리), 스터디(이름), 고양이(카테고리), 만화+놀숲(이름), 보드(카테고리), 룸카페(이름)
		String[] categoryCheck = { "커피전문점", "애견", "고양이", "보드" };
		String[] nameCheck = { "스터디", "만화", "놀숲", "룸카페" };

		for (int i = 0; i < categoryCheck.length; i++) {
			if (category.contains(categoryCheck[i])) {
				if (categoryCheck[i].equals("커피전문점")) {
					category = "프랜차이즈";
				} else {
					category = categoryCheck[i];
				}
			}
		}

		for (int i = 0; i < nameCheck.length; i++) {
			if (name.contains(nameCheck[i])) {
				if (nameCheck[i].equals("놀숲")) {
					category = "만화";
				} else {
					category = nameCheck[i];
				}
			}
		}

		return category;
	}
}