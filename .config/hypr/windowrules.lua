-- Float rules
hl.window_rule({ match = { class = "^org\\.pulseaudio\\.pavucontrol$" },                  float = true })
hl.window_rule({ match = { class = "^de\\.haeckerfelix\\.Shortwave$" },                   float = true })
hl.window_rule({ match = { class = "^com\\.github\\.iwalton3\\.jellyfin-media-player$" }, float = true })
hl.window_rule({ match = { class = "^Signal$" },                                          float = true })
hl.window_rule({ match = { class = "^com\\.github\\.rafostar\\.Clapper$" },               float = true })
hl.window_rule({ match = { class = "^app\\.drey\\.Warp$" },                               float = true })
hl.window_rule({ match = { class = "^net\\.davidotek\\.pupgui2$" },                       float = true })
hl.window_rule({ match = { class = "^yad$" },                                             float = true })
hl.window_rule({ match = { class = "^eog$" },                                             float = true })
hl.window_rule({ match = { class = "^io\\.github\\.alainm23\\.planify$" },                float = true })
hl.window_rule({ match = { class = "^io\\.gitlab\\.theevilskeleton\\.Upscaler$" },        float = true })
hl.window_rule({ match = { class = "^com\\.github\\.unrud\\.VideoDownloader$" },          float = true })
hl.window_rule({ match = { class = "^io\\.gitlab\\.adhami3310\\.Impression$" },           float = true })
hl.window_rule({ match = { class = "^io\\.missioncenter\\.MissionCenter$" },              float = true })

-- Idle inhibit rules
hl.window_rule({ match = { class = "^(.*celluloid.*|.*mpv.*|.*vlc.*)$" },                                                                                            idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^.*[Ss]potify.*$" },                                                                                                             idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(.*LibreWolf.*|.*floorp.*|.*brave-browser.*|.*firefox.*|.*chromium.*|.*zen.*|.*vivaldi.*)$" },                                  idle_inhibit = "fullscreen" })

-- Picture-in-picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture).*$" }, tag = "picture-in-picture" })
hl.window_rule({ match = { tag = "picture-in-picture" }, float = true, pin = true, keep_aspect_ratio = true, move = "73% 72%", size = "25% 25%" })

-- Keep Brave consistent with the global opacity when windowed, but make it
-- completely opaque in fullscreen (for video and distraction-free browsing).
hl.window_rule({
    match = { class = "^brave-browser$" },
    opacity = "0.90 override 0.9 override 1.0 override",
})

-- Games should remain fully opaque regardless of the global 90% opacity.
-- CS2 normally reports "cs2"; Steam's app-id class is included as a fallback.
hl.window_rule({
    match = { class = "^(cs2|steam_app_730)$" },
    opacity = "1.0 override 1.0 override 1.0 override",
})

-- Every other window inherits the global opacity from themes/theme.lua.

-- Misc rules
hl.window_rule({ match = { class = "^.*jetbrains.*$", title = "^win[0-9]+$" }, no_initial_focus = true })
