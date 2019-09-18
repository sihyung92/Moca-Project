package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

import com.kkssj.moca.model.entity.ResearchQuestionVo;

public interface ResearchQuestionDao {
	List<ResearchQuestionVo> list() throws SQLException;
	int add() throws SQLException;
	int update() throws SQLException;
	int delete() throws SQLException;
}
