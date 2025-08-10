local settings = require("settings")

local icons = {
  sf_symbols = {
    plus = "􀅼",
    loading = "􀖇",
    apple = "􀣺",
    gear = "􀍟",
    cpu = "􀫥",
    clipboard = "􀉄",

    switch = {
      on = "􁏮",
      off = "􁏯",
    },
    volume = {
      _100 = "􀊩",
      _66 = "􀊧",
      _33 = "􀊥",
      _10 = "􀊡",
      _0 = "􀊣",
    },
    battery = {
      _100 = "􀛨",
      _75 = "􀺸",
      _50 = "􀺶",
      _25 = "􀛩",
      _0 = "􀛪",
      charging = "􀢋"
    },
    wifi = {
      upload = "􀄨",
      download = "􀄩",
      connected = "􀙇",
      disconnected = "􀙈",
      router = "􁓤",
    },
    media = {
      back = "􀊊",
      forward = "􀊌",
      play_pause = "􀊈",
    },
    github = {
      mark = "􀐀",  -- Developer icon (closest to GitHub in SF Symbols)
      bell = "􀋚",
      bell_dot = "􀝗",
      octocat = "🐙",  -- Octopus emoji as alternative
    },
    linear = {
      mark = "💠",  -- Diamond with dot
      inbox = "💠",  -- Same icon for consistency
      inbox_dot = "💠",  -- Keep same icon, differentiate by count
    },
    slack = {
      mark = "💬",  -- Speech balloon emoji
      unread = "💬",  -- Same emoji, differentiate by count
    },
  },

  -- Alternative NerdFont icons
  nerdfont = {
    plus = "",
    loading = "",
    apple = "",
    gear = "",
    cpu = "",
    clipboard = "Missing Icon",

    switch = {
      on = "󱨥",
      off = "󱨦",
    },
    volume = {
      _100 = "",
      _66 = "",
      _33 = "",
      _10 = "",
      _0 = "",
    },
    battery = {
      _100 = "",
      _75 = "",
      _50 = "",
      _25 = "",
      _0 = "",
      charging = ""
    },
    wifi = {
      upload = "",
      download = "",
      connected = "󰖩",
      disconnected = "󰖪",
      router = "Missing Icon"
    },
    media = {
      back = "",
      forward = "",
      play_pause = "",
    },
    github = {
      mark = "",  -- GitHub logo
      bell = "",
      bell_dot = "",
      octocat = "",  -- Actual GitHub octocat icon in NerdFont
    },
    linear = {
      mark = "󰧑",  -- Task/checklist icon  
      inbox = "󰇮",  -- Inbox icon
      inbox_dot = "󰇰",  -- Inbox with notification
    },
    slack = {
      mark = "󰒱",  -- Slack icon in NerdFont
      unread = "󰒲",  -- Slack with notification
    },
  },
}

if not (settings.icons == "NerdFont") then
  return icons.sf_symbols
else
  return icons.nerdfont
end
