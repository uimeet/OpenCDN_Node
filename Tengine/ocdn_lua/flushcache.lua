cjson = require "cjson"
token = require "token"
common = require "common"

local args = ngx.req.get_uri_args()

if (args.token ~= token) then
	common.json(false, "access deny")
end

os.execute("rm -Rf /home/data1/nginx/cache/*")

common.json(true, "has send")
