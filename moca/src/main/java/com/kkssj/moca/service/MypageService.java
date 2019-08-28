package com.kkssj.moca.service;

import java.util.List;
import com.kkssj.moca.model.entity.StoreVo;

public interface MypageService{

	List<StoreVo> getFavoriteStoreList(int accountId);

	List<StoreVo> getLikeStoreList(int accountId);

}
