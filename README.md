# Two Claude assistants for a fine jewelry showroom

An independent sample by [The AI Pipe](https://theaipipe.com) for Alina Korotkina Fine Jewelry (Bainbridge Island, WA). Page: <https://theaipipe.com/demos/korotkina/>

Two assistants, packaged as one Claude plugin:

| Assistant | Reads | Returns |
| --- | --- | --- |
| `custom-heirloom-inquiries` | a client's message about a custom piece or a family heirloom | a short draft reply that suggests the right consultation and links the booking page, plus a prep note for Alina |
| `repair-inquiries` | a message about a repair, a resizing, a watch or a pickup | a short draft reply that suggests the right appointment type, plus an intake note |

Rules both follow: drafts only, nothing sent; never a price, a date, an availability or a judgment of feasibility; only facts from korotkina.com and the public booking page.

## Files

- [`korotkina-coworkers/`](korotkina-coworkers/): the plugin (manifest and the two `SKILL.md` files).
- [`dist/`](dist/): ready to upload. `korotkina-coworkers-plugin.zip` (both assistants), `custom-heirloom-inquiries.zip` and `repair-inquiries.zip` (one skill each, in the `<name>/SKILL.md` layout Claude expects).
- [`docs/install-claude-desktop-bedrock.md`](docs/install-claude-desktop-bedrock.md): installing Claude Desktop on one computer with Amazon Bedrock, step by step, each step sourced and dated. Not yet run on a real AWS account.
- [`docs/duplicate-an-assistant.md`](docs/duplicate-an-assistant.md): making a third assistant from one of these.
- [`verification/`](verification/): the five sample cases, the recorded runs (input, output, model, plugin version) and the import checks.
- `.claude-plugin/marketplace.json`: lets Claude Desktop or Claude Code add this repository as a plugin marketplace.
- `site/`, `worker.js`, `wrangler.toml`: the demo page.

Rebuild the ZIPs with `./build.sh`. Re-run the cases with `verification/run_cases.sh dist/korotkina-coworkers-plugin.zip`.

## How the examples were produced

Every example on the page is a recorded run of `claude -p` (Claude Code) on a Claude subscription, in an empty folder, with only the plugin ZIP loaded: no CLAUDE.md, no memory, no user settings, no MCP servers, and the Skill tool as the only tool. The messages are fictional. The runs were not made on Amazon Bedrock; on Bedrock the same files run with the model chosen at setup, and answers will differ in wording.
