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

hl.window_rule({ match = { class = "^(.*celluloid.*|.*mpv.*|.*vlc.*)$" },                                                                                            idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^.*[Ss]potify.*$" },                                                                                                             idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(.*LibreWolf.*|.*floorp.*|.*brave-browser.*|.*firefox.*|.*chromium.*|.*zen.*|.*vivaldi.*)$" },                                  idle_inhibit = "fullscreen" })

hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture).*$" }, tag = "picture-in-picture" })
hl.window_rule({ match = { tag = "picture-in-picture" }, float = true, pin = true, keep_aspect_ratio = true, move = "73% 72%", size = "25% 25%" })

hl.window_rule({
    match = { class = "^brave-browser$" },
    opacity = "0.90 override 0.9 override 1.0 override",
})

hl.window_rule({
    match = { class = "^okular" },
    opacity = "1.0 override 1.0 override 1.0 override",
})


hl.window_rule({
    -- Steam games use the steam_app_<AppID> window class.
    match = { class = "^(cs2|steam_app_[0-9]+)$" },
    opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
    -- War Thunder's native client changes its class when entering a battle.
    match = { class = "^(steam_app_236390|aces.*|.*[Ww]ar.*[Tt]hunder.*)$" },
    opacity = "1.0 override 1.0 override 1.0 override",
    opaque = true,
    force_rgbx = true,
    no_blur = true,
    no_shadow = true,
})


hl.window_rule({ match = { class = "^.*jetbrains.*$", title = "^win[0-9]+$" }, no_initial_focus = true })
