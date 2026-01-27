# 독서모임(BookClub) 개발 복습 퀴즈

> 실제 프로젝트 코드를 기반으로 한 퀴즈입니다.
> 정답은 `BOOKCLUB_QUIZ_ANSWERS.md` 파일을 참고하세요.

---

## Part 1: 어노테이션 이해하기 (기초)

### Q1. 클래스 레벨 어노테이션
다음 코드에서 각 어노테이션의 역할을 설명하세요.

```java
@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bookclubs")
public class BookClubController {
    private final BookClubService bookClubService;
}
```

| 어노테이션 | 역할 |
|------------|------|
| `@Controller` | ? |
| `@Slf4j` | ? |
| `@RequiredArgsConstructor` | ? |
| `@RequestMapping("/bookclubs")` | ? |

---

### Q2. HTTP 메서드 매핑
다음 두 어노테이션의 차이점은 무엇인가요?

```java
@GetMapping
public String getBookClubs(Model model) { ... }

@PostMapping
public Map<String, Object> createBookClubs(...) { ... }
```

---

### Q3. 파라미터 어노테이션
다음 코드에서 `@PathVariable`과 `@RequestParam`의 차이를 설명하세요.

```java
@GetMapping("/{bookClubId}/posts/{postId}")
public String getPostDetail(
        @PathVariable("bookClubId") Long bookClubId,
        @PathVariable("postId") Long postId,
        ...) { }

@GetMapping("/search")
public List<BookClubVO> searchBookClubs(
        @RequestParam(required = false) String keyword) { }
```

- URL `/bookclubs/5/posts/10` 호출 시 `bookClubId`와 `postId` 값은?
- URL `/bookclubs/search?keyword=서울` 호출 시 `keyword` 값은?
- `required = false`는 무슨 의미인가요?

---

### Q4. @ResponseBody
다음 두 메서드의 반환 방식 차이를 설명하세요.

```java
// 메서드 A
@GetMapping
public String getBookClubs(Model model) {
    model.addAttribute("bookclubList", bookClubs);
    return "bookclub/bookclub_list";
}

// 메서드 B
@GetMapping("/search")
@ResponseBody
public List<BookClubVO> searchBookClubs(@RequestParam String keyword) {
    return bookClubService.searchBookClubs(keyword);
}
```

---

### Q5. @ModelAttribute
다음 코드에서 `@ModelAttribute`는 어떤 역할을 하나요?

```java
@PostMapping
public Map<String, Object> createBookClubs(
        @ModelAttribute BookClubVO vo,
        @RequestParam(value = "banner_img", required = false) MultipartFile bannerImg,
        HttpSession session) { ... }
```

---

### Q6. @Value
다음 코드에서 `@Value`는 무엇을 하나요?

```java
@Value("${file.dir}")
private String uploadPath;
```

- `${file.dir}`는 어디에 정의되어 있을까요?
- 이렇게 하는 이유는 무엇일까요?

---

### Q7. Service 어노테이션
다음 Service 클래스의 어노테이션을 설명하세요.

```java
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class BookClubService {
    private final BookClubMapper bookClubMapper;
}
```

| 어노테이션 | 역할 |
|------------|------|
| `@Service` | ? |
| `@Transactional(readOnly = true)` | ? |

- 클래스에 `@Transactional(readOnly = true)`가 있는데, 일부 메서드에 `@Transactional`만 붙은 이유는?

---

### Q8. Mapper 어노테이션
다음 코드에서 `@Mapper`와 `@Param`의 역할을 설명하세요.

```java
@Mapper
public interface BookClubMapper {

    BookClubVO selectById(@Param("bookClubSeq") Long bookClubSeq);

    int selectJoinedMemberCount(
        @Param("bookClubSeq") Long bookClubSeq,
        @Param("memberSeq") Long memberSeq);
}
```

---

## Part 2: 계층 구조 이해하기 (중급)

### Q9. 계층별 책임
다음 표를 완성하세요.

| 계층 | 클래스 | 주요 책임 |
|------|--------|-----------|
| Controller | BookClubController | ? |
| Service | BookClubService | ? |
| Mapper | BookClubMapper | ? |

---

### Q10. 데이터 흐름
"독서모임 목록 조회" 기능의 데이터 흐름을 순서대로 나열하세요.

```
[브라우저] → [    ?    ] → [    ?    ] → [    ?    ] → [DB]
                ↓
[JSP에서 렌더링] ← [Model에 데이터 담기]
```

---

### Q11. 왜 Service를 거칠까?
Controller에서 바로 Mapper를 호출하지 않고 Service를 거치는 이유 2가지를 설명하세요.

---

### Q12. 트랜잭션 위치
다음 중 `@Transactional`을 붙여야 하는 곳은 어디이고, 왜 그럴까요?

```java
// A. Controller
@PostMapping("/{bookClubId}/posts")
public String createPost(...) {
    bookClubService.createBoardPost(boardVO);
    return "redirect:/...";
}

// B. Service
public Long createBoardPost(BookClubBoardVO boardVO) {
    bookClubMapper.insertBoardPost(boardVO);
    return boardVO.getBook_club_board_seq();
}

// C. Mapper
void insertBoardPost(BookClubBoardVO boardVO);
```

---

## Part 3: 코드 구현 (중급~심화)

### Q13. 빈칸 채우기 - 권한 검증
다음 권한 검증 코드의 빈칸을 채우세요.

```java
private String checkBoardAccessPermission(Long bookClubId, HttpSession session, Model model) {
    // 1. 로그인 여부 확인
    MemberVO loginMember = (MemberVO) session.getAttribute("_______");
    if (loginMember == null) {
        return "redirect:/login";
    }

    Long loginMemberSeq = loginMember.getMember_seq();
    BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);

    // 2. 권한 판정
    boolean isLeader = bookClub.getBook_club_leader_seq()._______(loginMemberSeq);
    boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);

    boolean allow = isLeader _______ isMember;

    return allow ? _______ : "bookclub/bookclub_post_forbidden";
}
```

---

### Q14. 빈칸 채우기 - PRG 패턴
다음 댓글 작성 코드의 빈칸을 채우세요.

```java
@PostMapping("/{bookClubId}/posts/{postId}/comments")
public String createComment(
        @PathVariable("bookClubId") Long bookClubId,
        @PathVariable("postId") Long postId,
        @RequestParam("commentCont") String commentCont,
        HttpSession session,
        _____________ redirectAttributes) {

    // ... 검증 로직 생략 ...

    // 댓글 저장
    bookClubService.createBoardComment(bookClubId, postId, memberSeq, commentCont);

    // PRG 패턴: POST 후 Redirect
    return "_______:/bookclubs/" + bookClubId + "/posts/" + postId;
}
```

- PRG 패턴을 사용하는 이유는?

---

### Q15. 코드 작성 - 파일 저장
UUID를 사용해서 고유한 파일명을 생성하는 코드를 작성하세요.

```java
private String saveFile(MultipartFile file) throws IOException {
    String originalFileName = file.getOriginalFilename();

    // TODO: 확장자 추출
    String extension = "";
    // 여기에 코드 작성

    // TODO: UUID로 새 파일명 생성
    String savedFileName = "";
    // 여기에 코드 작성

    // 파일 저장
    File destFile = new File(uploadPath + savedFileName);
    file.transferTo(destFile);

    return savedFileName;
}
```

---

### Q16. 코드 작성 - 키워드 분리
공백으로 구분된 키워드를 List로 분리하는 코드를 작성하세요.

```java
public List<BookClubVO> searchBookClubs(String keyword) {
    // keyword = "서울 독서 모임"
    // tokens = ["서울", "독서", "모임"]

    List<String> tokens = new ArrayList<>();

    // TODO: StringTokenizer를 사용해서 tokens에 추가
    // 여기에 코드 작성

    return bookClubMapper.searchByKeyword(tokens);
}
```

---

### Q17. 코드 작성 - Enum 결과 처리
가입 신청 결과를 Enum으로 처리하는 switch문을 완성하세요.

```java
JoinRequestResult result = bookClubService.createJoinRequest(bookClubId, memberSeq, null);

switch (result) {
    case SUCCESS:
        // TODO: 성공 메시지 추가
        break;

    case ALREADY_JOINED:
    case ALREADY_REQUESTED:
        // TODO: 에러 메시지 추가
        break;
}
```

- Enum을 사용하면 어떤 장점이 있나요?

---

### Q18. 코드 작성 - Model 데이터 전달
Controller에서 JSP로 여러 데이터를 전달하는 코드를 작성하세요.

```java
@GetMapping("/{bookClubId}")
public String getBookClubDetail(
        @PathVariable("bookClubId") Long bookClubId,
        HttpSession session,
        Model model) {

    BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
    int memberCount = bookClubService.getTotalJoinedMemberCount(bookClubId);
    int wishCount = bookClubService.getWishCount(bookClubId);

    // TODO: model에 3개의 데이터 추가
    // 여기에 코드 작성

    return "bookclub/bookclub_detail";
}
```

---

## Part 4: 동작 원리 이해 (심화)

### Q19. Fragment 로딩
다음 코드에서 일반 페이지 반환과 fragment 반환의 차이를 설명하세요.

```java
// 일반 페이지
@GetMapping("/{bookClubId}")
public String getBookClubDetail(...) {
    return "bookclub/bookclub_detail";
}

// Fragment
@GetMapping("/{bookClubId}/board-fragment")
public String getBoardFragment(...) {
    return "bookclub/bookclub_detail_board";
}
```

- Fragment는 언제, 어떻게 사용되나요?
- Fragment에서 `redirect:`를 사용할 수 없는 이유는?

---

### Q20. 동시성 처리
다음 코드에서 "동시성 이슈"를 언급하는 이유를 설명하세요.

```java
@Transactional
public JoinRequestResult createJoinRequest(Long bookClubSeq, Long memberSeq, String requestCont) {
    // 1차 검증: 비즈니스 로직
    if (hasPendingRequest(bookClubSeq, memberSeq)) {
        return JoinRequestResult.ALREADY_REQUESTED;
    }

    // INSERT 시도
    try {
        bookClubMapper.insertJoinRequest(bookClubSeq, memberSeq, requestCont);
        return JoinRequestResult.SUCCESS;
    } catch (DataIntegrityViolationException e) {
        // 2차 방어: DB UNIQUE 제약 위반
        return JoinRequestResult.ALREADY_REQUESTED;
    }
}
```

- 왜 SELECT로 확인했는데도 INSERT에서 예외가 발생할 수 있나요?
- UNIQUE 제약 조건은 어떤 역할을 하나요?

---

### Q21. 우회 방지
댓글 작성 시 "부모글 검증"을 하는 이유를 설명하세요.

```java
// 부모글 검증 (우회 방지)
boolean isValidPost = bookClubService.existsRootPost(bookClubId, postId);
if (!isValidPost) {
    redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 게시글입니다.");
    return redirectUrl;
}
```

- 어떤 "우회"를 방지하는 건가요?
- 이 검증이 없으면 어떤 문제가 생길 수 있나요?

---

### Q22. Flash Attribute
`RedirectAttributes`와 `addFlashAttribute`의 동작 원리를 설명하세요.

```java
redirectAttributes.addFlashAttribute("successMessage", "게시글이 등록되었습니다.");
return "redirect:/bookclubs/" + bookClubId + "/posts/" + newPostId;
```

- 일반 `addAttribute`와 `addFlashAttribute`의 차이는?
- Flash Attribute는 어디에 저장되고, 언제 사라지나요?

---

## 보너스 문제

### B1. 전체 흐름 그리기
"게시글 작성" 기능의 전체 흐름을 직접 그려보세요.

```
[브라우저에서 폼 제출]
    ↓
[                    ]
    ↓
[                    ]
    ↓
[                    ]
    ↓
[DB INSERT]
    ↓
[                    ]
    ↓
[브라우저에서 상세 페이지 표시]
```

---

### B2. 보안 취약점 찾기
다음 코드에서 잠재적인 보안 문제를 찾아보세요.

```java
@PostMapping("/{bookClubId}/posts")
public String createPost(
        @PathVariable("bookClubId") Long bookClubId,
        @RequestParam("boardTitle") String boardTitle,
        @RequestParam("boardCont") String boardCont,
        HttpSession session) {

    // 제목과 내용을 바로 저장
    BookClubBoardVO boardVO = new BookClubBoardVO();
    boardVO.setBoard_title(boardTitle);
    boardVO.setBoard_cont(boardCont);

    bookClubService.createBoardPost(boardVO);
    return "redirect:/bookclubs/" + bookClubId;
}
```

힌트: 실제 프로젝트 코드에는 이 문제를 방지하는 코드가 있습니다.

---

*퀴즈 완료 후 `BOOKCLUB_QUIZ_ANSWERS.md`에서 정답을 확인하세요!*
