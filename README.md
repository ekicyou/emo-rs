# emo
rust &amp; lua SHIORI implement.


## ghostディレクトリ構成
|[load_dir]\share       |emo共有ファイル      |
|[load_dir]\usr         |個別ファイル         |


### luaスクリプトのパス解決
 * [load_dir]\usr\?.lua
 * [load_dir]\usr\?\init.lua
 * [load_dir]\share\?.lua
 * [load_dir]\share\?\init.lua
 * luaスクリプトとして解決できない場合、pastaスクリプトとして解決

### pastaスクリプトのパス解決
 * [load_dir]\usr\?.pasta
 * [load_dir]\usr\?\init.pasta
 * [load_dir]\share\?.pasta
 * [load_dir]\share\?\init.pasta

