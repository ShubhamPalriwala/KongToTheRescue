local pegasus = require "pegasus"

local server = pegasus:new({
    port='8000'
})

server:start(function (request, response)
    response:write("Hello World!")
end)
