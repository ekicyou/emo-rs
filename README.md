# emo

rust &amp; lua SHIORI implement.


## ghostディレクトリ構成
|ディレクトリ                |解説                                |
|----------------------------|:-----------------------------------|
|`load_dir`\emo.dll          |emo shiori本体                      |
|`load_dir`\emo              |emoフレームワーク（変更しないこと） |
|`load_dir`\dic              |ユーザー辞書                        |
|`load_dir`\profile/emo/save |ユーザー save dataの保存先          |

### luaスクリプトのパス解決
|No|luaスクリプトの検索パス                |解説              |
|-:|:--------------------------------------|:-----------------|
| 1|`load_dir`/profile/emo/save/?.lua      |save data         |
| 2|`load_dir`/profile/emo/save/?/init.lua |                  |
| 3|`load_dir`/dic/?.lua                   |ユーザー辞書      |
| 4|`load_dir`/dic/?/init.lua              |                  |
| 5|`load_dir`/emo/?.lua                   |emoフレームワーク |
| 6|`load_dir`/emo/?/init.lua              |                  |

## lua呼び出しの引数

### shiori.load(hinst,ansi_load_dir)
shioriをロードする。

|引数            |内容                                                     |
|:---------------|:--------------------------------------------------------|
|`hinst`         |emo.dllのインスタンスid                                  |
|`ansi_load_dir` |emo.dllのディレクトリパス（ANSI、日本語環境下ではcp932） |


### shiori.unload()
shioriをアンロードする。
unloadに引数はない

### shiori.request(req)
shiori requestに応答する。

|引数                 |内容                                        |
|:--------------------|:-------------------------------------------|
|`req`                |utf-8としてSHIORI REQUESTを解析したテーブル |
|`req.method`         |get / notify                                |
|`req.version`        |30であること                                |
|`req.charset`        |utf-8であること                             |
|`req.id`             |event id                                    |
|`req.base_id`        |                                            |
|`req.status`         |                                            |
|`req.security_level` |                                            |
|`req.sender`         |                                            |
|`req.reference[num]` |reference0～n,ただしreference0のときnum=0   |
|`req.dic[key]`:      |すべての値を辞書テーブルで保管              |
