local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local linear = sbar.add("item", "widgets.linear", {
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

-- Alternative implementation using viewer's inbox count
local function update_linear_inbox()
  local script = [[
    if [ -z "$LINEAR_API_KEY" ]; then
      echo "NO_TOKEN"
      exit 0
    fi

    # Linear GraphQL API endpoint
    API="https://api.linear.app/graphql"

    # GraphQL query to get unread notifications
    QUERY='{"query":"{ notifications { nodes { id readAt } } }"}'

    # Make the API call
    response=$(curl -s \
      -H "Authorization: $LINEAR_API_KEY" \
      -H "Content-Type: application/json" \
      -d "$QUERY" \
      "$API" 2>/dev/null)

    # Check for errors
    if echo "$response" | grep -q '"errors"'; then
      echo "ERROR"
      exit 1
    fi

    # Count unread notifications (where readAt is null) using jq
    if command -v jq >/dev/null 2>&1; then
      inbox_count=$(echo "$response" | jq -r '.data.notifications.nodes | map(select(.readAt == null)) | length' 2>/dev/null || echo "0")
    else
      # Fallback: count occurrences of "readAt":null
      inbox_count=$(echo "$response" | grep -o '"readAt":null' | wc -l | tr -d ' ')
    fi

    echo "${inbox_count:-0}"
  ]]

  sbar.exec(script, function(result)
    local count_str = result:gsub("%s+", "")

    if count_str == "NO_TOKEN" then
      linear:set({
        icon = {
          string = icons.linear.mark,
          color = colors.grey
        },
        label = { string = "?" },
      })
      return
    end

    if count_str == "ERROR" then
      linear:set({
        icon = {
          string = icons.linear.mark,
          color = colors.red
        },
        label = { string = "!" },
      })
      return
    end

    local count = tonumber(count_str) or 0
    local icon = icons.linear.mark
    local color = colors.white

    if count > 0 then
      icon = icons.linear.inbox_dot or icons.linear.mark
    end

    local label = tostring(count)
    if count > 99 then
      label = "99+"
    end

    linear:set({
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

linear:subscribe({ "routine", "system_woke", "forced" }, function()
  -- Use inbox count instead of notifications
  -- Change to update_linear_notifications() if you prefer notification count
  update_linear_inbox()
end)

linear:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "left" then
    sbar.exec("open https://linear.app/inbox")
  elseif env.BUTTON == "right" then
    -- Force refresh
    update_linear_inbox()
  end
end)

sbar.add("bracket", "widgets.linear.bracket", { linear.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.linear.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Initial update
update_linear_inbox()

