#!/usr/bin/env bash
# Rename every herdr tab to what is running in its (focused) pane.
# Naming priority: detected agent (claude, codex, ...) > oldest foreground
# process (= what the user launched; newest entries are transient children
# like caffeinate) > the shell itself.
# Manual tab names are respected: a tab is only renamed while its label is
# the default number or a name this script set earlier (tracked in state).
set -euo pipefail

HERDR="${HERDR_BIN_PATH:-herdr}"
STATE_DIR="${HERDR_PLUGIN_STATE_DIR:-${TMPDIR:-/tmp}}"
STATE_FILE="$STATE_DIR/auto-names.json"
LOCK_DIR="$STATE_DIR/rename.lock"

# Events can fire in bursts; drop concurrent runs, the next event catches up.
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK_DIR"' EXIT

[ -f "$STATE_FILE" ] || echo '{}' >"$STATE_FILE"

tabs=$("$HERDR" tab list | jq -c '.result.tabs[]?')
panes=$("$HERDR" pane list | jq -c '.result.panes[]?')
agents=$("$HERDR" agent list | jq -c '.result.agents // []')
[ -n "$tabs" ] || exit 0

label_for_pane() {
  local pane_id="$1" agent info
  agent=$(jq -r --arg p "$pane_id" '.[] | select(.pane_id == $p) | .agent' <<<"$agents" | head -n 1)
  if [ -n "$agent" ]; then
    echo "$agent"
    return 0
  fi

  info=$("$HERDR" pane process-info --pane "$pane_id" 2>/dev/null) || return 1
  jq -r '
    .result.process_info as $pi
    | ([$pi.foreground_processes[]?
        | select(.pid != $pi.shell_pid)
        | (.argv0 | split("/") | last | sub("^-"; "")) as $cmd
        | select($cmd != "starship")
        | if ($cmd | IN("node", "python", "python3", "ruby", "bun", "deno", "sh", "bash"))
          then (((.argv // [])[1:] | map(select(startswith("-") | not)) | first
                 | split("/") | last | sub("\\.(rb|py|js|mjs|cjs|ts)$"; "")) // $cmd)
          else $cmd
          end
       ][-1])
      // ([$pi.foreground_processes[]? | select(.pid == $pi.shell_pid)
           | .argv0 | split("/") | last | sub("^-"; "")][0])
      // empty
  ' <<<"$info"
}

new_state='{}'
while IFS= read -r tab; do
  [ -n "$tab" ] || continue
  tab_id=$(jq -r '.tab_id' <<<"$tab")
  label=$(jq -r '.label' <<<"$tab")
  number=$(jq -r '.number' <<<"$tab")

  pane_id=$(jq -r --arg t "$tab_id" 'select(.tab_id == $t and .focused) | .pane_id' <<<"$panes" | head -n 1)
  [ -n "$pane_id" ] || pane_id=$(jq -r --arg t "$tab_id" 'select(.tab_id == $t) | .pane_id' <<<"$panes" | head -n 1)
  [ -n "$pane_id" ] || continue

  name=$(label_for_pane "$pane_id") || continue
  [ -n "$name" ] || continue

  last_auto=$(jq -r --arg t "$tab_id" '.[$t] // empty' "$STATE_FILE")

  # A label that is neither the default number nor our previous rename was
  # set by the user; leave it alone.
  if [ "$label" != "$number" ] && [ "$label" != "$last_auto" ]; then
    continue
  fi

  if [ "$label" != "$name" ]; then
    "$HERDR" tab rename "$tab_id" "$name" >/dev/null
  fi
  new_state=$(jq -c --arg t "$tab_id" --arg n "$name" '.[$t] = $n' <<<"$new_state")
done <<<"$tabs"

echo "$new_state" >"$STATE_FILE"
