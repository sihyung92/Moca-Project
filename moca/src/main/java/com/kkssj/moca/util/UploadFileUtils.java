package com.kkssj.moca.util;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.util.ByteArrayBuilder;
import com.kkssj.moca.model.entity.ImageVo;

public class UploadFileUtils {
    private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);

    // String uploadPath 파일의 저장경로
    // String originalName 원본 파일 이름
    // byte[] fileData 파일 데이터
    public static ImageVo uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {  	
    	
    	//S3 서버 관련 설정   // 3/28
    	S3Util s3 = new S3Util();
        String bucketName = "moca-pictures";
            
        //범용고유식별자(36개의 문자로된 중복 가능성이 거의 없는)    
        UUID uuid = UUID.randomUUID();
        
        String path ="";
        String uu_id = uuid.toString();
        String savedName = uu_id.toString() + "_" + originalName;
        String uploadedFileName =savedName.replace(File.separatorChar, '/');        
        s3.fileUpload(bucketName, uploadedFileName, fileData);  //  추가 
//      s3.fileUpload(bucketName, uploadPath+savedPath+uploadedFileName, fileData);  //  추가 
        
        ///////////////////
        //thumnail
        savedName = uu_id.toString() + "_thumbnail_" + originalName;
        uploadedFileName =savedName.replace(File.separatorChar, '/');   
        s3.fileUpload(bucketName, uploadedFileName, makeThumbnail(originalName, fileData));  //  추가 
        
        
//        if (MediaUtils.getMediaType(formatName) != null) {
//        	uploadedFileName = makeThumbnail(uploadPath, savedPath, savedName);
//        } else {
//        	uploadedFileName = makeIcon(uploadPath, savedPath, savedName);
//        }

        return new ImageVo(uu_id, path , originalName);
    }
    
    //섬네일 생성
    private static byte[] makeThumbnail(String fileName, byte[] fileData) throws Exception{
    	//저장된 원본파일로 부터 BufferedImage 객체를 생성
    	BufferedImage sourceImage = bytesToBufferedImage(fileData);
    	logger.debug("sourceImage - " +sourceImage.getWidth()+","+ sourceImage.getHeight());
    	
    	//최종 이미지의 크기
    	int destinationWidth = 200;
    	int destinationHeight = 200;
    	
    	//원본 이미지의 크기
    	int sourceWidth = sourceImage.getWidth();
    	int sourceHeight = sourceImage.getHeight();
    	
    	//원본 너비를 기준으로 섬네일의 비율로 높이 계간
    	int nWidth = sourceWidth;
    	int nHeight = (sourceWidth * destinationHeight) / destinationWidth;
    	
    	//계산된 높이가 원본 보다 높다면 crop이 안됨으로 원본의 높이 기준으로 너비 계산
    	if(nHeight > sourceHeight) {
    		nWidth = (sourceHeight * destinationWidth) / destinationHeight;
    		nHeight = sourceHeight;
    	}
    	
    	//계산된 크기로 원본 이미지를 가운데서 crop
    	BufferedImage cropedImage = Scalr.crop(sourceImage, (sourceWidth-nHeight)/2, (sourceHeight - nHeight)/2, nWidth, nHeight); 
    	
    	//crop된 이미지로 썸네일을 생성
    	BufferedImage destinationIamge = Scalr.resize(cropedImage, destinationWidth, destinationHeight);
    	logger.debug("destinationIamge - " +destinationIamge.getWidth()+","+ destinationIamge.getHeight());
    	return bufferedImageToBytes(destinationIamge, fileName);
    	
    }
    
    private static byte[] bufferedImageToBytes(BufferedImage image, String fileName) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()){
        	
        	//파일 이름의 확장자 주입
            ImageIO.write(image, fileName.substring(fileName.lastIndexOf(".")+1), out);
            return out.toByteArray();
        }catch (Exception e) {
        	throw new RuntimeException(e); 
		}
    }
   
    
    private static BufferedImage bytesToBufferedImage(byte[] imageData) {
    	ByteArrayInputStream bais = new ByteArrayInputStream(imageData);
    	try {
    		return ImageIO.read(bais);
    	}catch (Exception e) {
			throw new RuntimeException(e); 
		}
    	
    }

    

    
    //이미지 파일이 아닌경우에 아이콘 생성
    private static String makeIcon(String uploadPath, String path, String fileName) throws Exception {

        String iconName = uploadPath + path + File.separator + fileName;

        return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }
    
 // 경로 설정처리 
    private static String calcPath(String uploadPath) {


        return "";
       
    }

    //폴더 생성 처리
    private static void makeDir(String uploadPath, String... paths) {
        
        //중복 파일 존재하면 아무처리 하지 않음
        if (new File(paths[paths.length - 1]).exists()) {
            return;
        }

        for (String path : paths) {
            
            File dirPath = new File(uploadPath + path);
            
            if (!dirPath.exists()) {
                dirPath.mkdir();
            }
        }
    }
}