import compiler/[nimeval, ast], os, osproc, strutils, algorithm, tables
import configtypes

var
  nimdump = execProcess("nim dump").split("\n")
  nimlibs = nimdump[nimdump.find("-- end of list --")+1 ..^ 2]
nimlibs.sort()

let intr = createInterpreter("moerc.nims", nimlibs)
intr.evalScript()

var
  configstr = intr.getGlobalValue(intr.selectUniqueSymbol("configstr")).getStr()
echo configstr


var config: Table[string, ConfigVal]

proc isInt(s: string): bool =
  for ch in s:
    if not ch.isDigit: return false
  return true

var key, val: string
for i in configstr[1 ..^ 2].split(", "):
  (key, val) = i.split(": ")
  if val.isInt:
    config[key] = ConfigVal(kind: ConfigInt)
    config[key].intval = val.parseInt
  elif val == "true" or val == "false":
    config[key] = ConfigVal(kind: ConfigBool)
    config[key].boolval = val.parseBool
  else:
    config[key] = ConfigVal(kind: ConfigStr)
    config[key].strval = val


echo config["tabstop"].getInt()
echo config["autoindent"].getbool()


intr.destroyInterpreter()
