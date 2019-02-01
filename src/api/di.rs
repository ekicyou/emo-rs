use winapi::shared::minwindef::{DWORD, HGLOBAL, LPVOID};

/// windows api
pub trait IsRawWinAPI {
    fn raw_shiori3_dll_main(
        &mut self,
        h_inst: usize,
        ul_reason_for_call: DWORD,
        _lp_reserved: LPVOID,
    ) -> bool;

    fn raw_shiori3_load(&mut self, hdir: HGLOBAL, len: usize) -> bool;

    fn raw_shiori3_unload(&mut self) -> bool;

    fn raw_shiori3_request(&mut self, h: HGLOBAL, len: &mut usize) -> HGLOBAL;
}

/// apiの作成
pub trait IsGetWinAPI {
    fn create_api() -> IsRawWinAPI;
}
