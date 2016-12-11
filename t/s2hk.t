use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: Simplified Chinese to Traditional Chinese (Hong Kong Standard)
簡體到香港繁體（香港小學學習字詞表標準）

--- config
location = /t {
    content_by_lua_block {
        local opencc = require("resty.opencc")
        local o = opencc:new("s2hk.json")
        words = {"虚伪叹息", "潮湿灶台", "沙河涌汹涌的波浪"}
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
虛偽歎息
潮濕灶台
沙河涌洶湧的波浪

