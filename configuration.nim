import compiler/[nimeval, ast], os, osproc, strutils, algorithm, tables

var
  nimdump = execProcess("nim dump").split("\n")
  nimlibs = nimdump[nimdump.find("-- end of list --")+1 ..^ 2]
nimlibs.sort()

let intr = createInterpreter("moerc.nims", nimlibs)
intr.evalScript()

var
  configstr = intr.getGlobalValue(intr.selectUniqueSymbol("configstr")).getStr()
echo configstr

type Config = object
  bools: Table[string, bool]
  ints:  Table[string, int]

var config = Config()

proc isInt(s: string): bool =
  for ch in s:
    if not ch.isDigit: return false
  return true

var key, val: string
for i in configstr[1 ..^ 2].split(", "):
  (key, val) = i.split(": ")
  if val.isInt:
    config.ints[key] = val.parseInt
  else:
    config.bools[key] = val.parseBool

echo config.ints["tabstop"]
echo config.bools["autoindent"]


intr.destroyInterpreter()
