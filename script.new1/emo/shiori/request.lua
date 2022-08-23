local CLASS = {}
local meta_CLASS = {__index=CLASS}


-- self.Status を評価し、辞書にして返す。
function CLASS:get_status()
    if not self.Status then

    end
end


-- shiori.request メタオブジェクトの設定
local function set_meta(obj)
    setmetatable(obj, meta_CLASS)
    return obj
end

-- shiori.request サンプルオブジェクトの作成
local function new_sample()
    -- オブジェクト
    local obj = {
        Raw             ="(評価前の文字列)",
        TimeStamp       ="2000-04-01T01:23:45,6789",
        Version         ="SHIORI/3.0",
        Method          ="GET",
        Charset         ="UTF-8",
        Sender          ="SSP",
        SenderType      ="internal,raise",
        SecurityLevel   ="local",
        Status          ="choosing,balloon(0=0)",
        ID              ="OnFirstBoot",
        BaseID          ="OnBoot",
        Reference0      ="1",
    }
    set_meta(obj)
    return obj
end


-- shiori.request モジュール
local MOD = {
    set_meta=set_meta,
    new_sample=new_sample,
}

return MOD