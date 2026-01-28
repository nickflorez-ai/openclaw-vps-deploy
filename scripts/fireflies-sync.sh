#!/bin/bash
# Fireflies.ai Transcript Sync
# Syncs meeting transcripts from Fireflies.ai to local markdown files

set -euo pipefail

OUTPUT_DIR="${OUTPUT_DIR:-/root/clawd/data/fireflies}"
LIMIT="${LIMIT:-20}"
API_URL="https://api.fireflies.ai/graphql"

# Load API key
if [ -f ~/.clawdbot/.env ]; then
  source ~/.clawdbot/.env
fi

if [ -z "${FIREFLIES_API_KEY:-}" ]; then
  echo "Error: FIREFLIES_API_KEY not set"
  echo "Add it to ~/.clawdbot/.env"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Fetching transcripts from Fireflies.ai..."

# Fetch transcript list
LIST=$(curl -s -X POST "$API_URL" \
  -H "Authorization: Bearer $FIREFLIES_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ transcripts(limit: $LIMIT) { id title date duration organizer_email } }\"}")

COUNT=$(echo "$LIST" | jq '.data.transcripts | length')
echo "Found $COUNT transcripts"

echo "$LIST" | jq -c '.data.transcripts[]?' | while read -r item; do
  ID=$(echo "$item" | jq -r '.id')
  TITLE=$(echo "$item" | jq -r '.title // "Untitled"' | tr '/:' '-' | tr -cd '[:alnum:] -')
  DATE_MS=$(echo "$item" | jq -r '.date')
  
  # Handle date formatting (Linux vs macOS)
  if date --version 2>/dev/null | grep -q GNU; then
    DATE_FMT=$(date -d @$((DATE_MS / 1000)) +%Y-%m-%d)
  else
    DATE_FMT=$(date -r $((DATE_MS / 1000)) +%Y-%m-%d)
  fi
  
  FILENAME="${DATE_FMT}-${TITLE:0:50}.md"
  FILEPATH="$OUTPUT_DIR/$FILENAME"
  
  # Skip if already exists
  if [ -f "$FILEPATH" ]; then
    continue
  fi
  
  echo "Fetching: $TITLE"
  
  # Fetch full transcript
  DETAIL=$(curl -s -X POST "$API_URL" \
    -H "Authorization: Bearer $FIREFLIES_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"query\": \"{ transcript(id: \\\"$ID\\\") { title date duration organizer_email sentences { text speaker_name } summary { overview } } }\"}")
  
  # Extract data
  FULL_TITLE=$(echo "$DETAIL" | jq -r '.data.transcript.title // "Untitled"')
  DURATION=$(echo "$DETAIL" | jq -r '.data.transcript.duration // 0')
  ORGANIZER=$(echo "$DETAIL" | jq -r '.data.transcript.organizer_email // "Unknown"')
  OVERVIEW=$(echo "$DETAIL" | jq -r '.data.transcript.summary.overview // "No summary available"')
  
  # Build markdown
  cat > "$FILEPATH" << EOF
# $FULL_TITLE

**Date:** $DATE_FMT
**Duration:** $((DURATION / 60)) minutes
**Organizer:** $ORGANIZER

## Summary

$OVERVIEW

## Transcript

EOF

  # Add sentences
  echo "$DETAIL" | jq -r '.data.transcript.sentences[]? | "**\(.speaker_name):** \(.text)"' >> "$FILEPATH"
  
  echo "  Saved: $FILENAME"
done

echo "Done!"
