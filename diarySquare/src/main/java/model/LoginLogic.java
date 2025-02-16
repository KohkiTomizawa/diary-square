package model;

import dao.LoginDao;
import model.bean.LoginUserBean;

/**
 * ユーザーログインのロジック
 */
public class LoginLogic {

    /**
     * 第１引数をユーザーIDかEメールアドレスを判別した上で、パスワードと共に
     * loginDaoの対応したメソッドに渡し、一致したユーザー情報をログインユーザーBeanとして戻す
     * @param userIdOrEmail ユーザーIDまたはEメールアドレス(@の有無で判別)
     * @param pwd ログインパスワード
     * @return ログインユーザーBean(ログイン不可の場合、null)
     */
    public LoginUserBean login(String userIdOrEmail, String pwd) {
        LoginUserBean loginUser = null;
        LoginDao loginDao = new LoginDao();

        if (userIdOrEmail.indexOf("@") == -1) {
            String userId = userIdOrEmail;
            loginUser = loginDao.loginWithUserId(userId, pwd);
        } else {
            String email = userIdOrEmail;
            loginUser = loginDao.loginWithEmail(email, pwd);
        }

        return loginUser;
    }
}
