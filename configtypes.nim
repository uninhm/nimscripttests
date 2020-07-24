from tables import Table

type ConfigType* = enum
  ConfigBool,
  ConfigInt,
  ConfigStr,
  ConfigNil

type ConfigVal* = object
  case kind*: ConfigType
  of ConfigStr:
    strval*: string
  of ConfigBool:
    boolval*: bool
  of ConfigInt:
    intval*: int
  of ConfigNil:
    nil

type Config* = Table[string, ConfigVal]

proc getbool*(val: ConfigVal): bool =
  return val.boolval

proc getInt*(val: ConfigVal): int =
  return val.intval

proc getStr*(val: ConfigVal): string =
  return val.strval
