package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.bean.LoginUserBean;

/**
 * ユーザーのログインを行うDAO
 */
public class LoginDao extends BaseDao {
    
    /**
     * ユーザーIDとログインパスワードを指定してユーザーテーブルからユーザー情報を取得する
     * @param userId ユーザーID
     * @param pwd ログインパスワード
     * @return ログインユーザーの情報を格納したBean
     */
    public LoginUserBean loginWithUserId(String userId, String pwd) {
        LoginUserBean loginUser = null;
        
        /** 
         * SQL文：パスワードの暗号化に際し、鍵をバイナリ文字列に戻し、
         *        暗号化されたパスワード(バイナリ文字列)を16進数に変換
         *        ※２行目先頭のスペースを忘れないように気を付ける！
         */
        String strSql = "SELECT internal_id,id,name FROM users"
                + " WHERE id=? AND pwd=HEX(AES_ENCRYPT(?,UNHEX('" + key() + "')))";
        
        try {
            load();
            
            // try-with-resources文のため、conn、pstmt、rsは自動で閉じられる
            // (try-catch-finally文の場合は、finally句内でxxx.close()により閉じる必要がある)
            try (Connection conn = open()) {
                PreparedStatement pstmt = conn.prepareStatement(strSql);
                pstmt.setString(1, userId);
                pstmt.setString(2, pwd);
                
                ResultSet rs = pstmt.executeQuery();
                // 検索結果が1件でも、rs.getXxx()を動作させるためにrs.next()の記述が必要！
                if (rs.next()) {
                    loginUser = new LoginUserBean();
                    loginUser.setInternalUserId(rs.getInt("internal_id"));
                    loginUser.setUserId(rs.getString("id"));
                    loginUser.setUserName(rs.getString("name"));
                }
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            loginUser = null;
        }
        
        return loginUser;
    }
    

    /**
     * ユーザーEmailとログインパスワードを指定してユーザーテーブルからユーザー情報を取得する
     * @param email ユーザーEmail
     * @param pwd ログインパスワード
     * @return ログインユーザーの情報を格納したBean
     */
    public LoginUserBean loginWithEmail(String email, String pwd) {
        LoginUserBean loginUser = null;
        
        /** 
         * SQL文：パスワードの暗号化に際し、鍵をバイナリ文字列に戻し、
         *        暗号化されたパスワード(バイナリ文字列)を16進数に変換
         *        ※２行目先頭のスペースを忘れないように気を付ける！
         */
        String strSql = "SELECT internal_id,id,name FROM users"
                + " WHERE email=? AND pwd=HEX(AES_ENCRYPT(?,UNHEX('" + key() + "')))";
        
        try {
            load();
            
            // try-with-resources文のため、conn、pstmt、rsは自動で閉じられる
            // (try-catch-finally文の場合は、finally句内でxxx.close()により閉じる必要がある)
            try (Connection conn = open()) {
                PreparedStatement pstmt = conn.prepareStatement(strSql);
                pstmt.setString(1, email);
                pstmt.setString(2, pwd);

                ResultSet rs = pstmt.executeQuery();
                // 検索結果が1件でも、rs.getXxx()を動作させるためにrs.next()の記述が必要！
                if (rs.next()) {
                    loginUser = new LoginUserBean();
                    loginUser.setInternalUserId(rs.getInt("internal_id"));
                    loginUser.setUserId(rs.getString("id"));
                    loginUser.setUserName(rs.getString("name"));
                }
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            loginUser = null;
        }
            
        return loginUser;
    }
}