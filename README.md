This is a log where I try to note observations I made while trying to learn *OpenCode*.

# Commands

## translate

[`translate`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/.opencode/commands/translate.md) - Translate from/to english and/or german.

*Observations*:
 - The command does not specify an agent
 - It takes quite a while for a translation to be finished. Would the response time be better with another model?

# Assigning Tasks

## Create a shell script to translate text

[`create-shell-script-translate/assignment.md`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/create-shell-script-translate/assignment.md) - Create a shell script to translate text from/to english/german.

The assignment was executed with

    opencode run assignment.md  --model github-copilot/gpt-5.1-codex-max --agent build

### Observations

I had a hardcoded absolute path to `./opencode/commands/translate.md`. When executing the script, OpenCode told me that I didn't have the required persmissions to read the file
(`permission requested: external_directory (/home/rene/‥/.opencode/commands/*); auto-rejecting`)\
When I used [`@https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/.opencode/commands/translate.md`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/bd7dc8c3fbb353ac85bbbe43ee9776e337d83846/create-shell-script-translate/assignment.md?plain=1#L3C1-L3C105) instead, the error went away.

I had a few unsuccessful attempts to create the shell script because it tried the chinese URL `api.moonshot.cn` rather than `api.moonshot.ai`.
I fixed this by explicitely specifying the URL.

OpenCode notified me that it used the *WebFetch* (tool?) with

    % WebFetch https://raw.githubusercontent.com/ReneNyffenegger/OpenCode-learning-log/master/.opencode/commands/translate.md

I *guess* that the `%` sign indicates tool usage

All in all, I was surprised how long it took for the model to create a shell script which I assumed would be rather easy.

## Create a simple MCP Server

The goal of [`MCP-server/simple/create.md`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/MCP-server/simple/create.md) was to create a *simple MCP server* for educational purposes.

In order for `opencode` to be able to connect the MCP server, I had to [register it in the `opencode.json`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/ce1fd643f57fae5058be1d386478d551e384823b/MCP-server/simple/opencode.json#L3-L7) config file.

The MCP server was created by executing [`create.sh`](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/MCP-server/simple/create.sh)

### Observations

In one of the early tests, OpenCode created an MCP server that implemented the method `tools/execute` instead of `tools/call`.\
This gave rise to [an explicit test](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/ce1fd643f57fae5058be1d386478d551e384823b/MCP-server/simple/create.md?plain=1#L45) for `tools/call`.

When I executed `create.sh`, OpenCode also a `create.md` file in the `out` directory with approximatly the same content as in `create.md`, but formatted a bit differently.\
I didn't not add the created `out/create.md` to the git repository.

With this example, I also added a "global" instruction in the top level `AGENTS.md` file [to create artifacts in `out` directories](https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/06fa9c76d722d8fb5fa1310862591dbf371b8f90/AGENTS.md?plain=1#L2-L4).\
I was pleased to see that this instruction was honored.

## Oracle PL/SQL: Stored procedure to kill blocking sessions


