<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>だいすく新規アカウント登録</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
<h1>だいすく ～diary square～</h1>
<h2>アカウント新規登録</h2>
<h3>会員情報</h3>
<h4>＊：必須項目</h4>
<p id="checkedEmailAttention" class="attention">&nbsp;</p>
<form action="register" method="post" id="form" value="${state}">
<input type="hidden" name="state" value="confirm" />
<h4>メールアドレス *</h4>
<input type="email" name="email" id="email" class="txt" maxlength="30" placeholder="(例)xxxx@xxxx.com"
       value="${registerUser.email}">
<p id="emailAttention" class="attention">&nbsp;</p>
30文字以内のメールアドレスを入力してください。
<h4>メールアドレス(確認用) *</h4>
<input type="email" name="emailConfirm" id="emailConfirm" class="txt" maxlength="30"  placeholder="(例)xxxx@xxxx.com"
       value="${registerUser.emailConfirm}">
<p id="emailConfirmAttention" class="attention">&nbsp;</p>
<h4>ユーザーID *</h4>
<input type="text" name="userId" id="userId" class="txt" maxlength="20" placeholder="(例)abc123"
       value="${registerUser.userId}">
<p id="userIdAttention" class="attention">&nbsp;</p>
新規登録完了後にも変更できます。<br />
既存ユーザーと同じIDを登録することはできません。<br />
半角英数のみ、20文字以内で入力してください。
<h4>ユーザー名 *</h4>
<input type="text" name="userName" id="userName" class="txt" maxlength="20" placeholder="(例)だいすく"
       value="${registerUser.userName}">
<p id="userNameAttention" class="attention">&nbsp;</p>
新規登録完了後にも変更できます。<br />
20文字以内で入力してください。<br />
以下の記号は使用できません。 &lt; &gt; &amp; &quot; &#39;
<h4>パスワード *</h4>
<input type="password" name="pwd" id="pwd" class="txt" maxlength="20" placeholder="パスワードを入力してください。" />
<button type="button" id="displayToggleButton">表示する</button>
<p id="pwdAttention" class="attention">&nbsp;</p>
半角の英字と数字の組み合わせで、8文字以上20文字以内で入力してください。<br />
記号は使用できません。
<h4>生年月日</h4>
<input type="number" name="dob" id="dob" class="txt noSpin" placeholder="(例)1999年1月2日→19990102"
       value="${registerUser.dob}" />
<p id="dobAttention" class="attention">&nbsp;</p>
年月日を連続した8桁の数字で入力してください。<br />
あとから登録することも可能です。<br />
生年月日は一度登録すると変更することはできません。
<h4 id="sex" value="${registerUser.sex}">性別</h4>
<input type="radio" id="sex1" name="sex" value="1" />
  <label for="sex1">男性</label>
<input type="radio" id="sex2" name="sex" value="2" />
  <label for="sex2">女性</label>
<input type="radio" id="sex9" name="sex" value="9" />
  <label for="sex9">その他</label>
<input type="radio" id="sex0" name="sex" value="0" />
  <label for="sex0">回答しない</label><br />
あとから登録することも可能です。<br />
<input type="button" value="確認画面へ" id="submitButton" class="notAllowedSubmitButton">
</form>
<script>
//すべてのフォームが正規表現を満たしているかどうか、ビット演算にて管理するためのフラグ
//生年月日は未入力可のため初期値でフラグを立てておく
let submitFlags = 0b100000;

// 各フォームの未入力および正規表現をチェックし、フォーム下に注意文を追加する
// *のフォームの場合は、正規表現を満たしたらフラグを立て、未入力および正規表現を満たさなかったらフラグを折る
// *のないフォームの場合は、未入力および正規表現を満たしたらフラグを立て、正規表現を満たさなかったらフラグを折る
const email = document.getElementById('email');
const emailAttention = document.getElementById('emailAttention');

function emailCheck() {
  if (email.value === '') {
    emailAttention.innerHTML = 'メールアドレスを入力してください。';
    submitFlags &= (~0b000001);
  } else if (!email.value.match(/^[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$/)) {
    emailAttention.innerHTML = 'メールアドレスを正しく入力してください。';
    submitFlags &= (~0b000001);
  } else {
    emailAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b000001;
  }
}
email.addEventListener('focusout', emailCheck);
email.addEventListener('input', emailCheck);

const emailConfirm = document.getElementById('emailConfirm');
const emailConfirmAttention = document.getElementById('emailConfirmAttention');

function emailConfirmCheck() {
  if (emailConfirm.value === '') {
    emailConfirmAttention.innerHTML = 'メールアドレスを入力してください。';
    submitFlags &= (~0b000010);
  } else if (!emailConfirm.value.match(/^[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$/)) {
    emailConfirmAttention.innerHTML = 'メールアドレスを正しく入力してください。';
    submitFlags &= (~0b000010);
  } else {
    emailConfirmAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b000010;
  }
}
emailConfirm.addEventListener('focusout', emailConfirmCheck);
emailConfirm.addEventListener('input', emailConfirmCheck);

const userId = document.getElementById('userId');
const userIdAttention = document.getElementById('userIdAttention');

function userIdCheck() {
  if (userId.value === '') {
    userIdAttention.innerHTML = 'ユーザーIDを入力してください。';
    submitFlags &= (~0b000100);
  } else if (!userId.value.match(/^[a-zA-Z0-9]+$/)) {
    userIdAttention.innerHTML = '半角英数字で入力してください。';
    submitFlags &= (~0b000100);
  } else {
    userIdAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b000100;
  }
}
userId.addEventListener('focusout',userIdCheck);
userId.addEventListener('input',userIdCheck);

const userName = document.getElementById('userName');
const userNameAttention = document.getElementById('userNameAttention');

function userNameCheck() {
  if (userName.value === '') {
    userNameAttention.innerHTML = 'ユーザー名を入力してください。';
    submitFlags &= (~0b001000);
  } else if (!userName.value.match(/^[^<>&"']+$/)) {
    userNameAttention.innerHTML = '使用できない文字が含まれています。';
    submitFlags &= (~0b001000);
  } else {
    userNameAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b001000;
  }
}
userName.addEventListener('focusout', userNameCheck);
userName.addEventListener('input', userNameCheck);

const pwd = document.getElementById('pwd');
const pwdAttention = document.getElementById('pwdAttention');

function pwdCheck() {
  if (pwd.value === '') {
    pwdAttention.innerHTML = 'パスワードを入力してください。';
    submitFlags &= (~0b010000);
  } else if (pwd.value.length < 8 || 20 < pwd.value.length) {
    pwdAttention.innerHTML = '8文字以上20文字以内で入力してください。'
    submitFlags &= (~0b010000);
  } else if (!pwd.value.match(/^[a-zA-Z0-9]+$/)) {
    pwdAttention.innerHTML = '半角英数字で入力してください。';
    submitFlags &= (~0b010000);
  } else if (!pwd.value.match(/^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$/)) {
    pwdAttention.innerHTML = '半角英字と半角数字を両方使用してください。';
    submitFlags &= (~0b010000);
  } else {
    pwdAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b010000;
  }
}
pwd.addEventListener('focusout', pwdCheck);
pwd.addEventListener('input', pwdCheck);

const dob = document.getElementById('dob');
const dobAttention = document.getElementById('dobAttention');

function dobCheck() {
  let slicedDob = dob.value.slice(0, 8);
  dob.value = slicedDob;

  if (slicedDob === '') {
    dobAttention.innerHTML = '&nbsp;';
    submitFlags |= 0b100000;
  } else if (slicedDob.length < 8) {
    dobAttention.innerHTML = '生年月日の入力が未完了です。';
    submitFlags &= (~0b100000);
  } else {
    let yearOfBirth = Number(slicedDob.slice(0, 4));
    let monthOfBirth = Number(slicedDob.slice(4, 6));
    let dayOfBirth = Number(slicedDob.slice(6));
    let currentDate = new Date();
    let currentYear = Number(currentDate.getFullYear());

    if (yearOfBirth < 1900 || currentYear < yearOfBirth) {
      dobAttention.innerHTML = '正しい生年月日を入力してください。';
      submitFlags &= (~0b100000);
    } else if (12 < monthOfBirth) {
      dobAttention.innerHTML = '正しい生年月日を入力してください。';
      submitFlags &= (~0b100000);
    } else {
      switch (monthOfBirth) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
          if (dayOfBirth < 1 || 31 < dayOfBirth) {
            dobAttention.innerHTML = '正しい生年月日を入力してください。';
            submitFlags &= (~0b100000);
          } else {
            dobAttention.innerHTML = '&nbsp;';
            submitFlags |= 0b100000;
          }
          break;
        case 4:
        case 6:
        case 9:
        case 11:
          if (dayOfBirth < 1 || 30 < dayOfBirth) {
            dobAttention.innerHTML = '正しい生年月日を入力してください。';
            submitFlags &= (~0b100000);
          } else {
            dobAttention.innerHTML = '&nbsp;';
            submitFlags |= 0b100000;
          }
          break;
        case 2:
          if ((yearOfBirth % 4 === 0 && yearOfBirth % 100 !== 0) || yearOfBirth % 400 === 0) {
            if (dayOfBirth < 1 || 29 < dayOfBirth) {
              dobAttention.innerHTML = '正しい生年月日を入力してください。';
              submitFlags &= (~0b100000);
            } else {
              dobAttention.innerHTML = '&nbsp;';
              submitFlags |= 0b100000;
            }
          } else {
            if (dayOfBirth < 1 || 28 < dayOfBirth) {
              dobAttention.innerHTML = '正しい生年月日を入力してください。';
              submitFlags &= (~0b100000);
            } else {
              dobAttention.innerHTML = '&nbsp;';
              submitFlags |= 0b100000;
            }
          }
          break;
        default:
      }
    }
  }
}
dob.addEventListener('input', dobCheck);

const displayToggleButton = document.getElementById('displayToggleButton');

//表示/非表示ボタン押下により、パスワード入力欄のtypeをpassword←→textに切り替える
//同時にボタンの表記を表示←→非表示に変化させる
displayToggleButton.addEventListener('click', function(){
switch(pwd.type){
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

const form = document.getElementById('form');
const submitButton = document.getElementById('submitButton');

//すべてのフォームに正しい値が入力されているとき(*のないフォームは未入力も可)に送信ボタンを有効にする
//(submitFlags == 0b111111)
//有効/無効の切り替えはcssにより実装
form.addEventListener('input', function() {
if (submitFlags === 0b111111) {
 submitButton.className = 'allowedSubmitButton';
} else {
 submitButton.className = 'notAllowedSubmitButton';
}
});

// ログインボタン押下時に送信を行う(送信先はformタグに記述)
submitButton.addEventListener('click', function(){
  form.requestSubmit();
});

const sex = document.getElementById('sex');
const sexList = document.getElementsByName('sex');

// ページ読み込み時に登録ユーザーBeanのsexの値を取得し、
// 該当する性別ラジオボタンのcheckedを設定する(初期値は「回答しない」)
window.addEventListener('load', function() {
  switch (sex.getAttribute('value')) {
    case '1':
      sexList[0].checked = true;
      break;
    case '2':
      sexList[1].checked = true;
      break;
    case '9':
      sexList[2].checked = true;
      break;
    case '0':
      sexList[3].checked = true;
      break;
    default:
      sexList[3].checked = true;
  }
});

const checkedEmailAttention = document.getElementById('checkedEmailAttention');

// セッションスコープ内の登録ユーザーBeanのstateがdifferent/registerd/incorrectの場合、
// ページ読み込み時に各フォームの初期値をチェックしフラグ管理する(registerdの場合はEメールアドレスを除く)
// different/registerdの場合は、さらに注意文を追加する
// 上記以外の場合は、各フォームの初期値(value)を空にする
window.addEventListener('load', function() {
  if (form.getAttribute('value') === 'different' || form.getAttribute('value') === 'incorrect') {
    if (form.getAttribute('value') === 'different') {
      checkedEmailAttention.innerHTML = '入力されたメールアドレスが一致していません。よく確認してください。';
    }
    emailCheck();
    emailConfirmCheck();
    userIdCheck();
    userNameCheck();
    dobCheck();
  } else if (form.getAttribute('value') === 'registerd') {
    checkedEmailAttention.innerHTML = email.getAttribute('value') +
        'はすでに登録されています。<br />別のメールアドレスをご利用ください。';
    email.setAttribute('value', '');
    emailConfirm.setAttribute('value', '');
    userIdCheck();
    userNameCheck();
    dobCheck();
  } else {
    email.setAttribute('value', '');
    emailConfirm.setAttribute('value', '');
    userId.setAttribute('value', '');
    userName.setAttribute('value', '');
    dob.setAttribute('value', '');
    sexList[3].checked = true;
  }
});
</script>
</body>
</html>