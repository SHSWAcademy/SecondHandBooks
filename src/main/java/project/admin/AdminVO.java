package project.admin;

import lombok.Data;

@Data
public class AdminVO {
    private long admin_seq;         // PK
    private String admin_login_id;  // ID
    private String admin_password;  // Password
}