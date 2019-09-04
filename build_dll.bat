setlocal
pushd %~dp0
  cargo build --release --target i686-pc-windows-msvc 
  popd