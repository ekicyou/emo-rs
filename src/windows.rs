#![cfg(any(windows))]
use crate::shiori::Shiori;
use shiori3::api::*;
use lazy_static::*;
use std::default::Default;
use winapi::shared::minwindef::{DWORD, HGLOBAL, LPVOID};

lazy_static! {
    static ref api: impl RawShiori3 =  Shiori3DI::new(Shiori::new());
}

#[no_mangle]
pub extern "C" fn load(h_dir: HGLOBAL, len: usize) -> bool {
    (*api).raw_load(h_dir, len)
}

#[no_mangle]
pub extern "C" fn unload() -> bool {
    (*api).raw_unload()
}

#[no_mangle]
pub extern "C" fn request(h: HGLOBAL, len: &mut usize) -> HGLOBAL {
    (*api).raw_request(h, len)
}

#[no_mangle]
pub extern "stdcall" fn DllMain(
    h_inst: usize,
    ul_reason_for_call: DWORD,
    lp_reserved: LPVOID,
) -> bool {
    (*api).raw_shiori3_dll_main(h_inst, ul_reason_for_call, lp_reserved)
}
