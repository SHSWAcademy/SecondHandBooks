package project.util.book;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class BookApiService {

    @Value("${api.kakao.rest-api-key}")
    private String kakaoApiKey;

    @Value("${api.kakao.book-url}")
    private String kakaoBookUrl;

    // AppConfig 에서 수동으로 빈 등록해주었습니다 !
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public List<BookVO> searchBooks(String query) {
        List<BookVO> books = new ArrayList<>();

        try {
            // url 생성, UriComponentsBuilder.fromHttpUrl : 스프링 종속 클래스, URL을 안전하게 조립하기 위해 사용
            // https://dapi.kakao.com/v3/search/book?query=java&size=10 예시와 같이 쿼리 파라미터들을 안전하게 조립하기 위해 사용

            String url = UriComponentsBuilder.fromHttpUrl(kakaoBookUrl)
                    .queryParam("query", query)
                    .queryParam("size", 10)  // 최대 10개 결과 (10개 페이징 처리)
                    .build()
                    .toUriString();
            /*
            카카오 개발자 센터
            query	String	검색을 원하는 질의어	O
            sort	String	결과 문서 정렬 방식, accuracy(정확도순) 또는 latest(발간일순), 기본값 accuracy	X
            page	Integer	결과 페이지 번호, 1~50 사이의 값, 기본 값 1	X
            size	Integer	한 페이지에 보여질 문서 수, 1~50 사이의 값, 기본 값 10	X
            target	String	검색 필드 제한, 사용 가능한 값: title(제목), isbn (ISBN), publisher(출판사), person(인명)	X
             */

            log.info("Kakao API 호출: {}", url);

            // http 헤더 설정
            HttpHeaders headers = new HttpHeaders(); // 스프링이 제공하는 http 요청/응답 헤더를 담는 객체
            headers.set("Authorization", "KakaoAK " + kakaoApiKey); // 헤더 설정 (카카오 스펙에 맞추어야 한다) Authorization: KakaoAK ${REST_API_KEY}
            HttpEntity<?> entity = new HttpEntity<>(headers); // Spring 에서 http 요청/응답 헤더를 담는 객체

            // api 호출, Spring 에서 REST API 호출 + 응답 받기 담당
            // restTemplate : API 호출, 응답 담당, Jackson : json 변환 담당
            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            // 응답 파싱
            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode documents = root.get("documents");

                if (documents != null && documents.isArray()) {
                    for (JsonNode doc : documents) {
                        BookVO book = parseBookFromJson(doc); // json -> book
                        books.add(book);
                    }
                }
                log.info("검색 결과: {}건", books.size());
            }

        } catch (Exception e) {
            log.error("Kakao API 호출 실패: {}", e.getMessage()); // 빈 리스트 반환
        }

        return books;
    }


    // json -> book 데이터
    private BookVO parseBookFromJson(JsonNode jsonNode) {
        /* 응답 document 중 받아와야 하는 데이터
            title : String
            isbn : String
            authors : String[]
            publisher : String
            price : Integer
            thumbnail : String
         */


        // isbn (공백으로 구분된 경우 첫 번째 값 사용)
        String isbn = "";
        if (jsonNode.has("isbn")) {
            String isbnText = jsonNode.get("isbn").asText();
            if (!isbnText.isEmpty()) {
                isbn = isbnText.split(" ")[0];  // "9788972756194 1234567890" -> "9788972756194"
            }
        }

        // title
        String title = jsonNode.has("title") ? jsonNode.get("title").asText() : "";

        // author (배열로 올 경우 첫 번째 값 사용)
        String author = "";
        if (jsonNode.has("authors") && jsonNode.get("authors").isArray() && jsonNode.get("authors").size() > 0) {
            author = jsonNode.get("authors").get(0).asText();
        }

        // publisher
        String publisher = jsonNode.has("publisher") ? jsonNode.get("publisher").asText() : "";

        // thumbnail
        String thumbnail = jsonNode.has("thumbnail") ? jsonNode.get("thumbnail").asText() : "";

        // org_price
        int price = jsonNode.has("price") ? jsonNode.get("price").asInt() : 0;

        return new BookVO(isbn, title, author, publisher, thumbnail, price);
    }
}
