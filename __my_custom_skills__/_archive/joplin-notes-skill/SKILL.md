---
name: joplin-notes
description: Manage Joplin notes with intelligent categorization and organization. Import markdown/HTML/CSV files or entire directories efficiently (recommended method), automatically analyze content to determine appropriate notebooks and tags, create hierarchical notebook structures, apply namespaced tags, and search your knowledge base. Supports batch operations, template-based creation, metadata preservation, hashtag extraction, and internal link detection. Use when uploading documentation, troubleshooting notes, or any content to Joplin; organizing existing notes; searching for notes by content, tags, or notebooks; or managing note templates.
---

# Joplin Notes Skill

Import files directly to Joplin for maximum efficiency, or create notes with intelligent categorization. Organize notes into notebooks, apply namespaced tags, manage to-dos, preserve metadata, and search your knowledge base—all without leaving the conversation.

## Quick Start

### Importing Files (Recommended for Efficiency)

**The most token-efficient way to upload notes is using the import function:**

When you have markdown files, HTML files, CSVs, or entire directories:

```
You: Import this markdown file to Joplin
Me: [imports directly using import_from_file]
    Imported successfully to "Imported" notebook
    - 1 note created
    Do you want to reorganize or retag?
```

**Import supports:**
- Single files or entire directories (recursive)
- Formats: `.md`, `.html`, `.csv`, `.jex` (auto-detected)
- Direct import to specific notebook
- Hashtag extraction from markdown (`#tag` → tag)
- CSV import modes: table (one note with table) or rows (one note per row)

**Import Examples:**
```python
# Import single markdown file
import_from_file("/path/to/note.md", target_notebook="Network Docs")

# Import directory recursively
import_from_file("/path/to/docs/", target_notebook="Documentation")

# Import CSV as individual notes
import_from_file("/path/data.csv", 
                 format="csv",
                 target_notebook="CSV Data",
                 import_options={"csv_import_mode": "rows"})

# Extract hashtags from markdown
import_from_file("/path/notes.md",
                 import_options={"extract_hashtags": True})
```

### Creating a New Note (Manual Method)

When you ask me to create documentation or markdown from scratch:

1. I'll analyze the content and discover your notebook structure
2. I'll propose the **notebook path**, **note title**, **tags**, and **metadata**
3. You confirm or adjust
4. I'll create it in Joplin with proper organization

Example:
```
You: Create a NAPALM bug report note
Me: Analyzed content. I'll create "NAPALM Driver Mapping Bug" in Network Orchestration → Bug Reports
    Tags: system:napalm, system:nornir-mcp, platform:cisco-ios, backend:wsl, tenant:axepa, type:bug
    Sound good?
You: Yes, go ahead
Me: [creates note and confirms with note ID and link]
```

### Batch Operations

**Import method (recommended):**
```
You: Import all markdown files from /path/to/docs
Me: [uses import_from_file on directory]
    Imported 15 notes successfully
```

**Manual method (when you need custom categorization):**
```
You: Upload these 5 files with custom tags for each
Me: [Analyzes and proposes categorization for each]
    Ready to create all 5? [Yes/No/Adjust]
```

## Intelligent Organization

### Automatic Categorization

I analyze note content to determine optimal organization:

**Content Analysis:**
- Error messages → affected systems
- Device names → tenants/locations  
- Stack traces → technologies
- Commands → platforms
- Code blocks → languages/frameworks
- Frontmatter → metadata preservation

**Organization Strategy:**
1. Discover existing notebook structure (cached per session)
2. Identify parent notebook (e.g., "Network Orchestration")
3. Create subnotebooks if needed (e.g., "Bug Reports")
4. Generate appropriate notebook path
5. Apply namespaced tags based on content

**Tag Taxonomy:**
Use namespaced tags following this pattern:
- `system:` - Technologies (napalm, nornir-mcp, cisco-ios)
- `platform:` - Hardware/software platforms
- `backend:` - Execution environments (wsl, macbook, wyze)
- `tenant:` - Organizational units (axepa, zenith, ena-on)
- `type:` - Content type (bug, solution, guide, reference)
- `component:` - Specific subsystems (driver-mapping, api-client)
- `location:` - Physical locations (hq, datacenter-a)
- `status:` - Workflow states (open, resolved, in-progress)

See `references/TAG_TAXONOMY.md` for complete taxonomy.

### Notebook Structure Discovery

On first use in a session:
1. I call `list_notebooks()` to discover your structure
2. Cache the structure for the session
3. Use it to make intelligent categorization decisions
4. Propose creating new notebooks that fit your pattern

## Importing Files

**The `import_from_file` function is the most token-efficient way to upload content to Joplin.**

Instead of reading files and creating notes one by one (which consumes tokens for file content), use import to directly load files into Joplin.

### When to Use Import

**Always use import for:**
- Existing markdown files (`.md`)
- HTML documentation (`.html`)
- CSV data files (`.csv`)
- Entire directories of notes
- Joplin export files (`.jex`)
- Batch uploads of multiple files

**Use manual creation for:**
- Generated content (code, reports, analysis)
- Content that needs intelligent categorization analysis
- Notes requiring custom tag generation
- Template-based creation

### Import Parameters

```python
import_from_file(
    file_path="/path/to/file.md",          # Required: file or directory path
    format="md",                            # Optional: md, html, csv, jex, generic (auto-detected)
    target_notebook="My Notebook",          # Optional: destination notebook (default: "Imported")
    import_options={                        # Optional: additional options
        "extract_hashtags": True,           # Convert #tags to Joplin tags
        "csv_import_mode": "rows",          # CSV: "table" or "rows"
        "csv_delimiter": ";"                # CSV: custom delimiter
    }
)
```

### Import Formats

**Markdown (`.md`)**
- Preserves frontmatter metadata
- Maintains internal links `[text](:/noteId)`
- Can extract `#hashtags` as tags
- Preserves formatting and code blocks

**HTML (`.html`)**
- Converts HTML to Markdown
- Preserves links and images
- Maintains structure

**CSV (`.csv`)**
- Two modes:
  - `table`: Single note with CSV as table
  - `rows`: One note per row, with YAML frontmatter from columns
- Custom delimiters supported

**JEX (`.jex`)**
- Joplin export format
- Preserves all metadata, tags, notebooks
- Full structure import

**Directories**
- Recursive processing
- Auto-detects file types
- Handles mixed content
- RAW exports auto-detected

### Import Options

**Hashtag Extraction** (`extract_hashtags: true`)
```markdown
# My Note

This is about #networking and #cisco-ios devices.
```
Creates tags: `networking`, `cisco-ios`

**CSV Import Modes**

*Table Mode* (default):
```
Name,Age,Role
Alice,30,Engineer
Bob,25,Designer
```
→ One note with table

*Rows Mode*:
```
Name,Age,Role
Alice,30,Engineer
Bob,25,Designer
```
→ Two notes with frontmatter:
```yaml
---
Name: Alice
Age: 30
Role: Engineer
---
```

### Import Examples

**Single File:**
```python
# Basic import
import_from_file("/home/user/notes/troubleshooting.md")

# To specific notebook
import_from_file("/home/user/notes/bug-report.md", 
                 target_notebook="Bug Reports")

# With hashtag extraction
import_from_file("/home/user/notes/network-guide.md",
                 import_options={"extract_hashtags": True})
```

**Directory Import:**
```python
# Import entire directory
import_from_file("/home/user/documentation/")

# To specific notebook
import_from_file("/home/user/network-docs/",
                 target_notebook="Network Documentation")
```

**CSV Import:**
```python
# As table
import_from_file("/home/user/data.csv",
                 format="csv",
                 target_notebook="Data Tables")

# As individual notes
import_from_file("/home/user/devices.csv",
                 format="csv",
                 target_notebook="Device Inventory",
                 import_options={"csv_import_mode": "rows"})

# Custom delimiter
import_from_file("/home/user/euro-data.csv",
                 format="csv",
                 import_options={"csv_delimiter": ";"})
```

**Joplin Export:**
```python
# Import JEX backup
import_from_file("/home/user/backup.jex")
```

### Import Results

Import returns a summary:
```
Imported successfully:
- 15 notes created
- 3 notebooks created
- 8 tags created
- 2 warnings: duplicate titles

Target notebook: Documentation
```

**Post-Import Organization:**
After import, you can:
1. Search imported notes: `find_notes_in_notebook("Imported")`
2. Retag notes: `tag_note(note_id, "new-tag")`
3. Move notes: `update_note(note_id, notebook="New Notebook")`
4. Analyze and reorganize based on content

### Import Workflow Pattern

```
1. You: Import this directory to Joplin
2. Me: [imports using import_from_file]
   Result: 10 notes imported to "Imported" notebook
3. Me: Would you like me to:
   - Analyze and reorganize by content?
   - Apply tags based on content analysis?
   - Move to specific notebooks?
4. You: Yes, organize them
5. Me: [analyzes imported notes and proposes organization]
```

### Token Efficiency Comparison

**Manual Creation** (reading file + creating note):
- Read file: ~500-2000 tokens
- Analyze: ~200 tokens  
- Create note: ~300 tokens
- **Total per note: ~1000-2500 tokens**

**Import**:
- Import call: ~100 tokens
- **Total per note: ~100 tokens**

**For 10 notes: Manual = 10,000-25,000 tokens vs Import = 1,000 tokens**

## Template Support

Create notes from templates for consistency:

**Available Templates:**
- Bug Report (`templates/bug-report.md`)
- Meeting Notes (`templates/meeting-notes.md`)
- Technical Guide (`templates/technical-guide.md`)
- Project Plan (`templates/project-plan.md`)

Example:
```
You: Create a bug report note for the authentication issue
Me: I'll use the bug report template. What's the issue summary?
You: [describes issue]
Me: [fills template and proposes structure]
```

## Metadata Preservation

I extract and preserve frontmatter metadata:

**Supported Fields:**
- `date`, `created`, `updated` → preserve timestamps
- `author`, `creator` → preserve attribution
- `priority`, `severity` → add as tags
- `status` → add as `status:` tag
- `tags` → merge with auto-generated tags
- `project`, `epic` → add as tags

Example frontmatter:
```yaml
---
date: 2025-11-09
author: Nikos
priority: high
status: open
tags: [networking, cisco]
---
```

Becomes:
- Tags: `priority:high`, `status:open`, `networking`, `cisco` + auto-generated tags
- Note body preserves author and date information

## Internal Link Detection

I detect and preserve Joplin internal links:

**Link Formats Detected:**
- `[link text](:/noteId)` - Link to note
- `[link text](:/noteId#section)` - Link to section

**Handling:**
1. Detect internal links during upload
2. Preserve link structure
3. Validate linked notes exist (if needed)
4. Report any broken links

## Available Operations

**Importing (Most Efficient)**
- Import single files (markdown, HTML, CSV)
- Import entire directories recursively
- Auto-detect file formats
- Extract hashtags from markdown
- CSV import modes (table or rows)
- Direct import to target notebook

**Finding & Browsing**
- Search notes by text, tag, or notebook
- Discover notebook structure
- Get note details with metadata
- Find notes with specific tags
- List all notebooks and tags

**Creating (Manual)**
- New notes with intelligent categorization
- Batch upload multiple notes
- Template-based creation
- Notebooks and subnotebooks
- Tags with validation
- To-dos with status tracking

**Updating**
- Edit note content preserving metadata
- Rename notebooks
- Add/remove tags with validation
- Update to-do status
- Bulk tag operations

**Deleting**
- Remove notes, notebooks, or tags
- Confirmation required for destructive operations

## Workflow Overview

See `references/WORKFLOWS.md` for detailed multi-step patterns including:
- Upload Documentation (with auto-categorization)
- Batch Upload Multiple Notes
- Update Existing Notes
- Organize with Tags
- Template-Based Creation
- Search and Retrieve
- Manage To-Dos

See `references/TOOLS.md` for complete tool reference.

## Important Notes

- **Import First**: For existing files, use `import_from_file` - it's far more token-efficient than manual creation
- **Structure Discovery**: First operation in a session discovers your notebook structure
- **Tag Validation**: I check if tags exist before creating to avoid duplicates
- **Confirmation Workflow**: I always propose changes before executing (except imports which are direct)
- **Metadata Preservation**: Frontmatter metadata is extracted and preserved
- **Link Integrity**: Internal links are detected and validated
- **Batch Operations**: Multiple notes can be uploaded in a single operation
- **Template Library**: Use templates for consistent note structure
- **Hashtag Extraction**: Import can automatically convert `#tags` in markdown to Joplin tags

## Getting Help

- Need to find something? Ask me to search by notebook, tag, or text
- Want to organize existing notes? I can help restructure, retag, or bulk-update
- Not sure what notes exist? Ask me to list notebooks or discover your structure
- Need a template? Ask me to list available templates or create from template
