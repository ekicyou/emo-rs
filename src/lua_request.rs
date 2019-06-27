#![allow(clippy::trivially_copy_pass_by_ref)]
use crate::prelude::*;
use pest;
use pest::iterators::FlatPairs;
use pest::Parser as PestParser;
use shiori3::req;

/// SHIORI REQUESTを解析し、luaオブジェクトに展開します。
pub fn parse_request<'lua>(lua: &LuaContext<'lua>, text: &str) -> MyResult<LuaTable<'lua>> {
    let mut t = lua.create_table()?;
    t.set("reference", lua.create_table()?)?;
    t.set("dic", lua.create_table()?)?;
    let it = req::Parser::parse(req::Rule::req, text)?.flatten();
    parse1(&mut t, it)?;
    Ok(t)
}

fn parse1<'lua, 'a>(table: &mut LuaTable<'lua>, mut it: FlatPairs<'a, req::Rule>) -> MyResult<()> {
    let pair = match it.next() {
        Some(a) => a,
        None => return Ok(()),
    };
    let rule = pair.as_rule();
    match rule {
        req::Rule::key_value => parse_key_value(table, &mut it)?,
        req::Rule::get => table.set("method", "get")?,
        req::Rule::notify => table.set("method", "notify")?,
        req::Rule::header3 => table.set("version", 30)?,
        req::Rule::shiori2_id => table.set("id", pair.as_str())?,
        req::Rule::shiori2_ver => {
            let version = {
                let nums: i32 = pair.as_str().parse().unwrap();
                if nums < 0 {
                    20
                } else if nums > 9 {
                    29
                } else {
                    nums + 20
                }
            };
            table.set("version", version)?
        }
        _ => (),
    };
    parse1(table, it)
}

fn parse_key_value<'lua, 'a>(
    table: &mut LuaTable<'lua>,
    it: &mut FlatPairs<'a, req::Rule>,
) -> MyResult<()> {
    let pair = it.next().unwrap();
    let rule = pair.as_rule();
    let key = pair.as_str();
    let reference: LuaTable<'_> = table.get("reference")?;
    let dic: LuaTable<'_> = table.get("dic")?;

    let value = match rule {
        req::Rule::key_ref => {
            let nums: i32 = it.next().unwrap().as_str().parse().unwrap();
            let value = it.next().unwrap().as_str();
            reference.set(nums, value)?;
            value
        }
        _ => {
            let value = it.next().unwrap().as_str();
            match rule {
                req::Rule::key_charset => table.set("charset", value)?,
                req::Rule::key_id => table.set("id", value)?,
                req::Rule::key_base_id => table.set("base_id", value)?,
                req::Rule::key_status => table.set("status", value)?,
                req::Rule::key_security_level => table.set("security_level", value)?,
                req::Rule::key_sender => table.set("sender", value)?,
                req::Rule::key_other => (),
                _ => panic!(),
            };
            value
        }
    };
    dic.set(key, value)?;
    Ok(())
}
