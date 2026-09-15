"""Quality audit over live meetings. Printed by run.py; not a pass/fail suite."""

from __future__ import annotations

from pathlib import Path

from parse import load_summary, load_transcript, unnamed_owner

ROOT = Path(__file__).resolve().parents[1]


def audit() -> dict:
    transcripts = [load_transcript(p) for p in sorted((ROOT / "Transcripts").glob("*.md"))]
    summaries = [load_summary(p) for p in sorted((ROOT / "Summaries").glob("*.md"))]
    t_ids = {doc["id"] for doc in transcripts}
    s_ids = {doc["id"] for doc in summaries}

    named = unresolved = 0
    speaker_issues = []
    for doc in transcripts:
        for label, resolved in doc["speakers"].items():
            if resolved.strip().lower() == "unresolved" or not resolved.strip():
                unresolved += 1
                speaker_issues.append(f"{doc['id']}: {label} unresolved")
            else:
                named += 1
        if doc["fields"].get("own_mic_track") == "yes" and "Me" not in doc["body_speakers"]:
            speaker_issues.append(
                f"{doc['id']}: own_mic_track=yes but no **Me** blocks in the transcript"
            )

    action_rows = []
    unnamed_actions = []
    due_missing = 0
    for doc in summaries:
        for row in doc["actions"]:
            action_rows.append(row)
            owner = row.get("owner", "")
            if unnamed_owner(owner):
                unnamed_actions.append(f"{doc['id']}: {owner} — {row.get('action', '')[:80]}")
            due = row.get("due", "").strip().lower()
            if due in {"", "not stated", "n/a"}:
                due_missing += 1

    orphan_summaries = sorted(s_ids - t_ids)
    waiting = [doc["id"] for doc in transcripts if doc["fields"].get("status") == "awaiting-summary"]

    total_speakers = named + unresolved
    total_actions = len(action_rows)
    return {
        "transcripts": len(transcripts),
        "summaries": len(summaries),
        "speaker_named": named,
        "speaker_unresolved": unresolved,
        "speaker_resolution": (named / total_speakers) if total_speakers else None,
        "actions": total_actions,
        "actions_unnamed_owner": len(unnamed_actions),
        "actions_named_owner_rate": (
            (total_actions - len(unnamed_actions)) / total_actions if total_actions else None
        ),
        "actions_due_missing": due_missing,
        "orphan_summaries": orphan_summaries,
        "awaiting_summary": waiting,
        "speaker_issues": speaker_issues,
        "unnamed_action_owners": unnamed_actions,
    }


def format_report(report: dict) -> str:
    def pct(value):
        return "n/a" if value is None else f"{100 * value:.0f}%"

    lines = [
        "Quality audit (live Transcripts/ and Summaries/)",
        f"  meetings transcribed: {report['transcripts']}   summarized: {report['summaries']}",
        f"  speaker names resolved: {pct(report['speaker_resolution'])} "
        f"({report['speaker_named']} named, {report['speaker_unresolved']} unresolved)",
        f"  action items with a real owner: {pct(report['actions_named_owner_rate'])} "
        f"({report['actions'] - report['actions_unnamed_owner']} of {report['actions']})",
        f"  action items with no due date: {report['actions_due_missing']} of {report['actions']}",
    ]
    if report["orphan_summaries"]:
        lines.append(
            "  summaries with no matching transcript: " + ", ".join(report["orphan_summaries"])
        )
    if report["awaiting_summary"]:
        lines.append("  awaiting Claude: " + ", ".join(report["awaiting_summary"]))
    if report["speaker_issues"]:
        lines.append("  speaker issues:")
        lines.extend(f"    - {item}" for item in report["speaker_issues"])
    if report["unnamed_action_owners"]:
        lines.append("  unnamed action owners:")
        lines.extend(f"    - {item}" for item in report["unnamed_action_owners"])
    return "\n".join(lines)
