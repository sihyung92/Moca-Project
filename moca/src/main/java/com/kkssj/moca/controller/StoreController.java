package com.kkssj.moca.controller;


 import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(StoreController.class);

	@Inject
	StoreService storeService;
	
	
 	//ó�� ���������� ����
//	@PostMapping("/store")


 	//�����̷�Ʈ�� ����������
	@GetMapping("/store/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model) {
		logger.info("Welcome storeDetail!");
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		
		model.addAttribute("reviewVoList", storeService.getReviewList(accountId, storeId));

 		return "store_detail";
	}
	
	//���ƿ�Ⱦ�� �߰�
	@PostMapping("/likeHates/{review_id}")
	public ResponseEntity addLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		logger.debug("isLike :" + isLike);
		
		
		if(storeService.addLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
	}
	
	//���ƿ�Ⱦ�� ����
	//������ server.xml�� Connector �±׿� parseBodyMethods
	//<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443" parseBodyMethods="POST,PUT,DELETE"/> �߰�
	@PutMapping("/likeHates/{review_id}")
	public ResponseEntity editLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		logger.debug("isLike :" + isLike);
		
		if(storeService.editLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	//���ƿ� �Ⱦ�� ����
	@DeleteMapping("/likeHates/{review_id}")
	public ResponseEntity  deleteLikeHate(@PathVariable("review_id") int review_id) {		
		//���� ������ �޾ƿ���
		int accountId =1;	
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		
		if(storeService.deleteLikeHate(review_id, accountId) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
		


	//���� �Է�
	@PostMapping("/review")
	public String addReview() {
		
		return ""; 
	}
	
	//���� ����
	@PutMapping("/review")
	public void editReview() {
		
		//json���� ���� ���� ����
		
		//�޴� �ʿ��� refresh�ϰ�
	}
	
	//���� ����
	@DeleteMapping("/review")
	public void deleteReview() {
		
		//json���� ���� 
		
		//�޴� �ʿ��� refresh�ϰ� 
	}
	
	
	
	
 }