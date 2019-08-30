package com.kkssj.moca.service;

import javax.servlet.http.HttpServletRequest;

public interface LogService {
	
	boolean writeStoreIdKeyWordNone(HttpServletRequest req, String classification, int account_id);
}
