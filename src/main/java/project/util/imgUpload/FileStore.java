package project.util.imgUpload;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Component
public class FileStore {

    @Value("${file.dir}")
    private String fileDir;

    // 파라미터로 받은 파일 이름을 추가
    public String getFullPath(String fileName) {
        return fileDir + "/" + fileName;
    }

    // 멀티파트 파일들을 서버에 저장될 파일 리스트로 리턴
    public List<UploadFile> storeFiles(List<MultipartFile> multipartFiles) throws IOException {
        List<UploadFile> storeFileResult = new ArrayList<>();

        for (MultipartFile multipartFile : multipartFiles) {
            if (!multipartFile.isEmpty()) {
                storeFileResult.add(storeFile(multipartFile)); // uploadFIle 객체를 리스트에 추가
            }
        }
        return storeFileResult;
    }

    // 멀티파트 파일 -> 서버에 저장될 이름 변경
    public UploadFile storeFile(MultipartFile multipartFile) throws IOException {

        if (multipartFile.isEmpty()) {
            log.warn("빈 파일이 전달됨");
            return null;
        }

        // 디렉토리 생성 (없으면 자동 생성)
        File dir = new File(fileDir);
        if (!dir.exists()) {
            boolean created = dir.mkdirs();
            log.info("파일 저장 디렉토리 생성: {} (성공: {})", dir.getAbsolutePath(), created);
        }

        String orgFileName = multipartFile.getOriginalFilename();
        String storeFileName = createStoreFileName(orgFileName); // 사용자가 업로드한 파일 이름 -> 서버에 저장될 이름
        String fullPath = getFullPath(storeFileName);

        log.info("파일 저장 시도: 원본={}, 저장명={}, 경로={}, 크기={}바이트",
                 orgFileName, storeFileName, fullPath, multipartFile.getSize());

        multipartFile.transferTo(new File(fullPath)); // 서버에 저장될 파일 이름으로 실제 경로에 저장

        log.info("파일 저장 완료: {}", fullPath);
        return new UploadFile(orgFileName, storeFileName);
    }

    private String createStoreFileName(String orgFileName) {
        String ext = extractExt(orgFileName); // png, jpg 등 확장자
        String uuid = UUID.randomUUID().toString();
        return uuid + "." + ext;
    }

    private String extractExt(String orgFileName) {
        int pos = orgFileName.lastIndexOf(".");
        return orgFileName.substring(pos + 1);
    }
}
