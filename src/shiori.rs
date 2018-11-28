use rlua::{Lua, Table};
use shiori3::*;
use std::borrow::Cow;
use std::path::Path;
use std::path::PathBuf;

pub struct EmoShiori {
    h_inst: usize,
    load_dir: PathBuf,
    lua: Lua,
}
impl Drop for EmoShiori {
    fn drop(&mut self) {}
}
impl EmoShiori {
    fn h_inst(&self) -> usize {
        (self.h_inst)
    }
    fn load_dir(&self) -> &Path {
        &(self.load_dir)
    }
    fn lua(&self) -> &Lua {
        &(self.lua)
    }
}

impl Shiori3 for EmoShiori {
    fn load<P: AsRef<Path>>(h_inst: usize, load_dir: P) -> ShioriResult<Self> {
        let load_dir = load_dir.as_ref().to_path_buf();
        let lua = Lua::new();
        Ok(EmoShiori {
            h_inst: h_inst,
            load_dir: load_dir,
            lua: lua,
        })
    }
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> ShioriResult<Cow<'a, str>> {
        let req_str = req.into();
        let req = ShioriRequest::parse(req_str)?;
        let rc = format!("[{:?}]{} is OK", self.load_dir, req_str);
        Ok(rc.into())
    }
}
