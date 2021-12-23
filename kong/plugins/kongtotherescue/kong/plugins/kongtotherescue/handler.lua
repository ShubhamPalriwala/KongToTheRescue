local plugin = {
    PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.1"
}

local req_url_path = ""
local req_body = ""

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

    for _, sql_keyword in pairs(keywords) do
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
    kong.log.debug("'init_worker' handler called")

end

function plugin:access()
    req_body = kong.request.get_raw_body()
    req_url_path = kong.request.get_path()
    req_body = string.upper(req_body)
    req_url_path = string.upper(req_url_path)

end

function plugin:header_filter(plugin_conf)

    local is_suspicious = is_an_attack(req_url_path, req_body)
    kong.response.set_header(plugin_conf.response_header, is_suspicious)

end

return plugin
