#!/opt/homebrew/bin/fish

set -l mock_dir (mktemp -d)
set -l mock_log "$mock_dir/argv.log"

function cleanup --on-event fish_exit
  /bin/rm -rf "$mock_dir"
end

printf '%s\n' \
  '#!/bin/sh' \
  'printf "%s\n" "$@" > "$MOCK_LOG"' \
  > "$mock_dir/claude"
/bin/chmod +x "$mock_dir/claude"
/bin/cp "$mock_dir/claude" "$mock_dir/codex"

source home/.config/fish/config.fish
set -gx PATH "$mock_dir" /usr/bin /bin
set -gx MOCK_LOG "$mock_log"

function assert_args --argument-names label
  set -e argv[1]
  set -l actual (/bin/cat "$MOCK_LOG")
  set -l expected_serialized (string escape -- $argv | string join ' ')
  set -l actual_serialized (string escape -- $actual | string join ' ')
  if test "$actual_serialized" != "$expected_serialized"
    printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' \
      "$label" "$expected_serialized" "$actual_serialized" >&2
    exit 1
  end
end

set -gx HERDR_ENV 1

claude --resume claude-session
assert_args 'Herdr Claude resume' \
  --dangerously-skip-permissions --resume claude-session

codex resume codex-session
assert_args 'Herdr Codex resume' \
  --dangerously-bypass-approvals-and-sandbox resume codex-session

claude --version
assert_args 'Herdr Claude non-resume' --version

codex exec prompt
assert_args 'Herdr Codex non-resume' exec prompt

cc --resume claude-session
assert_args 'cc resume has one bypass flag' \
  --dangerously-skip-permissions --resume claude-session

co resume codex-session
assert_args 'co resume has one bypass flag' \
  --dangerously-bypass-approvals-and-sandbox resume codex-session

set -e HERDR_ENV

claude --resume claude-session
assert_args 'non-Herdr Claude resume' --resume claude-session

codex resume codex-session
assert_args 'non-Herdr Codex resume' resume codex-session

echo 'PASS: Herdr resume wrappers'
