-- Base
import XMonad
import qualified XMonad.StackSet as W

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier (magnifiercz)

-- Data
import Data.Maybe (fromJust, isJust)

-- Actions
import XMonad.Actions.CycleWS (nextScreen, prevScreen)
import XMonad.Actions.MouseResize

-- Hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import Graphics.X11.ExtraTypes.XF86

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
--import XMonad.Util.EZConfig (additionalKeysP)

--import XMonad.Layout.IndependentScreens

import Colors.DoomOne
--------------------------------------------------------------------
-- Default Terminal 

myTerminal = "urxvt"
myFont = "xft:Raleway:regular:size=9:antialias=true:hinting=true"
myEmacs = "emacsclient -c -a 'emacs' "
myEditor = "emacsclient -c -a 'emacs' "
myBorderWidth = 2
myNormColor = colorBack
myFocusColor = color15
myModMask = mod4Mask

--myWorkspaces = ["1", "2", "3", "4]
--windowCount :: X (Maybe String)
--windowCount = gets & Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- My Keys

myKeys = [ ("M-S-z",spawn "xscreensaver-command -lock")
         , ("M-C-s", unGrab *> spawn "scrot -s" )
         , ("M-f"  , spawn "firefox" )
         , ("M-e" , spawn "nautilus")
         , ("M-.", nextScreen)
         , ("M-,", prevScreen)
         , ("<XF86MonBrightnessUp>",    spawn "brightnessctl set +10%")
         , ("<XF86MonBrightnessDown>",  spawn "brightnessctl set 10%-")
         ]

--------------------------------------------------------------------
-- Layout
myLayout = tiled ||| Full
--myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
--    threeCol = magnifiercz 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1	-- Default number of windows in master pane
    ratio    = 1/2      -- Default proportion of screen occupied by master pane
    delta    = 3/100    -- Percent of screen to increment by when resizing Panes
----------------------------------------------------------------
-- Status Bar

myXmobarPP :: PP
myXmobarPP = def

-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- Startup Hook
myStartupHook :: X ()
myStartupHook = do
  spawn "killall trayer"
  spawnOnce "picom"
--  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 4 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --height 22 --tint 0x282c34" )
  spawnOnce "nitrogen --restore &"

main :: IO ()
main = xmonad 
     . ewmh 
     . withEasySB (statusBarProp "xmobar -x 0 ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
--     . withEasySB (statusBarProp "xmobar -x 1 ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask    = myModMask   -- Rebind Mod to the Super key
    , layoutHook = myLayout    -- Use custom layouts
    , startupHook = myStartupHook
    , terminal   = myTerminal  -- Default Terminal with Mod+Enter,
    , focusFollowsMouse = False -- Hover does not change focus
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormColor
    , focusedBorderColor = myFocusColor
--    , workspaces = myWorkspaces
  --  , workspaces = withScreens 2 ["web", "email", "irc"]
    }
  `additionalKeysP` myKeys
