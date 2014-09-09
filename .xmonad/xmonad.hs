import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Data.Monoid
import System.IO

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll [
    (className =? "Pidgin" <&&> (title =? "Pidgin" <||> title =? "Accounts"
                                 <||> title =? "Buddy List")) --> doFloat
    , className =? "Gimp" --> doFloat
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doIgnore
    , isFullscreen --> doFullFloat
    ]

main :: IO ()
main = do
    xmoproc <- spawnPipe "/usr/bin/xmobar /home/pedrick/.xmobarrc"
    xmoproc1 <- spawnPipe "/usr/bin/xmobar -x 1 /home/pedrick/.xmobarrc"
    xmonad $ defaultConfig {
        terminal = "gnome-terminal"
        , manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmoproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
                    >> dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmoproc1
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        , borderWidth        = 2
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#3300ff"
        }
