package com.kkssj.moca.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UploadFileUtils {
    private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);

    // String uploadPath 파일의 저장경로
    // String originalName 원본 팡리 이름
    // byte[] fileData 파일 데이터
    public static String uploadFile(String uploadPath, String originalName, byte[] fileData, String userid) throws Exception {
          //S3 서버 관련 설정   // 3/28
        
           S3Util s3 = new S3Util();
            String bucketName = "faint1122";
            
            
        UUID uid = UUID.randomUUID();

        String savedName = uid.toString() + "_" + originalName;

        String savedPath = calcPath(uploadPath);
        
         String imagepath = "profile/"+ uploadPath;  //이미패스 

//      File target = new File(uploadPath + savedPath, savedName);
//
//      FileCopyUtils.copy(fileData, target);
        
        

        String formatName = originalName.substring(originalName.lastIndexOf(".") + 1);
        
         String uploadedFileName =(savedPath+savedName).replace(File.separatorChar, '/');

    //  String uploadedFileName = null;

//      if (MediaUtils.getMediaType(formatName) != null) {
//          uploadedFileName = makeThumbnail(uploadPath, savedPath, savedName);
//      } else {
//          uploadedFileName = makeIcon(uploadPath, savedPath, savedName);
//      }
        
           s3.fileUpload(bucketName, uploadPath+uploadedFileName, fileData);  //  추가 

        return uploadedFileName;
    }
    
    //이미지 파일이 아닌경우에 아이콘 생성
    private static String makeIcon(String uploadPath, String path, String fileName) throws Exception {

        String iconName = uploadPath + path + File.separator + fileName;

        return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }

    // 경로 설정처리 
    private static String calcPath(String uploadPath) {
        Calendar cal = Calendar.getInstance();

        // 년도 설정
        String yearPath = File.separator + cal.get(Calendar.YEAR);

        // 월 설정
        String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);

        // 날짜 ㄱ설정
        String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
        
        S3Util s3 = new S3Util();
        String bucketName = "faint1122";


        // 폴더 생성 호출
//      makeDir(uploadPath, yearPath, monthPath, datePath);
//
//      logger.info(datePath);

        return datePath;
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

    //썸네일 생성
    private static String makeThumbnail(String uploadPath, String path, String fileName) throws Exception {

        BufferedImage sourceImg = ImageIO.read(new File(uploadPath + path, fileName));
    
        BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, 600);
        String thumbnailName = uploadPath + path + File.separator + "s_" + fileName;

        File newFile = new File(thumbnailName);
        String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);

        ImageIO.write(destImg, formatName.toUpperCase(), newFile);
        return thumbnailName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }
}