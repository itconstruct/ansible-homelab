#!/usr/bin/env bash
# scripts/check-sops-encrypted.sh
#
# Fails the commit if any file matching *.sops.yaml does NOT contain SOPS's
# own metadata block (the 'sops:' key SOPS appends after encryption).
# Absence of that block means the file was never actually run through
# `sops --encrypt`, and would otherwise be committed as plaintext.

set -euo pipefail

fail=0

for f in "$@"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  if ! grep -q '^sops:' "$f"; then
    echo "BLOCKED: '$f' matches the *.sops.yaml pattern but is not SOPS-encrypted"
    echo "         (no 'sops:' metadata block found - it looks like plaintext)."
    echo "         Fix: sops --encrypt --in-place '$f'"
    fail=1
  fi
done

exit $fail
