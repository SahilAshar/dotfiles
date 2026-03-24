---
name: serve-insights
description: Serve the Claude Code insights report locally via HTTP after running /insights. Designed for any environment including remote/Codespaces.
disable-model-invocation: true
allowed-tools: Bash, Read
---

# Serve Insights Report

After the user runs `/insights`, serve the generated HTML report via a local HTTP server so they can view it in their browser.

## Instructions

1. Check if the insights report exists. Try both paths and set `REPORT_DIR` to the directory containing it:
   ```
   if [ -f ~/.claude/usage-data/report.html ]; then
     REPORT_DIR=~/.claude/usage-data
   elif [ -f /workarea/.claude_config/usage-data/report.html ]; then
     REPORT_DIR=/workarea/.claude_config/usage-data
   fi
   ```
   If neither exists, tell the user: "No insights report found. Run `/insights` first to generate one."
   Then stop.

2. Kill any existing process on port 8080 so we start clean. Try `fuser` first, fall back to `ss`+`kill`:
   ```
   fuser -k 8080/tcp 2>/dev/null || {
     PID=$(ss -tlnp sport = :8080 2>/dev/null | grep -oP 'pid=\K[0-9]+' | head -1)
     [ -n "$PID" ] && kill "$PID" 2>/dev/null
   }
   ```
   Also clean up any stale PID file:
   ```
   rm -f "$REPORT_DIR/insights-server.pid" 2>/dev/null
   ```

3. Find a working Python binary. Do NOT assume `python3` or `python` are on PATH. Search broadly:
   ```
   PYTHON=$(
     command -v python3 2>/dev/null ||
     command -v python 2>/dev/null ||
     find /opt /usr/local -maxdepth 4 -name 'python3.*' -type f ! -name '*-config' ! -name '*-gdb*' 2>/dev/null | sort -V | tail -1
   )
   ```
   If no Python is found, tell the user: "No Python binary found. Cannot start HTTP server."
   Then stop.

4. Start the server in the background using the discovered Python and report directory:
   ```
   $PYTHON -m http.server 8080 -d $REPORT_DIR > $REPORT_DIR/insights-server.log 2>&1 &
   echo $! > $REPORT_DIR/insights-server.pid
   ```

5. Verify the server is actually accessible by checking after a brief delay:
   ```
   sleep 1 && curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/report.html
   ```
   - If the response is `200`, the server is healthy.
   - If not, check `$REPORT_DIR/insights-server.log` for errors, report them to the user, and stop.

6. Tell the user:
   - The report is live at: `http://localhost:8080/report.html`
   - If in a remote/SSH environment, they may need to set up port forwarding (e.g., `ssh -L 8080:localhost:8080 <host>`) or check the **Ports** tab in their IDE
   - Let you know when they're done so you can stop the server

7. When the user says they're done, stop the server cleanly:
   ```
   kill "$(cat $REPORT_DIR/insights-server.pid)" && rm $REPORT_DIR/insights-server.pid
   ```
