---
name: xhs-viral-video-breakdown
description: Evidence-based breakdown of Xiaohongshu and similar short videos into reusable visual-editing operation scripts. Use when the user provides a short-video URL or local video and asks to analyze picture edits, motion design, captions, pacing, screen recordings, PIP, sound rhythm, shot changes, or NLE track construction. Support visual-only breakdowns that intentionally exclude copywriting analysis.
---

# Xiaohongshu Viral Video Breakdown

Produce an evidence-based editing operation script, not a generic content critique. Lead with the finished operation script and save it under the current task's `outputs/` directory.

## Inputs

Require one reachable video URL or local video file. Treat the title, creator, share text, and user notes as context. Ask only when the source is inaccessible or login/CAPTCHA blocks the selected browser.

Honor scope exclusions. If the user says not to analyze copywriting, omit transcript, persuasion, and script-rewrite sections while still covering the full runtime visually.

## Workflow

1. For a URL, use the Browser skill and the browser family explicitly requested by the user; otherwise select for the URL.
2. Open the exact source. Record the title, creator, description, duration, dimensions, frame rate, and canonical/public video source when discoverable.
3. Download public media into `work/short-video-breakdown/<item-id>/source.mp4`. Do not redistribute it or place it in `outputs/`.
4. Run `scripts/analyze-video.ps1` with the downloaded source and a work output directory. Use its probe, scene cuts, and one-second contact sheets as primary visual evidence.
5. Obtain a timestamped transcript only when copywriting, spoken structure, caption accuracy, or persuasion logic is in scope.
6. Inspect every contact sheet. Add denser samples around the hook, full-screen graphics, product demonstrations, proof/data moments, tutorials, transitions, and CTA.
7. Detect visible hard cuts and scene-change timestamps. Distinguish editorial cuts from scrolling, cursor actions, animated changes, and digital reframing inside one source shot.
8. Separate facts from inference. Mark exact SFX, easing curves, fonts, and colors as estimates unless directly measurable.
9. Read `references/output-template.md` and adapt it to the user's requested scope.
10. Verify full-runtime coverage, timestamp continuity, a reusable operation script, and a track-level editing plan.

## Analysis layers

Analyze the synchronized layers that remain in scope:

1. **Picture edit** — A-roll framing, jump cuts, B-roll, screenshots, screen recordings, PIP, transitions, and shot density.
2. **Motion design** — composition, hierarchy, entry/exit order, estimated duration/easing, keyword emphasis, and information reveal sequence.
3. **Caption system** — chunk size, line count, placement, font category, outline/background, highlight colors, safe areas, and sync behavior.
4. **Sound and rhythm** — speech pace, music role, silence compression, likely accent SFX, and rhythm peaks. Never claim inaudible details as confirmed.
5. **Reproduction plan** — second-by-second edit table, reusable visual formula, NLE tracks, and verification checklist.
6. **Content logic** — hook, open loop, pain, promise, proof, mechanism, demonstration, objection, tutorial, and CTA only when the user requests content or copy analysis.

## Evidence discipline

- Do not infer the whole video from the post caption or a few screenshots.
- Cover the full runtime with at least one visual sample per five seconds; use one-second samples for complex sequences.
- Tie every motion observation to visible evidence.
- Give timestamp precision proportional to evidence: about ±0.2 seconds for detected cuts and ±1 second for contact-sheet observations.
- Treat automated scene detection as candidate nodes, not proof that every node is a hard cut.
- Preserve the source video's aspect ratio when describing reframing; call out nonstandard platform ratios.

## Browser cleanup

- Keep analysis tabs only while they help the task.
- Finalize browser tabs after extracting evidence. Keep only a requested or useful deliverable/handoff tab.

## Deliverable

Create one primary Markdown file named `<creator-or-title>_短视频动效拆解与剪辑操作稿.md` in `outputs/`.

Create CSV or JSON cut lists only when the user requests importable timeline data. Do not export or edit a video unless explicitly requested.
