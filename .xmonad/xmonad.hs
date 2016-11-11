import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Data.Monoid
import System.IO
import Graphics.X11.ExtraTypes.XF86

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll [
    manageDocks
    ,(className =? "Pidgin" <&&> (title =? "Pidgin" <||> title =? "Accounts"
                                 <||> title =? "Buddy List")) --> doFloat
    , className =? "Gimp" --> doFloat
    , isFullscreen --> doFullFloat
    ]

main :: IO ()
main = do
    xmoproc <- spawnPipe "/usr/bin/xmobar /home/pedrick/.xmobarrc"
    xmoproc1 <- spawnPipe "/usr/bin/xmobar -x 1 /home/pedrick/.xmobarrc"
    spawn "xautolock -time 5 -locker \"gnome-screensaver-command --lock\""
    xmonad $ def {
        terminal = "gnome-terminal"
        , handleEventHook = docksEventHook <+> handleEventHook def
        , manageHook = myManageHook <+> manageHook def
        , layoutHook = smartBorders . avoidStruts $ smartSpacing 10 $ layoutHook def
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmoproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
                    >> dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmoproc1
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        , borderWidth        = 4
        , normalBorderColor  = "#ccccff"
        , focusedBorderColor = "#6666ff"
        } `additionalKeys`
            [ ((0 , xF86XK_AudioLowerVolume), spawn "~/util/volume.sh down"),
              ((0 , xF86XK_AudioRaiseVolume), spawn "~/util/volume.sh up"),
              ((0 , xF86XK_AudioMute), spawn "~/util/volume.sh mute")
            ]
