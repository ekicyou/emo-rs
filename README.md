# emo

rust &amp; lua SHIORI implement.


## ghostディレクトリ構成
|{load_dir}\share       |emo共有ファイル      |
|{load_dir}\usr         |個別ファイル         |


### luaスクリプトのパス解決
* {load_dir}\usr\?.lua
* {load_dir}\usr\?\init.lua
* {load_dir}\share\?.lua
* {load_dir}\share\?\init.lua
* luaスクリプトとして解決できない場合、pastaスクリプトとして解決

### pastaスクリプトのパス解決
* {load_dir}\usr\?.pasta
* {load_dir}\usr\?\init.pasta
* {load_dir}\share\?.pasta
* {load_dir}\share\?\init.pasta


## lua呼び出しの引数

### shiori.load(hinst,ansi_load_dir)
|引数          |内容                                               |
|:-------------|:--------------------------------------------------|
|hinst         |emo.dllのインスタンスid                            |
|ansi_load_dir |emo.dllのディレクトリパス（日本語環境下ではcp932） |

### shiori.unload()
unloadに引数はない

### shiori.request(req)
|引数                 |内容                                        |
|:--------------------|:-------------------------------------------|
|req                  |utf-8としてSHIORI REQUESTを解析したテーブル |
|req.method           |get / notify                                |
|req.version          |30であること                                |
|req.charset          |utf-8であること                             |
|req.id               |event id                                    |
|req.base_id          |                                            |
|req.status           |                                            |
|req.security_level   |                                            |
|req.sender           |                                            |
|req.reference`[num]` |reference0～n,但しreference0のときnum=0     |
|req.dic`[key]`:      |すべての値を辞書テーブルで保管              |
