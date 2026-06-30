#!/usr/bin/env bash
#
# rebrand-skill.sh
# Rebrand the using-admin-backend skill to a custom tenant domain and swap the
# "Wellington" worked-example branding for "ITOPPLUS".
#
# Usage:
#   ./rebrand-skill.sh [TARGET_DOMAIN] [SKILL_DIR]
#
#   TARGET_DOMAIN   full base URL of the example tenant
#                   (default: https://demo110.itopplus.com/)
#   SKILL_DIR       directory holding SKILL.md + reference/*.md
#                   (default: the directory this script lives in)
#
# Examples:
#   ./rebrand-skill.sh                                # -> demo110.itopplus.com / ITOPPLUS
#   ./rebrand-skill.sh https://acme.itopplus.com/     # -> acme.itopplus.com / ITOPPLUS
#   ./rebrand-skill.sh https://shop.example.com/ ../using-admin-backend
#
# Notes:
#   * Idempotent: re-running after a rebrand is a no-op (old strings already gone).
#   * Requires GNU sed (Git Bash on Windows, or Linux). Uses `sed -i`.
#   * ORDER MATTERS: the host is replaced before the branding, because the old
#     host contains the word "wellington" — doing branding first would corrupt it.
set -euo pipefail

# -------- args / defaults --------
TARGET_URL="${1:-https://demo110.itopplus.com/}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="${2:-$SCRIPT_DIR}"

# -------- what we replace --------
OLD_HOST="www.wellingtoncollege.ac.th"   # primary example host
OLD_HOST_ALT="wellingtoncollege.ac.th"   # bare host (no www), just in case
OLD_BRAND_LONG="Wellington College"
OLD_BRAND_SHORT="Wellington"
NEW_BRAND="ITOPPLUS"

# Derive the bare host from TARGET_URL (strip scheme, path, trailing slash).
NEW_HOST="$(printf '%s' "$TARGET_URL" | sed -E 's#^[a-zA-Z][a-zA-Z0-9+.-]*://##; s#/.*$##')"
[ -n "$NEW_HOST" ] || { echo "ERROR: could not parse a host from '$TARGET_URL'" >&2; exit 1; }
[ -d "$SKILL_DIR" ] || { echo "ERROR: skill dir not found: '$SKILL_DIR'" >&2; exit 1; }

# Regex-escape the literal dots in the old hosts so they match literally.
esc() { printf '%s' "$1" | sed 's/[.[\*^$/]/\\&/g'; }
OLD_HOST_RE="$(esc "$OLD_HOST")"
OLD_HOST_ALT_RE="$(esc "$OLD_HOST_ALT")"

echo "Skill dir:    $SKILL_DIR"
echo "New host:     $NEW_HOST    (from $TARGET_URL)"
echo "New branding: $NEW_BRAND   (was '$OLD_BRAND_SHORT' / '$OLD_BRAND_LONG')"
echo

changed=0
total=0
while IFS= read -r f; do
  total=$((total + 1))
  before="$(cat "$f")"
  # 1) host (www + bare)  2) long brand  3) short brand. '#' delimiter is safe:
  # none of the old/new strings contain '#'.
  sed -i \
    -e "s#${OLD_HOST_RE}#${NEW_HOST}#g" \
    -e "s#${OLD_HOST_ALT_RE}#${NEW_HOST}#g" \
    -e "s#${OLD_BRAND_LONG}#${NEW_BRAND}#g" \
    -e "s#${OLD_BRAND_SHORT}#${NEW_BRAND}#g" \
    "$f"
  if [ "$before" != "$(cat "$f")" ]; then
    echo "  updated: ${f#"$SKILL_DIR"/}"
    changed=$((changed + 1))
  fi
done < <(find "$SKILL_DIR" -type f -name '*.md')

echo
echo "Done. $changed of $total markdown file(s) updated."
echo "Leftover 'wellington' references in *.md (case-insensitive; should be none):"
if grep -rin --include='*.md' "wellington" "$SKILL_DIR" >/dev/null 2>&1; then
  grep -rin --include='*.md' "wellington" "$SKILL_DIR"
  exit 2
else
  echo "  (none)"
fi
