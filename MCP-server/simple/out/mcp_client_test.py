"""Send a sequence of JSON-RPC requests to the local MCP server.

This mimics the initial OpenCode handshake and tool calls.
Run with: python out/mcp_client_test.py
"""

import json
import subprocess
import sys


REQUESTS = [
    {"method": "initialize", "params": {"protocolVersion": "2025-11-25", "capabilities": {}, "clientInfo": {"name": "opencode", "version": "1.2.20"}}, "jsonrpc": "2.0", "id": 0},
    {"method": "notifications/initialized", "jsonrpc": "2.0"},
    {"method": "tools/list", "jsonrpc": "2.0", "id": 1},
    {"jsonrpc": "2.0", "method": "tools/list", "id": 2},
    {"jsonrpc": "2.0", "method": "tools/call", "params": {"name": "currentDate"}, "id": 3},
]


def main() -> None:
    proc = subprocess.Popen([
        sys.executable,
        "out/simple_mcp_server.py",
    ], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    stdin = proc.stdin
    if stdin is None:
        raise RuntimeError("Failed to open stdin for server process")

    for req in REQUESTS:
        stdin.write(json.dumps(req) + "\n")
        stdin.flush()

    stdin.close()

    stdout, stderr = proc.communicate(timeout=5)

    print("STDOUT:")
    print(stdout.rstrip())
    if stderr:
        print("\nSTDERR:")
        print(stderr.rstrip())


if __name__ == "__main__":
    main()
