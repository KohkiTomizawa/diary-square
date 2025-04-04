<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>だいすく新規アカウント登録</title>
<link rel="stylesheet" href="css/style.css" />
<script src="http://localhost:8080/diarySquare/js/jquery-3.7.1.min.js"></script>
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
<input type="email" name="confirmEmail" id="confirmEmail" class="txt" maxlength="30"  placeholder="(例)xxxx@xxxx.com"
       value="${registerUser.confirmEmail}">
<p id="confirmEmailAttention" class="attention">&nbsp;</p>
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
以下の半角記号は使用できません。 &lt; &gt; &amp; &quot; &#39;
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
<input type="button" value="確認画面へ" id="submitButton" class="invalidSubmitButton" />
</form>
<script>
// １つのEventTargetに対して、同じ関数のイベントリスナーを複数設定する関数
function addMultiEventListener(eventTarget, func, ...eventTypes) {
  eventTypes.forEach(function(eventType) {
    eventTarget.addEventListener(eventType, func);
  });
}

// 上記の関数の代わりに下記のようにも記述可能
//['type1', 'type2', ...].forEach(function(eventType) {
  //eventTarget.addEventListener(eventType, func);
//});

// そもそも、jQueryを使えば以下のようにeventTypeを併記するだけでよい
// (今回は極力jQueryを用いずに記述したかったため未使用)
//$(eventTarget).on('type1 type2', func);

// プロパティの変更に連動して第３引数の関数を実行する関数
function watchValue(obj, propertyName, callback) {
  let value = obj[propertyName];
  Object.defineProperty(obj, propertyName, {
    get: function() {
      return value;
    },
    set: function(newValue) {
      value = newValue;
      callback(newValue);
    }
  });
}

// すべてのフォームが正規表現を満たしているかどうか、ビット演算にて管理するためのフラグ
// 生年月日(6ビット目)は未入力可のため初期値でフラグを立てておく
let submit = { flags: 0b00000000000000000000000000100000 };

// 各入力欄のフラグを管理するための定数
// ※const FLAG = { EMAIL = 1 << 0, CONFIRM_EMAIL = 1 << 1, ... };
//   のようにFLAGオブジェクトのプロパティとして定義したほうが見やすいが、
//   constはプロパティの変更を防げない("use strict";を記述すれば(strict mode)、
//   Object.freeze()によりオブジェクトを凍結できるが今回は使用しない)
const EMAIL_FLAG         = 1 << 0;  // 0b 0000 0000 0000 0000 0000 0000 0000 0001
const CONFIRM_EMAIL_FLAG = 1 << 1;  // 0b 0000 0000 0000 0000 0000 0000 0000 0010
const USER_ID_FLAG       = 1 << 2;  // 0b 0000 0000 0000 0000 0000 0000 0000 0100
const USER_NAME_FLAG     = 1 << 3;  // 0b 0000 0000 0000 0000 0000 0000 0000 1000
const PWD_FLAG           = 1 << 4;  // 0b 0000 0000 0000 0000 0000 0000 0001 0000
const DOB_FLAG           = 1 << 5;  // 0b 0000 0000 0000 0000 0000 0000 0010 0000

// -------------------------------------------------------------------------------------------------------------------------------
// ＜JavaScriptにおけるビット演算について＞
//
//   JavaScriptでは、ビット演算子を用いると強制的に符号あり32ビット整数に変換される(1 << 0が良い例)
//   (ただし、後述の符号なし右シフト(>>>)のみ、符号なし32ビット整数に変換される)
//   先頭のビット(32ビット目)は数値ではなく符号を表し、0なら正、1なら負となる(「2の補数表現」と呼ばれる)
//   よって、JavaScriptのビット演算では、10進数の2147483647(2 ** 31 - 1) 〜 -2147483648の範囲の整数を扱うことができる
//   なお、正の32ビット整数を反転(否定)してから1を足すことで、同じ絶対値の負の32ビット整数に変換できる
//   (または、1引いてから反転しても同様に変換できる。負から正にする際も同じ操作で可能)
//   (例)[1]0b 0111 1111 1111 1111 1111 1111 1111 1111 // 2147483647
//       [2]0b 1000 0000 0000 0000 0000 0000 0000 0000 // -2147483648(~[1])
//       [3]0b 1000 0000 0000 0000 0000 0000 0000 0001 // -2147483647([2] + 1)
//
//       [1]0b 0111 1111 1111 1111 1111 1111 1111 1111 // 2147483647
//     + [3]0b 1000 0000 0000 0000 0000 0000 0000 0001 // -2147483647
//     -----------------------------------------------
//          0b 0000 0000 0000 0000 0000 0000 0000 0000 // 0
//       (0b 1 0000 0000 0000 0000 0000 0000 0000 0000 の33ビット目がオーバーフローするため、0とみなせる)
//       (「ある数に足してゼロになる数(=[3])は、もとの数(=[1])のマイナスの数であるとみなせる」= 補数表現)
//
//   左シフト(<<)の場合、シフト前が正の整数でも、シフト後に32ビット目が1なら負の整数となる
//   (例)[1]0b 0100 0000 0000 0000 0000 0000 0000 0000 // 1073741824
//       [2]0b 1000 0000 0000 0000 0000 0000 0000 0000 // -2147483648([1] << 1)(符号なし32ビット整数であれば、2147483648)
//
//   右シフトには、符号保持右シフト(または、単に右シフト)、符号なし右シフト(または、ゼロ埋め右シフト)の2つがある
//   (1)符号保持右シフト(>>)では、元の整数が正なら0が、負なら1が補完され、符号あり32ビット整数に変換される
//      (例)[1]0b 0000 0000 0000 0000 0100 0000 0000 0000 // 16384
//          [2]0b 0000 0000 0000 0000 0000 0100 0000 0000 // 1024([1] >> 4)(1024 = 16384 / (2 ** 4))
//          [3]0b 1111 1111 1111 1111 1000 0000 0000 0000 // -16384(~[1] + 1)
//          [4]0b 1111 1111 1111 1111 1111 1000 0000 0000 // -1024([3] >> 4)(-1024 = -16384 / (2 ** 4))
//
//   (2)符号なし右シフト(>>>)では、元の整数の正負を問わず、かならず0が補完され、符号なし32ビット整数に変換される
//      (例)[1]0b 1111 1111 1111 1111 1000 0000 0000 0000 // -16384(符号なし32ビット整数では、4294934528)
//          [2]0b 0000 1111 1111 1111 1111 1000 0000 0000 // 268433408([1] >>> 4)(268433408 = 4294934528 / (2 ** 4))
//          [3]0b 1000 0000 0000 0000 0100 0000 0000 0000
//          [4]0b 1000 0000 0000 0000 0100 0000 0000 0000 // -2147467264([3] >> 0)
//            (0b 0111 1111 1111 1111 1100 0000 0000 0000 // 2147467264(~[4] + 1))
//          [5]0b 1000 0000 0000 0000 0100 0000 0000 0000 // 2147500032([3] >>> 0)←符号なし32ビット整数のため、2147483647を超える
//          (↑[4]と[5]はまったく同じに見えるが、[4]は符号あり32ビット整数、[5]は符号なし32ビット整数)
// -------------------------------------------------------------------------------------------------------------------------------

const submitButton = document.getElementById('submitButton');

// すべてのフォームに正しい値が入力されているとき(*のないフォームは未入力も可)に送信ボタンを有効にする
// 有効/無効の切り替えはcssにより実装

// Ajax内だと、inputからflag変更まで時間がかかり、
// flag変更前にチェックが実行されてしまうため、イベントリスナーは使用できない
//form.addEventListener('input', function() {
  //if (submitFlags === 0b111111) {
    //submitButton.className = 'validSubmitButton';
  //} else {
    //submitButton.className = 'invalidSubmitButton';
  //}
//});

// submit.flagsの変更(セッター実行)時に値をチェックし、
// 「確認」ボタンの有効化/無効化を行う
watchValue(submit, 'flags', function() {
  if (submit.flags === 0b00000000000000000000000000111111) {
    submitButton.className = 'validSubmitButton';
  } else {
    submitButton.className = 'invalidSubmitButton';
  }
});

// 各フォームの未入力および正規表現をチェックし、フォーム下に注意文を追加する
// *のフォームの場合は、正規表現を満たしたらフラグを立て、未入力および正規表現を満たさなかったらフラグを折る
// *のないフォームの場合は、未入力および正規表現を満たしたらフラグを立て、正規表現を満たさなかったらフラグを折る
const email = document.getElementById('email');
const emailAttention = document.getElementById('emailAttention');

function checkEmail() {
  if (email.value === '') {
    emailAttention.innerHTML = 'メールアドレスを入力してください。';
    submit.flags &= ~EMAIL_FLAG;
  } else if (!email.value.match(/^[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$/)) {
    emailAttention.innerHTML = 'メールアドレスを正しく入力してください。';
    submit.flags &= ~EMAIL_FLAG;
  } else {
    emailAttention.innerHTML = '&nbsp;';
    submit.flags |= EMAIL_FLAG;
  }
}
addMultiEventListener(email, checkEmail, 'focusout', 'input');

const confirmEmail = document.getElementById('confirmEmail');
const confirmEmailAttention = document.getElementById('confirmEmailAttention');

function checkConfirmEmail() {
  if (confirmEmail.value === '') {
    confirmEmailAttention.innerHTML = 'メールアドレスを入力してください。';
    submit.flags &= ~CONFIRM_EMAIL_FLAG;
  } else if (!confirmEmail.value.match(/^[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$/)) {
    confirmEmailAttention.innerHTML = 'メールアドレスを正しく入力してください。';
    submit.flags &= ~CONFIRM_EMAIL_FLAG;
  } else {
    confirmEmailAttention.innerHTML = '&nbsp;';
    submit.flags |= CONFIRM_EMAIL_FLAG;
  }
}
addMultiEventListener(confirmEmail, checkConfirmEmail, 'focusout', 'input');

const userId = document.getElementById('userId');
const userIdAttention = document.getElementById('userIdAttention');

let timerId = null;

// timerIdが空でければ、既存のtimerをキャンセルし、
// classを"attention"にする
function clearTimer() {
  if (timerId !== null) {
    window.clearTimeout(timerId);
    userIdAttention.className = 'attention';
  }
}

function checkUserId() {
  if (userId.value === '') {
    userIdAttention.innerHTML = 'ユーザーIDを入力してください。';
    submit.flags &= ~USER_ID_FLAG;
    clearTimer();
  } else if (!userId.value.match(/^[a-zA-Z0-9]+$/)) {
    userIdAttention.innerHTML = '半角英数字で入力してください。';
    submit.flags &= ~USER_ID_FLAG;
    clearTimer();
  } else {
    userIdAttention.innerHTML = '&nbsp;';
    submit.flags &= ~USER_ID_FLAG;
    clearTimer();

    // timerIdを生成し、指定時間(1000 ms)後に非同期処理を呼び出す
    timerId = window.setTimeout(function() {
        
      // 非同期処理のメソッドは後述
      checkUserIdIsRegisterdAsync();
      
    }, 1000);
  }
}
userId.addEventListener('input', checkUserId);

// userIdでは、'focusout'は未入力チェックのみにする
// ('focusout'によってajaxが再度動作しないようにするため)
userId.addEventListener('focusout', function() {
  if (userId.value === '') {
    userIdAttention.innerHTML = 'ユーザーIDを入力してください。';
    submit.flags &= ~USER_ID_FLAG;
  }
});

// 非同期処理によりデータベースと重複しているかチェックする
function checkUserIdIsRegisterdAsync() {

  // メッセージの文字色を変更するためにclassを変更し、メッセージを表示
  userIdAttention.className = 'checking';
  userIdAttention.innerHTML = userId.value + 'が登録済みか確認しています。'

  // リクエストJSON
  let request = {
    state : 'checkUserId',
    userId: userId.value
  };

  // ajaxにより非同期処理を実行
  $.ajax({
    type   : 'GET',       // RegisterServletのdoGETメソッドにより非同期処理を実行
    url    : 'register',  // RegisterServletにリクエストを送信
    data   : request,
    async  : true,
    success: function(data) {
      switch (data['result']) {
        case 'error':
          userIdAttention.className = 'attention';
          userIdAttention.innerHTML = 'エラーが発生しました。<br />恐れ入りますが、入力し直してください。';
          submit.flags &= ~USER_ID_FLAG;
          break;
        case 'registerd':
          userIdAttention.className = 'attention';
          userIdAttention.innerHTML = userId.value +
              'はすでに登録されています。<br />別のIDを入力してください。';
          submit.flags &= ~USER_ID_FLAG;
          break;
        case 'unregisterd':
          userIdAttention.className = 'unregisterd';
          userIdAttention.innerHTML = userId.value + 'は使用可能です。';
          submit.flags |= USER_ID_FLAG;
          break;
        default:
          userIdAttention.className = 'attention';
          userIdAttention.innerHTML = 'エラーが発生しました。<br />恐れ入りますが、入力し直してください。';
          submit.flags &= ~USER_ID_FLAG;
      }
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      userIdAttention.className = 'attention';
      userIdAttention.innerHTML = 'エラーが発生しました。<br />恐れ入りますが、入力し直してください。';
      submit.flags &= ~USER_ID_FLAG;
    }
  });
}

const userName = document.getElementById('userName');
const userNameAttention = document.getElementById('userNameAttention');

function checkUserName() {
  if (userName.value === '') {
    userNameAttention.innerHTML = 'ユーザー名を入力してください。';
    submit.flags &= ~USER_NAME_FLAG;
  } else if (!userName.value.match(/^[^<>&"']+$/)) {
    userNameAttention.innerHTML = '使用できない文字が含まれています。';
    submit.flags &= ~USER_NAME_FLAG;
  } else {
    userNameAttention.innerHTML = '&nbsp;';
    submit.flags |= USER_NAME_FLAG;
  }
}
addMultiEventListener(userName, checkUserName, 'focusout', 'input');

const pwd = document.getElementById('pwd');
const pwdAttention = document.getElementById('pwdAttention');

function checkPwd() {
  if (pwd.value === '') {
    pwdAttention.innerHTML = 'パスワードを入力してください。';
    submit.flags &= ~PWD_FLAG;
  } else if (pwd.value.length < 8 || 20 < pwd.value.length) {
    pwdAttention.innerHTML = '8文字以上20文字以内で入力してください。'
    submit.flags &= ~PWD_FLAG;
  } else if (!pwd.value.match(/^[a-zA-Z0-9]+$/)) {
    pwdAttention.innerHTML = '半角英数字で入力してください。';
    submit.flags &= ~PWD_FLAG;
  } else if (!pwd.value.match(/^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$/)) {
    pwdAttention.innerHTML = '半角英字と半角数字を両方使用してください。';
    submit.flags &= ~PWD_FLAG;
  } else {
    pwdAttention.innerHTML = '&nbsp;';
    submit.flags |= PWD_FLAG;
  }
}
addMultiEventListener(pwd, checkPwd, 'focusout', 'input');

const dob = document.getElementById('dob');
const dobAttention = document.getElementById('dobAttention');

function checkDob() {

  // dobの最大入力文字数を8文字以下に制限する
  // (input type="number"には、maxlengthが使用できないため)
  let slicedDob = dob.value.slice(0, 8);
  dob.value = slicedDob;
  
  if (slicedDob === '') {
    dobAttention.innerHTML = '&nbsp;';
    submit.flags |= DOB_FLAG;
  } else if (slicedDob.length < 8) {
    dobAttention.innerHTML = '生年月日の入力が未完了です。';
    submit.flags &= ~DOB_FLAG;
  } else {
    let yearOfBirth = Number(slicedDob.slice(0, 4));
    let monthOfBirth = Number(slicedDob.slice(4, 6));
    let dayOfBirth = Number(slicedDob.slice(6));
    let currentDate = new Date();
    let currentYear = Number(currentDate.getFullYear());
    
    if (yearOfBirth < 1900 || currentYear < yearOfBirth) {
      dobAttention.innerHTML = '正しい生年月日を入力してください。';
      submit.flags &= ~DOB_FLAG;
    } else if (12 < monthOfBirth) {
      dobAttention.innerHTML = '正しい生年月日を入力してください。';
      submit.flags &= ~DOB_FLAG;
    } else {

      // endOfMonth(月の日数)により、入力された生年月日が正しいかチェックする関数
      function checkDobByEndOfMonth(endOfMonth) {
        if (dayOfBirth < 1 || endOfMonth < dayOfBirth) {
          dobAttention.innerHTML = '正しい生年月日を入力してください。';
          submit.flags &= ~DOB_FLAG;
        } else {
          dobAttention.innerHTML = '&nbsp;';
          submit.flags |= DOB_FLAG;
        }
      }
      
      switch (monthOfBirth) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
          checkDobByEndOfMonth(31);
          break;
        case 4:
        case 6:
        case 9:
        case 11:
          checkDobByEndOfMonth(30);
          break;
        case 2:
          if ((yearOfBirth % 4 === 0 && yearOfBirth % 100 !== 0) || yearOfBirth % 400 === 0) {
            checkDobByEndOfMonth(29);
          } else {
            checkDobByEndOfMonth(28);
          }
          break;
        default:
      }
    }
  }
}
dob.addEventListener('input', checkDob);

const displayToggleButton = document.getElementById('displayToggleButton');

// 表示/非表示ボタン押下により、パスワード入力欄のtypeをpassword←→textに切り替える
// 同時にボタンの表記を表示←→非表示に変化させる
displayToggleButton.addEventListener('click', function(){
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

const form = document.getElementById('form');

// ログインボタン押下時に送信を行う(送信先はformタグに記述)
submitButton.addEventListener('click', function(){
  // 送信時にbeforeunloadイベントが発火しないよう事前に破棄する
  window.removeEventListener('beforeunload',invalidateSession);
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

function checkAllTextBox() {
  checkEmail();
  checkConfirmEmail();
  checkUserId();
  checkUserName();
  checkDob();
}

// セッションスコープ内の登録ユーザーBeanのstateがregisterd/error/different/incorrectの場合、
// ページ読み込み時に各フォームの初期値をチェックしフラグ管理する(registerdの場合は代わりにEメールアドレスを空にする)
// registerd/error/differentの場合は、さらに注意文を追加する
// 上記以外の場合は、各フォームの初期値(value)を空にする
window.addEventListener('load', function() {
  switch (form.getAttribute('value')) {
    case 'registerd':
      checkedEmailAttention.innerHTML = email.getAttribute('value') +
          'はすでに登録されています。<br />別のメールアドレスをご利用ください。';
      email.value = '';
      confirmEmail.value = '';
      checkUserId();
      checkUserName();
      checkDob();
      break;
    case 'error':
      checkedEmailAttention.innerHTML = 'エラーが発生しました。<br />恐れ入りますが、時間をおいて再度お試しください。';
      checkAllTextBox();
      break;
    case 'different':
      checkedEmailAttention.innerHTML = '入力されたメールアドレスが一致していません。<br />よく確認してください。';
      checkAllTextBox();
      break;
    case 'incorrect':
      checkAllTextBox();
      break;
    default:
      email.value = '';
      confirmEmail.value = '';
      userId.value = '';
      userName.value = '';
      dob.value = '';
      sexList[3].checked = true;
  }
});

// タブ及びウィンドウが閉じられた際に、いずれかのテキストボックスに
// 入力が残っている場合はセッションスコープを破棄する
// (送信時に発火しないよう、送信ボタンクリックイベント内で本イベントリスナーを破棄する)
function invalidateSession(event) {
  if (email.value !== '' || confirmEmail.value !== '' ||
        userId.value !== '' || userName.value !== '' || dob.value !== '') {

    event.preventDefault();
    event.returnValue = '';

    invalidateSessionAsync();
  }
}

window.addEventListener('beforeunload',invalidateSession);

//非同期処理によりセッションスコープを破棄する
function invalidateSessionAsync() {

  // リクエストJSON
    let request = {
      state: 'beforeClose'
    };

  // ajaxにより非同期処理を実行
  $.ajax({
    type : 'GET',       // RegisterServletのdoGETメソッドにより非同期処理を実行
    url  : 'register',  // RegisterServletにリクエストを送信
    data : request,
    async: true
  });
}
</script>
</body>
</html>