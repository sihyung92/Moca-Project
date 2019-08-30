package com.kkssj.moca.controller;

import java.sql.SQLException;

import javax.inject.Inject;

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

 	//ó�� ���������� ����, vo ��ü�� �ޱ�
	@PostMapping("/stores")
	public String addStore(@ModelAttribute StoreVo storeVo, Model model) throws SQLException {
		logger.info("getStoreId");

		// ���⼭ �����ID�� ������(0�� �ƴϸ�) -> insert ���ϰ�, �����ID�� ������ insert �ؾ���
		logger.debug("storeId : " + storeVo.getStore_Id());

		// ������ insert
		// ���� insert�� �������� ���� �Ͼ�� �� ALTER TABLE STORE AUTO_INCREMENT=�����Ұ�;���� seq �ʱ�ȭ
		if (storeVo.getStore_Id() == 0) {
			logger.debug("����� ID�� �����ϴ�");

			// category �з� �� �з��� ī�װ��� set storeVo
			storeVo.setCategory(changeCategory(storeVo.getCategory(), storeVo.getName()));
			logger.debug(storeVo.getCategory());
			logger.debug(storeVo.toString());
			storeVo = storeService.addStore(storeVo);
			logger.debug(storeVo.toString());
		}
		
 		return "redirect:stores/"+storeVo.getStore_Id();
	}


	// �����̷�Ʈ�� ����������
	@GetMapping("/stores/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model) throws SQLException {
		logger.debug("storeId : " + storeId + " - getStore");

		StoreVo storeVo = storeService.getStore(storeId);
		logger.debug(storeVo.toString());

		// �̶� storeVo�� store_id ���� ������ �ش������� ���ٴ� view ����
		if (storeVo.getStore_Id() == 0) {
			// return "����������";
		}

		// ���� ������ �޾ƿ���
		int accountId = 1;

		model.addAttribute("reviewVoList", storeService.getReviewList(accountId, storeId));

		model.addAttribute("storeVo", storeVo);

		return "store_detail";
	}
	
	@PutMapping("/stores/{storeId}")
	public ResponseEntity updateStore(@PathVariable("storeId") int storeId, @RequestBody StoreVo storeVo) throws SQLException{
		
		//ȸ���� �����ϰ� �α��� ��� �����Ǹ� �ٿ����� ��

		storeVo.setStore_Id(storeId);
		logger.debug("storeId : " + storeId + " - updateStore");
		logger.debug(storeVo.toString());

		// ������ ����� Id�� �ʿ�
		int accountId = 1; // session���� ������

		// edit store���� store update, storeinfohistory insert
		int isSuccess = storeService.editStore(accountId, storeVo);

		if (isSuccess > 0) {
			// ����
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			// ����
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

	}
	
	////////////////////////
	//review 
	
	//���� �Է�
	@PostMapping("/reviews")
	@ResponseBody
	public ResponseEntity addReview(ReviewVo reviewVo) {
		
		//����� ���� ���(���ǿ��� �Դٰ� ����)
		reviewVo.setAccount_Id(1);
		
		reviewVo = storeService.addReview(reviewVo);
		
		
		if(reviewVo != null) {
			logger.debug(reviewVo.toString());
			return new ResponseEntity<>(reviewVo,HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	//���� ����
	@PutMapping("/reviews/{review_id}")
	@ResponseBody
	public ResponseEntity editReview(@PathVariable("review_id") int review_id, ReviewVo reviewVo) {
		logger.debug(reviewVo.toString());
		
		//������ �۵��ߴٰ� ����
		reviewVo.setAccount_Id(1);
		
		//json���� ���� ���� ����
		int isEdite = storeService.editReview(reviewVo);
		
		//�޴� �ʿ��� refresh�ϰ�
		if(isEdite ==1) {
			return new ResponseEntity<>(reviewVo, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	// ���� ����
	@DeleteMapping("/reviews/{review_id}")
	public ResponseEntity deleteReview(@PathVariable("review_id") int review_id) throws SQLException {
		// ����� Ȯ��
		int accountId = 1;
		
		int isDelete = storeService.deleteReview(review_id);
		
		if(isDelete==1) {			
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	
	////////////////////////
	//likeHate

	// ���ƿ�Ⱦ�� �߰�
	@PostMapping("/likeHates/{review_id}")
	public ResponseEntity addLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		if(storeService.addLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

	}

	// ���ƿ�Ⱦ�� ����
	// ������ server.xml�� Connector �±׿� parseBodyMethods
	// <Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1"
	// redirectPort="8443" parseBodyMethods="POST,PUT,DELETE"/> �߰�
	@PutMapping("/likeHates/{review_id}")
	public ResponseEntity editLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		
		//���� ������ �޾ƿ���
		int accountId =1;
		
		if(storeService.editLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}

	// ���ƿ� �Ⱦ�� ����
	@DeleteMapping("/likeHates/{review_id}")
	public ResponseEntity  deleteLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {		
		//���� ������ �޾ƿ���
		int accountId =1;	

		if(storeService.deleteLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}


	
	//���� ���ƿ�� ����ȭ(���߿� put ������� ����)
	@GetMapping("/reviewsLikeHate")
	public String syncReviewLikeHate() {
		
		int result = storeService.syncReviewLikeHate();
		
		//�ϴ� ������ ����� �ϴϱ� 
		return "redirect:../stores/"+1;
	}



	public String changeCategory(String category, String name) {
		// ���ԵǸ� �ش� ī�װ��� ��ȯ
		// ����������(ī�װ�), �ְ�(ī�װ�), ���͵�(�̸�), �����(ī�װ�), ��ȭ+�(�̸�), ����(ī�װ�), ��ī��(�̸�)
		String[] categoryCheck = { "Ŀ��������", "�ְ�", "�����", "����" };
		String[] nameCheck = { "���͵�", "��ȭ", "�", "��ī��" };

		for (int i = 0; i < categoryCheck.length; i++) {
			if (category.contains(categoryCheck[i])) {
				if (categoryCheck[i].equals("Ŀ��������")) {
					category = "����������";
				} else {
					category = categoryCheck[i];
				}
			}
		}

		for (int i = 0; i < nameCheck.length; i++) {
			if (name.contains(nameCheck[i])) {
				if (nameCheck[i].equals("�")) {
					category = "��ȭ";
				} else {
					category = nameCheck[i];
				}
			}
		}

		return category;
	}
}