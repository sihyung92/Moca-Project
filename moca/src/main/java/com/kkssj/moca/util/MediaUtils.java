package com.kkssj.moca.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.MediaType;

public class MediaUtils {
	// Map<String, MediaType> 타입의 mediaMap객체 생성
	private static Map<String, MediaType> mediaMap;
	
	// 초기화 블록에서 mediaMap 초기화
	static {
		mediaMap = new HashMap<>();
		mediaMap.put("JPG", MediaType.IMAGE_JPEG);
		mediaMap.put("GIF", MediaType.IMAGE_GIF);
		mediaMap.put("PNG", MediaType.IMAGE_PNG);
	}
	
	// getMediaType(type)으로 호출시
	// mediaMap의 이미지 타입의 키("JPG", "GIF", "PNG")가 존재한다면(확장자가 이미지 타입이라면) MediaType 타입 상수 리턴
	// 존재하지 않는다면(확장자가 그 외 타입이라면) null 리턴
	public static MediaType getMediaType(String type) {
		return mediaMap.get(type.toUpperCase());
	}
}