package project.util;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
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
        if (urls == null || urls.isEmpty()) return;

        for (String url : urls) {
            deleteByUrl(url);
        }
    }

    /**
     * URL을 받아서 안전하게 S3 파일을 삭제합니다.
     *
     * 보안 정책:
     * 1. 우리 버킷(secondarybooksimages)의 URL만 삭제 허용
     * 2. 올바른 region(ap-northeast-2) 확인
     * 3. key prefix는 images/로 시작해야 함 (업로드 규칙과 일치)
     *
     * @param url 삭제할 S3 파일의 전체 URL
     * @throws IllegalArgumentException URL 파싱 실패 또는 보안 정책 위반 시
     */
    public void deleteByUrl(String url) {
        // null/blank 체크
        if (url == null || url.trim().isEmpty()) {
            log.debug("Empty URL provided to deleteByUrl, skipping");
            return;
        }

        try {
            // URI로 안전하게 파싱 (query string 자동 분리)
            URI uri = new URI(url.trim());
            String host = uri.getHost();
            String path = uri.getPath();

            // 보안 검증 1: host가 우리 버킷인지 확인
            String expectedHost = String.format("%s.s3.%s.amazonaws.com", bucketName, region);
            if (host == null || !host.equals(expectedHost)) {
                log.warn("Security violation: Attempted to delete file from unauthorized bucket. " +
                        "URL={}, expected_host={}, actual_host={}", url, expectedHost, host);
                throw new IllegalArgumentException(
                    "Only files from bucket '" + bucketName + "' in region '" + region + "' can be deleted"
                );
            }

            // 보안 검증 2: path에서 key 추출 (leading slash 제거)
            if (path == null || path.isEmpty() || path.equals("/")) {
                log.warn("Invalid path in URL: {}", url);
                throw new IllegalArgumentException("URL does not contain a valid file path");
            }

            String key = path.startsWith("/") ? path.substring(1) : path;

            // 보안 검증 3: key가 허용된 prefix로 시작하는지 확인
            // 현재 업로드는 images/ prefix를 사용하므로, 삭제도 동일한 prefix만 허용
            if (!key.startsWith("images/")) {
                log.warn("Security violation: Attempted to delete file outside allowed prefix. " +
                        "URL={}, key={}, allowed_prefix=images/", url, key);
                throw new IllegalArgumentException(
                    "Only files with prefix 'images/' can be deleted. Provided key: " + key
                );
            }

            // 보안 검증 4: path traversal 시도 차단
            if (key.contains("..")) {
                log.warn("Security violation: Path traversal attempt detected. URL={}, key={}", url, key);
                throw new IllegalArgumentException("Path traversal is not allowed in key: " + key);
            }

            // 모든 검증 통과 - 삭제 실행
            log.info("Deleting S3 file - URL: {}, Key: {}", url, key);
            deleteFile(key);
            log.info("Successfully deleted S3 file - Key: {}", key);

        } catch (URISyntaxException e) {
            log.error("Failed to parse URL: {}. Error: {}", url, e.getMessage());
            throw new IllegalArgumentException("Invalid URL format: " + url, e);
        } catch (Exception e) {
            log.error("Failed to delete S3 file. URL: {}, Error: {}", url, e.getMessage());
            throw new RuntimeException("Failed to delete S3 file: " + url, e);
        }
    }
}