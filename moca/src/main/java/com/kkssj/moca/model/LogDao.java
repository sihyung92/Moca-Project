package com.kkssj.moca.model;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.LogVo;

public interface LogDao {
	int write(LogVo logVo) throws SQLException;
	int writeStoreIdNone(LogVo logVo) throws SQLException;
	int writeKeyWordNone(LogVo logVo) throws SQLException;
	int writeStoreIdKeyWordNone(LogVo logVo) throws SQLException;
	int insertKeywordLog(LogVo logVo);
}
