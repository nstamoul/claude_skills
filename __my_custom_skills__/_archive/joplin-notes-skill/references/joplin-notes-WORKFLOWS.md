# Joplin Workflows

Common patterns and multi-step workflows for managing notes effectively.

## Workflow 1: Structure Discovery (Session Initialization)

**Scenario:** Beginning a new session or first Joplin operation

**Steps:**

1. **Discovery Phase**
   - Call `list_notebooks()` to get complete notebook structure
   - Cache structure in session memory
   - Identify patterns (e.g., System/Bug Reports, Project/Type structure)

2. **Analysis**
   - Note top-level notebooks
   - Identify common subnotebook patterns
   - Recognize organizational conventions

3. **Use Throughout Session**
   - Reference cached structure for categorization decisions
   - Propose new notebooks that fit existing patterns
   - Avoid duplicate structure creation

**Key principle:** Discover once per session, use everywhere.

## Workflow 2: Import Files Directly (Recommended for Efficiency)

**Scenario:** Upload existing markdown, HTML, CSV files, or entire directories to Joplin

**This is the MOST TOKEN-EFFICIENT method for uploading existing files.**

**Steps:**

1. **File Identification**
   - User provides file path or directory
   - Identify file type (auto-detected or specified)
   - Count files if directory

2. **Import Execution**
   - Call `import_from_file()` with parameters:
     - `file_path`: Path to file or directory
     - `target_notebook`: Destination (optional, default "Imported")
     - `format`: File type (optional, auto-detected)
     - `import_options`: Additional options like hashtag extraction
   - Direct import without reading content into context
   - **Token usage: ~100 tokens per note vs 1,000-2,500 for manual creation**

3. **Result Summary**
   - Report counts:
     - Notes created
     - Notebooks created (if needed)
     - Tags created (from hashtags if enabled)
   - List any errors or warnings
   - Show target notebook

4. **Post-Import Organization (Optional)**
   - Ask: "Would you like me to analyze and reorganize these notes?"
   - If yes:
     - Search: `find_notes_in_notebook("Imported")`
     - Analyze content in each note
     - Propose tags based on content
     - Propose moving to better notebooks
     - Execute organization with confirmation

**Examples:**

*Single file import:*
```
User: Import this markdown file to Joplin
Me: [calls import_from_file("/path/to/note.md")]
    ✓ Imported 1 note to "Imported" notebook
    Would you like me to analyze and reorganize it?
```

*Directory import:*
```
User: Import all markdown files from /docs/network
Me: [calls import_from_file("/docs/network/", target_notebook="Network Documentation")]
    ✓ Imported 15 notes to "Network Documentation" notebook
    Notes created: 15
    Would you like me to analyze and apply tags?
```

*Import with hashtag extraction:*
```
User: Import these notes and convert hashtags to tags
Me: [calls import_from_file(..., import_options={"extract_hashtags": True})]
    ✓ Imported 5 notes
    ✓ Created 8 tags from hashtags
```

*CSV import as individual notes:*
```
User: Import this device inventory CSV, one note per device
Me: [calls import_from_file("/path/devices.csv", 
                           format="csv",
                           target_notebook="Device Inventory",
                           import_options={"csv_import_mode": "rows"})]
    ✓ Imported 42 device notes
    Each note contains YAML frontmatter from CSV columns
```

**Token Efficiency Comparison:**

*Manual method (10 files):*
- Read 10 files: 5,000-20,000 tokens
- Analyze content: 2,000 tokens
- Create 10 notes: 3,000 tokens
- **Total: 10,000-25,000 tokens**

*Import method (10 files):*
- Import call: ~1,000 tokens
- **Total: ~1,000 tokens**
- **Savings: 90-96%**

**When to Use:**
- ✅ Existing markdown/HTML/CSV files
- ✅ Entire directories of notes
- ✅ Batch uploads
- ✅ Joplin backups (.jex)
- ❌ Generated content (use Workflow 3 instead)
- ❌ Content requiring custom categorization analysis

**Key principle:** Import first for efficiency, organize after if needed.

## Workflow 3: Intelligent Manual Creation with Auto-Categorization

**Scenario:** Create note from generated content, analysis, or when custom categorization is needed

**Use this when:**
- Creating content from scratch (code, reports, analysis)
- Content requires intelligent categorization analysis before upload
- Using templates for consistent structure
- Need custom tag generation based on deep content analysis

**For existing files, use Workflow 2 (Import) instead - it's far more efficient.**

**Steps:**

1. **Content Analysis**
   - Parse error messages → identify affected systems
   - Extract device names → determine tenants/locations
   - Analyze stack traces → identify technologies
   - Read commands → determine platforms
   - Examine code blocks → identify languages/frameworks
   - Extract frontmatter metadata

2. **Structure Discovery** (if not cached)
   - Call `list_notebooks()` once per session
   - Cache notebook structure
   - Identify organizational patterns

3. **Categorization Decision**
   - Determine parent notebook (e.g., "Network Orchestration")
   - Check if subnotebook needed (e.g., "Bug Reports")
   - Generate full path: `Parent/Subnotebook/`
   - Create namespaced tags based on content analysis

4. **Tag Validation**
   - Call `list_tags()` to get existing tags
   - Check if proposed tags already exist
   - Reuse existing tags when possible
   - Create new tags only when needed

5. **Proposal Phase**
   - Show: notebook path, note title, proposed tags, preserved metadata
   - Example: "I'll create 'NAPALM Driver Bug' in Network Orchestration → Bug Reports"
   - List all proposed tags with namespaces
   - Highlight any metadata being preserved

6. **Confirmation Phase**
   - Wait for user confirmation
   - Accept adjustments to notebook, tags, or metadata
   - Validate user changes

7. **Execution Phase**
   - Create notebook structure if needed (with parent_id for subnotebooks)
   - Call `create_note()` with content and metadata
   - Call `tag_note()` for each tag (reusing or creating)
   - Detect and preserve internal links

8. **Verification**
   - Report success with note ID
   - Provide Joplin link if available
   - Confirm tag application
   - Report any link validation issues

**Example Output:**
```
Analyzed: NAPALM_DRIVER_MAPPING_BUG.md
Notebook: Network Orchestration → Bug Reports (will create subnotebook)
Metadata: Author preserved, date: 2025-11-09
Tags: system:napalm, system:nornir-mcp, platform:cisco-ios, backend:wsl, 
      tenant:axepa, type:bug, component:driver-mapping
Internal links: None detected
Confirm? [Yes/No/Adjust]
```

**Key principle:** Analyze deeply, propose clearly, execute precisely.

## Workflow 4: Batch Operations

**Scenario:** Process multiple files or notes

### 4a: Batch Import (Recommended)

**Use for:** Existing files that need uploading

**Steps:**

1. **Import Directory**
   - Call `import_from_file()` on directory path
   - Specify target notebook
   - Enable options like hashtag extraction if needed

2. **Result Review**
   - Review import summary
   - Note count and any warnings

3. **Post-Import Organization** (if needed)
   - Search imported notes
   - Analyze and propose reorganization
   - Apply tags based on content analysis
   - Move to appropriate notebooks

**Example:**
```
User: Import all markdown files from /docs/troubleshooting
Me: [import_from_file("/docs/troubleshooting/", target_notebook="Troubleshooting")]
    ✓ 23 notes imported
    Analyze and organize? [Yes/No]
User: Yes
Me: [analyzes content, proposes tags and organization]
```

### 4b: Batch Manual Creation (For Generated Content)

**Use for:** Content generated during conversation or requiring deep analysis before categorization

**Steps:**

1. **Discovery Phase**
   - Identify all markdown files in source
   - Count total files to process
   - Ensure notebook structure is cached

2. **Analysis Phase**
   - For each file:
     - Read content
     - Extract frontmatter metadata
     - Analyze content for categorization
     - Determine notebook path
     - Generate tags
     - Detect internal links

3. **Proposal Phase**
   - Show summary: "Found 5 markdown files to upload"
   - For each file, show:
     - Filename → Note title
     - Proposed notebook path
     - Proposed tags
     - Metadata to preserve
   - Ask: "Upload all 5 files with this organization?"

4. **Confirmation Phase**
   - Allow bulk confirmation ("Yes, upload all")
   - Allow individual adjustments
   - Allow cancellation of specific files

5. **Execution Phase**
   - Process files in order
   - Show progress: "Uploading 1 of 5..."
   - Create notebooks as needed
   - Upload each note
   - Apply tags (validating each time)
   - Preserve metadata and links

6. **Verification**
   - Report summary: "Successfully uploaded 5 notes"
   - List note IDs and paths
   - Report any errors or warnings
   - Highlight any link issues

**Key principle:** Analyze all, propose all, confirm once, execute with progress.

## Workflow 5: Template-Based Note Creation

**Scenario:** Create consistent notes using predefined templates

**Steps:**

1. **Template Selection**
   - User requests: "Create a bug report for X"
   - Identify appropriate template: `templates/bug-report.md`
   - Read template content

2. **Information Gathering**
   - Prompt for required fields based on template
   - Example for bug report:
     - Issue summary
     - Error details
     - Steps to reproduce
     - Expected vs actual behavior
     - Environment details

3. **Template Population**
   - Fill template with provided information
   - Preserve template structure
   - Add metadata to frontmatter

4. **Standard Upload Flow**
   - Analyze populated content
   - Propose categorization (notebook + tags)
   - Confirm with user
   - Execute upload

**Available Templates:**

- **bug-report.md**: Structured bug documentation
- **meeting-notes.md**: Meeting minutes with attendees, agenda, decisions
- **technical-guide.md**: Step-by-step technical documentation
- **project-plan.md**: Project planning with goals, milestones, tasks

**Key principle:** Consistency through templates, flexibility through fields.

## Workflow 6: Update Existing Note

**Scenario:** Modify content in an existing note while preserving metadata

**Steps:**

1. **Find Phase**
   - Search for note: `find_notes_in_notebook()` or `find_notes_with_tag()`
   - Or use direct note ID if known
   - Call `get_note()` to retrieve current content

2. **Metadata Extraction**
   - Extract existing frontmatter
   - Get current tags: `get_tags_by_note()`
   - Note modification timestamp

3. **Propose Changes**
   - Show current content (or summary if long)
   - Show new content or changes
   - Indicate metadata preservation
   - Ask: "Update [notebook]/[note_title]?"

4. **Confirmation Phase**
   - Wait for approval
   - Allow content adjustments
   - Confirm metadata preservation

5. **Execute**
   - Call `update_note()` with new body
   - Preserve frontmatter metadata
   - Update modification timestamp
   - Preserve internal links

6. **Verification**
   - Confirm update success
   - Report maintained metadata
   - Verify link integrity

**Key principle:** Preserve what exists, change what's needed.

## Workflow 7: Tag Management with Validation

**Scenario:** Apply or reorganize tags on notes

**Steps:**

1. **Tag Discovery**
   - Call `list_tags()` to get all existing tags
   - Cache for session
   - Note tag counts and usage patterns

2. **Target Identification**
   - Find notes to tag: by search, notebook, or existing tags
   - Call `get_tags_by_note()` for each

3. **Proposal Phase**
   - Show current tags for each note
   - Show proposed new tags
   - Indicate which tags exist vs. need creation
   - Show which tags to remove (if any)

4. **Validation**
   - Check if new tags already exist
   - Reuse existing tags
   - Only create truly new tags
   - Warn if creating many new tags

5. **Execute**
   - For existing tags: call `tag_note()` directly
   - For new tags: call `create_tag()` first, then `tag_note()`
   - For removals: call `untag_note()`

6. **Verify**
   - Retrieve updated tags to confirm
   - Report tag creation count
   - Report tag reuse count

**Key principle:** Reuse before creating, validate before executing.

## Workflow 8: Search and Retrieve with Link Awareness

**Scenario:** Find existing notes and understand their connections

**Patterns:**

**By text:**
```
find_notes("python debugging")  # Full-text search
find_notes("*")                 # List all notes
```

**By organization:**
```
find_notes_in_notebook("Technical References")
find_notes_with_tag("system:napalm")
```

**By status:**
```
find_notes("*", task=True)                    # All tasks
find_notes("*", task=True, completed=False)   # Incomplete tasks
```

**With link analysis:**
```
get_note(note_id)           # Full content
get_links(note_id)          # See what this note links to and what links to it
```

**Key principle:** Search broadly, narrow precisely, understand connections.

## Workflow 9: Metadata Preservation During Operations

**Scenario:** Ensure important metadata survives note operations

**Metadata Types:**

**Timestamps:**
- `date`, `created` → preserve original creation date
- `updated` → update to current timestamp on modification

**Attribution:**
- `author`, `creator` → preserve in frontmatter
- Add as note body if not in frontmatter

**Status Fields:**
- `priority` → convert to `priority:high`, `priority:medium`, `priority:low` tags
- `status` → convert to `status:` namespaced tags
- `severity` → convert to tags

**Custom Fields:**
- `project`, `epic`, `sprint` → preserve as tags
- `links`, `related` → preserve in note body
- Any other fields → preserve in frontmatter

**Process:**

1. **Extract** metadata from frontmatter
2. **Transform** relevant fields to tags (with validation)
3. **Preserve** remaining fields in frontmatter
4. **Update** timestamps appropriately
5. **Report** what was preserved and transformed

**Key principle:** Nothing is lost, everything is transformed appropriately.

## Workflow 10: Internal Link Management

**Scenario:** Preserve and validate note-to-note links

**Link Detection:**
- Scan content for `[text](:/noteId)` patterns
- Scan for `[text](:/noteId#section)` patterns
- Extract all noteIds

**Validation (optional):**
- For each detected link:
  - Check if target note exists
  - Report broken links
  - Suggest fixes

**Preservation:**
- Maintain exact link format during uploads
- Preserve links during updates
- Update links if note IDs change (advanced)

**Reporting:**
- "Internal links detected: 3"
- "All links valid" or "1 broken link detected"
- Show broken link details

**Key principle:** Detect all, validate when needed, preserve always.

## Common Patterns

### Pattern: Namespace Tag Creation

When creating namespaced tags:

1. Check if namespace exists in current tags
2. Propose tag with proper namespace
3. Validate against existing tags
4. Create only if truly new

Example:
```
Proposed: system:napalm
Existing tags check... 
✓ Tag exists, will reuse
```

### Pattern: Hierarchical Notebook Creation

When creating nested notebooks:

1. Check if parent notebook exists
2. Create parent if needed (with confirmation)
3. Create child notebook with parent_id
4. Cache new structure

Example:
```
Network Orchestration (exists)
└─ Bug Reports (will create)
   └─ NAPALM Driver Bug (your note)
```

### Pattern: Batch Tag Application

When tagging multiple notes:

1. Validate all tags first (one pass)
2. Create all new tags (if approved)
3. Apply tags to all notes (batch operation)
4. Report summary

## Error Handling

**Note not found:** Offer alternatives from search results

**Ambiguous notebook name:** List matches and ask for clarification

**Tag conflicts:** Show existing similar tags and ask to reuse

**Broken internal links:** Report and offer to remove or fix

**Metadata parsing errors:** Show error, ask to proceed without metadata or fix

**Permission failures:** Report specific error and suggest troubleshooting

**Batch operation failures:** Continue with remaining items, report failed items at end
