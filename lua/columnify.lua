---@module columnify

---@alias col_name string
---@alias col_value string
---
---@class Columnify.Stats
---@field name string    column name
---@field col_start number   byte index of column start
---@field col_end number    byte index of column end (or -1 if last)
---@field len number     total width of column (including spacing)
---@field pos number     position of column
---
---@class Columnify
---@field opts? {primary_col: string}
---@field header string         -- raw header string
---@field cols table<string>    -- keep order of cols
---@field stats table<col_name,Columnify.Stats>
local M = {}
M.__index = M

---@param header string
function M:parse_header(header)
  if next(self.stats) then
    return self.stats
  end
  local cols = vim.split(header, "%s%s+")
  local result = {}
  local i = 1
  local col_start = 1
  for s in string.gmatch(header, "(%s%s+)") do
    local col = cols[i]
    local full_col = #col + #s
    result[col] = {
      name = col,
      len = full_col,
      col_start = col_start,
      col_end = col_start + full_col - 1,
      pos = i
    }
    col_start = col_start + full_col
    i = i + 1
  end
  local last_col = cols[#cols]
  result[last_col] = {
    name = last_col,
    len = #last_col,
    col_start = col_start,
    col_end = -1,
    pos = i
  }
  self.cols = cols
  self.stats = result
end

---@param col_name string
---@return Columnify.Stats?
function M:has_col(col_name)
  vim.validate({
    col_name = { col_name, "string" }
  })
  local col_stat = self.stats[col_name]
  if not col_stat then
    return nil
  end
  return col_stat
end

---@param line string
---@param col_name string
---@return string
function M:get_col(line, col_name)
  vim.validate({
    line = { line, "string" },
    col_name = { col_name, "string" }
  })
  local col_stat = self:has_col(col_name)
  if not col_stat then
    return ""
  end
  local col_start = col_stat.col_start
  local col_end = col_stat.col_end
  return vim.trim(line:sub(col_start, col_end))
end

---@param line string
---@param col_name string
---@param value string
function M:set_col(line, col_name, value)
  vim.validate({
    line = { line, "string" },
    col_name = { col_name, "string" },
    value = { value, "string" },
  })
  local col_stat = self:has_col(col_name)
  if not col_stat then
    return line
  end
  local col_end = col_stat.col_end == -1 and #line or col_stat.col_end
  local text_before = line:sub(1, col_stat.col_start - 1)
  local text_after = line:sub(col_end + 1)
  local spacing = string.rep(" ", col_stat.len - #value)
  local text_replaced = value .. spacing
  local result = text_before .. text_replaced .. text_after
  return result
end

---@return string
function M:get_primary_col(line)
  if not self.opts.primary_col then
    print("[Columnify] primary_col not set, fallback to NAME")
  end
  return self:get_col(line, self.opts.primary_col or "NAME")
end

---@alias  HeaderParsed table<string, Columnify.Stats>
---@param header string
---@param opts? {primary_col: string}
---@return Columnify
local function new(header, opts)
  local self = setmetatable({}, M)
  self.header = header
  self.opts = vim.tbl_deep_extend("force", { primary_col = "NAME" }, opts or {})
  self.cols = {}
  self.stats = {}
  self:parse_header(header)
  return self
end

---@param line string
---@return table<col_name, col_value>
function M:parse_line(line)
  local result = {}
  for _, col_name in ipairs(self.cols) do
    local value = self:get_col(line, col_name)
    result[col_name] = value
  end
  return result
end

return {
  new = new
}
