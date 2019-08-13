package com.kkssj.moca.controller;


import java.sql.SQLException;
import java.sql.Time;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
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
import org.springframework.web.bind.annotation.RestController;

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

		//category
		storeVo.setCategory(changeCategory(storeVo.getCategory()));
		
		//vo 객체로 전달된 값으로 데이터가 있는 지 검색한 후 없으면 insert, 있으면 vo리턴
		storeVo = storeService.addStore(storeVo);
		logger.debug(storeVo.toString());
		
 		return "redirect:store/"+storeVo.getStore_Id();
	}

 	//리다이렉트로 상세페이지로
	@GetMapping("/store/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId,  Model model) throws SQLException {
		logger.debug("storeId : "+storeId+" - getStore");
		//logger.debug(storeService.getStore(storeId).toString());
		
		model.addAttribute("storeVo", storeService.getStore(storeId));
		//model.addAttribute("reviewVoList", "");
		
 		return "store_detail";
	}
	
	@PutMapping("/store/{storeId}")
//	@PostMapping("/store/{storeId}")
	@ResponseBody
//	public void updateStore(@PathVariable("storeId") int storeId, @RequestBody String msg) throws SQLException{
	public String updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo) throws SQLException{
//	public String updateStore(@PathVariable("storeId") int storeId, @RequestParam("openTime") String openTime, @RequestParam("endTime") String endTime, @ModelAttribute StoreVo storeVo) throws SQLException{
		
		logger.debug("storeId : "+storeId+" - updateStore");
//		logger.debug(msg);
		logger.debug(storeVo.toString());
//		logger.debug(openTime+"");
//		logger.debug(endTime+"");
		
		//wifi, parkingLot, 
    	return "{\"key\":\"value\"}";
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
	
	public String changeCategory(String category){
		
		return category;
	}
 }