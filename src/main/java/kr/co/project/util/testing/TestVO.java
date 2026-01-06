package kr.co.project.util.testing;


import java.sql.Timestamp;
import lombok.Data;

@Data
public class TestVO {
    private int no;           // 첫 번째 컬럼 (숫자)
    private String title;     // 두 번째 컬럼 (테스트1, 테스트2...)
    private Timestamp regdate; // 세 번째 컬럼 (날짜)
}