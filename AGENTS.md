# Repository Instructions

## Repository purpose

The Developer Playbook is a separate, portable repository of reusable commands, workflows, templates, documentation standards, and experience-proven lessons. It accompanies application repositories but retains its own Git history and must not be nested inside them.

The Playbook is not an encyclopedia. Add material only when it has solved a real problem, addresses a recurring workflow, or is likely to help the user work more independently. The user has final approval for Playbook additions.

## Read before editing

Before substantial work, inspect the relevant repository documents and the current working tree.

- `README.md` - repository purpose.
- `ROADMAP.md` - planned, active, and completed improvements.
- `docs/DEVELOPMENT.md` - documentation and engineering philosophy.
- `docs/COMMANDS.md` - commands, aliases, workflows, and troubleshooting.
- `docs/PROJECT_CHECKLIST.md` - repeatable project setup procedures.
- `docs/WORKSTATION_SETUP.md` - workstation standards, setup, and recovery.
- `docs/DECISIONS.md` - durable decisions and their reasoning.
- `docs/LESSONS_LEARNED.md` - reusable lessons established through experience.
- `templates/` - files intended to be copied into other repositories.

Read neighboring content before editing so additions preserve the target document's scope, organization, terminology, and level of detail.

## Documentation routing

Put each addition in the document with the closest existing responsibility.

- Commands and command-driven workflows belong in `docs/COMMANDS.md`.
- Project creation and onboarding procedures belong in `docs/PROJECT_CHECKLIST.md`.
- Machine setup, validation, and recovery belong in `docs/WORKSTATION_SETUP.md`.
- Proven engineering lessons belong in `docs/LESSONS_LEARNED.md`.
- Durable choices and their rationale belong in `docs/DECISIONS.md`.
- Future or unapproved ideas belong in `ROADMAP.md` until approved and implemented.
- Reusable starter content belongs in `templates/`; project-specific state does not.

Do not duplicate the same guidance across documents unless one location is an intentional summary or template. When a change completes or invalidates a roadmap item, update `ROADMAP.md` in the same change.

## Writing and formatting

- Write for a learner in plain English and explain why and when, not only what.
- Teach the reusable pattern before the project-specific example.
- Preserve the existing Markdown heading hierarchy and nearby formatting conventions.
- Use fenced code blocks with an appropriate language identifier for commands and code.
- Use placeholders such as `<username>` in reusable patterns and real values only in clearly labeled examples.
- Keep instructions executable: include prerequisites, working directory, verification, expected results, and common mistakes when they apply.
- Do not claim a command or workflow is verified unless it was actually run successfully; identify unverified assumptions explicitly.
- Update visible dates, status markers, indexes, and related references affected by the change.

## Command documentation

Before adding a command, inspect `How to Use This Document` and a nearby entry in `docs/COMMANDS.md`. A complete entry should answer the applicable questions about purpose, motivation, alias, full command, reusable pattern, example, breakdown, requirements, verification, mistakes, typical use, related commands, and lessons learned.

Place a new entry in the appropriate learning-status section. Do not move an entry between `Currently Learning`, `Familiar Commands`, `Mastered Commands`, or `Reference Commands` without the user's approval.

When adding, renaming, moving, or removing a command or workflow heading in `docs/COMMANDS.md`, update `Quick Navigation` in the same change. Keep link text concise, preserve document order, and verify that every Markdown anchor targets the corresponding heading.

Update the `Last Updated` date in `docs/COMMANDS.md` whenever its substantive content changes.

## Templates and copied files

Treat files under `templates/` as reusable sources, not as live project files. Keep placeholders explicit and documented, and never leave unresolved placeholders when using a template to initialize a real project.

When a reusable collaboration standard changes, update the appropriate template. Existing project copies do not update automatically, so inspect the scope of the request and update active copies only when the user approves or the requested change explicitly applies to them.

Do not place machine-specific paths, secrets, virtual environments, IDE state, or session-specific handoff details in reusable templates.

## Verification

Verify each meaningful change in proportion to its risk. For documentation changes, at minimum:

1. Run `git diff --check`.
2. Review the rendered structure or relevant Markdown excerpt.
3. Verify internal links and heading anchors when navigation changes.
4. Search for stale dates, status markers, placeholders, or cross-document references affected by the change.
5. Review `git diff` and `git status --short` before recommending a commit.

Report what was verified and what was not.

## Working-tree and Git safety

Existing and uncommitted changes belong to the user unless clearly established otherwise. Preserve unrelated work, inspect overlapping edits before changing a file, and never discard changes without explicit approval.

Prefer small, conceptually focused changes. Do not commit or push unless the user explicitly approves it.

When the user asks to wrap up or switch computers, summarize completed and unfinished work, run practical verification, inspect `git status --short`, and ask whether the user wants the changes committed and pushed. After an approved push, report the branch, commit hash, and whether the local branch is synchronized with its upstream.
