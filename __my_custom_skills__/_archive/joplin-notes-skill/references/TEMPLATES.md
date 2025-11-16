# Template Usage Guide

Complete guide for using note templates in the Joplin Notes skill.

## Available Templates

### bug-report.md
Structured bug report with comprehensive sections for documenting issues.

**Best for:**
- Software bugs
- Configuration errors
- Integration failures
- System malfunctions

**Key Sections:**
- Error details and stack traces
- Root cause analysis
- Steps to reproduce
- Workaround status
- Impact assessment
- Resolution plan

**Example usage:**
```
You: Create a bug report for the NAPALM driver mapping issue
Me: I'll use the bug-report template. What's the issue summary?
You: NAPALM getters fail with driver import error on Cisco devices
Me: [fills template, proposes categorization]
```

---

### meeting-notes.md
Comprehensive meeting minutes template with agenda, discussions, and action items.

**Best for:**
- Team standups
- Planning meetings
- Sprint reviews
- Retrospectives
- Stakeholder meetings

**Key Sections:**
- Attendee tracking
- Structured agenda
- Discussion points
- Decisions made
- Action items with owners
- Next meeting planning

**Example usage:**
```
You: Create meeting notes for today's sprint planning
Me: I'll use the meeting-notes template. Who attended?
You: [provides attendees]
Me: What was discussed?
You: [provides topics]
Me: [fills template, proposes categorization]
```

---

### technical-guide.md
Step-by-step technical documentation with verification and troubleshooting.

**Best for:**
- How-to guides
- Setup instructions
- Configuration guides
- Process documentation
- Runbooks

**Key Sections:**
- Prerequisites and setup
- Detailed step-by-step instructions
- Verification procedures
- Troubleshooting common issues
- Advanced topics
- Best practices

**Example usage:**
```
You: Create a guide for setting up the Joplin MCP server
Me: I'll use the technical-guide template. What are the main steps?
You: [provides high-level steps]
Me: [fills template with detailed instructions]
```

---

### project-plan.md
Comprehensive project planning document with timeline, resources, and risks.

**Best for:**
- New initiatives
- Multi-phase projects
- Product launches
- Infrastructure migrations
- Feature development

**Key Sections:**
- Executive summary
- Goals and success criteria
- Stakeholder identification
- Timeline and milestones
- Resource planning
- Risk management
- Communication plan
- Quality assurance
- Deployment plan

**Example usage:**
```
You: Create a project plan for the network automation migration
Me: I'll use the project-plan template. What are the primary objectives?
You: [provides objectives]
Me: What's the timeline?
You: [provides dates]
Me: [fills template with comprehensive plan]
```

---

## Using Templates

### Basic Workflow

1. **Request Template-Based Creation**
   ```
   "Create a bug report for [issue]"
   "Create meeting notes for [meeting]"
   "Create a technical guide for [topic]"
   "Create a project plan for [project]"
   ```

2. **Interactive Filling**
   - I'll ask for required information
   - You provide details for each section
   - I fill the template as we go

3. **Categorization**
   - I analyze the filled content
   - Propose notebook location
   - Suggest appropriate tags

4. **Confirmation & Upload**
   - Review the populated template
   - Confirm categorization
   - Upload to Joplin

### Advanced Usage

#### Pre-fill from Document

If you already have content:
```
You: Use the bug report template for this error log [attaches file]
Me: [extracts relevant information, fills template]
```

#### Batch Template Creation

Create multiple notes from one template:
```
You: Create bug reports for these 5 issues using the template
Me: [creates 5 notes, each from template with different data]
```

#### Custom Template Variations

Request modifications:
```
You: Use the meeting notes template but add a "Parking Lot" section
Me: [adds custom section to template before filling]
```

---

## Template Customization

### Frontmatter Metadata

All templates include frontmatter that gets processed:

```yaml
---
title: [Auto-filled from your input]
date: [Auto-filled with current date]
author: [Your name or auto-detected]
status: [Appropriate default for template type]
priority: [Asked during filling or auto-assigned]
tags: [Base tags + auto-generated tags]
---
```

### Section Adaptation

Templates are starting points. Sections can be:
- **Expanded** - Add more detail where needed
- **Removed** - Skip irrelevant sections
- **Reordered** - Adjust flow to match needs
- **Customized** - Modify headers or structure

### Tag Application

Each template has default tag patterns:

| Template | Default Tags | Additional Auto-Tags |
|----------|--------------|---------------------|
| bug-report.md | `type:bug` | `system:*`, `platform:*`, `component:*`, `status:*`, `priority:*` |
| meeting-notes.md | `type:meeting-notes` | `tenant:*`, `project:*`, `location:*` |
| technical-guide.md | `type:guide` | `system:*`, `language:*`, `platform:*` |
| project-plan.md | `type:project-plan` | `project:*`, `status:*`, `priority:*` |

---

## Template Best Practices

### ✅ Do:

**Start with Templates for Consistency**
- Use templates for recurring document types
- Builds organizational habits
- Improves findability

**Fill Completely**
- Even if sections seem optional
- More context = better future searches
- Easier to delete than to remember

**Update Templates**
- If you skip sections repeatedly, remove them
- If you add sections often, include them
- Templates should evolve with your needs

**Use Appropriate Template**
- Match template to content type
- Don't force-fit content into wrong template
- Ask for guidance if unsure

### ❌ Don't:

**Don't Skip Frontmatter**
- Metadata is critical for organization
- Auto-tagging depends on frontmatter
- Future-you will thank present-you

**Don't Leave Placeholders**
- Replace all `[brackets]` with actual content
- Remove unused sections rather than leaving empty
- Clean up template artifacts

**Don't Ignore Template Structure**
- Templates are structured for a reason
- Reordering may break logical flow
- Customize thoughtfully

---

## Template-Specific Tips

### Bug Report Tips

**Error Messages:**
- Include full stack traces
- Preserve formatting with code blocks
- Include timestamps if available

**Steps to Reproduce:**
- Number each step clearly
- Include exact commands/clicks
- Specify starting state

**Root Cause:**
- Separate observations from hypothesis
- Link to related issues/docs
- Update as investigation progresses

---

### Meeting Notes Tips

**Action Items:**
- Always assign an owner
- Include due dates
- Use checkboxes for tracking
- Copy to separate task tracking system

**Decisions:**
- Document rationale, not just decision
- Note who made the decision
- Include impact assessment

**Attendee Tracking:**
- Track both present and absent
- Note if partial attendance
- Include roles if not obvious

---

### Technical Guide Tips

**Prerequisites:**
- Be explicit about required knowledge
- Link to dependency docs
- Include version requirements

**Verification:**
- Test every verification step yourself
- Include expected output
- Provide debugging for failed verification

**Troubleshooting:**
- Document actual problems you encountered
- Test each solution before documenting
- Include prevention strategies

---

### Project Plan Tips

**Timeline:**
- Build in buffer time
- Mark critical path items
- Update dates as project progresses

**Risks:**
- Identify early and often
- Update probability/impact as project proceeds
- Document actual risk outcomes

**Status Updates:**
- Update regularly (weekly minimum)
- Include blockers prominently
- Celebrate milestones

---

## Creating Custom Templates

Want to create your own templates?

1. **Identify Recurring Document Type**
   - Do you create this document type frequently?
   - Does it have a consistent structure?
   - Would a template save time?

2. **Document Required Sections**
   - What must be included?
   - What's optional?
   - What metadata is needed?

3. **Create Template File**
   - Start with frontmatter
   - Add section headers
   - Include placeholders
   - Add inline instructions

4. **Test and Iterate**
   - Use template for real documents
   - Refine based on experience
   - Remove unused sections
   - Add frequently-needed sections

5. **Save in Templates Directory**
   - Name descriptively: `custom-template-name.md`
   - Document usage in this file
   - Share with me when ready to use

---

## Template Maintenance

### Regular Review

**Monthly:**
- Review recent notes created from templates
- Identify commonly skipped sections
- Note commonly added content

**Quarterly:**
- Update templates based on usage patterns
- Add new templates for new document types
- Archive unused templates

**Annually:**
- Major template overhaul if needed
- Align with organizational changes
- Document template evolution

### Version Control

Track template changes:
```yaml
---
template-version: 2.0
last-updated: 2025-11-09
changelog:
  - v2.0 (2025-11): Added verification section
  - v1.0 (2025-01): Initial version
---
```

---

## Quick Reference

| Need | Use Template | Key Sections |
|------|--------------|--------------|
| Document a bug | bug-report.md | Error details, reproduction steps |
| Record meeting | meeting-notes.md | Attendees, decisions, action items |
| Write how-to | technical-guide.md | Prerequisites, steps, verification |
| Plan project | project-plan.md | Goals, timeline, resources, risks |
| Custom recurring doc | Create new template | [Define your structure] |

---

## Getting Help with Templates

```
"List available templates"
"Show me the bug report template"
"Create a note from [template name]"
"Help me customize the [template] template"
"What template should I use for [purpose]?"
```
