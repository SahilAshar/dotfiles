---
name: serve-insights
description: Serve the Claude Code insights report locally via HTTP after running /insights. Designed for Codespace environments.
disable-model-invocation: true
allowed-tools: Bash, Read
---

# Serve Insights Report

After the user runs `/insights`, serve the generated HTML report via a local HTTP server so they can view it in their browser.

## Instructions

1. Check if the insights report exists:
   ```
   ls ~/.claude/usage-data/report.html
   ```
   If it does NOT exist, tell the user: "No insights report found. Run `/insights` first to generate one."
   Then stop.

2. Check if a server is already running on port 8080:
   ```
   ss -ltn sport = :8080 | grep -q LISTEN
   ```
   If a server is already running, tell the user it's already being served and remind them to check the **Ports** tab.

3. If no server is running, start one in the background and record its PID:
   ```
   python3 -m http.server 8080 -d ~/.claude/usage-data > ~/.claude/usage-data/insights-server.log 2>&1 &
   echo $! > ~/.claude/usage-data/insights-server.pid
   ```

4. Tell the user:
   - The report is being served on **port 8080**
   - Check the **Ports** tab in the Codespace and click the forwarded URL
   - Append `/report.html` to the URL to view the report
   - Let you know when they're done so you can stop the server

5. When the user says they're done, stop the server cleanly:
   ```
   kill "$(cat ~/.claude/usage-data/insights-server.pid)" && rm ~/.claude/usage-data/insights-server.pid
   ```
