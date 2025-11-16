# Infrastructure Orchestration Skill Update

## Overview

Created a new **infrastructure-orchestration-skill** that extends the existing network-orchestration-skill to include **Linux Engineer MCP** capabilities, providing unified orchestration for both network and Linux infrastructure automation.

## What Changed

### New Skill: infrastructure-orchestration-skill.skill

This skill supersedes the network-orchestration-skill by adding Linux administration capabilities while maintaining all existing network automation features.

**Key Additions:**

1. **Linux Engineer MCP Tools** (4 new tools):
   - `check_service_status` - Check systemd services across servers
   - `analyze_disk_usage` - Find servers with high disk usage
   - `scan_for_packages` - Find servers with specific packages
   - `check_system_health` - Check CPU/memory/load metrics

2. **Updated Documentation**:
   - **SKILL.md**: Added Linux administration section with tool descriptions and examples
   - **WORKFLOWS.md**: Added 6 new Linux workflows + 2 combined network+Linux workflows
   - **REFERENCE.md**: Added comprehensive Linux tool reference documentation
   - **TROUBLESHOOTING.md**: Retained existing network troubleshooting

3. **Architecture Diagram**: Shows integration of Linux Engineer MCP alongside Network Engineer MCP

## Why This Update

### Problem Solved

The **Linux Engineer MCP** (https://github.com/nstamoul/linuxeng-mcp) was recently implemented following the same architecture pattern as Network Engineer MCP:

- **Context Window Explosion**: Prevents 100+ servers × 1,000 packages = 100,000 lines overwhelming LLM context
- **Local Processing**: Processes large datasets locally, returns only relevant results
- **Cost Optimization**: 5,000x reduction in tokens (250,000 → 50)
- **Same Integration Pattern**: Orchestrator → Specialized MCP → Execution Backend

### Benefits

1. **Unified Skill**: Single skill for all infrastructure orchestration (network + Linux)
2. **Consistent Patterns**: Same workflow for network devices and Linux servers
3. **Better Discovery**: Users find both capabilities in one skill
4. **Complete Coverage**: Network automation + Linux administration in unified documentation

## Usage

### Network Automation (Unchanged)

```json
{
  "name": "execute_network_task",
  "arguments": {
    "tenant": "AXEPA",
    "role": "access switch",
    "task_type": "cli_command",
    "task_params": {"commands": ["show version"]}
  }
}
```

### Linux Administration (New)

```json
{
  "name": "check_service_status",
  "arguments": {
    "service_name": "nginx",
    "inventory": {
      "hosts": {
        "web-01": {"hostname": "10.1.1.10", "username": "admin", "password": "***"}
      }
    },
    "ssh_backend": "wsl",
    "response_format": "markdown"
  }
}
```

### Combined Workflows (New)

```json
// Step 1: Locate device on network
{"name": "locate_device_by_ip", "arguments": {"ip_address": "10.1.1.10", "tenant": "AXEPA"}}

// Step 2: Check server health
{"name": "check_system_health", "arguments": {"inventory": {...}, "cpu_threshold": 80}}

// Step 3: Check service status
{"name": "check_service_status", "arguments": {"service_name": "nginx", "inventory": {...}}}
```

## Migration Path

### Option 1: Keep Both Skills

- **network-orchestration-skill**: Existing, network-only
- **infrastructure-orchestration-skill**: New, network + Linux

### Option 2: Deprecate Network-Only Skill

- Update skill name in deployments from `network-orchestration` to `infrastructure-orchestration`
- All existing network automation workflows continue to work unchanged
- New Linux capabilities available immediately

## Technical Details

### File Structure

```
infrastructure-orchestration-skill/
├── SKILL.md                 # Main skill file (network + Linux)
└── references/
    ├── WORKFLOWS.md         # 12 workflows (4 network, 6 Linux, 2 combined)
    ├── REFERENCE.md         # Complete tool reference (network + Linux)
    └── TROUBLESHOOTING.md   # Troubleshooting guide
```

### Integration Points

**Orchestrator MCP** coordinates:
- **Nautobot MCP**: Device/server inventory
- **Vault MCP**: Credentials management
- **Network Engineer MCP**: Device location, network troubleshooting
- **Linux Engineer MCP**: System administration, monitoring ← NEW
- **Nornir MCP**: Network device execution backend
- **SSH MCP**: Linux server execution backend

### MCP Endpoints

- **Network Engineer MCP**: `https://mcp.orb.local/neteng`
- **Linux Engineer MCP**: `https://mcp.orb.local/linuxeng` ← NEW
- **Nornir MCP**: Various backends (default, macbook, wsl, wyze)
- **SSH MCP**: Backends (wsl, macbook)

## Examples Added

### Linux Workflows

1. **Service Health Check Across Fleet** - Monitor critical services
2. **Proactive Disk Space Monitoring** - Find servers approaching limits
3. **Security Vulnerability Assessment** - Find vulnerable package versions
4. **Performance Issue Investigation** - Check CPU/memory/load
5. **Post-Deployment Verification** - Verify deployment success
6. **Package Inventory Audit** - Compliance checking

### Combined Network + Linux Workflows

7. **End-to-End Connectivity Troubleshooting** - Network → Application → System
8. **Multi-Tenant Infrastructure Audit** - Complete infrastructure view

## Skill Metadata

```yaml
name: infrastructure-orchestration
description: Execute network and Linux automation tasks across multi-tenant infrastructure by coordinating Nautobot (inventory), Vault (credentials), Network Engineer MCP, Linux Engineer MCP, and execution backends (Nornir, SSH). Use for network device management, Linux server administration, device location, system health checks, package management, service monitoring, disk analysis, and infrastructure troubleshooting across tenants like AXEPA, Zenith, ENA-ON.
```

## Testing Recommendations

1. **Verify network workflows still work** - Test existing execute_network_task calls
2. **Test Linux tools individually** - Start with check_service_status on 1-2 servers
3. **Test combined workflows** - Try end-to-end troubleshooting scenario
4. **Validate backend selection** - Ensure wsl/macbook backends work correctly

## Next Steps

1. ✅ Created infrastructure-orchestration-skill.skill
2. ✅ Added comprehensive documentation (SKILL.md, WORKFLOWS.md, REFERENCE.md)
3. ✅ Packaged as .skill file
4. ⏳ Commit to claude_skills repository
5. ⏳ Deploy to Claude Code environment
6. ⏳ Update orchestrator configurations if needed
7. ⏳ Test with real scenarios

## References

- **Linux Engineer MCP**: https://github.com/nstamoul/linuxeng-mcp
- **Network Engineer MCP**: https://github.com/nstamoul/neteng-mcp
- **Nautobot MCP**: https://github.com/nstamoul/nautobot-mcp
- **Architecture Document**: See ARCHITECTURE.md in linuxeng-mcp repo

---

**Created**: 2025-11-16
**Author**: Claude Code
**Version**: 1.0.0
