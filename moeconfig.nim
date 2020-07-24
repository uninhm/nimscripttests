type Config = object
  autoindent: bool
  disableChangeCursor: bool
  tabstop: int

var
  config* = Config()

# defaults
config.autoindent = true
config.tabstop = 2

proc autoindent*(a: bool) =
  config.autoindent = a

proc disableChangeCursor*(a: bool) =
  config.disableChangeCursor = a

proc tabstop*(a: int) =
  config.tabstop = a

proc loadConfig*(config: Config, configstr: var string) =
  configstr = $config
