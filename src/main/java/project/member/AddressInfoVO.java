package project.member;

import lombok.Data;

@Data
public class AddressInfoVO {
    private long addr_seq;
    private long member_seq;
    private String post_no;
    private String addr_h;
    private String addr_d;
    private int default_yn;
    private String addr_nm;
}
