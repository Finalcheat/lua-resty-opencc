use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: Simplified Chinese to Traditional Chinese (Taiwan Standard)
簡體到臺灣正體

--- config
location = /t {
    content_by_lua_block {
        local opencc = require("resty.opencc")
        local o = opencc:new("s2tw.json")
        words = {"着装污染虚伪发泄棱柱群众里面", "鲶鱼和鲇鱼是一种生物。"}
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
著裝汙染虛偽發洩稜柱群眾裡面
鯰魚和鯰魚是一種生物。
