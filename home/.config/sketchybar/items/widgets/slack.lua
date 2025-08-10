local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local slack = sbar.add("item", "widgets.slack", {
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

local function update_slack_notifications()
  local script = [[
    if [ -z "$SLACK_USER_TOKEN" ]; then
      echo "NO_TOKEN"
      exit 0
    fi
    
    # Slack API endpoint for conversations.list to get unreads
    # Using the newer Web API with app-level token
    API="https://slack.com/api/conversations.list"
    
    # Get all conversations with unread counts
    response=$(curl -s \
      -H "Authorization: Bearer $SLACK_USER_TOKEN" \
      "$API?exclude_archived=true&limit=200" 2>/dev/null)
    
    # Check for errors
    if echo "$response" 2>/dev/null | grep -q '"ok":false' 2>/dev/null; then
      echo "ERROR"
      exit 1
    fi
    
    # Count total unreads
    if command -v jq >/dev/null 2>&1; then
      # Sum up unread_count_display from channels where user is member
      channels_unread=$(echo "$response" 2>/dev/null | jq '[.channels[] | select(.is_member == true) | .unread_count_display // 0] | add // 0' 2>/dev/null || echo "0")
      
      # Also get DMs/IMs unread count
      dm_response=$(curl -s \
        -H "Authorization: Bearer $SLACK_USER_TOKEN" \
        "https://slack.com/api/conversations.list?types=im&exclude_archived=true&limit=200" 2>/dev/null)
      
      dm_unread=$(echo "$dm_response" 2>/dev/null | jq '[.channels[] | .unread_count_display // 0] | add // 0' 2>/dev/null || echo "0")
      
      # Total unread count
      unread_count=$((channels_unread + dm_unread))
    else
      # Fallback without jq - just count channels with unread messages
      unread_count=$(echo "$response" 2>/dev/null | grep -o '"unread_count_display":[1-9][0-9]*' 2>/dev/null | wc -l 2>/dev/null | tr -d ' ')
    fi
    
    echo "${unread_count:-0}" 2>/dev/null || echo "0"
  ]]
  
  sbar.exec(script, function(result)
    local count_str = result:gsub("%s+", "")
    
    if count_str == "NO_TOKEN" then
      slack:set({
        icon = { 
          string = icons.slack.mark,
          color = colors.grey
        },
        label = { string = "?" },
      })
      return
    end
    
    if count_str == "ERROR" then
      slack:set({
        icon = { 
          string = icons.slack.mark,
          color = colors.red
        },
        label = { string = "!" },
      })
      return
    end
    
    local count = tonumber(count_str) or 0
    local icon = icons.slack.mark
    local color = colors.white
    
    if count > 0 then
      icon = icons.slack.unread or icons.slack.mark
    end
    
    local label = tostring(count)
    if count > 99 then
      label = "99+"
    end
    
    slack:set({
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

slack:subscribe({ "routine", "system_woke", "forced" }, function()
  update_slack_notifications()
end)

slack:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "left" then
    -- Open Slack app or web
    sbar.exec("open -a Slack || open https://app.slack.com/client")
  elseif env.BUTTON == "right" then
    -- Force refresh
    update_slack_notifications()
  end
end)

sbar.add("bracket", "widgets.slack.bracket", { slack.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.slack.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Initial update
update_slack_notifications()