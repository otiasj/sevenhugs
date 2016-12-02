-- Simulate http module used on the Sevenhugs remote.
--
-- Requests are stored in a local pending list until http.run() is called, to
-- simulate asynchronous handling.
local http = {}
local shttp = require 'socket.http'
local ltn12 = require 'ltn12'

http.pending_requests = {}
http.debug = false

-- When doing a request, http_request object is returned to the client.
local http_request = {}
http_request.__index = http_request
local function http_request_new(cls, args)
    local self = setmetatable({}, cls)
    for k, v in pairs(args) do
        self[k] = v
    end
    return self
end
setmetatable(http_request, { __call = http_request_new })

-- Cancel a request.
function http_request:close()
    -- Cancel callbacks in case it is too late to cancel the request.
    self.done = nil
    self.fail = nil
    -- Try to unqueue the request.
    for i, v in ipairs(http.pending_requests) do
        if v == self then
            table.remove(http.pending_requests, i)
            break
        end
    end
end

-- Run a request, called by http.run().
function http_request:run()
    local url = self.url
    local headers = self.headers
    -- Handle URL parameters.
    local params = self.params
    local params_list = {}
    if params then
	for k, v in pairs(params) do
	    table.insert(params_list, k .. '=' .. v)
	end
	url = url .. '?' .. table.concat(params_list, '&')
    end
    -- Make a LTN12 source if data is provided.
    local source = nil
    if self.data then
        if http.debug then
            local utils = require 'utils'
            utils.dump(self.data)
        end
        source = ltn12.source.string(self.data)
        headers = headers or {}
        if not headers['Content-Length'] then
            headers['Content-Length'] = #self.data
        end
    end
    -- Proceed with the request.
    body = {}
    local ok, status_code_or_error, rheaders, sline = shttp.request{
        url = url,
        sink = ltn12.sink.table(body),
        method = self.method,
        headers = headers,
        source = source,
    }
    -- Call callbacks.
    if ok then
        local result = {
            status_code = status_code_or_error,
            content = table.concat(body),
            headers = rheaders,
        }
        if http.debug then
            local utils = require 'utils'
            utils.dump(result)
        end
        if status_code_or_error < 400 then
            self.done(result)
        else
            self.fail(sline, result)
        end
    else
        self.fail(status_code_or_error)
    end
end

-- Requests functions, all functions call request with the right method
-- argument.
local function request(method, args)
    r = http_request{
        method = method,
        url = args.url,
        params = args.params,
        headers = args.headers,
        data = args.data,
        result_max = args.result_max,
        done = args.done or function(...) end,
        fail = args.fail or function(...) end,
    }
    table.insert(http.pending_requests, r)
    return r
end

function http.get(args)
    return request('GET', args)
end

function http.put(args)
    return request('PUT', args)
end

function http.post(args)
    return request('POST', args)
end

function http.head(args)
    return request('HEAD', args)
end

function http.delete(args)
    return request('DELETE', args)
end

function http.options(args)
    return request('OPTIONS', args)
end

-- Run all pending requests.
function http.run()
    while #http.pending_requests ~= 0 do
        local pr = http.pending_requests
        http.pending_requests = {}
        for i, r in ipairs(pr) do
            r:run()
        end
    end
end

return http
