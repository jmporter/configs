import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier (magnifiercz)

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import Graphics.X11.ExtraTypes.XF86

--import XMonad.Util.EZConfig (additionalKeysP)

--------------------------------------------------------------------
-- Default Terminal 

myTerminal = "urxvt"

--------------------------------------------------------------------
-- Mod Mask

myModMask = mod4Mask

--------------------------------------------------------------------
-- My Keys

myKeys = [ ("M-S-z", 		   	spawn "xscreensaver-command -lock")
   	 , ("M-C-s", 		        unGrab *> spawn "scrot -s" )
    	 , ("M-f"  , 			spawn "firefox" )
	 , ("M-e"  , 			spawn "nautilus" )
	 , ("<XF86MonBrightnessUp>",    spawn "brightnessctl set +10%")
	 , ("<XF86MonBrightnessDown>",  spawn "brightnessctl set 10%-")
	 , ("<XF86AudioRaiseVolume>",   spawn "amixer -D pulse sset Master 10%+")
	 , ("<XF86AudioLowerVolume>",   spawn "amixer -D pulse sset Master 10%-")
	 , ("<XF86AudioMute>",          spawn "amixer -D pulse sset Master toggle")
	]	


--------------------------------------------------------------------
-- Layout

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1	-- Default number of windows in master pane
    ratio    = 1/2      -- Default proportion of screen occupied by master pane
    delta    = 3/100    -- Percent of screen to increment by when resizing Panes
----------------------------------------------------------------
-- Status Bar

myXmobarPP :: PP
myXmobarPP = def


main :: IO ()
main = xmonad 
     . ewmh 
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey 
     $ myConfig

myConfig = def
    { modMask    = myModMask   -- Rebind Mod to the Super key
    , layoutHook = myLayout    -- Use custom layouts
    , terminal   = myTerminal  -- Default Terminal with Mod+Enter
    }
  `additionalKeysP` myKeys
  
