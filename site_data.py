# Builds site/data.js from the recorded runs and the plugin's SKILL.md files.
import json, glob, os
meta = {
 "01-heirloom-ordinary": {"piece":"Grandmother's engagement ring","work":"Redesign for everyday wear","appt":"Initial Consultation"},
 "02-uncertain-stone-metal": {"piece":"Brooch, inherited","work":"Set the stone in a ring","appt":"Initial Consultation"},
 "03-urgent-guarantee": {"piece":"Wedding band","work":"Resize, asks for Friday","appt":"Jewelry Repair"},
 "04-pickup-unconfirmed": {"piece":"Watch","work":"Battery and strap, asks to collect","appt":"None yet, Alina checks first"},
 "05-pickup-confirmed": {"piece":"Necklace, new clasp","work":"Collect, says it is ready","appt":"Pick up"},
 "06-appraisal-engraving": {"piece":"Diamond necklace, inherited","work":"Appraisal for insurance, engraving","appt":"Appraisals"},
 "07-message-in-french": {"piece":"Grandmother's sapphire ring","work":"Redesign, message in French","appt":"Initial Consultation","page":False},
}
recs = {}
for f in sorted(glob.glob("verification/records/*.json")):
    d = json.load(open(f)); cid = d["case"]
    case = json.load(open(f"verification/cases/{cid}.json"))
    recs[cid] = {"client": d["fictional_client"], "message": case["message"], "output": d["output"],
                 "skill": d["skill_invoked"], "model": d["model"], "cc": d["claude_code_version"],
                 "plugin_version": d["plugin_version"], "at": d["recorded_at_utc"], "page": True, **meta[cid]}
skills = {}
for name in ["custom-heirloom-inquiries", "repair-inquiries"]:
    skills[name] = open(f"korotkina-coworkers/skills/{name}/SKILL.md").read()
out = "window.KORO = " + json.dumps({"records": recs, "skills": skills}, ensure_ascii=False, indent=1) + ";\n"
assert "—" not in out, "em dash found"
open("site/data.js", "w").write(out)
print("ok", len(out))
