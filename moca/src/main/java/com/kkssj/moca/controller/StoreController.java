package com.kkssj.moca.controller;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.support.DaoSupport;
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

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.LogService;
import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(StoreController.class);

	@Inject
	StoreService storeService;
	
	@Inject
	LogService logService;
	
	////////////////////////
	//store
 	//처음 상세페이지로 접속, vo 객체로 받기
	@PostMapping("/stores")
	public String addStore(@ModelAttribute StoreVo storeVo, Model model){
		
		// 여기서 스토어ID가 있으면(0이 아니면) -> insert 안하고, 스토어ID가 없으면 insert 해야함
		logger.debug("storeId : " + storeVo.getStore_Id());

		// 없으면 insert
		// 거짓 insert가 쓸때없이 많이 일어났을 때 ALTER TABLE STORE AUTO_INCREMENT=변경할값;으로 seq 초기화
		if (storeVo.getStore_Id() == 0) {
			logger.debug("스토어 ID가 없습니다");

			// category 분류 후 분류된 카테고리로 set storeVo
			storeVo.setCategory(changeCategory(storeVo.getCategory(), storeVo.getName()));
			storeVo.setLogoImg(setUrlByCategory(storeVo.getName()));
			logger.debug(storeVo.getCategory());
			logger.debug(storeVo.toString());
			storeVo = storeService.addStore(storeVo);
			logger.debug(storeVo.toString());
		}
		
 		return "redirect:stores/"+storeVo.getStore_Id();
	}


	private String setUrlByCategory(String storeName) {
		String[][] storeNames = new String[][] {{"스타벅스","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/starbucks.jpg"},
												{"커피빈","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/coffeBean.jpg"},
												{"이디아","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/ediya.jpg"},
												{"투썸플레이스","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/twoSomePlace.jpg"},
												{"엔제리너스","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/angelInUsCoffee.jpg"},
												{"드롭탑","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/twoSomePlace.jpg"},
												{"할리스","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/hollys.jpg"},
												{"풀바셋","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/paulBassett.jpg"},
												{"파스쿠찌","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/pascucci.jpg"},
												{"탐앤탐스","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/tomntoms.jpg"},
												{"빽다방","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/paiksCoffe.jpg"},
												{"토프레소","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/topresso.jpg"},
												{"만랩커피","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/10000lab.jpg"},
												{"커피온리","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/coffeOnly.jpg"},
												{"쥬씨","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/juicy.jpg"},
												{"메가커피","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/megaCoffe.jpg"},
												{"매머드커피","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/mmthCoffe.jpg"},
												{"더리터","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/theLitter.jpg"},
												{"더벤티","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/theVenti.jpg"},
												{"블루보틀","https://team-moca.s3.ap-northeast-2.amazonaws.com/logo/blueBottle.jpg"}
												};
												
		for (int i = 0; i < storeNames.length; i++) {
			logger.debug(storeName +":"+storeNames[i][0]+"," +storeName.contains(storeNames[i][0]) );
			if(storeName.contains(storeNames[i][0])) {
				return storeNames[i][1];
			}
		}

		return null;
	}


	// 리다이렉트로 상세페이지로
	@GetMapping("/stores/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model, HttpSession session, HttpServletRequest req, HttpServletResponse res){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//store Log 찍혔는지 확인
		//storeview 찍기 위한 session (storeId당 30분)
		if(session.getAttribute("viewCntIsAdded")==null) {
			session.setAttribute("viewCntIsAdded",new HashMap<Integer, Long>());
		}
		
		
		////////////////////////////////
		//store log
		boolean addStoreView = true;
		Map<Integer,Long> viewCntIsAdded = (Map<Integer, Long>) session.getAttribute("viewCntIsAdded");
		
		if(viewCntIsAdded.get(storeId)==null) {
			viewCntIsAdded.put(storeId, System.currentTimeMillis());
			addStoreView = false;
		}else {
			long currentTime = System.currentTimeMillis();
			long timeDiff = viewCntIsAdded.get(storeId);
			if(currentTime-timeDiff>(1000*60*30)) {
				addStoreView = false;
				viewCntIsAdded.put(storeId, System.currentTimeMillis());
			}
		}
	
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			//비회원 store view 로그 찍기
			if(addStoreView==false)
			logService.writeLogStore(req, "스토어뷰", storeId, accountVo.getAccount_id());
		}else {
			logger.debug(accountVo.toString());
			//회원 store view 로그 찍기
			if(addStoreView==false)
			logService.writeLogStore(req, "스토어뷰", storeId, accountVo.getAccount_id());
		}
		
		

		
		StoreVo storeVo = storeService.getStore(storeId, accountVo.getAccount_id());
		logger.debug(storeVo.toString());

		/// 이때 storeVo에 store_id 값이 없으면 해당페이지 없다는 view 리턴
		if (storeVo.getStore_Id() == 0) {
			res.setStatus(res.SC_NOT_FOUND);
			return "error";
		}
		
		List<String> tagNameList = storeService.getTagNameList();

		logger.debug("accountVo!!!!"+accountVo.toString());
		model.addAttribute("accountVo", accountVo);

		//리뷰가져오기
		model.addAttribute("reviewVoList", storeService.getReviewListLimit(accountVo.getAccount_id(), storeId, 0));

		//tag 가져오기
		model.addAttribute("tagNameList", tagNameList);
				
		model.addAttribute("storeVo", storeVo);
		
		//storeImg의 개수에 따라 리뷰 이미지 vo 받아오기
		model.addAttribute("StoreImgList", storeService.getStoreImgList(storeId));
		
		model.addAttribute("storeInfoHistory", storeService.getStoreInfoHistory(storeId));		
		
		
		
		return "store_detail";
	}
	
	@PutMapping("/stores/{storeId}")
	public ResponseEntity updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}

		////////////////////////////////
		//input check
		
		
		
		////////////////////////////////
		//logger
		storeVo.setStore_Id(storeId);
		logger.debug("storeId : " + storeId + " - updateStore");
		logger.debug(storeVo.toString());


		////////////////////////////////
		//기능
		
		// edit store에서 store update, storeinfohistory insert
		if (storeService.editStore(accountVo.getAccount_id(), storeVo) > 0) {
			// 성공
			return ResponseEntity.status(HttpStatus.OK).body(storeService.getStoreInfoHistory(storeId));
		} else {
			// 실패
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

	}
	
	//카페 대표이미지 수정
	@PostMapping("/storeImg/{store_Id}")
	@ResponseBody
	public ResponseEntity editStoreImg(@RequestParam("newStoreFiles") MultipartFile[] newFiles,
			@RequestParam("delStoreImg") String delStoreImg, @RequestParam("oldStoreImg") String oldStoreImg, 
			StoreVo storeVo, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		

		
		////////////////////////////////
		//input check
		
		String[] delStoreImgArr = delStoreImg.split(",");
		if(delStoreImg.equals("")) {
			delStoreImgArr = new String[0];
		}
		String[] oldStoreImgArr = oldStoreImg.split(",");
		if(oldStoreImg.equals("")) {
			oldStoreImgArr = new String[0];
		}
		
		//수정한 내용이 없는 경우
		if(oldStoreImgArr.length ==3 ) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		if((newFiles.length+oldStoreImgArr.length)>3) {
    		return new ResponseEntity<>(HttpStatus.TOO_MANY_REQUESTS);
    	}
		for (int i = 0; i < newFiles.length; i++) {
			if(!newFiles[i].getContentType().contains("image")) {
				logger.debug("input contenType : " +newFiles[i].getContentType());
				return new ResponseEntity<>(HttpStatus.UNSUPPORTED_MEDIA_TYPE);
			}
		}
		
		
		////////////////////////////////
		//logger
		for (int i = 0; i < newFiles.length; i++) {
			logger.debug(newFiles[i].getOriginalFilename());
		}
		for (int i = 0; i < oldStoreImgArr.length; i++) {
			logger.debug("old : "+oldStoreImgArr[i]);			
		}
		for (int i = 0; i < delStoreImgArr.length; i++) {
			logger.debug("del : "+delStoreImgArr[i]);				
		}
		logger.debug(storeVo.toString());
		
		
		
		////////////////////////////////
		//기능
		
		//이미지 수정
		if(storeService.editStoreImg(storeVo.getStore_Id(), newFiles, oldStoreImgArr, delStoreImgArr) == 1) {
			return new ResponseEntity<>(storeVo,  HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	//로고 파일 수정
	@PostMapping("/storeLogo/{store_Id}")
	@ResponseBody
	public ResponseEntity editStoreLogo(@RequestParam("storeLogoFile") MultipartFile newFile,
			@RequestParam("delStoreLogo") String delStoreLogo, 
			StoreVo storeVo, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		////////////////////////////////
		//input check
		
		if(delStoreLogo.equals("")) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		if(!newFile.getContentType().contains("image")) {
			logger.debug("input contenType : " +newFile.getContentType());
			return new ResponseEntity<>(HttpStatus.UNSUPPORTED_MEDIA_TYPE);
		}
		
		
		////////////////////////////////
		//logger
		logger.debug(newFile.getOriginalFilename());
		logger.debug("del : "+delStoreLogo);				
		logger.debug(storeVo.toString());
		

		////////////////////////////////
		//기능
		
		//로고 수정
		if(storeService.editStoreLogo(storeVo.getStore_Id(), newFile, delStoreLogo) == 1) {
			return new ResponseEntity<>(storeVo,  HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	
	////////////////////////
	//카페 좋아요
    @PostMapping(value ="/likeStore/{accountId}")
    public ResponseEntity addLikeStore(@PathVariable("accountId") int accountId, @RequestParam int storeId,Model model, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		
		////////////////////////////////
		//기능
		if(storeService.addLikeStore(storeId, accountVo.getAccount_id()) == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
    @DeleteMapping(value ="/likeStore/{accountId}")
    public ResponseEntity deleteLikeStore(@PathVariable("accountId") int accountId, @RequestParam int storeId, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}

		
		////////////////////////////////
		//기능
		if(storeService.deleteLikeStore(storeId, accountVo.getAccount_id()) == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
	
	////////////////////////
	//카페 즐겨 찾기
    @PostMapping(value ="/favoriteStore/{accountId}")
    public ResponseEntity addFavoriteStore(@PathVariable("accountId") int accountId, @RequestParam int storeId , HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}

		
		////////////////////////////////
		//기능
		if(storeService.addFavoriteStore(storeId, accountVo.getAccount_id()) == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
    @DeleteMapping(value ="/favoriteStore/{accountId}")
    public ResponseEntity deleteFavoriteStore(@PathVariable("accountId") int accountId, @RequestParam int storeId, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}

		
		////////////////////////////////
		if(storeService.deleteFavoriteStore(storeId, accountVo.getAccount_id()) == 1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
	
	
	////////////////////////
	//review 
    
    //리뷰 3개씩 가져오기
    @ResponseBody
    @GetMapping(value ="/storeReviews/{store_id}")
    public ResponseEntity getReview(@PathVariable("store_id") int store_id, @RequestParam("startNum") int startNum,  HttpSession session){
    	AccountVo accountVo = (AccountVo) session.getAttribute("login");
    	
    	//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
		}
    	
    	List<ReviewVo> reviewVoList = storeService.getReviewListLimit(accountVo.getAccount_id(), store_id, startNum);
    	logger.debug("startNum : "+startNum);
    	logger.debug(reviewVoList.toString());
    	return new ResponseEntity<>(reviewVoList,HttpStatus.OK);
    }
	
	//리뷰 입력, 서버에 파일 업로드
    @ResponseBody
    @PostMapping(value ="/reviews")
    public ResponseEntity addReview(@RequestParam("file") MultipartFile[] files, ReviewVo reviewVo, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		
		////////////////////////////////
		//input check
		
    	if(files.length>10) {
    		return new ResponseEntity<>(HttpStatus.TOO_MANY_REQUESTS);
    	}
    	for (int i = 0; i < files.length; i++) {
    		if(!files[i].getContentType().contains("image")) {
    			logger.debug("input contenType : " +files[i].getContentType());
    			return new ResponseEntity<>(HttpStatus.UNSUPPORTED_MEDIA_TYPE);
    		}
		}

    	
    	
		////////////////////////////////
		//logger
        reviewVo.setAccount_id(accountVo.getAccount_id());
        logger.debug(reviewVo.toString());
		
        for (int i = 0; i < files.length; i++) {
			logger.debug(files[i].getName());
		}
        
		////////////////////////////////
		//기능		
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
			@RequestParam("delThumbnail") String delThumbnails, ReviewVo reviewVo, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		reviewVo.setAccount_id(accountVo.getAccount_id());
		
		String[] delThumbnail = delThumbnails.split(",");
		if((newFiles.length+delThumbnail.length)>10) {
    		return new ResponseEntity<>(HttpStatus.TOO_MANY_REQUESTS);
    	}
		
		
		////////////////////////////////
		//input check
		for (int i = 0; i < newFiles.length; i++) {
			if(!newFiles[i].getContentType().contains("image")) {
				logger.debug("input contenType : " +newFiles[i].getContentType());
				return new ResponseEntity<>(HttpStatus.UNSUPPORTED_MEDIA_TYPE);
			}
		}
		
		
		////////////////////////////////
		//logger
		logger.debug(reviewVo.toString());
		logger.debug(delThumbnails);
		for (int i = 0; i < newFiles.length; i++) {
			logger.debug(newFiles[i].getName());
		}
		
		
		////////////////////////////////
		//기능
		if(storeService.editReview(reviewVo, newFiles, delThumbnails) !=null) {
			return new ResponseEntity<>(reviewVo, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	// 리뷰 삭제
	@DeleteMapping("/reviews/{review_id}")
	public ResponseEntity deleteReview(@PathVariable("review_id") int review_id,@RequestParam("storeId") int store_id, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		logger.debug("store_id : "+store_id);
		
		ReviewVo reviewVo = new ReviewVo();
		reviewVo.setAccount_id(accountVo.getAccount_id());
		reviewVo.setReview_id(review_id);
		reviewVo.setStore_id(store_id);
		
		
		
		////////////////////////////////
		//기능
		if(storeService.deleteReview(reviewVo)==1) {			
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	
	////////////////////////
	//likeHate

	// 좋아요싫어요 추가
	@PostMapping("/likeHates/{review_id}")
	public ResponseEntity addLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		
		////////////////////////////////
		//기능
		if(storeService.addLikeHate(review_id, accountVo.getAccount_id(), isLike) ==1) {
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
	public ResponseEntity editLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		
		
		////////////////////////////////
		//기능
		if(storeService.editLikeHate(review_id, accountVo.getAccount_id(), isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}

	// 좋아요 싫어요 삭제
	@DeleteMapping("/likeHates/{review_id}")
	public ResponseEntity  deleteLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike, HttpSession session){
		
		////////////////////////////////
		//account check
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}

		
		////////////////////////////////
		//기능
		if(storeService.deleteLikeHate(review_id, accountVo.getAccount_id(), isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	
	/////////////////////////
	//리뷰 이미지 뷰 수 올리기
	@PutMapping("/reviewImages/views")
	public ResponseEntity upReviewImageViews(@RequestParam String url, HttpSession session) {
		//
		if(session.getAttribute("reviewImageViewsMap") ==null) {
			session.setAttribute("reviewImageViewsMap", new HashMap<String, Long>());
		}
		
		//리뷰 이미지의 뷰 수를 증가 시킬 수 있는가
		boolean isUpReviewImageViews = true;
		Map<String, Long> reviewImageViewsMap = (HashMap<String, Long>)session.getAttribute("reviewImageViewsMap");
		
		//처음 클릭한 이미지인 경우
		if(reviewImageViewsMap.get(url) ==null) {
			reviewImageViewsMap.put(url, System.currentTimeMillis());
		}else {//이전에 클릭한 경우
			long currentTime = System.currentTimeMillis();
			long timeDiff = reviewImageViewsMap.get(url);
			
			//30분 전에 클릭한 경우
			if((currentTime-timeDiff) <(1000*60*30)) {
				isUpReviewImageViews = false;
				reviewImageViewsMap.put(url, System.currentTimeMillis());
			}
		}
		int result = 1;
		
		//증가시킬 경우
		if(isUpReviewImageViews) {
			ImageVo imageVo = new ImageVo();
			imageVo.setUrl(url);
			imageVo.setUu_idPathOriginNameByUrl();
			
			result = storeService.editReviewImageViews(imageVo.getUu_id());
		}
		
		
		if(result ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

	}


	////////////////////////
	//동기화 (나중에 put 방식으로 변경)
	
	//리뷰 좋아요수 동기화
	@GetMapping("/reviews/likeHate")
	public String syncReviewLikeHate() {
		
		int result = storeService.syncReviewLikeHate();
		
		//일단 페이지 띄워야 하니까 
		return "redirect:/stores/"+1;
	}
	
	//store 좋아요 수 동기화
	@GetMapping("/stores/likeCnt")
	public String syncStoresLikeCnt() {
		int result = storeService.syncStoresLikeCnt();
		logger.debug("syncStoresLikeCnt result="+result);
		return "";
	}
	
	//store 리뷰 수 동기화
	@GetMapping("/stores/reviewCnt")
	public String syncStoresReviewCnt() {
		int result = storeService.syncStoresReviewCnt();
		logger.debug("syncStoresReviewCnt result="+result);
		return "";
	}
	
	//store 가고싶은 수 동기화
	@GetMapping("/stores/favoriteCnt")
	public String syncStoresFavoriteCnt() {
		int result = storeService.syncStoresFavoriteCnt();
		logger.debug("syncStoresFavoriteCnt result="+result);
		return "";
	}
	

	//store levelCnt 동기화
	@GetMapping("/stores/levelCnt")
	public String syncStoreLevel() {
		int result = storeService.syncStoreLevel();
		return "redirect:../1";
	}

	
	public String changeCategory(String category, String name) {
		// 포함되면 해당 카테고리로 변환
		// 프랜차이즈(카테고리), 애견(카테고리), 스터디(이름), 고양이(카테고리), 만화+놀숲(이름), 보드(카테고리), 룸카페(이름)
		//테이크아웃: 매머드, 컴포즈커피, 빽다방, 메가커피, 더리터, 커피온리, 더벤티, 쥬씨, 마노핀, 커피식스, 어벤더치
		String[] categoryCheck = { "커피전문점", "애견", "고양이", "보드" };
		String[] nameCheck = { "스터디", "만화", "놀숲", "룸카페" };
		String[] takeOutCafe = {"매머드", "컴포즈커피", "빽다방", "메가커피", "더리터", "커피온리", "더벤티", "쥬씨", "마노핀", "커피식스", "어벤더치"};
		
		for (int i = 0; i < categoryCheck.length; i++) {
			if (category.contains(categoryCheck[i])) {
				if (categoryCheck[i].equals("커피전문점")) {
					category = "프랜차이즈";
				} else {
					category = categoryCheck[i];
				}
				break;
			}
		}
		
		for(int i=0; i<takeOutCafe.length; i++) {
			if (name.contains(takeOutCafe[i])) {
				category = "프랜차이즈>테이크아웃";
			}
		}

		for (int i = 0; i < nameCheck.length; i++) {
			if (name.contains(nameCheck[i])) {
				if (nameCheck[i].equals("놀숲")) {
					category = "만화";
				} else {
					category = nameCheck[i];
				}
				break;
			}
		}

		return category;
	}
}