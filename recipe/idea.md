# recipe 検討例

## 注意事項

この文章は古いものであり、現在の仕様を表すものではない。
アイデアの参考にするためだけに残す。


## GA的トーク決定アルゴリズム

* 現在の状態と、新たに選択されたトークの属性を
  交配させることにより、次に一致するトークを選ぶ。

＃トーク(generator fn)は「・」か、「・・」で始まる
＃タイトル（「～」）は省略可能
＃「：」以降は属性。状態と比較し、属性が一致しなければ対象外となる。
・・今日のご飯　：会話、季節？夏～秋、時刻？夕方、好感度？お客さん～

　　今日のご飯は＠今日のご飯＄１　でした。
　　＠１　って美味しいの？




＃単語(enum)辞書は「？」か、「？？」で始まる。
？？今日のご飯
　カレー
　チャーハン
　うどん

？好感度
無関心
普通
お客さん
気になる
好き
大好き

？不快度
無関心
いや
嫌い
大嫌い





＃「・」、「？」が１つのタイトルは重複不可


＃「・・」、「？？」は重複可能、マージされる





## recipe peg

// １：全体定義[start]
start = eof
      / block start
      / comment_line start

block = comment_line
      /





// ２：行の定義
line = comment_line
     / element_line

// ２．１：コメント行
// [#]で始まり、改行の手前で終わる。
comment_line = sharp !(eol)*:text eol

// ２．２：会話行
// ０個以上の空白の後に、会話inline要素が列挙され、が列挙される。
element_line = b:blank e:element* { return ast.element_line({brank: b}, e, loc());}
blank = s:SP* {return text(); }


// ３．１：会話行：inline要素
element = text
        / keyword


// ３．２：テキスト
text   = text:(esc / normal)+ { return ast.text(text.join(""), loc()); }
esc    = &(KEY_MARK KEY_MARK) . mark:. { return [mark]; }
normal = NORMAL_CHAR+ { return text(); }

// ３．３：キーワード

// ３．３．１：キーワード全体定義
keyword      =  body:keyword_body SPLIT { return body; }
keyword_mark = &KEY_MARK .
keyword_body = keyword_mark item:keyword_item { return item.func(item.key, loc()); }
keyword_item = keyword_local_anchor
             / keyword_local_jump
             / keyword_normal

// ３．３．２：キーワード
// 「＠keyword」一般
keyword_normal       =                        key:IDENTIFIER { return {key: key, func: ast.keyword_normal}; }

// ３．３．３：キーワード
// 「＠－keyword」一致するローカルアンカーのいずれかに飛ぶ
keyword_local_jump   = (&LOCAL_JUMP_CHAR  ) . key:IDENTIFIER { return {key: key, func: ast.keyword_local_jump}; }

// ３．３．４：キーワード
// 「＠：keyword」ローカルアンカー
keyword_local_anchor = (&LOCAL_ANCHOR_CHAR) . key:IDENTIFIER { return {key: key, func: ast.keyword_local_anchor}; }



// ９：一般トークン
BR          = LineTerminatorSequence
SP          = WhiteSpace
IDENTIFIER  = a:Identifier  {return a.name;}
SPLIT       = SP* / &BR
KEY_MARK    = [@＠]
KEY_CHAR    = [^@＠ 　\r\n]
PRI_COMMENT = [#＃]
NOT_BR      = !BR .
NORMAL_CHAR = [^@＠￥\r\n]
LOCAL_JUMP_CHAR   = [－ー-]
LOCAL_ANCHOR_CHAR = [：:]

