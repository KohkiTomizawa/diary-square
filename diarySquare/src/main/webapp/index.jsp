<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>だいすくログイン</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
<h1>だいすく ～diary square～</h1>
<h2>ログイン</h2>
<form action="login" method="post" id="form">
<h3>ユーザーIDまたはメールアドレス</h3>
<input type="text" name="userIdOrEmail" id="userIdOrEmail" maxlength="30" /><br />
(半角英数および記号)<br />
<h3>パスワード</h3>
<input type="password" name="pwd" id="pwd" maxlength="20" />
<button type="button" id="displayToggleButton">表示する</button><br />
(半角の英字と数字の組み合わせ8～20桁)<br />
<input type="button" value="ログイン" id="submitButton" class="invalidSubmitButton" /><br />
初めてご利用の方は<a href="register.jsp">アカウント新規登録</a>をお願いします
</form>
<script>
const form = document.getElementById('form');
const userIdOrEmail = document.getElementById('userIdOrEmail');
const pwd = document.getElementById('pwd');
const submitButton = document.getElementById('submitButton');

// すべてのフォームに入力されているとき、ログインボタンを有効にする
// 有効/無効の切り替えはcssに実装
form.addEventListener('input', function() {
  if (userIdOrEmail.value === '' || pwd.value === '') {
    submitButton.className = 'invalidSubmitButton';
  } else {
    submitButton.className = 'validSubmitButton';
  }
});

// ログインボタン押下時に送信を行う(送信先はformタグに記述)
submitButton.addEventListener('click', function() {
  form.requestSubmit();
});

const displayToggleButton = document.getElementById('displayToggleButton');

// 表示/非表示ボタン押下により、パスワード入力欄のtypeをpassword←→textに切り替える
// 同時にボタンの表記を表示←→非表示に変化させる
displayToggleButton.addEventListener('click', function() {
  switch (pwd.type) {
    case 'password':
      pwd.type = 'text';
      displayToggleButton.innerHTML = '表示しない'
      break;
    case 'text':
      pwd.type = 'password';
      displayToggleButton.innerHTML = '表示する'
      break;
    default:
  }
});
</script>
</body>
</html>