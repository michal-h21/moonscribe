local lfs = require "lfs"

local function parse_content(text)
end



--- @param
local function load_file(path)
  local attributes = lfs.attributes(path)
  local f = io.open(path, "r")
  if not f then return nil, "cannot open file: " .. path end
  local metadata, content = parse_content(f:read("*a"))
  f:close()
  return metadata
end

local M = {}
M.parse_content = parse_content
M.load_file = load_file

return M
