#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────
# mcp_agent_mail — Server Management
#
# Usage:
#   bash scripts/mail-server.sh start    # Start server in background
#   bash scripts/mail-server.sh stop     # Stop server
#   bash scripts/mail-server.sh status   # Check if running
#   bash scripts/mail-server.sh restart  # Restart server
# ────────────────────────────────────────────────────────────────────
set -euo pipefail

MCP_MAIL_DIR="$HOME/.mcp_agent_mail"
PID_FILE="/tmp/mcp_agent_mail.pid"
LOG_FILE="/tmp/mcp_agent_mail.log"
PORT=8765

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

get_pid() {
  if [ -f "$PID_FILE" ]; then
    local pid
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      echo "$pid"
      return 0
    fi
    rm -f "$PID_FILE"
  fi
  return 1
}

do_start() {
  if pid=$(get_pid); then
    echo -e "${YELLOW}Already running${NC} (PID: $pid, port: $PORT)"
    echo "  Logs: $LOG_FILE"
    return 0
  fi

  if [ ! -d "$MCP_MAIL_DIR" ]; then
    echo -e "${RED}mcp_agent_mail not installed.${NC} Run: make setup-mail"
    exit 1
  fi

  if [ ! -f "$MCP_MAIL_DIR/.venv/bin/python" ]; then
    echo -e "${RED}Python venv not found.${NC} Run: make setup-mail"
    exit 1
  fi

  # Load token
  if [ -f "$MCP_MAIL_DIR/.env" ]; then
    set -a
    source "$MCP_MAIL_DIR/.env"
    set +a
  fi

  echo -n "Starting mcp_agent_mail on port $PORT..."

  cd "$MCP_MAIL_DIR"
  .venv/bin/python -m mcp_agent_mail.http --port "$PORT" >> "$LOG_FILE" 2>&1 &
  local pid=$!
  echo "$pid" > "$PID_FILE"
  cd - >/dev/null

  # Wait for server to be ready
  for i in $(seq 1 10); do
    if curl -s "http://127.0.0.1:$PORT/docs" >/dev/null 2>&1; then
      echo -e " ${GREEN}started${NC} (PID: $pid)"
      echo "  URL:  http://127.0.0.1:$PORT"
      echo "  Logs: $LOG_FILE"
      return 0
    fi
    sleep 0.5
  done

  echo -e " ${YELLOW}started${NC} (PID: $pid, may still be initializing)"
  echo "  Logs: $LOG_FILE"
}

do_stop() {
  if pid=$(get_pid); then
    kill "$pid" 2>/dev/null
    rm -f "$PID_FILE"
    echo -e "${GREEN}Stopped${NC} (was PID: $pid)"
  else
    echo "Not running."
  fi
}

do_status() {
  if pid=$(get_pid); then
    echo -e "${GREEN}Running${NC} (PID: $pid, port: $PORT)"
    if curl -s "http://127.0.0.1:$PORT/docs" >/dev/null 2>&1; then
      echo -e "  HTTP: ${GREEN}responding${NC}"
    else
      echo -e "  HTTP: ${YELLOW}not responding${NC}"
    fi
    echo "  Logs: $LOG_FILE"
  else
    echo -e "${RED}Not running${NC}"
    echo "  Start with: make start-mail"
  fi
}

case "${1:-status}" in
  start)   do_start ;;
  stop)    do_stop ;;
  restart) do_stop; sleep 1; do_start ;;
  status)  do_status ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
