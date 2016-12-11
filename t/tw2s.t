use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1:  Traditional Chinese (Taiwan Standard) to Simplified Chinese
臺灣正體到簡體

--- config
location = /t {
    content_by_lua_block {
        local opencc = require("resty.opencc")
        local o = opencc:new("tw2s.json")
        words = {"著裝著作汙染虛偽發洩稜柱群眾裡面"}
        for _, word in ipairs(words) do
            local output = o:convert(word)
            ngx.say(output)
        end
        o:close()
    }
}

--- request
GET /t

--- error_code: 200
--- response_body
着装著作污染虚伪发泄棱柱群众里面
