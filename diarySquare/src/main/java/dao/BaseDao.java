package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DAOの基底クラス
 */
public class BaseDao {

    /** JDBCドライバ名 */
    private static final String JDBC_DRIVER_NAME = "com.mysql.cj.jdbc.Driver";

    /** DBの接続先URL */
    private static final String CONNECTION_URL = "jdbc:mysql://localhost/diarySquare";

    /** DBへ接続時のユーザーID */
    private static final String CONNECTION_USER_ID = "root";

    /** DBへ接続時のパスワード */
    private static final String CONNECTION_PASSWORD = "1234";
    
    /** 
     * AES_CRYPTOを使用した暗号化･復号化時の16バイト(128ビット)鍵(16進数)
     * (SQL文"SELECT HEX(RANDOM_BYTES(16));"により、バイナリ文字列を生成し16進数に変換したもの)
     */
    private static final String KEY = "45DAB654CF0A27ED065EA047B87C17A1";

    /** DBへの接続 */
    protected Connection conn = null;
    
    /**
     * JDBCドライバを読み込む
     * 
     * @throws ClassNotFoundException JDBCドライバが存在しない
     */
    protected void load() throws ClassNotFoundException {
        Class.forName(JDBC_DRIVER_NAME);
    }

    /**
     * DBへ接続する
     * 
     * @throws SQLException DB接続失敗
     */
    protected Connection open() throws SQLException {
        conn = DriverManager.getConnection(CONNECTION_URL, CONNECTION_USER_ID, CONNECTION_PASSWORD);
        return conn;
    }
    
    /**
     * 暗号化・復号化に使用する暗号鍵を返すメソッド
     */
    protected String key() {
        return KEY;
    }
}
