package project.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminMapper adminMapper;

    public AdminVO login(String id, String pwd) {
        return adminMapper.loginAdmin(id, pwd);
    }
}