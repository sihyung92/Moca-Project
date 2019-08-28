package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.StoreVo;

public interface MainService {

	List<StoreVo> getCafesNearBy(Map<String, String> variables);
}
