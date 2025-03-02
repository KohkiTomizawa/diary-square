package model;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import dao.RegisterDao;
import model.bean.RegisterUserBean;

/**
 * ユーザー新規登録のロジック
 */
public class RegisterLogic {
    /**
     * 入力されたユーザーIDを元にregisterDaoにより、
     * ユーザーIDが未登録/登録済みか判定
     * 
     * @param userId 入力されたユーザーID
     * @param userIdCheckResult ユーザーIDが未登録かどうかの確認結果 ->
     *   "error"：チェックが正常に行えなかった場合
     *   "registerd"：登録済みの場合
     *   "unregisterd"：未登録の場合
     * @return userIdCheckResult 確認結果
     */
    public String userIdCheck(String userId) {
        RegisterDao registerDao = new RegisterDao();
        String userIdCheckResult = null;
        
        userIdCheckResult = registerDao.unregisterdUserIdCheck(userId);
        
        return userIdCheckResult;
    }
    
    /**
     * 登録ユーザーBeanのEメールアドレスを元に画面遷移先を指定する
     * はじめにregisterDaoによりEメールアドレスが未登録/登録済みか判定し、
     * 未登録の場合は、確認用Eメールアドレスと一致/不一致か判定する
     * 
     * @param registerUser 登録ユーザーBean
     * @param emailCheckResult Eメールアドレスが未登録かどうかの確認結果 ->
     *   "error"：チェックが正常に行えなかった場合
     *   "registerd"：登録済みの場合
     *   "unregisterd"：未登録の場合
     * @return dispatcher 遷移先アドレスを指定
     */
    public RequestDispatcher emailCheck(RegisterUserBean registerUser, HttpServletRequest request, HttpSession session) {
        RequestDispatcher dispatcher = null;
        RegisterDao registerDao = new RegisterDao();
        String emailCheckResult = null;
        
        emailCheckResult = registerDao.unregisterdEmailCheck(registerUser);
        
        if (emailCheckResult.equals("registerd")) {
            /** 登録済みのとき */
            session.setAttribute("state", "registerd");
            dispatcher = request.getRequestDispatcher("register.jsp");
        } else if (emailCheckResult.equals("error")) {
            /** チェックが正常に行えなかったとき */
            session.setAttribute("state", "error");
            dispatcher = request.getRequestDispatcher("register.jsp");
        } else if (!registerUser.getEmail().equals(registerUser.getEmailConfirm())) {
            /** 未登録かつ確認用Eメールアドレスが一致しないとき */
            session.setAttribute("state", "different");
            dispatcher = request.getRequestDispatcher("register.jsp");
            
        } else {
            /** 未登録かつ確認用Eメールアドレスが一致するとき */
            session.setAttribute("state", "correct");
            dispatcher = request.getRequestDispatcher("WEB-INF/register_confirm.jsp");
        }
        
        return dispatcher;
    }

    /**
     * 登録ユーザーBeanに現在日時(登録日時)をセットしたのち、
     * 登録ユーザーBeanをregisterDaoに渡し、受け取ったエラーメッセージを戻す
     * 
     * @param registerUser 登録ユーザーBean
     * @param sdf MySQLのDATETIME型に入る形のフォーマット
     * @return errorMsg エラーメッセージ(ログイン成功の場合、null)
     */
    public String register(RegisterUserBean registerUser) {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        registerUser.setRegistrationDate(sdf.format(date));
        
        String errMsg = null;
        RegisterDao registerDao = new RegisterDao();

        errMsg = registerDao.register(registerUser);
        
        return errMsg;
    }
}
