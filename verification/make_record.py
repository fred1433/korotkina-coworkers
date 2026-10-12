import json, sys, hashlib, datetime, zipfile
case = json.load(open(sys.argv[1])); events = [json.loads(l) for l in open(sys.argv[2])]
zpath = sys.argv[3]
init = next(e for e in events if e.get("type") == "system" and e.get("subtype") == "init")
res = next(e for e in events if e.get("type") == "result")
skills_called = [c["input"].get("skill") for e in events if e.get("type") == "assistant"
                 for c in e["message"]["content"] if c.get("type") == "tool_use" and c.get("name") == "Skill"]
with zipfile.ZipFile(zpath) as z:
    manifest = json.loads(next(z.read(n) for n in z.namelist() if n.endswith(".claude-plugin/plugin.json")))
print(json.dumps({
  "case": case["id"], "fictional_client": case["fictional_client"], "input": case["prompt"],
  "expected_skill": case["expected_skill"], "skill_invoked": skills_called,
  "output": res.get("result"),
  "model": init.get("model"), "models_used": list((res.get("modelUsage") or {}).keys()),
  "claude_code_version": init.get("claude_code_version"),
  "plugin": manifest["name"], "plugin_version": manifest["version"],
  "plugin_zip_sha256": hashlib.sha256(open(zpath, "rb").read()).hexdigest(),
  "skills_in_context": init.get("skills"), "tools_in_context": init.get("tools"),
  "auth": "Claude subscription (OAuth), apiKeySource=" + str(init.get("apiKeySource")),
  "recorded_at_utc": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
}, indent=2, ensure_ascii=False))
