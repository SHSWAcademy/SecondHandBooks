package project.util;


import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final S3Client s3Client;

    @Value("${AWS_S3_BUCKET}")
    private String bucketName;

    @Value("${AWS_S3_REGION}")
    private String region;

    // 단일 파일 업로드
    public String uploadFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) return null;

        // 파일명 및 확장자 처리
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) originalFilename = "file";
        String ext = "";
        int dotIndex = originalFilename.lastIndexOf(".");
        if(dotIndex >= 0) ext = originalFilename.substring(dotIndex + 1);

        // S3에 저장될 키 생성 (UUID 기반)
        String key = "images/" + UUID.randomUUID() + (ext.isEmpty() ? "" : "." + ext);

        // S3 업로드 요청
        PutObjectRequest request = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType(file.getContentType())
                .build();

        s3Client.putObject(request, RequestBody.fromBytes(file.getBytes()));

        // S3 URL 반환
        return String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
    }

    // 다중 파일 업로드
    public List<String> storeFiles(List<MultipartFile> files) throws IOException {
        List<String> urls = new ArrayList<>();
        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                urls.add(uploadFile(file));
            }
        }
        return urls;
    }

    // 단일 파일 삭제
    public void deleteFile(String key) {
        s3Client.deleteObject(builder -> builder.bucket(bucketName).key(key).build());
    }

    // 다중 파일 삭제
    public void deleteFiles(List<String> keys) {
        for (String key : keys) {
            deleteFile(key);
        }
    }

    // 만약 imgUrls 전체 URL이 있다면 key만 추출
    public void deleteFilesByUrls(List<String> urls) {
        for (String url : urls) {
            String key = url.substring(url.indexOf(".com/") + 5); // https://bucket.s3.region.amazonaws.com/key
            deleteFile(key);
        }
    }
}