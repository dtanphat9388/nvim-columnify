## 📚 API

### `columnify.new(header: string, opts?: {primary_col?: string}): Columnify`

Creates a new `Columnify` parser with a given header.

#### Arguments:

- `header` (`string`): The raw header string that defines the columns.
- `opts` (`table?`): Optional configuration table.
  - `primary_col` (`string?`): The name of the column to be considered as the primary column. Default is `"NAME"`.

#### Returns:

- Returns a new instance of the `Columnify` parser.

#### Example:

```lua
local header = "CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE"
local parser = columnify.new(header, { primary_col = "NAME" })
```

---

### `Columnify:parse_line(line: string): table`

Parses a single line of text and returns the column values in a table.

#### Arguments:

- `line` (`string`): The line to be parsed, which should correspond to the columns defined by the header.

#### Returns:

- A table where each key is a column name, and the value is the corresponding parsed value from the line.

#### Example:

```lua
local line = "*         kubernetes-admin@kubernetes                kubernetes-admin   kube-system"
local line_parsed = parser:parse_line(line)
-- OUTPUT
-- {
--   AUTHINFO = "kubernetes-admin",
--   CLUSTER = "",
--   CURRENT = "*",
--   NAME = "kubernetes-admin@kubernetes",
--   NAMESPACE = "kube-system"
-- }
```

---

### `Columnify:get_col(col_name: string): string`

Gets the value of a specific column from the parsed line.

#### Arguments:

- `col_name` (`string`): The name of the column whose value you want to retrieve.

#### Returns:

- The value of the column as a string.

#### Example:

```lua
local value = parser:get_col("NAMESPACE")
-- OUTPUT
-- "kube-system"
```

---

### `Columnify:get_primary_col(): string`

Gets the value of the primary column (by default, `"NAME"`).

#### Returns:

- The value of the primary column as a string.

#### Example:

```lua
local primary_value = parser:get_primary_col()
-- OUTPUT
-- "kubernetes-admin@kubernetes"
```

---

### `Columnify:parse_header(): void`

Parses the header string and builds column information.

#### Returns:

- This function modifies the internal state of the `Columnify` instance and does not return a value.

#### Example:

```lua
parser:parse_header()
-- This will internally parse the header and set up column details.
```

---

### `parser:set_col(column_name: string, value: string)`

Sets or updates the value of a specific column in the most recently parsed

**Parameters:**

- `column_name` (string): The name of the column to set.
- `value` (string): The new value to assign to the column.

**Example:**

```lua
parser:set_col("NAMESPACE", "default")
print(parser:get_col("NAMESPACE"))  -- OUTPUT: "default"
```

---

## 🎯 Customization

- You can customize the primary column by passing it as an option when calling `columnify.new(header, { primary_col = "COLUMN_NAME" })`.
- The module automatically handles columns with irregular spacing and missing values, filling them as necessary.
