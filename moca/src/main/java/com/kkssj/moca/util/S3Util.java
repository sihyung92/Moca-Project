package com.kkssj.moca.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;

public class S3Util implements VariableManagement {
    
    //bucketName
    private String bucketName = "team-moca"; 
    private AmazonS3 conn;


    public S3Util() {
    	AWSCredentials credentail = new BasicAWSCredentials(accessKey,secretKey);
    	ClientConfiguration clientConfig = new ClientConfiguration();
    	clientConfig.setProtocol(Protocol.HTTP);
        this.conn = new AmazonS3Client(credentail, clientConfig);
        conn.setEndpoint("s3.ap-northeast-2.amazonaws.com");
    }
    //bucketName getter    
    public String getBucketName() {
        return bucketName;
    }

    // 버킷 리스트를 가져오는 메서드이다.
    public List<Bucket> getBucketList() {
        return conn.listBuckets();
    }
    // 버킷을 생성하는 메서드이다.
    public Bucket createBucket(String bucketName) {
        return conn.createBucket(bucketName);
    }

    // 폴더 생성 (폴더는 파일명 뒤에 "/"를 붙여야한다.)
    public void createFolder(String bucketName, String folderName) {
        conn.putObject(bucketName, folderName + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
    }
    // 파일 업로드
    public void fileUpload(String bucketName, String fileName, byte[] fileData) throws FileNotFoundException {

        String filePath = (fileName).replace(File.separatorChar, '/'); // 파일 구별자를 `/`로 설정(\->/) 이게 기존에 / 였어도 넘어오면서 \로 바뀌는 거같다.
        ObjectMetadata metaData = new ObjectMetadata();
        metaData.setContentLength(fileData.length);   //메타데이터 설정 -->원래는 128kB까지 업로드 가능했으나 파일크기만큼 버퍼를 설정시켰다.
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //파일 넣음

        conn.putObject(bucketName, filePath, byteArrayInputStream, metaData);

    }

    // 파일 삭제
    public void fileDelete(String fileName) {

        System.out.println("fileName : " + fileName);
        String imgName = (fileName).replace(File.separatorChar, '/');
        conn.deleteObject(this.getBucketName(), imgName);
        System.out.println("삭제성공");
    }
    public void thumbnailFileDelete(String fileName) {
    	String thumbnailFile = fileName.split("_")[0]+"_thumbnail_"+fileName.split("_")[1];
    	fileDelete(thumbnailFile);
    }

    // 파일 URL
    public String getFileURL(String bucketName, String fileName) {
        System.out.println("넘어오는 파일명 : "+fileName);
        String imgName = (fileName).replace(File.separatorChar, '/');
        return conn.generatePresignedUrl(new GeneratePresignedUrlRequest(bucketName, imgName)).toString();
    }

    // src파일 읽어오기
    public S3ObjectInputStream getSrcFile(String bucketName, String fileName) throws IOException{
        System.out.println("넘어오는 파일명 : "+fileName);
        fileName = (fileName).replace(File.separatorChar, '/');
        S3Object s3object = conn.getObject(new GetObjectRequest(bucketName, fileName)); //해당 파일 s3객체에 담기
        S3ObjectInputStream objectInputStream = s3object.getObjectContent();    //s3객체를 스트림으로 변환

        return objectInputStream;
    }



}