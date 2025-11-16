# Joplin MCP Tools Reference

Complete reference for all tools available through the joplin-mcp server.

## Quick Reference Patterns

**Intelligent content discovery:**
```python
# By system/technology
find_notes_with_tag("system:napalm")
find_notes_with_tag("platform:cisco-ios")

# By tenant/organization
find_notes_in_notebook("Network Orchestration")
# Then filter results by tenant:axepa tag

# By type and status
find_notes_with_tag("type:bug")
find_notes("*", task=True, completed=False)  # Incomplete tasks

# Combined search patterns
# 1. Find in notebook with specific tag
results = find_notes_in_notebook("Network Orchestration")
# 2. Filter by content search
cisco_notes = find_notes("cisco")
# 3. Intersect results by tag
find_notes_with_tag("tenant:axepa")
```

**Structure discovery:**
```python
# Get all notebooks (cache this)
notebooks = list_notebooks()

# Get all tags (cache this)
tags = list_tags()

# Use cached data for validation
```

---

## Finding & Searching Notes

### find_notes(query, task=None, completed=None, limit=20, offset=0)
⭐ **MAIN FUNCTION FOR TEXT SEARCHES AND LISTING ALL NOTES**

Full-text search across all notes with optional task filtering and pagination.

**Parameters:**
- `query`: Search text (or "*" to list all notes)
- `task`: Filter by task type (True/False/None)
- `completed`: Filter by completion status (True/False/None)
- `limit`: Max results (1-100, default 20)
- `offset`: Skip count for pagination (default 0)

**Returns:** List of notes matching criteria with title, ID, content preview, and dates. Includes pagination info (total results, current page range).

**Examples:**
```python
find_notes("*")                          # List first 20 notes
find_notes("napalm driver")              # Find notes about NAPALM drivers
find_notes("*", task=True)               # List all tasks
find_notes("*", limit=20, offset=20)     # Page 2 (notes 21-40)
```

**💡 TIP:** For tag-specific searches, use `find_notes_with_tag()` instead.  
**💡 TIP:** For notebook-specific searches, use `find_notes_in_notebook()` instead.

### find_notes_with_tag(tag_name, task=None, completed=None, limit=20, offset=0)
⭐ **MAIN FUNCTION FOR TAG SEARCHES**

Find all notes tagged with a specific tag name.

**Parameters:**
- `tag_name`: Tag name to search for
- `task`: Filter by task type (True/False/None)
- `completed`: Filter by completion status (True/False/None)
- `limit`: Max results (1-100, default 20)
- `offset`: Skip count for pagination (default 0)

**Returns:** List of notes with the specified tag, with pagination information.

**Examples:**
```python
find_notes_with_tag("system:napalm")                       # All notes tagged system:napalm
find_notes_with_tag("type:bug", limit=10, offset=10)      # Page 2 of bug reports
find_notes_with_tag("tenant:axepa", task=True)            # All AXEPA tasks
find_notes_with_tag("status:open", task=True, completed=False)  # Open incomplete tasks
```

### find_notes_in_notebook(notebook_name, task=None, completed=None, limit=20, offset=0)
⭐ **MAIN FUNCTION FOR NOTEBOOK SEARCHES**

Find all notes in a specific notebook.

**Parameters:**
- `notebook_name`: Notebook name to search in
- `task`: Filter by task type (True/False/None)
- `completed`: Filter by completion status (True/False/None)
- `limit`: Max results (1-100, default 20)
- `offset`: Skip count for pagination (default 0)

**Returns:** List of all notes in the specified notebook, with pagination information.

**Examples:**
```python
find_notes_in_notebook("Network Orchestration")                    # All notes in notebook
find_notes_in_notebook("Projects", limit=10, offset=10)            # Page 2
find_notes_in_notebook("Work", task=True)                          # Only tasks
find_notes_in_notebook("Personal", task=True, completed=False)     # Incomplete personal tasks
```

### get_note(note_id, section=None, start_line=None, line_count=None, toc_only=False, force_full=False, metadata_only=False)
Retrieve a note with smart content display and sequential reading support.

**Smart Behavior:**
- Short notes: show full content automatically
- Long notes: show table of contents only
- Sequential reading: extract specific line ranges

**Parameters:**
- `note_id`: Note identifier (32-character ID)
- `section`: Extract specific section (heading text, slug, or number)
- `start_line`: Start line for sequential reading (1-based)
- `line_count`: Number of lines to extract (default: 50)
- `toc_only`: Show only TOC and metadata (True/False)
- `force_full`: Force full content even for long notes (True/False)
- `metadata_only`: Show only metadata without content (True/False)

**Returns:** Note content (full, TOC, section, or line range) with metadata

**Examples:**
```python
get_note("note_id")                              # Smart display (full if short, TOC if long)
get_note("note_id", section="1")                 # Get first section
get_note("note_id", start_line=1)                # Sequential reading from line 1 (50 lines)
get_note("note_id", start_line=51, line_count=30) # Continue from line 51 (30 lines)
get_note("note_id", toc_only=True)               # TOC only
get_note("note_id", force_full=True)             # Force full content
get_note("note_id", metadata_only=True)          # Metadata only
```

### find_in_note(note_id, pattern, case_sensitive=False, multiline=True, dotall=False, limit=20, offset=0)
Regex search within a single note with paginated results. Multiline mode is enabled by default.

**Parameters:**
- `note_id`: Note ID to search within (32-character ID)
- `pattern`: Regular expression to search for
- `case_sensitive`: Use case-sensitive matching (default False)
- `multiline`: Enable multiline flag (affects ^ and $, default True)
- `dotall`: Dot matches newlines (re.DOTALL, default False)
- `limit`: Max matches per page (1-100, default 20)
- `offset`: Skip count for pagination (default 0)

**Returns:** Paginated matches with line numbers and context

**Examples:**
```python
find_in_note("note_id", r"^- \[ \]")              # Find unchecked checklist items
find_in_note("note_id", r"TODO:", case_sensitive=True)  # Case-sensitive TODO search
find_in_note("note_id", r"error.*failed", limit=10)     # Find error patterns
```

### get_links(note_id)
Extract all links to other notes from a given note and find backlinks from other notes.

**Parameters:**
- `note_id`: Note ID to extract links from (32-character ID)

**Returns:** Formatted list of outgoing links and backlinks with titles, IDs, section slugs, and line context

**Link Formats:**
- `[link text](:/targetNoteId)` - Link to note
- `[link text](:/targetNoteId#section-slug)` - Link to specific section

---

## Managing Notes

### create_note(title, notebook_name, body="", is_todo=False, todo_completed=False)
Create a new note in a specified notebook.

**Parameters:**
- `title`: Note title (required, min 1 character)
- `notebook_name`: Notebook name (required, min 1 character)
- `body`: Note content (default empty string)
- `is_todo`: Create as todo (default False)
- `todo_completed`: Mark todo as completed (default False)

**Returns:** Success message with note title and unique ID

**Examples:**
```python
create_note("Shopping List", "Personal", "- Milk\n- Eggs", is_todo=True, todo_completed=False)
create_note("Meeting Notes", "Work", "# Meeting with Client")
create_note("Bug Report", "Projects", body=bug_content)
```

### update_note(note_id, title=None, body=None, is_todo=None, todo_completed=None)
Update an existing note. At least one field must be provided.

**Parameters:**
- `note_id`: Note ID to update (required, 32-character ID)
- `title`: New title (optional)
- `body`: New content (optional)
- `is_todo`: Convert to/from todo (optional)
- `todo_completed`: Mark todo completed (optional)

**Returns:** Success message confirming the update

**Examples:**
```python
update_note("note_id", title="New Title")                    # Update title only
update_note("note_id", body="New content", is_todo=True)     # Update content and convert to todo
update_note("note_id", todo_completed=True)                  # Mark todo as complete
```

### delete_note(note_id)
Permanently remove a note from Joplin. **This action cannot be undone.**

**Parameters:**
- `note_id`: Note ID to delete (required, 32-character ID)

**Returns:** Success message confirming deletion

**⚠️ Warning:** This action is permanent and cannot be undone.

---

## Managing Notebooks

### list_notebooks()
Retrieve and display all notebooks (folders) in your Joplin instance.

**Returns:** Formatted list of all notebooks including title, unique ID, parent notebook (if sub-notebook), and creation date

**Example:**
```python
notebooks = list_notebooks()
# Cache this for session to avoid repeated calls
```

### create_notebook(title, parent_id=None)
Create a new notebook (folder) to organize notes. Can create top-level notebooks or sub-notebooks.

**Parameters:**
- `title`: Notebook title (required, min 1 character)
- `parent_id`: Parent notebook ID for sub-notebooks (optional, 32-character ID)

**Returns:** Success message with notebook title and unique ID

**Examples:**
```python
create_notebook("Work Projects")                         # Top-level notebook
create_notebook("2024 Projects", parent_id="parent_id")  # Sub-notebook
```

### delete_notebook(notebook_id)
Permanently remove a notebook from Joplin. **All notes in the notebook will also be deleted.**

**Parameters:**
- `notebook_id`: Notebook ID to delete (required, 32-character ID)

**Returns:** Success message confirming deletion

**⚠️ Warning:** This action is permanent. All notes in the notebook are also deleted.

---

## Managing Tags

### list_tags()
Retrieve and display all tags in your Joplin instance with note counts.

**Returns:** Formatted list of all tags including title, unique ID, number of notes tagged, and creation date

**Example:**
```python
tags = list_tags()
# Cache this for session to validate tags before creating
```

### create_tag(title)
Create a new tag for categorization and organization.

**Parameters:**
- `title`: Tag title (required, min 1 character)

**Returns:** Success message with tag title and unique ID

**Examples:**
```python
create_tag("system:napalm")      # Create namespaced tag
create_tag("important")          # Create simple tag
```

**💡 TIP:** Always check if tag exists with `list_tags()` before creating to avoid duplicates.

### delete_tag(tag_id)
Permanently remove a tag from Joplin. **The tag will be removed from all notes.**

**Parameters:**
- `tag_id`: Tag ID to delete (required, 32-character ID)

**Returns:** Success message confirming deletion

**⚠️ Warning:** This action is permanent. The tag will be removed from all notes.

### get_tags_by_note(note_id)
Retrieve all tags currently applied to a specific note.

**Parameters:**
- `note_id`: Note ID to get tags from (required, 32-character ID)

**Returns:** Formatted list of tags with title, ID, and creation date

### tag_note(note_id, tag_name)
Add a tag to a note for categorization and organization. Uses note ID and tag name.

**Parameters:**
- `note_id`: Note ID to add tag to (required, 32-character ID)
- `tag_name`: Tag name to add (required, min 1 character)

**Returns:** Success message confirming tag was added

**Examples:**
```python
tag_note("note_id", "system:napalm")     # Add namespaced tag
tag_note("note_id", "important")         # Add simple tag
```

**Note:** Tag must exist (create with `create_tag()` first if needed). A note can have multiple tags.

### untag_note(note_id, tag_name)
Remove a tag from a note.

**Parameters:**
- `note_id`: Note ID to remove tag from (required, 32-character ID)
- `tag_name`: Tag name to remove (required, min 1 character)

**Returns:** Success message confirming tag removal

**Example:**
```python
untag_note("note_id", "system:napalm")   # Remove tag
```

---

## Importing Files

### import_from_file(file_path, format=None, target_notebook="Imported", import_options=None)
⭐ **MOST TOKEN-EFFICIENT METHOD FOR UPLOADING EXISTING FILES**

Import notes directly from files or directories into Joplin. This is 10-25x more token-efficient than reading files and manually creating notes.

**Parameters:**
- `file_path`: Path to file or directory to import (required)
- `format`: File format - `md`, `html`, `csv`, `jex`, `generic` (optional, auto-detected)
- `target_notebook`: Destination notebook name (default: "Imported")
- `import_options`: Additional options as dict (optional):
  - `extract_hashtags` (bool): Convert `#tags` in markdown to Joplin tags
  - `csv_import_mode` (str): `"table"` (single note with table) or `"rows"` (one note per row)
  - `csv_delimiter` (str): Custom CSV delimiter (e.g., `";"`)

**Supported Formats:**
- **Markdown** (`.md`): Preserves frontmatter, internal links, formatting
- **HTML** (`.html`): Converts to Markdown, preserves structure
- **CSV** (`.csv`): Import as table or individual notes (one per row)
- **JEX** (`.jex`): Joplin export format, full structure import
- **Directories**: Recursive processing, auto-detects formats, handles RAW exports

**Returns:** Summary with counts (notes created, notebooks created, tags created) and any errors/warnings

**Examples:**

```python
# Basic single file import
import_from_file("/path/to/note.md")

# Import to specific notebook
import_from_file("/path/to/doc.md", target_notebook="Documentation")

# Import with hashtag extraction
import_from_file("/path/to/notes.md", 
                 import_options={"extract_hashtags": True})

# Import entire directory
import_from_file("/path/to/markdown-files/")

# CSV as table (default)
import_from_file("/path/to/data.csv", 
                 format="csv",
                 target_notebook="Data Tables")

# CSV as individual notes (one per row)
import_from_file("/path/to/devices.csv",
                 format="csv", 
                 target_notebook="Device Inventory",
                 import_options={"csv_import_mode": "rows"})

# CSV with custom delimiter
import_from_file("/path/to/euro-data.csv",
                 format="csv",
                 import_options={"csv_delimiter": ";"})

# Import Joplin backup
import_from_file("/path/to/backup.jex")
```

**Token Efficiency:**
- Manual creation: ~1,000-2,500 tokens per note (read file + analyze + create)
- Import: ~100 tokens per note
- **Savings: 90-96% fewer tokens**

**Post-Import Workflow:**
1. Import files directly to target notebook
2. Search imported notes: `find_notes_in_notebook("Imported")`
3. Analyze content and propose organization
4. Retag: `tag_note(note_id, "new-tag")`
5. Move if needed: update note with new notebook

**💡 TIP:** Always use import for existing files. Only use manual `create_note()` for generated content.

---

## System Tools

### ping_joplin()
Test connectivity to the Joplin application and verify the server is working.

**Returns:** Connection status information

**Example:**
```python
ping_joplin()  # Test before starting operations
```

---

## Common Usage Patterns

### Pattern: Import Existing Files (Recommended)
```python
# Import single file
import_from_file("/path/to/doc.md", target_notebook="Documentation")

# Import directory
import_from_file("/path/to/notes/", target_notebook="Imported")

# Then organize imported notes
notes = find_notes_in_notebook("Imported")
for note in notes:
    # Analyze and tag based on content
    tag_note(note['id'], "appropriate-tag")
```

### Pattern: Creating with Organization
```python
# Create note
note_id = create_note("My Note", "Work", "Content here")

# Add multiple tags
tag_note(note_id, "system:napalm")
tag_note(note_id, "type:guide")
tag_note(note_id, "status:draft")
```

### Pattern: Updating Existing Content
```python
# Find note
notes = find_notes_in_notebook("Work")

# Get specific note
note = get_note(note_id)

# Update content
update_note(note_id, body="Updated content here")
```

### Pattern: Hierarchical Search
```python
# Search at different levels
all_work_notes = find_notes_in_notebook("Work")
urgent_notes = find_notes_with_tag("status:urgent")
specific_content = find_notes("python debugging")
```

### Pattern: Todo Management
```python
# Create todo
task_id = create_note("Task", "Projects", "Do this", is_todo=True, todo_completed=False)

# Mark complete
update_note(task_id, todo_completed=True)

# Find incomplete tasks
incomplete = find_notes("*", task=True, completed=False)
```

### Pattern: Tag Validation and Reuse
```python
# Get all existing tags once per session
all_tags = list_tags()
tag_names = [tag['title'] for tag in all_tags]

# Check before creating
if "system:napalm" not in tag_names:
    create_tag("system:napalm")

# Apply tag
tag_note(note_id, "system:napalm")
```

### Pattern: Batch Operations
```python
# Find all notes to tag
notes = find_notes_in_notebook("Documentation")

# Apply tag to all
for note in notes:
    tag_note(note['id'], "type:guide")
```
