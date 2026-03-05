# Create a shell script to translate

@https://github.com/ReneNyffenegger/OpenCode-learning-log/blob/master/.opencode/commands/translate.md is an OpenCode command to translate
text in OpenCode's TUI.

Because this command is a bit slow, I want a shell script that calls the [https://api.moonshot.ai/v1/chat/completions](endpoint of the moonshot API) and uses the `kimi-k2.5` model to
translate the text.

You can assume that the moonshot API key is stored in the environment variable `MOONSHOT_API_KEY` when the script is being run.

Use `curl` and `jq`.\
*Do not* embed `python` into the script. 

Name the script `translate`, put it into the directory `out` (to be created if it doesn't exist) and set the executable bits for the owner and the group.

## Testing

Test the script with

    ./out/translate In einer Zeit, in der Algorithmen unsere Entscheidungen maßgeblich beeinflussen, gewinnt die digitale Souveränität an Bedeutung

If the test fails, fix the script and test again.
