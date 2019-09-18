package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.servlet.http.HttpSession;

public interface ResearchQuestionService {
	void getList(HttpSession sess) throws SQLException;
}
