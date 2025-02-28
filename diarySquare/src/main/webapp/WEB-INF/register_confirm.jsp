<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>だいすく新規アカウント登録確認</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
<h1>だいすく ～diary square～</h1>
<h2>アカウント新規登録</h2>
<h3>入力情報確認</h3>
<h4>メールアドレス</h4>
<p>${registerUser.email}</p>
<h4>ユーザーID</h4>
<p>${registerUser.userId}</p>
<h4>ユーザー名</h4>
<p>${registerUser.userName}</p>
<h4>パスワード</h4>
<p id="pwd" value="${registerUser.pwdLength}"></p>
<h4>生年月日</h4>
<p id="dob" value="${registerUser.dob}"></p>
<h4>性別</h4>
<p id="sex" value="${registerUser.sex}"></p>
<form style="display: inline-block" action="register" method="post" id="formModify" class="inlineForm">
  <input type="hidden" name="state" value="modify" />
  <input type="button" value="修正する" id="modifyButton">
</form>
<form style="display: inline-block" action="register" method="post" id="formExecute" class="inlineForm">
  <input type="hidden" name="state" value="execute" />
  <input type="button" value="登録する" id="executeButton">
</form>
<script>
const pwd = document.getElementById('pwd');
const dob = document.getElementById('dob');
const sex = document.getElementById('sex');

// ページ読み込み時にパスワード、生年月日、性別を変換して表示する。
window.addEventListener('load', function() {
  pwd.innerHTML = '*'.repeat(pwd.getAttribute('value')); 

  let dobValue = dob.getAttribute('value');
  if (dobValue == '') {
    dob.innerHTML = '登録しない';
  } else {
    dob.innerHTML = dobValue.slice(0, 4) + '年'
                          + dobValue.slice(4, 6) + '月'
                          + dobValue.slice(6) + '日';
  }

  switch (sex.getAttribute('value')) {
    case '1':
      sex.innerHTML = '男性';
      break;
    case '2':
      sex.innerHTML = '女性';
      break;
    case '9':
      sex.innerHTML = 'その他';
      break;
    case '0':
      sex.innerHTML = '回答しない';
      break;
    default:
  }
});

const modifyButton = document.getElementById('modifyButton');

//修正ボタン押下時に、登録画面へ遷移。
modifyButton.addEventListener('click', function() {
  formModify.requestSubmit();
});

const executeButton = document.getElementById('executeButton');

// 登録ボタン押下時に、登録を実行。
executeButton.addEventListener('click', function() {
  formExecute.requestSubmit();
});
</script>
</body>
</html>