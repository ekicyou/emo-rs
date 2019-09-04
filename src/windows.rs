#![cfg(any(windows))]
use crate::shiori::Shiori;
use lazy_static::*;
use log::*;
use shiori3::RawShiori3;
use std::default::Default;
use std::ptr;
use std::sync::{Arc, Mutex};
use winapi::shared::minwindef::{DWORD, HGLOBAL, LPVOID};

lazy_static! {
    static ref API: Arc<Mutex<RawShiori3<Shiori>>> = Arc::new(Mutex::new(Default::default()));
}

#[no_mangle]
pub extern "C" fn load(h_dir: HGLOBAL, len: usize) -> bool {
    match (*API).lock() {
        Err(e) => {
            error!("[emo::load] {}", e);
            false
        }
        Ok(mut a) => a.raw_load(h_dir, len),
    }
}

#[no_mangle]
pub extern "C" fn unload() -> bool {
    match (*API).lock() {
        Err(e) => {
            error!("[emo::unload] {}", e);
            false
        }
        Ok(mut a) => a.raw_unload(),
    }
}

#[no_mangle]
pub extern "C" fn request(h: HGLOBAL, len: &mut usize) -> HGLOBAL {
    match (*API).lock() {
        Err(e) => {
            error!("[emo::request] {}", e);
            *len = 0;
            ptr::null_mut()
        }
        Ok(mut a) => a.raw_request(h, len),
    }
}

#[no_mangle]
pub extern "stdcall" fn DllMain(
    h_inst: usize,
    ul_reason_for_call: DWORD,
    lp_reserved: LPVOID,
) -> bool {
    match (*API).lock() {
        Err(e) => {
            error!("[emo::DllMain] {}", e);
            false
        }
        Ok(mut a) => a.raw_dllmain(h_inst, ul_reason_for_call, lp_reserved),
    }
}
