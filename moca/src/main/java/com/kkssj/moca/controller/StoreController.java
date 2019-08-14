package com.kkssj.moca.controller;


import java.sql.SQLException;

import javax.inject.Inject;

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

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(StoreController.class);
	
	@Inject
	StoreService storeService;

 	//처음 상세페이지로 접속, vo 객체로 받기
	@PostMapping("/store")
	public String addStore(@ModelAttribute StoreVo storeVo, Model model) throws SQLException {
		logger.info("getStoreId");
		
		//여기서 스토어ID가 있으면(0이 아니면) -> insert 안하고, 스토어ID가 없으면 insert 해야함
		logger.debug("storeId : "+storeVo.getStore_Id());
		
		//없으면 insert
		//거짓 insert가 쓸때없이 많이 일어났을 때 ALTER TABLE STORE AUTO_INCREMENT=변경할값;으로 seq 초기화 
		if(storeVo.getStore_Id()==0) {
			logger.debug("스토어 ID가 없습니다");
			
			//category 분류 후 분류된 카테고리로 set storeVo
			storeVo.setCategory(changeCategory(storeVo.getCategory(),storeVo.getName()));
			logger.debug(storeVo.getCategory());
			logger.debug(storeVo.toString());
			storeVo = storeService.addStore(storeVo);
			logger.debug(storeVo.toString());
		}
		
 		return "redirect:store/"+storeVo.getStore_Id();
	}

 	//리다이렉트로 상세페이지로
	@GetMapping("/store/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId,  Model model) throws SQLException {
		logger.debug("storeId : "+storeId+" - getStore");

		StoreVo storeVo = storeService.getStore(storeId);
		logger.debug(storeVo.toString());

		//이때 storeVo에 store_id 값이 없으면 해당페이지 없다는 view 리턴
		if(storeVo.getStore_Id()==0) {
			//return "에러페이지";
		}
		
		model.addAttribute("storeVo", storeVo);
		
 		return "store_detail";
	}
	
	@PutMapping("/store/{storeId}")
	public ResponseEntity updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo) throws SQLException{
		
		//회원만 가능하게 로그인 기능 구현되면 붙여넣을 것
		
		storeVo.setStore_Id(storeId);
		logger.debug("storeId : "+storeId+" - updateStore");
		logger.debug(storeVo.toString());
		
		int isSuccess = storeService.editStore(storeVo);
		ResponseEntity entity=null;
		
		if(isSuccess>0) {
			//성공
			entity=ResponseEntity
					.status(HttpStatus.OK).body(null);
		}else {
			//실패
			entity=ResponseEntity
					.status(HttpStatus.BAD_REQUEST).body(null);
		}
		
		return entity;
	}
	
	//리뷰 입력
	@PostMapping("/review")
	public String addReview() {
		
		return ""; 
	}
	
	//리뷰 수정
	@PutMapping("/review")
	public void editReview() {
		
		//json으로 수정 내용 전송
		
		//받는 쪽에서 refresh하게
	}
	
	//리뷰 삭제
	@DeleteMapping("/review")
	public void deleteReview() {
		
		//json으로 삭제 
		
		//받는 쪽에서 refresh하게 
	}
	
	public String changeCategory(String category,String name){
		//포함되면 해당 카테고리로 변환
		//프랜차이즈(카테고리), 애견(카테고리), 스터디(이름), 고양이(카테고리), 만화+놀숲(이름), 보드(카테고리), 룸카페(이름)
		String[] categoryCheck = {"커피전문점","애견","고양이","보드"};
		String[] nameCheck = {"스터디","만화","놀숲","룸카페"};
		
		for(int i=0; i<categoryCheck.length; i++) {
			if(category.contains(categoryCheck[i])) {
				if(categoryCheck[i].equals("커피전문점")) {
					category = "프랜차이즈";
				}else {
					category = categoryCheck[i];
				}
			}
		}
		
		for(int i=0; i<nameCheck.length; i++) {
			if(name.contains(nameCheck[i])) {
				if(nameCheck[i].equals("놀숲")) {
					category = "만화";
				}else {
					category = nameCheck[i];
				}
			}
		}
		
		return category;
	}
 }