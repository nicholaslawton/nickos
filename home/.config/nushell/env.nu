# Nushell Environment Config File

def "nickos home rebuild" [] {
  nix-env -iA nixos.%account%
}

let prompt-style = {
  fg: '#000000'
  bg: '#00ffff'
  attr: b
}

def create_left_prompt [] {
  echo [
    (ansi -e $prompt-style)
    $env.PWD
    (ansi reset)
  ] | str collect
}

def create_right_prompt [] {
  let battery-capacity = (open /sys/class/power_supply/BAT0/capacity | str trim)
  let time = (date now | date format '%_I:%M')

  echo [
    (ansi reset)
    $battery-capacity '% '
    (ansi -e $prompt-style)
    $time
    (ansi reset)
  ] | str collect
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { "  " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "* " }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | prepend '/some/path')

# The cursor is not visible in sway. Switching from the graphics driver cursor to a software cursor resolves it.
let-env WLR_NO_HARDWARE_CURSORS = 1
