package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.RegisterLogic;
import model.bean.RegisterUserBean;
import util.StringUtil;

/**
 * Servlet implementation class Login
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * アカウント新規登録に関する処理を行うメソッド
     * セッションスコープ内の"state"の値によって処理を分岐する
     * @param request   HTTPのリクエスト
     * @param response  HTTPのレスポンス
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String state = request.getParameter("state");
        HttpSession session = request.getSession();

        if (state == null) {
            session.removeAttribute("registerUser");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        switch (state) {
        /**
         * メールアドレスの一致/不一致を判定し、一致したら登録情報確認画面へ遷移、
         * 不一致なら登録画面へ遷移
         */
        case "confirm":
            RegisterUserBean registerUser = new RegisterUserBean();
            registerUser.setEmail(StringUtil.exchangeXSS(request.getParameter("email")));
            registerUser.setEmailConfirm(StringUtil.exchangeXSS(request.getParameter("emailConfirm")));
            registerUser.setUserId(StringUtil.exchangeXSS(request.getParameter("userId")));
            registerUser.setUserName(StringUtil.exchangeXSS(request.getParameter("userName")));
            registerUser.setPwd(StringUtil.exchangeXSS(request.getParameter("pwd")));
            registerUser.setPwdLength(request.getParameter("pwd").length());
            registerUser.setDob(StringUtil.exchangeXSS(request.getParameter("dob")));
            registerUser.setSex(request.getParameter("sex"));
            
            if (registerUser.getEmail().equals(registerUser.getEmailConfirm())) {
                session.setAttribute("state", "same");
                session.setAttribute("registerUser", registerUser);
                request.getRequestDispatcher("WEB-INF/register_confirm.jsp").forward(request, response);
            } else {
                session.setAttribute("state", "different");
                session.setAttribute("registerUser", registerUser);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            break;
        /**
         * 登録情報を修正するために登録画面へ遷移
         * セッションスコープの登録ユーザーBeanが空の場合は、
         * セッションスコープを削除して登録画面へ遷移
         */
        case "correct":
            registerUser = (RegisterUserBean)session.getAttribute("registerUser");
            if (registerUser != null) {
                session.setAttribute("state", "incorrect");
                session.setAttribute("registerUser", registerUser);
            } else {
                session.invalidate();
            }
            request.getRequestDispatcher("register.jsp").forward(request, response);
            break;
        /**
         * 登録を実行し、エラーメッセージが空であれば登録完了画面へ遷移
         * エラーメッセージが空でない場合、または、セッションスコープの
         * 登録ユーザーBeanが空の場合は登録未完了画面へ遷移
         */
        case "execute":
            registerUser = (RegisterUserBean)session.getAttribute("registerUser");
            if (registerUser == null) {
                request.getRequestDispatcher("register_faild.jsp").forward(request, response);
                return;
            }
            
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            registerUser.setRegistrationDate(sdf.format(date));
            
            RegisterLogic registerLogic = new RegisterLogic();
            String errMsg = null;
            
            errMsg = registerLogic.register(registerUser);
            session.invalidate();
            
            if (errMsg == null) {
                request.getRequestDispatcher("register_success.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("register_faild.jsp").forward(request, response);
            }
            break;
        /*
         * 想定外の処理の場合は、セッションスコープを削除して登録画面へ遷移
         */
        default:
            session.invalidate();
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}