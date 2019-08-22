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

    // String uploadPath ������ ������
    // String originalName ���� ���� �̸�
    // byte[] fileData ���� ������
    public static ImageVo uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {  	
    	
    	//S3 ���� ���� ����   // 3/28
    	S3Util s3 = new S3Util();
        String bucketName = "moca-pictures";
            
        //��������ĺ���(36���� ���ڷε� �ߺ� ���ɼ��� ���� ����)    
        UUID uuid = UUID.randomUUID();
        
        String path ="";
        String uu_id = uuid.toString();
        String savedName = uu_id.toString() + "_" + originalName;
        String uploadedFileName =savedName.replace(File.separatorChar, '/');        
        s3.fileUpload(bucketName, uploadedFileName, fileData);  //  �߰� 
//      s3.fileUpload(bucketName, uploadPath+savedPath+uploadedFileName, fileData);  //  �߰� 
        
        ///////////////////
        //thumnail
        savedName = uu_id.toString() + "_thumbnail_" + originalName;
        uploadedFileName =savedName.replace(File.separatorChar, '/');   
        s3.fileUpload(bucketName, uploadedFileName, makeThumbnail(originalName, fileData));  //  �߰� 
        
        
//        if (MediaUtils.getMediaType(formatName) != null) {
//        	uploadedFileName = makeThumbnail(uploadPath, savedPath, savedName);
//        } else {
//        	uploadedFileName = makeIcon(uploadPath, savedPath, savedName);
//        }

        return new ImageVo(uu_id, path , originalName);
    }
    
    //������ ����
    private static byte[] makeThumbnail(String fileName, byte[] fileData) throws Exception{
    	//����� �������Ϸ� ���� BufferedImage ��ü�� ����
    	BufferedImage sourceImage = bytesToBufferedImage(fileData);
    	logger.debug("sourceImage - " +sourceImage.getWidth()+","+ sourceImage.getHeight());
    	
    	//���� �̹����� ũ��
    	int destinationWidth = 200;
    	int destinationHeight = 200;
    	
    	//���� �̹����� ũ��
    	int sourceWidth = sourceImage.getWidth();
    	int sourceHeight = sourceImage.getHeight();
    	
    	//���� �ʺ� �������� �������� ������ ���� �谣
    	int nWidth = sourceWidth;
    	int nHeight = (sourceWidth * destinationHeight) / destinationWidth;
    	
    	//���� ���̰� ���� ���� ���ٸ� crop�� �ȵ����� ������ ���� �������� �ʺ� ���
    	if(nHeight > sourceHeight) {
    		nWidth = (sourceHeight * destinationWidth) / destinationHeight;
    		nHeight = sourceHeight;
    	}
    	
    	//���� ũ��� ���� �̹����� ����� crop
    	BufferedImage cropedImage = Scalr.crop(sourceImage, (sourceWidth-nHeight)/2, (sourceHeight - nHeight)/2, nWidth, nHeight); 
    	
    	//crop�� �̹����� ������� ����
    	BufferedImage destinationIamge = Scalr.resize(cropedImage, destinationWidth, destinationHeight);
    	logger.debug("destinationIamge - " +destinationIamge.getWidth()+","+ destinationIamge.getHeight());
    	return bufferedImageToBytes(destinationIamge, fileName);
    	
    }
    
    private static byte[] bufferedImageToBytes(BufferedImage image, String fileName) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()){
        	
        	//���� �̸��� Ȯ���� ����
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

    

    
    //�̹��� ������ �ƴѰ�쿡 ������ ����
    private static String makeIcon(String uploadPath, String path, String fileName) throws Exception {

        String iconName = uploadPath + path + File.separator + fileName;

        return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }
    
 // ��� ����ó�� 
    private static String calcPath(String uploadPath) {


        return "";
       
    }

    //���� ���� ó��
    private static void makeDir(String uploadPath, String... paths) {
        
        //�ߺ� ���� �����ϸ� �ƹ�ó�� ���� ����
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