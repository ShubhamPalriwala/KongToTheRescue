-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.
-- assert(ngx.get_phase() == "timer", "The world is coming to an end!")
---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------
local plugin = {
    PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.1"
}

local function directory_traversal_attack(request_path)
    return request_path:find("%.%.") ~= nil
end

local function xss_attack(request_body)
    return request_body:find("<") ~= nil
end

local function sqli_attack(request_body)
    local keywords = {"ALTER", "CREATE", "DELETE", "DROP", "EXEC", "INSERT", "SELECT", "TRUNCATE", "UPDATE", "UNION",
                      "UNION ALL", "LOAD", "INTO", "FROM", "WHERE", "LIKE", "IN", "TABLE", "JOIN", "AND", "OR",
                      "ORDER BY", "GROUP BY", "HAVING", "LIMIT", "OFFSET", "VALUES", "SET", "CASE", "WHEN", "THEN",
                      "ELSE", "END", "CURRENT_TIMESTAMP", "DATABASE", "DATABASES", "USER", "USERS", "PASSWORD",
                      "PASSWORDS", "ROLE", "ROLES", "GRANT", "REVOKE", "PROCEDURE", "FUNCTION", "TRIGGER", "VIEW",
                      "INTO"}

    for sql_keyword in pairs(keywords) do
        if request_body:find(sql_keyword) then
            return true
        end
    end
    return false
end

local function is_an_attack(request_path, request_body)
    if directory_traversal_attack(request_path) or xss_attack(request_body) or sqli_attack(request_body) then
        return true
    end
    return false
end

function plugin:init_worker()

    kong.log.debug("saying hi from the 'init_worker' handler")
    local req_body = kong.request.get_raw_body()
    local req_url_path = kong.request.get_path()
    if is_an_attack(req_url_path, req_body) then
        kong.response.exit(403, "Forbidden")
    end

end

return plugin
