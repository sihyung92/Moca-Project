package com.kkssj.moca.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.util.IOUtils;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.util.MediaUtils;
import com.kkssj.moca.util.S3Util;
import com.kkssj.moca.util.UploadFileUtils;

@Controller
public class UploadController {
    
    S3Util s3 = new S3Util();
    String bucketName = "moca";
    
    @Resource(name="uploadPath")
    private String uploadPath;
    
    private static final Logger logger = LoggerFactory.getLogger(UploadController.class);
    @RequestMapping(value ="/uploadAjax", method =RequestMethod.GET)
    public String uploadAjax(){
        
    	return "uploadAjax";
    }
    //서버에 파일 업로드
    @ResponseBody
    @RequestMapping(value ="/uploadAjax", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> uploadAjax(@RequestParam("file") MultipartFile[] files, HttpSession session) throws Exception{
    	AccountVo vo = (AccountVo)session.getAttribute("login");
        vo = new AccountVo();
        vo.setNickname("songhae");
        String userid = vo.getNickname();
    	
    	MultipartFile file;
    	for (int i = 0; i < files.length; i++) {
    		file = files[i];
    		logger.info("originalName: " + file.getOriginalFilename());
            logger.info("size : " +  file.getSize());
            logger.info("contentType : " + file.getContentType());
            logger.info("uploadPath : "+uploadPath);
            
            UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes(), userid);
		}
        
        
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    
    //파일 표시
    @ResponseBody
    @RequestMapping("/displayFile")
    public ResponseEntity<byte[]> displayFile(String fileName)throws Exception{

        InputStream in = null;
        ResponseEntity<byte[]> entity = null;
        HttpURLConnection uCon = null;
        System.out.println("FILE NAME: " + fileName);

        //System.out.println("FileName : "+fileName);

        try{
            String formatName = fileName.substring(fileName.lastIndexOf(".")+1);

            MediaType mType = MediaUtils.getMediaType(formatName);
            HttpHeaders headers = new HttpHeaders();

            String inputDirectory = "faint1122";
            URL url;

            try {
                url = new URL(s3.getFileURL(bucketName, inputDirectory+fileName));
                System.out.println(url);
                uCon = (HttpURLConnection) url.openConnection();
                in = uCon.getInputStream(); // 이미지를 불러옴
            } catch (Exception e) {
                url = new URL(s3.getFileURL(bucketName, "default.jpg"));
                uCon = (HttpURLConnection) url.openConnection();
                in = uCon.getInputStream();
            }

                                                            // 여기
            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),
            headers,
            HttpStatus.CREATED);
        }catch (FileNotFoundException effe){
            System.out.println("File Not found Exception");
            String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
            MediaType mType = MediaUtils.getMediaType(formatName);
            HttpHeaders headers = new HttpHeaders();
            in = new FileInputStream(uploadPath+"/noimage.jpeg");

                headers.setContentType(mType);

            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),
                    headers,
                    HttpStatus.CREATED);
        }catch (Exception e){
            e.printStackTrace();
            entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
        }finally {
            in.close();
        }
        return entity;
    }

    
    //파일 삭제
    @ResponseBody
    @RequestMapping(value="/deleteFile", method=RequestMethod.POST)
    public ResponseEntity<String> deleteFile(String fileName){
        logger.info("delete file: "+fileName);
        
        String inputDirectory = "faint1122";
        s3.fileDelete(inputDirectory+fileName);
                
        return new ResponseEntity<String>("deleted", HttpStatus.OK);
    }
    
    
    
    
    ////////////////////////////////////
//    
//    @PostMapping("/uploadImage")
//    public @ResponseBody String initUpload2(@RequestParam("files") MultipartFile[] files,
//    		
//    		HttpServletRequest request) throws Exception{
//    	logger.debug(files[0]+"");
//    	
//    	try {
//    		//AWSCredentials credentials = new BasicAWSCredentials("xxx", "xxx");
//    		
//    	}catch (Exception e) {
//			// TODO: handle exception
//		}
//    	
//    	
//    	return "";
//    }
}