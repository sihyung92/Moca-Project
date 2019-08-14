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

 	//ó�� ���������� ����, vo ��ü�� �ޱ�
	@PostMapping("/store")
	public String addStore(@ModelAttribute StoreVo storeVo, Model model) throws SQLException {
		logger.info("getStoreId");
		
		//���⼭ �����ID�� ������(0�� �ƴϸ�) -> insert ���ϰ�, �����ID�� ������ insert �ؾ���
		logger.debug("storeId : "+storeVo.getStore_Id());
		
		//������ insert
		//���� insert�� �������� ���� �Ͼ�� �� ALTER TABLE STORE AUTO_INCREMENT=�����Ұ�;���� seq �ʱ�ȭ 
		if(storeVo.getStore_Id()==0) {
			logger.debug("����� ID�� �����ϴ�");
			
			//category �з� �� �з��� ī�װ��� set storeVo
			storeVo.setCategory(changeCategory(storeVo.getCategory(),storeVo.getName()));
			logger.debug(storeVo.getCategory());
			logger.debug(storeVo.toString());
			storeVo = storeService.addStore(storeVo);
			logger.debug(storeVo.toString());
		}
		
 		return "redirect:store/"+storeVo.getStore_Id();
	}

 	//�����̷�Ʈ�� ����������
	@GetMapping("/store/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId,  Model model) throws SQLException {
		logger.debug("storeId : "+storeId+" - getStore");

		StoreVo storeVo = storeService.getStore(storeId);
		logger.debug(storeVo.toString());

		//�̶� storeVo�� store_id ���� ������ �ش������� ���ٴ� view ����
		if(storeVo.getStore_Id()==0) {
			//return "����������";
		}
		
		model.addAttribute("storeVo", storeVo);
		
 		return "store_detail";
	}
	
	@PutMapping("/store/{storeId}")
	public ResponseEntity updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo) throws SQLException{
		
		//ȸ���� �����ϰ� �α��� ��� �����Ǹ� �ٿ����� ��
		
		storeVo.setStore_Id(storeId);
		logger.debug("storeId : "+storeId+" - updateStore");
		logger.debug(storeVo.toString());
		
		int isSuccess = storeService.editStore(storeVo);
		ResponseEntity entity=null;
		
		if(isSuccess>0) {
			//����
			entity=ResponseEntity
					.status(HttpStatus.OK).body(null);
		}else {
			//����
			entity=ResponseEntity
					.status(HttpStatus.BAD_REQUEST).body(null);
		}
		
		return entity;
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
	
	public String changeCategory(String category,String name){
		//���ԵǸ� �ش� ī�װ��� ��ȯ
		//����������(ī�װ�), �ְ�(ī�װ�), ���͵�(�̸�), �����(ī�װ�), ��ȭ+�(�̸�), ����(ī�װ�), ��ī��(�̸�)
		String[] categoryCheck = {"Ŀ��������","�ְ�","�����","����"};
		String[] nameCheck = {"���͵�","��ȭ","�","��ī��"};
		
		for(int i=0; i<categoryCheck.length; i++) {
			if(category.contains(categoryCheck[i])) {
				if(categoryCheck[i].equals("Ŀ��������")) {
					category = "����������";
				}else {
					category = categoryCheck[i];
				}
			}
		}
		
		for(int i=0; i<nameCheck.length; i++) {
			if(name.contains(nameCheck[i])) {
				if(nameCheck[i].equals("�")) {
					category = "��ȭ";
				}else {
					category = nameCheck[i];
				}
			}
		}
		
		return category;
	}
 }