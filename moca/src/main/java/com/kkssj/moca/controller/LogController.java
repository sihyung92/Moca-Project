package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;

import com.kkssj.moca.service.LogService;

@Controller
public class LogController {

	@Inject
	LogService logService;
	
	//Ajax�� ���ؼ� ����� �ִ°�� LogController ���� �Ƿ���? $ ���� ��Ʈ�ѷ����� �α� �������� �� ��Ʈ�ѷ� ���ο��� LogService Inject �ؼ� ���� �ɵ�
}
