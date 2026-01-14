package project;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

@Controller
public class MockupController {

    // Mock 데이터 생성
    private List<Map<String, Object>> createMockBooks() {
        List<Map<String, Object>> books = new ArrayList<>();

        String[] titles = {"클린 코드", "위대한 개츠비", "알고리즘 개론", "사피엔스", "해리포터와 마법사의 돌",
                          "총 균 쇠", "돈의 속성", "파친코", "코스모스", "미움받을 용기"};
        String[] authors = {"로버트 C. 마틴", "F. 스콧 피츠제럴드", "Thomas H. Cormen", "유발 하라리", "J.K. 롤링",
                           "재레드 다이아몬드", "김승호", "이민진", "칼 세이건", "기시미 이치로"};
        String[] publishers = {"인사이트", "민음사", "한빛미디어", "김영사", "문학동네",
                              "문학사상", "스노우폭스북스", "인플루엔셜", "사이언스북스", "인플루엔셜"};
        String[] categories = {"과학/IT", "소설/문학", "과학/IT", "인문/사회", "소설/문학",
                              "인문/사회", "경영/경제", "소설/문학", "인문/사회", "인문/사회"};
        String[] locations = {"서울 강남구", "서울 마포구", "부산 해운대구", "대구 수성구", "경기 성남시",
                             "인천 연수구", "대전 유성구", "광주 동구", "서울 서초구", "경기 수원시"};
        String[] sellers = {"개발왕김코딩", "책벌레99", "컴공학생", "역사덕후", "마법사",
                           "부자될거야", "드라마광", "우주먼지", "심리학도", "독서왕"};

        for (int i = 0; i < 50; i++) {
            Map<String, Object> book = new HashMap<>();
            int idx = i % titles.length;

            book.put("id", "mock-" + (i + 1));
            book.put("type", "SALE");
            book.put("title", titles[idx]);
            book.put("postTitle", "급처합니다 " + titles[idx] + " 팝니다");
            book.put("author", authors[idx]);
            book.put("publisher", publishers[idx]);
            book.put("category", categories[idx]);

            int price = (int)(Math.random() * 30000) + 5000;
            price = price - (price % 100);
            book.put("price", price);
            book.put("originalPrice", price + 5000 + (int)(Math.random() * 10000));

            book.put("condition", new String[]{"New", "Like New", "Good", "Fair"}[i % 4]);
            book.put("description", "구매한지 얼마 안 된 " + titles[idx] + " 책입니다. 상태 매우 양호하며 직거래, 택배 거래 모두 가능합니다.");

            List<String> images = Arrays.asList(
                "https://picsum.photos/400/600?random=" + (i + 1),
                "https://picsum.photos/400/600?random=" + (i + 1001),
                "https://picsum.photos/400/600?random=" + (i + 2001)
            );
            book.put("images", images);

            book.put("sellerId", "user-" + (i % sellers.length));
            book.put("sellerName", sellers[i % sellers.length]);
            book.put("location", locations[i % locations.length]);
            book.put("createdAt", System.currentTimeMillis() - (long)(Math.random() * 1000000000));
            book.put("likes", (int)(Math.random() * 50));
            book.put("views", (int)(Math.random() * 300));
            book.put("shippingFee", i % 3 == 0 ? 0 : 3000);

            String resellState = "ON_SALE";
            if (Math.random() > 0.9) resellState = "SOLD";
            else if (Math.random() > 0.85) resellState = "RESERVED";
            book.put("resellState", resellState);

            books.add(book);
        }

        return books;
    }

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        List<Map<String, Object>> books = createMockBooks();
        model.addAttribute("books", books);
        model.addAttribute("categories", Arrays.asList(
            "소설/문학", "경영/경제", "인문/사회", "자기계발", "과학/IT",
            "예술/대중문화", "학습/참고서", "만화", "기타"
        ));
        return "common/home";
    }

    @GetMapping("/productDetail")
    public String productDetail(@RequestParam(required = false) String id, Model model) {
        // Mock book data
        Map<String, Object> book = new HashMap<>();
        book.put("id", "mock-1");
        book.put("type", "SALE");
        book.put("title", "클린 코드");
        book.put("postTitle", "급처합니다 클린 코드 팝니다");
        book.put("author", "로버트 C. 마틴");
        book.put("publisher", "인사이트");
        book.put("category", "과학/IT");
        book.put("price", 25000);
        book.put("originalPrice", 35000);
        book.put("condition", "Like New");
        book.put("description", "구매한지 얼마 안 된 클린 코드 책입니다. 상태 매우 양호하며 직거래, 택배 거래 모두 가능합니다.");
        book.put("images", Arrays.asList(
            "https://picsum.photos/400/600?random=1",
            "https://picsum.photos/400/600?random=1001",
            "https://picsum.photos/400/600?random=2001"
        ));
        book.put("sellerId", "user-1");
        book.put("sellerName", "개발왕김코딩");
        book.put("location", "서울 강남구");
        book.put("likes", 15);
        book.put("shippingFee", 3000);

        model.addAttribute("book", book);
        return "mockup/productDetail";
    }

//    @GetMapping("/login")
//    public String login() {
//        return "mockup/login";
//    }

//    @GetMapping("/signup")
//    public String signup() {
//        return "mockup/signup";
//    }

    @GetMapping("/profile")
    public String profile(Model model) {
        // Mock user data
        Map<String, Object> user = new HashMap<>();
        user.put("id", "user-1");
        user.put("username", "user123");
        user.put("email", "user@shinhan.com");
        user.put("nickname", "모닝커피");
        user.put("temperature", 36.5);
        user.put("points", 1000);
        user.put("phoneNumber", "010-1234-5678");
        user.put("address", "서울특별시 중구 세종대로 9길 20");
        user.put("joinedAt", "2024-01-01");

        model.addAttribute("user", user);
        return "mockup/profile";
    }

    @GetMapping("/wishlist")
    public String wishlist(Model model) {
        // Mock wishlist books
        List<Map<String, Object>> wishlistBooks = new ArrayList<>();

        for (int i = 0; i < 5; i++) {
            Map<String, Object> book = new HashMap<>();
            book.put("id", "mock-" + (i + 1));
            book.put("title", "클린 코드");
            book.put("author", "로버트 C. 마틴");
            book.put("price", 25000 + i * 1000);
            book.put("images", Arrays.asList("https://picsum.photos/400/600?random=" + (i + 1)));
            wishlistBooks.add(book);
        }

        model.addAttribute("wishlistBooks", wishlistBooks);
        return "mockup/wishlist";
    }

    @GetMapping("/upload")
    public String upload() {
        return "mockup/upload";
    }

    @GetMapping("/chat")
    public String chat() {
        return "mockup/chat";
    }

    @GetMapping("/readingGroups")
    public String readingGroups() {
        return "mockup/readingGroups";
    }

    @GetMapping("/findAccount")
    public String findAccount() {
        return "mockup/findAccount";
    }

    @GetMapping("/company")
    public String company() {
        return "mockup/company";
    }

    @GetMapping("/terms")
    public String terms() {
        return "mockup/terms";
    }

    @GetMapping("/support")
    public String support() {
        return "mockup/support";
    }

    @GetMapping("/safetyGuide")
    public String safetyGuide() {
        return "mockup/safetyGuide";
    }

    @GetMapping("/sellingGuide")
    public String sellingGuide() {
        return "mockup/sellingGuide";
    }

    @GetMapping("/event")
    public String event() {
        return "mockup/event";
    }

    @GetMapping("/admin")
    public String admin() {
        return "mockup/admin";
    }
}
