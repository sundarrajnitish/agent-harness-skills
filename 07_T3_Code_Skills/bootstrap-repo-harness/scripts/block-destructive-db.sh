#!/usr/bin/env bash
# PreToolUse hook: blocks destructive database commands unless LOCAL_ONLY=1.
# Reads tool call JSON on stdin; exit code 2 blocks the call and returns stderr to the agent.

input="$(cat)"
cmd="$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)"

if printf '%s' "$cmd" | grep -Eq 'db:reset|migrate:fresh|DROP (TABLE|DATABASE)|TRUNCATE '; then
  if [ "${LOCAL_ONLY:-0}" != "1" ]; then
    echo "Blocked: destructive DB command. Set LOCAL_ONLY=1 for a local-only session." >&2
    exit 2
  fi
fi
exit 0
