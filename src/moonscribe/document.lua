local lfs = require "lfs"
local yaml = require "yaml"

--- read a line from the text starting at position
---@param text string
---@param position number
---@return string
---@return number
local function read_line(text, position)
  local start, stop = text:find("\n", position)
  if not start then return nil, position end
  local line = text:sub(position, start - 1)
  return line, stop + 1
end


--- Check if the line starts with three dashes
--- @param text string
--- @return boolean
local function match_dashes(text)
  return text:match("^%s*%-%-%-")
end

local function table_join(tbl1, tbl2) 
  for k,v in pairs(tbl2) do
    tbl1[k] = v
  end
  return tbl1
end

--- Parse the frontmatter from the text, return the frontmatter and the rest of the text
--- If there is no frontmatter, return nil and the whole text as content
---@param text string
---@return string
---@return string
local function parse_frontmatter(text)
  local frontmatter = {}
  if not match_dashes then
    return nil, text -- No frontmatter found, return the whole text as content
  end
  local line, stop = read_line(text, 1)
  -- this can happen if there are no line breaks
  if not line or not match_dashes(line) then
    return nil, text -- No frontmatter found, return the whole text as content
  end
  local found_second_dash = false
  while line do
    line, stop = read_line(text, stop)
    if match_dashes(line) then
      found_second_dash = true
      break -- End of frontmatter
    end
    frontmatter[#frontmatter + 1] = line
  end
  if not found_second_dash then
    return nil, text -- No closing dashes found, return the whole text as content
  end
  local metadata = yaml.eval(table.concat(frontmatter, "\n"))
  return metadata, text:sub(stop)
end

--- Parse the document for the pramble and text content, return metadata table
---@param text string
---@return table
local function parse_content(text)
  local metadata = {}
  local frontmatter, content = parse_frontmatter(text)
  if frontmatter then
    metadata = table_join(metadata, frontmatter)
  end
  metadata.content = content
  return metadata
end


--- comment
--- @param path string
--- @return table
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
