# Simple MCP server for learning purposes

The goal is to create a **local MCP Server** (i. e. communicating over STDIN/STDOUT) for educational purposes.

Refer to @https://modelcontextprotocol.io/docs/develop/build-server for the MCP specifications.

The created MCP Server must be simple so that I can follow what's happening "under the hood" when connecting to an MCP server from OpenCode.

Refer to @opencode.json to figure out the characteristics of the server.

## Offered functions

The MCP should offer these functions (tools):
  - `currentDate` (In order for me to check that the date commes from the MCP, the return value must start with *The current date is:*. Also, I want the date format in `yyyy-mm-dd`.
  - `constantText` (which returns *Hello world*, obviously)
  - `constantNumber` (which returns *42*, also obvious)

## Code guidelines

*Don't*
  - use libraries except those that come with Python's standard library.
  - use the `if __name__ == "__main__":` guard. I already know that I want to run the script as a script. It won't be imported.
  - neither use a function named `main()` or similar that is called at the end of the script for the same reason.
  - create directories and dependencies. Create *one* script only.


## Testing

After creating the script, test it with the following call which must not return a status code different from 0:

     opencode mcp list | grep 'renes-test.*connected'

Also write a script that sends the following RPCs that seem to correspond the OpenCode's initial RPCs when connectiong to an MCP:

     {"method":"initialize","params":{"protocolVersion":"2025-11-25","capabilities":{},"clientInfo":{"name":"opencode","version":"1.2.20"}},"jsonrpc":"2.0","id":0}

     {"method":"notifications/initialized","jsonrpc":"2.0"}

     {"method":"tools/list","jsonrpc":"2.0","id":1}

This script should also test sent the following object

     {"jsonrpc":"2.0","method":"tools/list",                                   "id":2}

     {"jsonrpc":"2.0","method":"tools/call", "params": {"name": "currentDate"},"id":3}

If one of these tests fails, create another mcp server, until it works.
