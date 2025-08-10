local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local github = sbar.add("item", "widgets.github", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 16.0,
    }
  },
  label = { 
    font = { 
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    } 
  },
  update_freq = 30,
  popup = { align = "center" }
})

local function update_github_notifications()
  local script = [[
    if [ -z "$GITHUB_TOKEN" ]; then
      echo "NO_TOKEN"
      exit 0
    fi
    
    # GitHub API call to get unread notifications count
    API="https://api.github.com/notifications"
    
    # Use per_page=1 and check Link header for efficient counting
    response=$(curl -sI \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      "$API?per_page=1" 2>/dev/null)
    
    # Extract Link header
    link_header=$(echo "$response" | grep -i '^link:' | sed 's/^[Ll]ink: //')
    
    if echo "$link_header" | grep -q 'rel="last"'; then
      # Extract page number from last page link
      last_page=$(echo "$link_header" | grep -o 'page=[0-9]*>; rel="last"' | grep -o '[0-9]*')
      echo "${last_page:-0}"
    else
      # Either zero or exactly one notification - count them
      count=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        "$API?per_page=50" 2>/dev/null | grep -c '"id"' || echo "0")
      echo "$count"
    fi
  ]]
  
  sbar.exec(script, function(result)
    local count_str = result:gsub("%s+", "")
    
    if count_str == "NO_TOKEN" then
      github:set({
        icon = { 
          string = icons.github.octocat or icons.github.mark,
          color = colors.grey
        },
        label = { string = "?" },
      })
      return
    end
    
    local count = tonumber(count_str) or 0
    local icon = icons.github.octocat or icons.github.mark
    local color = colors.green
    
    if count > 0 then
      icon = icons.github.octocat or icons.github.mark
      if count >= 10 then
        color = colors.red
      elseif count >= 5 then
        color = colors.orange
      else
        color = colors.yellow
      end
    else
      color = colors.grey
    end
    
    local label = ""
    if count > 0 then
      label = tostring(count)
      if count > 99 then
        label = "99+"
      end
    end
    
    github:set({
      icon = { 
        string = icon,
        color = color
      },
      label = { 
        string = label,
        color = color
      },
    })
  end)
end

github:subscribe({ "routine", "system_woke", "forced" }, function()
  update_github_notifications()
end)

github:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "left" then
    sbar.exec("open https://github.com/notifications")
  elseif env.BUTTON == "right" then
    -- Force refresh
    update_github_notifications()
  end
end)

sbar.add("bracket", "widgets.github.bracket", { github.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.github.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Initial update
update_github_notifications()