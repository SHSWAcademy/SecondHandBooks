package project.util;

import javax.servlet.http.HttpSession;

public class Util {
    public static boolean checkSession (HttpSession session) {
        if (session == null) {
            return false;
        } else return true;
    }
}
