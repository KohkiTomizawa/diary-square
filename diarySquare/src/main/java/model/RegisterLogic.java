package model;

import dao.RegisterDao;
import model.bean.RegisterUserBean;

/**
 * ユーザー新規登録のロジック
 */
public class RegisterLogic {

    /**
     * 登録ユーザーBeanをregisterDaoに渡し、受け取ったエラーメッセージを戻す
     * 
     * @param registerUser 登録ユーザーBean
     * @return errorMsg エラーメッセージ(ログイン成功の場合、null)
     */
    public String register(RegisterUserBean registerUser) {
        String errMsg = null;
        RegisterDao registerDao = new RegisterDao();

        errMsg = registerDao.register(registerUser);
        
        return errMsg;
    }
}
