#! /usr/bin/env node

import { execFileSync } from "node:child_process";
import { readFileSync, existsSync } from "node:fs";
import path from "node:path";
import os from "node:os";

function getTmuxInfo() {
  try {
    const session = execFileSync('tmux', ['display-message', '-p', '#{session_name}'], { encoding: 'utf8' }).trim();
    const window = execFileSync('tmux', ['display-message', '-p', '#{window_index}'], { encoding: 'utf8' }).trim();
    const pane = execFileSync('tmux', ['display-message', '-p', '#{pane_index}'], { encoding: 'utf8' }).trim();
    return { session, window, pane };
  } catch {
    return null;
  }
}

try {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  if (!input.transcript_path) {
    process.exit(0);
  }

  const homeDir = os.homedir();
  let transcriptPath = input.transcript_path;

  if (transcriptPath.startsWith('~/')) {
    transcriptPath = path.join(homeDir, transcriptPath.slice(2));
  }

  const allowedBase = path.join(homeDir, '.claude', 'projects');
  const resolvedPath = path.resolve(transcriptPath);

  if (!resolvedPath.startsWith(allowedBase)) {
    process.exit(1);
  }

  if (!existsSync(resolvedPath)) {
    console.log('Hook execution failed: Transcript file does not exist');
    process.exit(0);
  }

  const lines = readFileSync(resolvedPath, "utf-8").split("\n").filter(line => line.trim());
  if (lines.length === 0) {
    console.log('Hook execution failed: Transcript file is empty');
    process.exit(0);
  }

  const lastLine = lines[lines.length - 1];
  const transcript = JSON.parse(lastLine);
  const lastMessageContent = transcript?.message?.content?.[0]?.text;

  if (lastMessageContent) {
    const tmuxInfo = getTmuxInfo();
    const message = lastMessageContent.substring(0, 200);

    if (tmuxInfo) {
      const focusScript = path.join(homeDir, '.claude', 'hooks', 'focus-claude-pane.sh');
      execFileSync('terminal-notifier', [
        '-title', 'Claude Code',
        '-message', message,
        '-execute', `"${focusScript}" "${tmuxInfo.session}" "${tmuxInfo.window}" "${tmuxInfo.pane}"`
      ], { stdio: 'ignore' });
    } else {
      execFileSync('terminal-notifier', [
        '-title', 'Claude Code',
        '-message', message
      ], { stdio: 'ignore' });
    }
  }
} catch (error) {
  console.log('Hook execution failed:', error.message);
  process.exit(1);
}
