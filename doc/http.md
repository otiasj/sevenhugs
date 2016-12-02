# Sevenhugs Smart Remote SDK - HTTP library

## Overview

This library allows to make asynchronous HTTP requests. Result is not
available immediately, instead a callback is called when it is ready. This
mechanism will look familiar for jQuery users.

## Sending a request

Requests are sent using `get`, `post`, `put`, `head`, `delete` or `options`
methods.  Their argument is a table which must include the `url` field.

The optional fields are:

 - `params`: a table of parameters which will be appended to URL (for example,
   `{a=1, b=3}` is translated to `"?a=1&b=2"`).
 - `headers`: a table of additional headers to include in the request.
 - `data`: request body, if provided a `Content-Length` header is
   automatically added.
 - `result_max`: maximum size of the response, defaults to 16384.
 - `done`: function called on success with result.
 - `fail`: function called on failure with error message and result if
   available.

Request methods return a request object whose only member is a `close` method
to cancel the request.

The result given to callbacks is a table with fields:

 - `status_code`: HTTP status code.
 - `content`: response body.
 - `headers`: table of response headers.

Examples:

```lua
local function done(result)
    print('done')
    print('status_code: ' .. result.status_code)
    print('content: ' .. result.content)
end

local function fail(err, result)
    print('fail')
    if result then
        print('status_code: ' .. result.status_code)
        print('content: ' .. result.content)
    else
        print('no result')
    end
end

r = http.get{
    url = 'http://httpbin.org/get',
    done = done, fail = fail}
r = http.post{
    url = 'http://httpbin.org/post',
    data = 'Hello world',
    done = done, fail = fail}
r = http.get{
    url = 'http://httpbin.org/status/404',
    done = done, fail = fail}
```

> Planned evolution:
Future API will accept JSON data (parameter `json`, with a table to encode,
set `Content-Type` accordingly), table data (parameter `data`, using form
encoding, set `Content-Type` accordingly), URL with empty path and basic auth.
It will also provide a method do decode JSON result and will handle redirects
automatically.
