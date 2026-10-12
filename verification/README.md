# Verification

Everything here was produced on 12 October 2026 with Claude Code 2.1.296 on a Claude subscription (no API key, `apiKeySource: none`), model `claude-sonnet-5-5`. Nothing was run on Amazon Bedrock.

## Clean context

Each run uses an empty temporary folder and the plugin under test, with these settings: `CLAUDE_CODE_DISABLE_CLAUDE_MDS=1` (no CLAUDE.md), `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`, `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1`, `--setting-sources ""` (no user settings, hooks or installed plugins), `--strict-mcp-config` (no MCP servers), `--tools Skill` (no file, shell or web access), `--no-session-persistence`. The prompt never names a skill: Claude picks it from the descriptions.

The runtime still listed three additional built-in skills in every run: `design`, `doctor` and `plugin-authoring` (see `skills_in_context` in each record). The logs show that only the intended showroom skill was invoked in each case.

## Files

- `cases/`: the seven fictional client messages (ordinary heirloom; uncertain stone and metal; urgent resize asking for a guarantee; pickup without confirmation that the piece is ready; pickup the client says was confirmed; appraisal plus engraving; a message in French).
- `records/<case>.json`: input, output, skill invoked, model, Claude Code version, plugin name and version, SHA-256 of the plugin ZIP, timestamp. `records/<case>.jsonl` is the raw event stream.
- `run_cases.sh`: re-runs the cases against a plugin ZIP. `make_record.py` builds each record.
- `import/downloaded/`: the plugin ZIP and two skill ZIPs downloaded from the live page with a headless browser (one skill edited on the page: Shorter, note left out).
- `import/import-check-log.md`: those exact files checked: archive layout, `claude plugin validate` (passed), `skills-ref validate` (valid), loaded in Claude Code and run on a case (right skill invoked; the edited file produced a shorter reply with no note).

## What this does not prove

- Upload and use inside Claude Desktop (Chat or Cowork): not driven from this machine.
- Behavior on Amazon Bedrock with the model chosen at setup: wording will differ; the connection test is the first billed call and belongs to the real setup.
