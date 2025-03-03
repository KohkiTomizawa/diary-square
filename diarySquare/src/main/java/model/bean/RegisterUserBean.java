package model.bean;

import java.io.Serializable;

/** 登録ユーザーBean */
public class RegisterUserBean implements Serializable {
    /** Eメールアドレス */
    private String email;
    /** Eメールアドレス(確認用) */
    private String confirmEmail;
    /** ユーザーID */
    private String userId;
    /** ユーザー名 */
    private String userName;
    /** パスワード */
    private String pwd;
    /** パスワードの長さ */
    private int pwdLength;
    /** 生年月日(date of birthの略) */
    private String dob;
    /** 
     * 性別
     * 初期値:"0"(回答しない)
     */
    private String sex = "0";
    /** 
     * 登録情報の状態
     * same:メールアドレス一致
     * different:メールアドレス不一致
     * incorrect:修正が必要
     */
    private String registerState;
    /** 登録日時 */
    private String registrationDate;

    /**
     * Eメールアドレスのゲッター
     * @param email Eメールアドレス
     */
    public String getEmail() {
        return email;
    }

    /**
     * Eメールアドレスのセッター
     * @param email Eメールアドレス
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Eメールアドレス(確認用)のゲッター
     * @param confirmEmail Eメールアドレス(確認用)
     */
    public String getConfirmEmail() {
        return confirmEmail;
    }

    /**
     * Eメールアドレス(確認用)のセッター
     * @param confirmEmail Eメールアドレス(確認用)
     */
    public void setConfirmEmail(String confirmEmail) {
        this.confirmEmail = confirmEmail;
    }

    /**
     * ユーザーIDのゲッター
     * @param userId ユーザーID
     */
    public String getUserId() {
        return userId;
    }

    /**
     * ユーザーIDのセッター
     * @param userId ユーザーID
     */
    public void setUserId(String userId) {
        this.userId = userId;
    }

    /**
     * ユーザー名のゲッター
     * @param userName ユーザー名
     */
    public String getUserName() {
        return userName;
    }

    /**
     * ユーザー名のセッター
     * @param userName ユーザー名
     */
    public void setUserName(String userName) {
        this.userName = userName;
    }

    /**
     * パスワードのゲッター
     * @param pwd パスワード
     */
    public String getPwd() {
        return pwd;
    }

    /**
     * パスワードのセッター
     * @param pwd パスワード
     */
    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    /**
     * パスワードの長さのゲッター
     * @param pwdLength パスワードの長さ
     */
    public int getPwdLength() {
        return pwdLength;
    }

    /**
     * パスワードの長さのセッター
     * @param pwdLength パスワードの長さ
     */
    public void setPwdLength(int pwdLength) {
        this.pwdLength = pwdLength;
    }

    /**
     * 生年月日のゲッター
     * @param dob 生年月日
     */
    public String getDob() {
        return dob;
    }

    /**
     * 生年月日のセッター
     * @param dob 生年月日
     */
    public void setDob(String dob) {
        this.dob = dob;
    }

    /**
     * 性別のゲッター
     * @param gender 性別
     */
    public String getSex() {
        return sex;
    }

    /**
     * 性別のセッター
     * @param gender 性別
     */
    public void setSex(String sex) {
        this.sex = sex;
    }

    /**
     * 登録情報の状態のゲッター
     * @param registerState 登録情報の状態
     */
    public String getRegisterState() {
        return registerState;
    }

    /**
     * 登録情報の状態のセッター
     * @param state 登録情報の状態
     */
    public void setRegisterState(String registerState) {
        this.registerState = registerState;
    }

    /**
     * 登録年月日のゲッター
     * @param registrationDate 登録年月日
     */
    public String getRegistrationDate() {
        return registrationDate;
    }

    /**
     * 登録年月日のセッター
     * @param registrationDate 登録年月日
     */
    public void setRegistrationDate(String registrationDate) {
        this.registrationDate = registrationDate;
    }
}
