"""Minimal local MCP server speaking JSON-RPC 2.0 over STDIN/STDOUT.

Implements the three requested tools and basic MCP methods:
- initialize
- tools/list
- tools/call
"""

import datetime
import json
import sys
import traceback


TOOLS = {
    "currentDate": {
        "name": "currentDate",
        "description": "Return today's date as yyyy-mm-dd prefixed with explanatory text",
        "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
    },
    "constantText": {
        "name": "constantText",
        "description": "Return a friendly greeting",
        "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
    },
    "constantNumber": {
        "name": "constantNumber",
        "description": "Return the answer to everything",
        "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
    },
}


def send_message(payload):
    sys.stdout.write(json.dumps(payload) + "\n")
    sys.stdout.flush()


def send_error(request_id, code, message):
    send_message({
        "jsonrpc": "2.0",
        "id": request_id,
        "error": {
            "code": code,
            "message": message,
        },
    })


def tool_result_text(text):
    return {"content": [{"type": "text", "text": text}]}


def handle_initialize(request):
    result = {
        "protocolVersion": "2025-11-25",
        "capabilities": {"tools": {}},
        "serverInfo": {"name": "simple-mcp-server", "version": "0.1.0"},
    }
    send_message({"jsonrpc": "2.0", "id": request.get("id"), "result": result})


def handle_tools_list(request):
    result = {"tools": list(TOOLS.values())}
    send_message({"jsonrpc": "2.0", "id": request.get("id"), "result": result})


def handle_tools_call(request):
    params = request.get("params") or {}
    name = params.get("name")
    if name not in TOOLS:
        send_error(request.get("id"), -32602, "Unknown tool name")
        return

    if name == "currentDate":
        today = datetime.date.today().isoformat()
        result = tool_result_text(f"The current date is: {today}")
    elif name == "constantText":
        result = tool_result_text("Hello world")
    elif name == "constantNumber":
        result = tool_result_text("42")
    else:
        result = tool_result_text("Unsupported tool")

    send_message({"jsonrpc": "2.0", "id": request.get("id"), "result": result})


def dispatch(request):
    method = request.get("method")

    if method == "initialize":
        handle_initialize(request)
    elif method == "tools/list":
        handle_tools_list(request)
    elif method == "tools/call":
        handle_tools_call(request)
    elif method == "notifications/initialized":
        # Notification; no response expected.
        return
    else:
        send_error(request.get("id"), -32601, "Method not found")


def run_server():
    for line in sys.stdin:
        stripped = line.strip()
        if not stripped:
            continue
        try:
            request = json.loads(stripped)
        except json.JSONDecodeError as exc:
            send_error(None, -32700, f"Parse error: {exc}")
            continue

        try:
            dispatch(request)
        except Exception:
            send_error(request.get("id"), -32000, "Internal server error")
            traceback.print_exc(file=sys.stderr)


run_server()
