#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────
# Beads Viewer — Server Management
#
# Usage:
#   bash scripts/bv-server.sh start    # Start preview server
#   bash scripts/bv-server.sh stop     # Stop server
#   bash scripts/bv-server.sh status   # Check if running
#   bash scripts/bv-server.sh restart  # Restart server
#   bash scripts/bv-server.sh refresh  # Re-export pages without restart
# ────────────────────────────────────────────────────────────────────
set -euo pipefail

PAGES_DIR="/tmp/bv-pages"
PID_FILE="/tmp/bv_server.pid"
LOG_FILE="/tmp/bv_server.log"
PORT=9000

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
    return 0
  fi

  if ! command -v bv &>/dev/null; then
    echo -e "${RED}bv not installed.${NC} Install beads_viewer first."
    exit 1
  fi

  # Export pages first
  echo -n "Exporting beads pages..."
  bv --export-pages "$PAGES_DIR" >/dev/null 2>&1
  echo -e " ${GREEN}done${NC}"

  # Start preview server in background
  echo -n "Starting beads viewer on port $PORT..."
  bv --preview-pages "$PAGES_DIR" --no-live-reload >> "$LOG_FILE" 2>&1 &
  local pid=$!
  echo "$pid" > "$PID_FILE"

  # Wait for server to be ready
  for i in $(seq 1 10); do
    if curl -s "http://127.0.0.1:$PORT" >/dev/null 2>&1; then
      echo -e " ${GREEN}started${NC} (PID: $pid)"
      echo "  URL:  http://127.0.0.1:$PORT"
      echo "  Logs: $LOG_FILE"
      return 0
    fi
    sleep 0.5
  done

  echo -e " ${YELLOW}started${NC} (PID: $pid, may still be initializing)"
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
    if curl -s "http://127.0.0.1:$PORT" >/dev/null 2>&1; then
      echo -e "  HTTP: ${GREEN}responding${NC}"
    else
      echo -e "  HTTP: ${YELLOW}not responding${NC}"
    fi
    echo "  Logs: $LOG_FILE"
  else
    echo -e "${RED}Not running${NC}"
    echo "  Start with: make start-bv"
  fi
}

# Re-export pages without restarting server
do_refresh() {
  echo -n "Re-exporting beads pages..."
  bv --export-pages "$PAGES_DIR" >/dev/null 2>&1
  echo -e " ${GREEN}done${NC}"
  if get_pid >/dev/null; then
    echo "  Server still running — refresh browser to see changes."
  else
    echo "  Server not running. Start with: bash scripts/bv-server.sh start"
  fi
}

case "${1:-status}" in
  start)   do_start ;;
  stop)    do_stop ;;
  restart) do_stop; sleep 1; do_start ;;
  status)  do_status ;;
  refresh) do_refresh ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|refresh}"
    exit 1
    ;;
esac
