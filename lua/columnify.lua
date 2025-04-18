---@module columnify

---@alias col_name string
---
---@class Columnify.Stats
---@field name string column name
---@field start number start of column
---@field _end number end of column
---@field len number len of column
---@field pos number position of column
---
---@class Columnify
---@field opts? {primary_col: string}
---@field header string         -- raw header string
---@field cols table<string>    -- keep order of cols
---@field stats table<col_name,Columnify.Stats>
local M = {}
M.__index = M

function M:parse_header()
  if next(self.stats) then
    return self.stats
  end
  local startidx = 0
  local pos = 1
  for name, spaces in self.header:gmatch("(%S+)(%s*)") do
    table.insert(self.cols, name)
    local len = #name + #spaces
    local endidx = startidx + len
    self.stats[name] = { name = name, pos = pos, start = startidx, _end = endidx, len = len }
    if (endidx == #self.header) then
      self.stats[name]._end = -1
    end
    startidx = endidx
    pos = pos + 1
  end
end

---@param line string
function M:parse_line(line)
  local result = {}
  for col_name in self.header:gmatch("(%S+)") do
    local value = self:get_col(line, col_name)
    result[col_name] = value
  end
  return result
end

---@param line string
---@param col_name string
---@return string
function M:get_col(line, col_name)
  ---@type Columnify.Stats
  local col_stat = self.stats[col_name]
  if not col_stat then
    print(("[Columnify] col '%s' not found"):format(col_name))
    return ""
  end
  local col_start = col_stat.start + 1 -- convert to base 1
  local col_end = col_stat._end
  return vim.trim(line:sub(col_start, col_end))
end

---@param row number base 0
---@param col_name string
---@param value string
function M:set_col(row, col_name, value)
  ---@type Columnify.Stats
  local col_stat = self.stats[col_name]
  if not col_stat then
    print(("[Columnify] col '%s' not found"):format(col_name))
    return ""
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local start_col = col_stat.start
  local end_col = col_stat._end
  vim.api.nvim_buf_set_text(bufnr, row, start_col, row, end_col, { value })
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
  self:parse_header()
  return self
end

return {
  new = new
}
