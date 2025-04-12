local Columnify = require("columnify")

describe("Columnify", function()
  it("Should return value at specify column", function()
    local header = "CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE"
    local line   = "*                                       abc          kubernetes-admin   kube-system"
    local parser = Columnify.new(header)
    local value  = parser:get_col(line, "AUTHINFO")
    assert.equals("kubernetes-admin", value)
  end)

  it("Should return empty string at specify column if value is missing", function()
    local header = "CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE"
    local line   = "*                                       abc          kubernetes-admin   kube-system"
    local parser = Columnify.new(header)
    local value  = parser:get_col(line, "NAME")
    assert.equals("", value)
  end)

  it("parses columns from line", function()
    local header = "CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE"
    local line   = "*         kubernetes-admin@kubernetes   abc                             kube-system"
    local parser = Columnify.new(header)
    local result = parser:parse_line(line)
    assert.equals("*", result.CURRENT)
    assert.equals("kubernetes-admin@kubernetes", result.NAME)
    assert.equals("abc", result.CLUSTER)
    assert.equals("", result.AUTHINFO)
    assert.equals("kube-system", result.NAMESPACE)
  end)
end)
