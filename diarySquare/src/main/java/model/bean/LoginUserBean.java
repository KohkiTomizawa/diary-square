package model.bean;

import java.io.Serializable;

/** ログインユーザーBean */
public class LoginUserBean implements Serializable {
    /** 内部ユーザーID */
    private int internalUserId;
    /** ユーザーID */
    private String userId;
    /** ユーザー名 */
    private String userName;

    /**
     * 内部ユーザーIDのゲッター
     * @param internalUserId 内部ユーザーID
     */
    public int getInternalUserId() {
        return internalUserId;
    }

    /**
     * 内部ユーザーIDのセッター
     * @param internalUserId 内部ユーザーID
     */
    public void setInternalUserId(int internalUserId) {
        this.internalUserId = internalUserId;
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
}
