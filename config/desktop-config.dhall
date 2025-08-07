let Config = ./Config/Config.dhall

in Config::{
  _backend = "Pancake"
, _startingApps = { _center = Some "launchTerminal"
                  , _right  = None Text
                  , _bottom = None Text
                  , _left   = None Text
                  , _top    = None Text
                  }
, _defaultCursor = "left_ptr"
, _environmentsDirectory = "./environments/"
, _keyboardShortcuts = Config.default.keyboardShortcuts
, _keyboardRemappings = Config.default.keyboardRemappings
, _transparency = 0.9
, _windowScale = 1.0
}
