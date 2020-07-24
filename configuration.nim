import compiler/[nimeval, ast], os, osproc, strutils, algorithm, tables

var
  nimdump = execProcess("nim dump").split("\n")
  nimlibs = nimdump[nimdump.find("-- end of list --")+1 ..^ 2]
nimlibs.sort()

let intr = createInterpreter("moerc.nims", nimlibs)
intr.evalScript()

var
  configstr = intr.getGlobalValue(intr.selectUniqueSymbol("configstr")).getStr()
  configBools: Table[string, bool]
  configInts:  Table[string, int]
echo configstr

proc isInt(s: string): bool =
  for ch in s:
    if not ch.isDigit: return false
  return true

var key, val: string
for i in configstr[1 ..^ 2].split(", "):
  (key, val) = i.split(": ")
  if val.isInt:
    configInts[key] = val.parseInt
  else:
    configBools[key] = val.parseBool

echo configInts["tabstop"]
echo configBools["autoindent"]
  


intr.destroyInterpreter()
