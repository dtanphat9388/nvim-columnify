rockspec_format = '3.0'
package = "nvim-columnify"
version = "1.0.0-1"

source = {
  url = "git+https://github.com/dtanphat9388/nvim-columnify.git",
  tag = "v1.0.0" -- optional, if you tag releases
}

description = {
  summary = "Format input into multiple aligned columns for Neovim",
  homepage = "https://github.com/dtanphat9388/nvim-columnify",
  license = "MIT",
}

-- dependencies = {
--   "nlua"
-- }
test_dependencies = {
  "nlua"
}

build = {
  type = "builtin",
  modules = {
    ["columnify"] = "lua/columnify/init.lua",
  }
}

test = {
  type = "busted"
}
