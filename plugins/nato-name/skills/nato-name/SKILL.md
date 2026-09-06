---
name: nato-name
description: Pick an unused NATO reporting name as a placeholder project name. Use when starting a new project or when asked for a codename, project name, or NATO name.
---

Run this in the current directory and report what it prints:

```bash
grep -vxFf <(ls -A | tr 'A-Z' 'a-z' | tr -c 'a-z0-9\n' '\n' | grep .) ${CLAUDE_PLUGIN_ROOT}/skills/nato-name/names.txt
```

Every name printed is unused here: no entry in the current directory contains it as a whole word, case-insensitive. Offer the first one (the list is alphabetical, so A-names go first) and list the rest only if asked. If the user wants a particular letter, filter with `grep ^<letter>`.

`names.txt` holds every single-word NATO reporting name from Wikipedia's lists: aircraft, missiles, and Soviet/Russian submarine and ship classes.
