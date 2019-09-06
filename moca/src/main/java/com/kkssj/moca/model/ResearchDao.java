package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

import com.kkssj.moca.model.entity.ResearchVo;

public interface ResearchDao {
	int insertResearch(ResearchVo research) throws SQLException;
	List selectUsersByNumAndVal(Object[] obj) throws SQLException;
}
