cjson = require "cjson"
token = require "token"
common = require "common"

ngx.req.read_body()
local args = ngx.req.get_uri_args()
local post = ngx.req.get_post_args()

if (args.token ~= token) then
	common.json(false, "access deny")
end

local value = cjson.decode(post.data)
if not value then
	common.json(false, "argument is invalid")
end

local reload = value.reload

-- nginx 配置
local file,err = io.open(common.nginxPATH..'/conf/'..value.filename, "w")
if not file then
	common.json(false, err)
end

if not value.content then
	common.json(false, "the file body is empty")
end

file:write(value.content)
file:close()

-- 证书配置
-- 删除原来的证书目录
os.execute('rm -rf '..common.nginxPATH..'/conf/pems/'..value.pems_dir..'/')
-- 重建目录
os.execute('mkdir -p '..common.nginxPATH..'/conf/pems/'..value.pems_dir..'/')
-- 循环写入文件
if value.pems then
	local pem_dir = common.nginxPATH..'/conf/pems/'..value.pems_dir..'/'
	for i, pem in pairs(value.pems) do
		file, err = io.open(pem_dir..pem.domain..'.crt', 'w')
		if not file then
			common.json(false, err)
		end
		file:write(pem.crt)
		file:close()
		
                file, err = io.open(pem_dir..pem.domain..'.key', 'w')
                if not file then
                        common.json(false, err)
                end
                file:write(pem.private_key)
                file:close()	
	end
end

if reload then
	io.popen(common.nginxPATH..'/sbin/nginx -s reload')
end

common.json(true, 'sync success')
