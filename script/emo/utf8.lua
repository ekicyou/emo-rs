local module = require("libs.utf8"):init()

-- 文字列をパターン表記にエスケープする
function module.escape(x)
    x = module.gsub(x, '%%', '%%%%')
    x = module.gsub('^%^', '%%^')
    x = module.gsub('%$$', '%%$')
    x = module.gsub('%(', '%%(')
    x = module.gsub('%)', '%%)')
    x = module.gsub('%.', '%%.')
    x = module.gsub('%[', '%%[')
    x = module.gsub('%]', '%%]')
    x = module.gsub('%*', '%%*')
    x = module.gsub('%+', '%%+')
    x = module.gsub('%-', '%%-')
    x = module.gsub('%?', '%%?')
    return x
end

return module