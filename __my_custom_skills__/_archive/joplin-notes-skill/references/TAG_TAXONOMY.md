# Tag Taxonomy Reference

Complete guide to namespaced tag conventions for consistent organization.

## Philosophy

Tags use namespaces to create structured, searchable metadata. The pattern is:
```
namespace:value
```

This enables:
- **Faceted search**: Find all `system:*` tags or all `*:napalm` values
- **Logical grouping**: Related concepts cluster together
- **Scalability**: Add new namespaces without conflicts
- **Clarity**: Tag purpose is immediately obvious

## Core Namespaces

### system:
Technologies, libraries, frameworks, and software systems.

**Purpose:** Identify which technical systems are involved

**Examples:**
- `system:napalm` - NAPALM library
- `system:nornir` - Nornir automation framework
- `system:nautobot` - Nautobot IPAM/DCIM
- `system:vault` - HashiCorp Vault
- `system:docker` - Docker containerization
- `system:traefik` - Traefik reverse proxy
- `system:lldap` - LLDAP authentication
- `system:authelia` - Authelia SSO

**When to use:** Any time a specific technology, tool, or software system is central to the content.

---

### platform:
Hardware platforms, operating systems, network devices, and vendor-specific systems.

**Purpose:** Identify the hardware or vendor platform

**Examples:**
- `platform:cisco-ios` - Cisco IOS/IOS-XE
- `platform:cisco-nxos` - Cisco Nexus NX-OS
- `platform:arista-eos` - Arista EOS
- `platform:junos` - Juniper JUNOS
- `platform:linux` - Linux operating system
- `platform:ubuntu` - Ubuntu Linux
- `platform:windows` - Windows operating system
- `platform:raspberry-pi` - Raspberry Pi hardware

**When to use:** When content is specific to a particular hardware platform, OS, or network device vendor.

---

### backend:
Execution environments, servers, MCP backends, and infrastructure hosts.

**Purpose:** Identify where code runs or which infrastructure is involved

**Examples:**
- `backend:wsl` - Windows Subsystem for Linux
- `backend:macbook` - MacBook development environment
- `backend:wyze` - Wyze production server
- `backend:cloud` - Cloud infrastructure
- `backend:azure` - Azure cloud
- `backend:aws` - AWS cloud

**When to use:** When content relates to a specific execution environment or infrastructure backend.

---

### tenant:
Organizational units, customers, clients, or business entities.

**Purpose:** Segment content by organization or customer

**Examples:**
- `tenant:axepa` - AXEPA organization
- `tenant:zenith` - Zenith organization  
- `tenant:ena-on` - ENA-ON organization
- `tenant:internal` - Internal company use
- `tenant:personal` - Personal projects

**When to use:** When content is specific to a particular organization, customer, or business unit.

---

### type:
Content categories and document types.

**Purpose:** Classify the kind of content

**Examples:**
- `type:bug` - Bug report or issue
- `type:solution` - Solution or fix documentation
- `type:guide` - How-to guide or tutorial
- `type:reference` - Reference documentation
- `type:checklist` - Checklist or procedure
- `type:troubleshooting` - Troubleshooting guide
- `type:meeting-notes` - Meeting notes
- `type:decision` - Decision record
- `type:rfc` - Request for Comments
- `type:postmortem` - Incident postmortem

**When to use:** Always. Every note should have a type tag to indicate what kind of document it is.

---

### component:
Specific subsystems, modules, or functional components within a larger system.

**Purpose:** Identify which part of a system is involved

**Examples:**
- `component:driver-mapping` - Driver mapping subsystem
- `component:api-client` - API client module
- `component:authentication` - Authentication system
- `component:database` - Database layer
- `component:frontend` - Frontend interface
- `component:backend-api` - Backend API
- `component:network-stack` - Network stack
- `component:storage` - Storage subsystem

**When to use:** When discussing a specific module or component within a larger system.

---

### location:
Physical locations, data centers, offices, or geographical regions.

**Purpose:** Identify physical or logical location

**Examples:**
- `location:hq` - Headquarters
- `location:datacenter-a` - Data center A
- `location:remote` - Remote location
- `location:thessaloniki` - Thessaloniki office
- `location:athens` - Athens office
- `location:cloud-region-eu` - EU cloud region

**When to use:** When content is specific to a physical location or geographical region.

---

### status:
Workflow states, progress tracking, and completion status.

**Purpose:** Track the state or progress of work

**Examples:**
- `status:open` - Open/active issue
- `status:in-progress` - Work in progress
- `status:resolved` - Resolved/fixed
- `status:closed` - Closed/completed
- `status:blocked` - Blocked by dependencies
- `status:needs-review` - Awaiting review
- `status:draft` - Draft/work in progress
- `status:published` - Published/final

**When to use:** For issues, tasks, and documents that have a workflow state.

---

### priority:
Importance or urgency levels.

**Purpose:** Indicate relative importance

**Examples:**
- `priority:critical` - Critical priority
- `priority:high` - High priority
- `priority:medium` - Medium priority
- `priority:low` - Low priority

**When to use:** When prioritization is important (bugs, tasks, issues).

---

### language:
Programming languages or markup languages.

**Purpose:** Identify the programming language

**Examples:**
- `language:python` - Python code
- `language:bash` - Bash scripts
- `language:javascript` - JavaScript code
- `language:yaml` - YAML configuration
- `language:markdown` - Markdown documentation

**When to use:** For code snippets, scripts, or language-specific content.

---

### project:
Project names or initiatives.

**Purpose:** Associate content with specific projects

**Examples:**
- `project:network-automation` - Network automation project
- `project:homelab-migration` - Homelab migration project
- `project:2025-q1` - Q1 2025 initiatives

**When to use:** When content belongs to a specific project or initiative.

---

## Tag Creation Guidelines

### 1. Use Lowercase with Hyphens
✅ Good: `system:cisco-ios`, `type:meeting-notes`  
❌ Bad: `system:CiscoIOS`, `type:MeetingNotes`, `type:meeting_notes`

### 2. Always Include Namespace Prefix
✅ Good: `system:docker`, `type:bug`  
❌ Bad: `docker`, `bug` (unless intentional non-namespaced tag)

### 3. Be Specific But Not Overly Granular
✅ Good: `component:driver-mapping`, `platform:cisco-ios`  
❌ Too granular: `component:driver-mapping-cisco-ios-xe-16.12.3`

### 4. Reuse Existing Tags When Possible
Before creating a new tag:
1. Call `list_tags()` to see what exists
2. Check if similar tag already exists
3. Reuse if appropriate
4. Only create if truly needed

### 5. Create New Tags Only When Necessary
Ask:
- Does an existing tag cover this concept?
- Is this tag likely to be used again?
- Will this help findability?

If yes to all three, create the tag.

### 6. Consider Searchability
Tags should make content findable:
- Use terms you'll actually search for
- Use consistent terminology across related notes
- Think about how you'll search in 6 months

### 7. Avoid Redundancy
Don't create tags that duplicate other metadata:
- ❌ `date:2025-11-09` (use note metadata instead)
- ❌ `notebook:work` (already in notebook)
- ✅ `type:bug` (adds semantic meaning)

## Multi-Tag Strategy

Most notes should have 3-7 tags covering different facets:

**Example 1: Network Bug Report**
```
system:napalm
system:nornir-mcp
platform:cisco-ios
backend:wsl
tenant:axepa
type:bug
component:driver-mapping
status:open
priority:high
```

**Example 2: Technical Guide**
```
system:docker
system:traefik
type:guide
language:yaml
project:homelab-migration
status:published
```

**Example 3: Meeting Notes**
```
tenant:axepa
type:meeting-notes
project:network-automation
location:hq
```

## Namespace Extensions

You can create new namespaces as needed. Consider adding:

**role:** - For device roles
- `role:access-switch`
- `role:aggregation-switch`  
- `role:firewall`

**protocol:** - For network protocols
- `protocol:bgp`
- `protocol:ospf`
- `protocol:snmp`

**vendor:** - For vendor-agnostic references
- `vendor:cisco`
- `vendor:arista`
- `vendor:juniper`

**environment:** - For deployment environments
- `environment:production`
- `environment:staging`
- `environment:development`

## Anti-Patterns

### ❌ Don't: Create Namespace for Every Category
Too many namespaces create confusion. Stick to 8-12 core namespaces.

### ❌ Don't: Mix Namespaced and Non-Namespaced
Pick one approach and stick with it. Preferably use namespaces consistently.

### ❌ Don't: Use Tags for Filtering That Can Be Done Other Ways
- ❌ `completed:true` → Use todo_completed parameter instead
- ❌ `notebook:work` → Use notebook hierarchy instead

### ❌ Don't: Create Single-Use Tags
If a tag will only ever apply to one note, it's not adding value.

### ❌ Don't: Use Very Long Tag Names
- ❌ `system:network-automation-orchestration-framework`
- ✅ `system:nornir` (use multiple tags if needed)

## Best Practices

### ✅ Start Conservative
Begin with core namespaces. Add new ones only when clear need emerges.

### ✅ Review Periodically
Every few months:
1. List all tags: `list_tags()`
2. Identify unused or rarely-used tags
3. Consider consolidation
4. Update taxonomy if needed

### ✅ Document Conventions
Keep this taxonomy updated as you add namespaces or change conventions.

### ✅ Validate Before Creating
Always check existing tags before creating new ones to avoid duplication.

### ✅ Use Tags for Discovery
Think: "How will I search for this in 6 months?"

## Quick Reference

| Namespace | Purpose | Example |
|-----------|---------|---------|
| `system:` | Technologies, software | `system:napalm` |
| `platform:` | Hardware, OS, devices | `platform:cisco-ios` |
| `backend:` | Execution environments | `backend:wsl` |
| `tenant:` | Organizations, customers | `tenant:axepa` |
| `type:` | Content category | `type:bug` |
| `component:` | Subsystems, modules | `component:driver-mapping` |
| `location:` | Physical locations | `location:hq` |
| `status:` | Workflow states | `status:open` |
| `priority:` | Importance levels | `priority:high` |
| `language:` | Programming languages | `language:python` |
| `project:` | Project names | `project:network-automation` |
