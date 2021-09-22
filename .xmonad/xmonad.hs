import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Data.Monoid
import System.IO
import Graphics.X11.ExtraTypes.XF86

myLayoutHook         =   avoidStruts $ smartBorders tiled
                     ||| smartBorders (Mirror tiled)
                     ||| noBorders Full
  where
    tiled = spacingRaw True
               (Border outer outer outer outer) False
               (Border inner inner inner inner) True
              --   n  increment  ratio
            $ Tall 1  (3/100)    (1/2)
        where
          outer = 0
          inner = 10

-- Solarized colors
solarizedBase03 = "#002b36"
solarizedBase02 = "#073642"
solarizedBase01 = "#586e75"
solarizedBase00 = "#657b83"
solarizedBase0 = "#839496"
solarizedBase1 = "#93a1a1"
solarizedBase2 = "#eee8d5"
solarizedBase3 = "#fdf6e3"
solarizedYellow = "#b58900"
solarizedOrange = "#cb4b16"
solarizedRed = "#dc322f"
solarizedMagenta = "#d33682"
solarizedViolet = "#6c71c4"
solarizedBlue = "#268bd2"
solarizedCyan = "#2aa198"
solarizedGreen = "#859900"

myLogHook xmoproc xmoproc1 =  do
  dynamicLogWithPP $ xmobarPP
    { ppOutput = hPutStrLn xmoproc
      , ppTitle = xmobarColor solarizedYellow "" . shorten 50
      , ppOrder            = \(workspaces:layout:title:_) -> [workspaces, title]
      , ppWsSep            = ""
      , ppCurrent          = xmobarColor solarizedBase03 solarizedBlue . wrap " " " "
      , ppVisible          = xmobarColor solarizedBase03 solarizedBlue . wrap " " " "
      , ppHidden           = xmobarColor solarizedBase1 ""       . wrap " " " "
    }
  dynamicLogWithPP $ xmobarPP
    { ppOutput = hPutStrLn xmoproc1
      , ppTitle = xmobarColor solarizedYellow "" . shorten 50
      , ppOrder            = \(workspaces:layout:title:_) -> [workspaces, title]
      , ppWsSep            = ""
      , ppCurrent          = xmobarColor solarizedBase03 solarizedBlue . wrap " " " "
      , ppVisible          = xmobarColor solarizedBase03 solarizedBlue . wrap " " " "
      , ppHidden           = xmobarColor solarizedBase1 ""       . wrap " " " "
    }

myStartupHook = setWMName "LG3D"

myKeys = [
    ((0 , xF86XK_AudioLowerVolume), spawn "~/util/volume.sh down"),
    ((0 , xF86XK_AudioRaiseVolume), spawn "~/util/volume.sh up"),
    ((0 , xF86XK_AudioMute), spawn "~/util/volume.sh mute"),
    ((mod1Mask , xK_p), spawn "rofi -show run"),
    ((mod1Mask , xK_0), spawn "rofi-pass"),
    ((mod4Mask , xK_f), sendMessage ToggleStruts),
    ((mod4Mask , xK_l), spawn "dm-tool switch-to-greeter"),
    ((mod4Mask , xK_Print), spawn "gnome-screenshot"),
    ((mod4Mask .|. shiftMask, xK_Print), spawn "gnome-screenshot -i")
  ]

main :: IO ()
main = do
    xmoproc <- spawnPipe "/usr/bin/xmobar /home/pedrick/.xmobarrc"
    xmoproc1 <- spawnPipe "/usr/bin/xmobar -x 1 /home/pedrick/.xmobarrc"
    spawn "xautolock -time 5 -locker \"dm-tool switch-to-greeter\""
    xmonad $ docks $ ewmh
      def {
        terminal = "alacritty"
        , layoutHook = myLayoutHook
        , startupHook = myStartupHook
        , logHook = myLogHook xmoproc xmoproc1
        , borderWidth        = 1
        , normalBorderColor  = solarizedBase2
        , focusedBorderColor = solarizedBlue
        } `additionalKeys` myKeys
