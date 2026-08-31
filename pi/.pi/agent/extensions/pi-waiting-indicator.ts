// pi-waiting-indicator.ts
//
// Marks the tmux window a pi.dev session is running in with the
// `@pi_waiting` user option whenever pi goes idle waiting for user input,
// and clears it as soon as a new prompt is submitted or the session ends.
//
// Paired with tmux/tmux-pi-waiting.conf, which surfaces `@pi_waiting`
// windows in the status bar and provides Prefix+P to jump to one.
//
// No-op outside tmux.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

export default function (pi: ExtensionAPI) {
  const tmuxPane = process.env.TMUX_PANE;
  if (!tmuxPane) return; // not running inside tmux

  let target: string | undefined;

  async function resolveTarget(): Promise<string | undefined> {
    if (target) return target;
    try {
      const { stdout } = await execFileAsync("tmux", [
        "display-message",
        "-p",
        "-t",
        tmuxPane,
        "#{session_name}:#{window_index}",
      ]);
      target = stdout.trim() || undefined;
    } catch {
      // tmux binary missing or pane gone; stay disabled silently
    }
    return target;
  }

  async function setWaiting(waiting: boolean) {
    const t = await resolveTarget();
    if (!t) return;
    execFile(
      "tmux",
      ["set-window-option", "-t", t, "@pi_waiting", waiting ? "on" : "off"],
      () => {}, // fire and forget; ignore errors (e.g. window closed)
    );
  }

  pi.on("session_start", async () => {
    await setWaiting(false);
  });

  // Fired right after the user submits a prompt (before the agent loop runs).
  pi.on("before_agent_start", async () => {
    await setWaiting(false);
  });

  // Fired when pi is truly idle and will not continue automatically.
  pi.on("agent_settled", async () => {
    await setWaiting(true);
  });

  pi.on("session_shutdown", async () => {
    await setWaiting(false);
  });
}
