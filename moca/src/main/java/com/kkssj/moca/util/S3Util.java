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

    // ��Ŷ ����Ʈ�� �������� �޼����̴�.
    public List<Bucket> getBucketList() {
        return conn.listBuckets();
    }
    // ��Ŷ�� �����ϴ� �޼����̴�.
    public Bucket createBucket(String bucketName) {
        return conn.createBucket(bucketName);
    }

    // ���� ���� (������ ���ϸ� �ڿ� "/"�� �ٿ����Ѵ�.)
    public void createFolder(String bucketName, String folderName) {
        conn.putObject(bucketName, folderName + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
    }
    // ���� ���ε�
    public void fileUpload(String bucketName, String fileName, byte[] fileData) throws FileNotFoundException {

        String filePath = (fileName).replace(File.separatorChar, '/'); // ���� �����ڸ� `/`�� ����(\->/) �̰� ������ / ��� �Ѿ���鼭 \�� �ٲ�� �Ű���.
        ObjectMetadata metaData = new ObjectMetadata();
        metaData.setContentLength(fileData.length);   //��Ÿ������ ���� -->������ 128kB���� ���ε� ���������� ����ũ�⸸ŭ ���۸� �������״�.
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //���� ����

        conn.putObject(bucketName, filePath, byteArrayInputStream, metaData);

    }

    // ���� ����
    public void fileDelete(String fileName) {

        System.out.println("fileName : " + fileName);
        String imgName = (fileName).replace(File.separatorChar, '/');
        conn.deleteObject(this.getBucketName(), imgName);
        System.out.println("��������");
    }

    // ���� URL
    public String getFileURL(String bucketName, String fileName) {
        System.out.println("�Ѿ���� ���ϸ� : "+fileName);
        String imgName = (fileName).replace(File.separatorChar, '/');
        return conn.generatePresignedUrl(new GeneratePresignedUrlRequest(bucketName, imgName)).toString();
    }

    // src���� �о����
    public S3ObjectInputStream getSrcFile(String bucketName, String fileName) throws IOException{
        System.out.println("�Ѿ���� ���ϸ� : "+fileName);
        fileName = (fileName).replace(File.separatorChar, '/');
        S3Object s3object = conn.getObject(new GetObjectRequest(bucketName, fileName)); //�ش� ���� s3��ü�� ���
        S3ObjectInputStream objectInputStream = s3object.getObjectContent();    //s3��ü�� ��Ʈ������ ��ȯ

        return objectInputStream;
    }



}