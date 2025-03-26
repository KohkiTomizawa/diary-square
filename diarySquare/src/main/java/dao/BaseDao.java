package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

/**
 * DAOの基底クラス
 * (定数はコンストラクタにより外部ファイルから読み込んだ値により初期化する)
 */
public class BaseDao {

    /** JDBCドライバ名 */
    private final String JDBC_DRIVER_NAME;

    /** DBの接続先URL */
    private final String CONNECTION_URL;

    /** DBへ接続時のユーザーID */
    private final String CONNECTION_USER_ID;

    /** DBへ接続時のパスワード */
    private final String CONNECTION_PASSWORD;
    
    /** 
     * AES_CRYPTOを使用した暗号化･復号化時の16バイト(128ビット)鍵(16進数)
     * (SQL文"SELECT HEX(RANDOM_BYTES(16));"により、バイナリ文字列を生成し16進数に変換したもの)
     */
    private final String KEY;

    /** DBへの接続 */
    protected Connection conn = null;
    
    /** コンストラクタ(外部ファイルから読み込んだ値により定数を初期化する) */
    public BaseDao() {
        ResourceBundle rb = ResourceBundle.getBundle("database");
        
        JDBC_DRIVER_NAME = rb.getString("JDBC_DRIVER_NAME");
        CONNECTION_URL = rb.getString("CONNECTION_URL");
        CONNECTION_USER_ID = rb.getString("CONNECTION_USER_ID");
        CONNECTION_PASSWORD = rb.getString("CONNECTION_PASSWORD");
        KEY = rb.getString("KEY");
    }
    
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
