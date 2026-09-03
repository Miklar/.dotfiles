// pi-waiting-indicator.ts
//
// Marks the tmux window a pi.dev session is running in with user options:
// - `@pi_active=on` while pi is processing a prompt
// - `@pi_waiting=on` once pi settles and needs user input
//
// Paired with tmux/tmux-pi-waiting.conf, which surfaces waiting windows and
// provides shortcuts for jumping to waiting or active pi sessions.
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

  async function setOption(name: "@pi_active" | "@pi_waiting", enabled: boolean) {
    const t = await resolveTarget();
    if (!t) return;
    try {
      await execFileAsync("tmux", [
        "set-window-option",
        "-t",
        t,
        name,
        enabled ? "on" : "off",
      ]);
    } catch {
      // Window closed or tmux unavailable; stay disabled silently.
    }
  }

  async function setState(state: "idle" | "active" | "waiting") {
    // Turn off the previous state before enabling the next one so active and
    // waiting are never simultaneously advertised.
    await setOption("@pi_active", false);
    await setOption("@pi_waiting", false);

    if (state === "active") await setOption("@pi_active", true);
    if (state === "waiting") await setOption("@pi_waiting", true);
  }

  pi.on("session_start", async () => {
    await setState("idle");
  });

  // Fired right after the user submits a prompt (before the agent loop runs).
  pi.on("before_agent_start", async () => {
    await setState("active");
  });

  // Fired when pi is truly idle and will not continue automatically.
  pi.on("agent_settled", async () => {
    await setState("waiting");
  });

  pi.on("session_shutdown", async () => {
    await setState("idle");
  });
}
