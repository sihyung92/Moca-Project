package com.kkssj.moca.controller;


 import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Inject
	StoreService storeService;
	
	
 	//ó�� ���������� ����
//	@PostMapping("/store")


 	//�����̷�Ʈ�� ����������
	@GetMapping("/stores/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model) {
		logger.info("Welcome storeDetail!");
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		
		model.addAttribute("reviewVoList", storeService.getReviewList(accountId, storeId));

 		return "store_detail";
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
	
	//���ƿ�Ⱦ�� �߰�
	@PostMapping("/likeHate")
	public void addLikeHate() {
		
		
	}
	
	//���ƿ�Ⱦ�� ����
	@PutMapping("/likeHate")
	public void editLikeHate() {
		
	}
	
	//���ƿ� �Ⱦ�� ����
	@DeleteMapping("/likeHate")
	public void deleteLikeHate() {
		
	}
 }