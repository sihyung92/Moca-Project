package com.kkssj.moca.model;

import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreDao {

	List<StoreVo> selectByTag(Map<String, String> variables);

}
