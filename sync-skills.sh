#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="/opt/_tools/skills/__my_custom_skills__"
CLAUDE_HOME_SKILLS="${HOME}/.claude/skills"
CLAUDE_DESKTOP_DIR="${SOURCE_DIR}/_for_claude_desktop"
CLAUDE_CODE_DIR="${SOURCE_DIR}/_for_claude_code"
EXTRACT_ROOT=""

shopt -s nocasematch

log() {
  printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"
}

warn() {
  printf '[%s] WARN: %s\n' "$(date +'%H:%M:%S')" "$*" >&2
}

archive_existing() {
  local target="$1"
  if [[ -e "$target" ]]; then
    local parent base archive_dir timestamp archived_path
    parent="$(dirname "$target")"
    base="$(basename "$target")"
    archive_dir="${parent}/_archive"
    timestamp="$(date +'%Y%m%d%H%M%S')"
    mkdir -p "$archive_dir"
    archived_path="${archive_dir}/${base}.${timestamp}"
    log "Archiving existing $target -> $archived_path"
    mv "$target" "$archived_path"
  fi
}

copy_archive() {
  local source_file="$1" destination="$2"
  archive_existing "$destination"
  mkdir -p "$(dirname "$destination")"
  cp -f "$source_file" "$destination"
}

copy_folder() {
  local source_dir="$1" destination="$2"
  archive_existing "$destination"
  mkdir -p "$(dirname "$destination")"
  cp -a "$source_dir" "$destination"
}

create_temp_archive() {
  local source_dir="$1" base tmp_archive
  base="$(basename "$source_dir")"
  tmp_archive="$(mktemp "/tmp/${base}.XXXXXX.skill")"
  (cd "$(dirname "$source_dir")" && zip -qr "$tmp_archive" "$base")
  printf '%s' "$tmp_archive"
}

extract_skill_archive() {
  local archive_path="$1" tmp_root skill_dir candidate count
  tmp_root="$(mktemp -d)"
  if ! unzip -q "$archive_path" -d "$tmp_root"; then
    rm -rf "$tmp_root"
    return 1
  fi

  if [[ -f "${tmp_root}/SKILL.md" ]]; then
    EXTRACT_ROOT="$tmp_root"
    printf '%s' "$tmp_root"
    return 0
  fi

  skill_dir=""
  count=0
  while IFS= read -r -d '' candidate; do
    [[ -f "${candidate}/SKILL.md" ]] || continue
    skill_dir="$candidate"
    count=$((count + 1))
  done < <(find "$tmp_root" -mindepth 1 -maxdepth 1 -type d ! -name '__MACOSX' -print0)

  if (( count == 1 )); then
    EXTRACT_ROOT="$tmp_root"
    printf '%s' "$skill_dir"
    return 0
  fi

  rm -rf "$tmp_root"
  return 1
}

sync_from_directory() {
  local directory="$1" base tmp_archive
  base="$(basename "$directory")"
  if [[ ! -f "${directory}/SKILL.md" ]]; then
    warn "Skipping '$base' because SKILL.md was not found"
    return
  fi

  log "Syncing directory skill '$base'"
  tmp_archive="$(create_temp_archive "$directory")"
  copy_archive "$tmp_archive" "${CLAUDE_DESKTOP_DIR}/${base}.skill"
  copy_folder "$directory" "${CLAUDE_HOME_SKILLS}/${base}"
  copy_folder "$directory" "${CLAUDE_CODE_DIR}/${base}"
  rm -f "$tmp_archive"
}

sync_from_archive() {
  local archive_path="$1" filename base extracted_dir
  filename="$(basename "$archive_path")"
  if [[ "$filename" == *.skill ]]; then
    base="${filename%.*}"
  else
    base="$filename"
  fi
  log "Syncing archive skill '$base'"

  EXTRACT_ROOT=""
  if ! extracted_dir="$(extract_skill_archive "$archive_path")"; then
    warn "Could not extract SKILL contents from ${filename}; skipping"
    return
  fi

  copy_archive "$archive_path" "${CLAUDE_DESKTOP_DIR}/${base}.skill"
  copy_folder "$extracted_dir" "${CLAUDE_HOME_SKILLS}/${base}"
  copy_folder "$extracted_dir" "${CLAUDE_CODE_DIR}/${base}"

  if [[ -n "$EXTRACT_ROOT" ]]; then
    rm -rf "$EXTRACT_ROOT"
    EXTRACT_ROOT=""
  fi
}

main() {
  command -v zip >/dev/null || { warn "zip is required"; exit 1; }
  command -v unzip >/dev/null || { warn "unzip is required"; exit 1; }

  mkdir -p "$SOURCE_DIR" "$CLAUDE_HOME_SKILLS" "$CLAUDE_DESKTOP_DIR" "$CLAUDE_CODE_DIR"

  local processed=0 path name
  while IFS= read -r -d '' path; do
    name="$(basename "$path")"
    [[ "$name" == "_archive" ]] && continue

    if [[ -d "$path" ]]; then
      sync_from_directory "$path"
      processed=$((processed + 1))
    else
      if [[ "$name" == *.skill ]]; then
        sync_from_archive "$path"
        processed=$((processed + 1))
      else
        warn "Skipping unsupported file '$name'"
      fi
    fi
  done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 \( -type d -o -type f \) -print0)

  log "Processed ${processed} skill(s)."
}

main "$@"
