package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.bean.LoginUserBean;

/**
 * Servlet Filter implementation class LoginCheckFilter
 */

/**
 * すべてのurlを指定。
 */
//@WebFilter(urlPatterns={"/*"})

/**
 * ログインしているかチェックしログインしていない場合はエラーページへ遷移させるFilter
 */
public class LoginCheckFilter implements Filter {

    /**
     * @see HttpFilter#HttpFilter()
     */
    public LoginCheckFilter() {
        super();
    }

    /**
     * @see Filter#destroy()
     */
    public void destroy() {
    }

    /**
     * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        /**
         * 前処理
         */

        /**
         * ログインチェックが不要なものをURLにより指定する。
         * (対象JSPが参照している外部ファイル(.css/.js)を含む)
         */
        String requestUrl = ((HttpServletRequest)request).getRequestURL().toString();
        if(!requestUrl.equals("http://localhost:8080/diarySquare/index.jsp")
            && !requestUrl.equals("http://localhost:8080/diarySquare/LoginServlet")
            && !requestUrl.equals("http://localhost:8080/diarySquare/WEB-INF/login_faild.jsp")
            && !requestUrl.equals("http://localhost:8080/diarySquare/register.jsp")
            && !requestUrl.equals("http://localhost:8080/diarySquare/css/style.css")
            ) {
            HttpSession session = ((HttpServletRequest)request).getSession();
            LoginUserBean loginUser = (LoginUserBean)session.getAttribute("loginUser");

            if(loginUser == null) {
                ((HttpServletResponse)response).sendRedirect("index.jsp");
                return;
            }
        }

        chain.doFilter(request, response);

        /**
         * 後処理
         */
    }

    /**
     * @see Filter#init(FilterConfig)
     */
    public void init(FilterConfig fConfig) throws ServletException {
    }

}
