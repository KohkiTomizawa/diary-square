package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.LoginLogic;
import model.bean.LoginUserBean;

/**
 * Servlet implementation class Login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * リクエスト内のログイン情報とDBのユーザー情報を比較し、MainServlet経由でメイン画面(ログイン成功時)、
     * または、ログイン失敗画面に遷移する
     * @param request   HTTPのリクエスト
     * @param response  HTTPのレスポンス
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String userIdOrEmail = request.getParameter("userIdOrEmail");
        String pwd = request.getParameter("pwd");

        LoginLogic loginLogic = new LoginLogic();
        LoginUserBean loginUser = null;
        loginUser = loginLogic.login(userIdOrEmail, pwd);

        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            System.out.println(loginUser.getInternalUserId());
            request.getRequestDispatcher("Main").forward(request, response);
        } else {
            request.getRequestDispatcher("WEB-INF/login_faild.jsp").forward(request, response);
        }
        
    }
}
