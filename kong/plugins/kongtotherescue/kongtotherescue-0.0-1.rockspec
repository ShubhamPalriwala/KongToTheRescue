package = "kongtotherescue"
version = "0.0-1"

local pluginName = "kongtotherescue"

source = {
  url = "https://github.com/shubhampalriwala/kongtotherescue.git"
}
description = {
  summary = "A Kong API Gateway Plugin that adds an is-suspicious header to the response for any potentially harmful requests to the system",
  license = "MIT"
}
dependencies = {
  "lua ~> 5.1",
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.kongtotherescue.handler"] = "kong/plugins/kongtotherescue/handler.lua",
    ["kong.plugins.kongtotherescue.schema"] = "kong/plugins/kongtotherescue/schema.lua",
  }
}