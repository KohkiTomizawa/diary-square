package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.bean.RegisterUserBean;

/**
 * ユーザー新規登録DAO
 */
public class RegisterDao extends BaseDao {
    
    /**
     * 新規登録用Eメールアドレスがデータベースに登録済みかどうか確認する
     * 
     * @param registerUser 登録ユーザーの情報を格納したBean
     * @return 真偽値(未登録のとき、true)
     */
    public boolean unregisterdEmailCheck (RegisterUserBean registerUser) {
        String email = null;
        
        String strSql = "SELECT email FROM users WHERE email=?";

        try {
            load();
            
            // try-with-resources文のため、conn、pstmt、rsは自動で閉じられる
            // (try-catch-finally文の場合は、finally句内でxxx.close()により閉じる必要がある)
            try (Connection conn = open()) {
                PreparedStatement pstmt = conn.prepareStatement(strSql);
                pstmt.setString(1, registerUser.getEmail());
                
                ResultSet rs = pstmt.executeQuery();
                // 検索結果が1件でも、rs.getXxx()を動作させるためにrs.next()の記述が必要！
                if (rs.next()) {
                    email = rs.getString("email");
                }
                
                if (email != null) {
                    return false;
                }
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
            
        return true;
    }

    /**
     * ユーザーテーブルへユーザー新規登録を行う
     * @param registerUser 登録ユーザーの情報を格納したBean
     * @return エラーメッセージ(処理成功時、null)
     */
    public String register(RegisterUserBean registerUser) {
        String errMsg = null;

        /** 
         * SQL文：パスワードの暗号化に際し、鍵をバイナリ文字列に戻し、
         *        暗号化されたパスワード(バイナリ文字列)を16進数に変換
         *        ※２行目先頭のスペースを忘れないように気を付ける！
         */
        String strSql = "INSERT INTO users (id,name,email,pwd,registration_date,dob,sex)"
                + " VALUES(?,?,?,HEX(AES_ENCRYPT(?,UNHEX('" + key() + "'))),?,?,?)";

        try {
            load();
            
            // try-with-resources文のため、conn、pstmt、rsは自動で閉じられる
            // (try-catch-finally文の場合は、finally句内でxxx.close()により閉じる必要がある)
            try (Connection conn = open()) {
                PreparedStatement pstmt = conn.prepareStatement(strSql);
                pstmt.setString(1, registerUser.getUserId());
                pstmt.setString(2, registerUser.getUserName());
                pstmt.setString(3, registerUser.getEmail());
                pstmt.setString(4, registerUser.getPwd());
                pstmt.setString(5, registerUser.getRegistrationDate());
                pstmt.setString(6, registerUser.getDob());
                pstmt.setString(7, registerUser.getSex());
                pstmt.executeUpdate();
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            errMsg = e.getMessage();
        }
            
        return errMsg;
    }
}