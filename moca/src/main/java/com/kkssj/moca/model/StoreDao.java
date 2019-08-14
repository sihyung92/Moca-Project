package com.kkssj.moca.model;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreDao {

	List<StoreVo> selectListByTag(Map<String, String> variables);
	StoreVo selectByKakaoId(int kakaoId);
	Properties selectByRegion(String region);

}
