package = "moonscribe"
version = "0.1.0-1"
source = {
  url = "https://github.com/michal_h21/moonscribe/archive/v0.1.0.tar.gz",
  dir = "moonscribe-0.1.0-1"
}
description = {
  summary = "moonscribe",
  detailed = [[
    Static site generator in Lua
  ]],
  homepage = "https://github.com/michal_h21/moonscribe/",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
   modules = {
    moonscribe = "src/moonscribe.lua"
  }
}