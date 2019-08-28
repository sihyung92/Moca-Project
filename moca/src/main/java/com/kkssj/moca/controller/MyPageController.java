package com.kkssj.moca.controller;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MypageService;
import com.kkssj.moca.service.StoreService;

@Controller
public class MyPageController {
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageController.class);
	
	@Inject
	MypageService mypageService;

	@GetMapping("/mypage/{accountId}")
	public String home(@PathVariable("accountId") int accountId) {
		//account 정보 받아오기
		
		//그래프 정복 가져오기
		
		//배지 정보 가져오기
		
		//내 게시글 정보 가져오기
		
		return "mypage";
	}
	
	@GetMapping("/favoriteStores/{accountId}")
	public ResponseEntity getFavoriteStores(@PathVariable("accountId") int accountId) {
		//session의 accountId와 비교
		//다르면
//		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
		logger.debug("accountId = "+ accountId);

		
		
		List<StoreVo> favoriteStoreList = mypageService.getFavoriteStoreList(accountId);
		
		if(favoriteStoreList!=null) {
			return new ResponseEntity<>(favoriteStoreList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	@GetMapping("/likeStores/{accountId}")
	public ResponseEntity getLikeStores(@PathVariable("accountId") int accountId) {
		//session의 accountId와 비교
		//다르면
//		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		logger.debug("accountId = "+ accountId);
		
		List<StoreVo> likeStoreList = mypageService.getLikeStoreList(accountId);
		
		if(likeStoreList!=null) {
			return new ResponseEntity<>(likeStoreList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
}