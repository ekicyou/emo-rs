#[cfg(feature = "builtin-lua")]
extern crate cc;

#[cfg(feature = "system-lua")]
extern crate pkg_config;

fn main() {
    if cfg!(all(feature = "builtin-lua", feature = "system-lua")) {
        panic!("cannot enable both builtin-lua and system-lua features when building rlua");
    }

    #[cfg(feature = "builtin-lua")]
    {
        use std::env;

        let target_os = env::var("CARGO_CFG_TARGET_OS");
        let target_family = env::var("CARGO_CFG_TARGET_FAMILY");

        let mut config = cc::Build::new();

        if target_os == Ok("linux".to_string()) {
            config.define("LUA_USE_LINUX", None);
        } else if target_os == Ok("macos".to_string()) {
            config.define("LUA_USE_MACOSX", None);
        } else if target_family == Ok("unix".to_string()) {
            config.define("LUA_USE_POSIX", None);
        } else if target_family == Ok("windows".to_string()) {
            config.define("LUA_USE_WINDOWS", None);
        }

        if cfg!(debug_assertions) {
            config.define("LUA_USE_APICHECK", None);
        }

        config
            .include("c/lua")
            .file("c/lua/lapi.c")
            .file("c/lua/lauxlib.c")
            .file("c/lua/lbaselib.c")
            .file("c/lua/lbitlib.c")
            .file("c/lua/lcode.c")
            .file("c/lua/lcorolib.c")
            .file("c/lua/lctype.c")
            .file("c/lua/ldblib.c")
            .file("c/lua/ldebug.c")
            .file("c/lua/ldo.c")
            .file("c/lua/ldump.c")
            .file("c/lua/lfunc.c")
            .file("c/lua/lgc.c")
            .file("c/lua/linit.c")
            .file("c/lua/liolib.c")
            .file("c/lua/llex.c")
            .file("c/lua/lmathlib.c")
            .file("c/lua/lmem.c")
            .file("c/lua/loadlib.c")
            .file("c/lua/lobject.c")
            .file("c/lua/lopcodes.c")
            .file("c/lua/loslib.c")
            .file("c/lua/lparser.c")
            .file("c/lua/lstate.c")
            .file("c/lua/lstring.c")
            .file("c/lua/lstrlib.c")
            .file("c/lua/ltable.c")
            .file("c/lua/ltablib.c")
            .file("c/lua/ltm.c")
            .file("c/lua/lundump.c")
            .file("c/lua/lutf8lib.c")
            .file("c/lua/lvm.c")
            .file("c/lua/lzio.c")
            .compile("liblua5.3.a");
    }

    #[cfg(feature = "system-lua")]
    {
        pkg_config::Config::new()
            .atleast_version("5.3")
            .probe("lua")
            .unwrap();
    }
}
