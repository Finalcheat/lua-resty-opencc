use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: Simplified Chinese to Traditional Chinese (Taiwan Standard) with Taiwanese idiom
簡體到繁體（臺灣正體標準）並轉換爲臺灣常用詞彙

--- config
location = /t {
    content_by_lua_block {
        local opencc = require("resty.opencc")
        local o = opencc:new("s2twp.json")
        words = {
            "鼠标里面的硅二极管坏了，导致光标分辨率降低。",
            "我们在老挝的服务器的硬盘需要使用互联网算法软件解决异步的问题。",
            "为什么你在床里面睡着？",
        }
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
滑鼠裡面的矽二極體壞了，導致游標解析度降低。
我們在寮國的伺服器的硬碟需要使用網際網路演算法軟體解決非同步的問題。
為什麼你在床裡面睡著？
