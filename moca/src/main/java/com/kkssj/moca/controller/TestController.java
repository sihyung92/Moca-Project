package com.kkssj.moca.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class TestController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class); 
	
	// ���ε�� ������ ����� ��ġ �Դϴ�. 
	private final String PATH = "C:/java/workspace4/moca/src/main/webapp/resources/upload"; 
	
	// json �����ͷ� ������ ������ ���� 
	@Autowired 
	MappingJackson2JsonView jsonView;
	
	@RequestMapping(value="/pictures", method = RequestMethod.POST, produces = "text/plain")
	public ModelAndView upload(MultipartHttpServletRequest req) throws Exception{
		//����� ��ü ����, jsonView ���
		ModelAndView mav = new ModelAndView();
		mav.setView(jsonView);
		JSONObject json = new JSONObject();
		
		Iterator itr = req.getFileNames();
		
		if(itr.hasNext()) {
			List<MultipartFile> mpf = req.getFiles((String) itr.next());
			
			//�ӽ� ������ ����
			for(int i = 0 ; i < mpf.size(); i++) {
				File file = new File(PATH + mpf.get(i).getOriginalFilename());
				logger.debug(file.getAbsolutePath());
				mpf.get(i).transferTo(file);
			}
			
			//���ε� �� ������ �ִ� ��� ����
			json.put("code", "true");
			
		}else {
			
			//������ ���� ��� ����
			json.put("code", "false");
		}
		mav.addObject("result", json);
		return mav;
	}

	
//	@PostMapping("/pictures")
//	@ResponseBody
//	public Object uploadFile(MultipartHttpServletRequest request) {
//		Iterator<String> itr = request.getFileNames();
//		if(itr.hasNext()) {
//			MultipartFile mpf = request.getFile(itr.next());
//			System.out.println(mpf.getOriginalFilename() + " uploaded!");
//			try {
//				System.out.println("file length : "+mpf.getBytes().length);
//				System.out.println("file name : "+mpf.getOriginalFilename());
//			} catch (IOException e) {
//				System.out.println(e.getMessage());
//				e.printStackTrace();
//			}
//			return true;
//			
//		}else {
//			return false;			
//		}
//		
//	}

}
