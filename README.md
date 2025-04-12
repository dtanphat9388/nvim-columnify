![Generate Docs](https://github.com/dtanphat9388/nvim-columnify/actions/workflows/test.yaml/badge.svg)

# 📊 nvim-columnify

**A lightweight Lua utility for parsing and working with tabulated text output in Neovim.**

This plugin is used in [**nvim-kubectl**](https://github.com/dtanphat9388/nvim-kubectl) — check it out if you want a full Kubernetes experience in Neovim!

---

## ✨ Features

- 📄 Parses tabulated strings into structured Lua tables
- 🧠 Handles irregular spacing and missing column values gracefully
- 🔍 Access specific columns or primary column values with ease
- 🧪 Designed for integration with Neovim plugins and tools

---

## 📦 Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
-- That's it
return {
  "dtanphat9388/nvim-columnify"
}
```

---

## 🚀 Usage

### 1. Initialize with a Header

```lua
local columnify = require("columnify")

local header = "CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE"
local parser = columnify.new(header)
```

### 2. by usecases

- Columnify will automatically parse the line, filling in any missing column values.

```lua
local line = "*         kubernetes-admin@kubernetes                kubernetes-admin   kube-system"
local line_parsed = parser(line)
vim.print(line_parsed)
-- OUTPUT
-- {
--   CURRENT = "*",
--   NAME = "kubernetes-admin@kubernetes",
--   CLUSTER = "",
--   AUTHINFO = "kubernetes-admin",
--   NAMESPACE = "kube-system"
-- }
```

- To retrieve the value of a specific column:

```lua
parser:get_col("NAMESPACE")
-- OUTPUT
-- kube-system
```

- By default, the primary column is `NAME`. You can change it via options:

```lua
local parser = columnify.new(header, { primary_col = "CLUSTER" })
parser:get_primary_col()
-- OUTPUT
-- (value of the CLUSTER column)
```

For detailed API documentation, refer to [APIs.md](./docs/APIs.md).

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=dtanphat9388/nvim-columnify&type=Date)](https://www.star-history.com/#dtanphat9388/nvim-columnify&Date)

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## 📦 Used In

- 👉 [**nvim-kubectl**](https://github.com/dtanphat9388/nvim-kubectl) — A powerful Kubernetes navigator for Neovim, powered by `nvim-columnify`.
