---
mode: agent
description: Stage, validate, commit, and push all pending changes.
---

Do the full commit workflow for the current changes, without asking for confirmation at each step:

1. Run `git status` to see what changed.
2. Run `dart format .` and `flutter analyze --fatal-infos --fatal-warnings`; fix any issues found before continuing.
3. Run `flutter test --coverage` and make sure it passes.
4. Stage all relevant changes with `git add`.
5. Write a concise, conventional commit message summarizing the change (infer it from the diff — don't ask the user for one unless the change is ambiguous).
6. Commit.
7. Push with `git push`. If the pre-push hook fails, fix the reported issue and retry.
8. Report a short summary of what was committed and pushed.
