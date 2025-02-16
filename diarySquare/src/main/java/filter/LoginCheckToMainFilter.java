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
import javax.servlet.http.HttpSession;

import model.bean.LoginUserBean;

/**
 * Servlet Filter implementation class LoginCheckFilter
 */

/**
 * すべてのurlを指定。
 */
//@WebFilter(urlPatterns={"/index.jsp"})

/**
 * ログインしているかチェックしログインしている場合はホームページへ遷移させるFilter
 */
public class LoginCheckToMainFilter implements Filter {

    /**
     * @see HttpFilter#HttpFilter()
     */
    public LoginCheckToMainFilter() {
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

        HttpSession session = ((HttpServletRequest)request).getSession();
        LoginUserBean loginUser = (LoginUserBean)session.getAttribute("loginUser");

        if (loginUser != null) {
            ((HttpServletRequest)request).getRequestDispatcher("Main").forward(request, response);
            return;
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
