package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.RegisterLogic;
import model.bean.RegisterUserBean;
import util.StringUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * アカウント新規登録に関する非同期処理を行うメソッド
     * 
     * @param request   HTTPのリクエスト
     * @param response  HTTPのレスポンス
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String state = request.getParameter("state");
            
            switch (state) {
            /**
             * リクエストスコープのstateの値に応じて非同期処理を行う
             * 
             * @RequestScope "state" ->
             *   "checkUserId"：入力されたユーザーIDがすでに登録されているかどうかを確認する
             *   "beforeClose"：タブ及びウィンドウが閉じられた際にセッションスコープを破棄する
             */
            case "checkUserId":
                String userId = request.getParameter("userId");
                
                RegisterLogic registerLogic = new RegisterLogic();
                String strResult = registerLogic.userIdCheck(userId);
                
                Map<String, String> mapResult = new HashMap<String, String>();
                mapResult.put("result", strResult);
                ObjectMapper mapper = new ObjectMapper();
                String strJson = mapper.writeValueAsString(mapResult);
                
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter pw = response.getWriter();
                pw.print(strJson);
                pw.close();
                
            case "beforeClose":
                request.getSession().invalidate();
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * アカウント新規登録に関する処理を行うメソッド
     * セッションスコープ内の"state"の値によって処理を分岐する
     * 
     * @param request   HTTPのリクエスト
     * @param response  HTTPのレスポンス
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String state = request.getParameter("state");
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;
        RegisterLogic registerLogic = new RegisterLogic();

        if (state == null) {
            session.removeAttribute("registerUser");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        switch (state) {
        /**
         * Eメールアドレスの未登録/登録済み、および一致/不一致を判定し、
         * 未登録かつ一致なら登録情報確認画面へ遷移、それ以外なら登録画面へ遷移
         * なお、登録済みなら一致/不一致の判定をせずに遷移
         * 
         * @SessionScope "state" ->
         *   "registerd"：Eメールアドレスが登録済みの場合
         *   "error"：Eメールアドレスが未登録かどうかの確認が正常に行えなかった場合
         *   "different"：Eメールアドレスが未登録かつ不一致の場合
         *   "correct"：Eメールアドレスが未登録かつ一致の場合
         */
        case "confirm":
            RegisterUserBean registerUser = new RegisterUserBean();
            registerUser.setEmail(StringUtil.exchangeXSS(request.getParameter("email")));
            registerUser.setConfirmEmail(StringUtil.exchangeXSS(request.getParameter("confirmEmail")));
            registerUser.setUserId(StringUtil.exchangeXSS(request.getParameter("userId")));
            registerUser.setUserName(StringUtil.exchangeXSS(request.getParameter("userName")));
            registerUser.setPwd(StringUtil.exchangeXSS(request.getParameter("pwd")));
            registerUser.setPwdLength(request.getParameter("pwd").length());
            registerUser.setDob(StringUtil.exchangeXSS(request.getParameter("dob")));
            registerUser.setSex(request.getParameter("sex"));
            
            dispatcher = registerLogic.emailCheck(registerUser, request, session);
            
            session.setAttribute("registerUser", registerUser);
            dispatcher.forward(request, response);
            break;
        /**
         * 登録情報を修正するために登録画面へ遷移
         * セッションスコープの登録ユーザーBeanが空の場合は、
         * セッションスコープを削除して登録画面へ遷移
         * 
         * @SessionScope "state" ->
         *   "incorrect"：修正ボタンが押された場合
         */
        case "modify":
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
                request.getRequestDispatcher("WEB-INF/register_faild.jsp").forward(request, response);
                return;
            }
            
            String result = "";
            
            result = registerLogic.register(registerUser);
            session.invalidate();
            
            if (result.equals("success")) {
                request.getRequestDispatcher("WEB-INF/register_success.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("WEB-INF/register_faild.jsp").forward(request, response);
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