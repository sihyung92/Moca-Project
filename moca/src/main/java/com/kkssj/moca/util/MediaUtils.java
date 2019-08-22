package com.kkssj.moca.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.MediaType;

public class MediaUtils {
	// Map<String, MediaType> Ÿ���� mediaMap��ü ����
	private static Map<String, MediaType> mediaMap;
	
	// �ʱ�ȭ ��Ͽ��� mediaMap �ʱ�ȭ
	static {
		mediaMap = new HashMap<>();
		mediaMap.put("JPG", MediaType.IMAGE_JPEG);
		mediaMap.put("GIF", MediaType.IMAGE_GIF);
		mediaMap.put("PNG", MediaType.IMAGE_PNG);
	}
	
	// getMediaType(type)���� ȣ���
	// mediaMap�� �̹��� Ÿ���� Ű("JPG", "GIF", "PNG")�� �����Ѵٸ�(Ȯ���ڰ� �̹��� Ÿ���̶��) MediaType Ÿ�� ��� ����
	// �������� �ʴ´ٸ�(Ȯ���ڰ� �� �� Ÿ���̶��) null ����
	public static MediaType getMediaType(String type) {
		return mediaMap.get(type.toUpperCase());
	}
}