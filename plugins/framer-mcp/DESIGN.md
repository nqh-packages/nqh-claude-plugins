# Framer MCP Server Design

## Overview

A Python MCP server focused on **code-to-design** workflows for Framer. Unlike the existing Framer MCP (read-heavy), this focuses on creating and updating designs programmatically.

## Architecture

```
┌─────────────────┐      ┌────────────────────┐      ┌──────────────────┐
│  Claude Code    │─────▶│  framer-mcp        │─────▶│  Framer Plugin   │
│  (MCP Client)   │ MCP  │  (Python Server)   │  WS  │  (Browser)       │
└─────────────────┘      └────────────────────┘      └──────────────────┘
                                  │
                         ┌────────┴────────┐
                         │                 │
                    ┌────▼────┐      ┌─────▼─────┐
                    │  Tools  │      │  Bridge   │
                    │  Layer  │      │  Layer    │
                    └─────────┘      └───────────┘
```

### Components

| Component | Responsibility |
|-----------|---------------|
| **MCP Server** | Handles Claude Code requests via stdio |
| **Tools Layer** | High-level code-to-design operations |
| **Bridge Layer** | WebSocket communication with Framer plugin |
| **Framer Plugin** | Existing marketplace plugin (unchanged) |

## Tools Specification

### 1. `create_component`

Create a Framer code component from React/TypeScript code.

```python
@tool
def create_component(
    name: str,           # Component name (PascalCase)
    code: str,           # React/TSX code
    description: str,    # Component description
    props_schema: dict,  # Property controls schema
) -> ComponentResult:
    """
    Creates a Framer code component from React code.

    Example:
        create_component(
            name="HeroSection",
            code='''
            import { motion } from "framer-motion"

            export function HeroSection({ title, subtitle }) {
                return (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
                        <h1>{title}</h1>
                        <p>{subtitle}</p>
                    </motion.div>
                )
            }
            ''',
            props_schema={
                "title": { "type": "string", "default": "Welcome" },
                "subtitle": { "type": "string", "default": "Get started" }
            }
        )
    """
```

**Input:**
- `name`: Component name (will be created as `{name}.tsx`)
- `code`: Valid React/TSX code (Framer-compatible)
- `description`: For component library
- `props_schema`: Framer property controls

**Output:**
```json
{
    "component_id": "abc123",
    "file_path": "HeroSection.tsx",
    "status": "created",
    "preview_url": "framer://component/abc123"
}
```

**Implementation:**
1. Validate React code syntax
2. Add Framer property controls from schema
3. Call existing MCP `createCodeFile` via bridge
4. Return component reference

---

### 2. `create_layout`

Generate a Framer layout from natural language description.

```python
@tool
def create_layout(
    description: str,    # Natural language layout description
    parent_id: str = None,  # Parent node (optional, defaults to current page)
    style_preset: str = "default",  # Style preset to apply
) -> LayoutResult:
    """
    Creates a Framer layout from a description.

    Example:
        create_layout(
            description="Header with logo on left, navigation menu in center,
                        and login button on right. Use flexbox with space-between.",
            style_preset="modern"
        )
    """
```

**Input:**
- `description`: Natural language layout description
- `parent_id`: Where to insert (default: current page)
- `style_preset`: Predefined style (modern, minimal, bold, etc.)

**Output:**
```json
{
    "node_id": "xyz789",
    "structure": {
        "type": "Frame",
        "layout": "flex",
        "children": [
            { "type": "Frame", "name": "Logo", "width": 120 },
            { "type": "Frame", "name": "Nav", "layout": "flex" },
            { "type": "Frame", "name": "LoginButton" }
        ]
    },
    "status": "created"
}
```

**Implementation:**
1. Parse description into layout structure (LLM-assisted)
2. Map to Framer node types and properties
3. Generate XML representation
4. Call bridge to create nodes via Plugin API
5. Apply style preset

---

### 3. `generate_design`

Full design generation from a prompt - the most powerful tool.

```python
@tool
def generate_design(
    prompt: str,         # Design prompt
    page_name: str = None,  # Target page (creates new if None)
    style_guide: dict = None,  # Optional style constraints
    reference_url: str = None,  # Reference design URL
) -> DesignResult:
    """
    Generates a complete Framer design from a prompt.

    Example:
        generate_design(
            prompt="Create a SaaS landing page with:
                   - Hero section with headline, subheadline, and CTA button
                   - Features grid showing 3 key benefits with icons
                   - Testimonial carousel
                   - Pricing table with 3 tiers
                   - Footer with links and newsletter signup",
            style_guide={
                "primary_color": "#6366F1",
                "font_family": "Inter",
                "border_radius": "8px"
            }
        )
    """
```

**Input:**
- `prompt`: Detailed design description
- `page_name`: Target page name
- `style_guide`: Colors, typography, spacing
- `reference_url`: Screenshot/reference for style matching

**Output:**
```json
{
    "page_id": "page123",
    "sections": [
        { "name": "Hero", "node_id": "hero123" },
        { "name": "Features", "node_id": "feat456" },
        { "name": "Testimonials", "node_id": "test789" },
        { "name": "Pricing", "node_id": "price012" },
        { "name": "Footer", "node_id": "foot345" }
    ],
    "components_created": 12,
    "status": "created"
}
```

**Implementation:**
1. Decompose prompt into sections
2. For each section:
   - Determine optimal component structure
   - Generate code components if complex
   - Create layout frames for simple structures
3. Apply style guide globally
4. Create responsive variants
5. Link sections with navigation if needed

---

### 4. `sync_tokens`

Import design tokens as Framer styles.

```python
@tool
def sync_tokens(
    tokens: dict,        # Design tokens object
    format: str = "auto",  # Token format (figma, style-dictionary, tailwind, auto)
    merge_strategy: str = "update",  # update, replace, or create_only
) -> TokenSyncResult:
    """
    Syncs design tokens to Framer color and text styles.

    Example:
        sync_tokens(
            tokens={
                "colors": {
                    "primary": { "50": "#EEF2FF", "500": "#6366F1", "900": "#312E81" },
                    "gray": { "100": "#F3F4F6", "900": "#111827" }
                },
                "typography": {
                    "heading": { "fontFamily": "Inter", "fontWeight": 700 },
                    "body": { "fontFamily": "Inter", "fontWeight": 400 }
                },
                "spacing": { "xs": "4px", "sm": "8px", "md": "16px", "lg": "24px" }
            },
            format="tailwind"
        )
    """
```

**Input:**
- `tokens`: Design tokens in supported format
- `format`: Source format (auto-detected if not specified)
- `merge_strategy`: How to handle existing styles

**Output:**
```json
{
    "colors_synced": 12,
    "text_styles_synced": 6,
    "spacing_applied": true,
    "conflicts": [],
    "status": "synced"
}
```

**Implementation:**
1. Parse tokens based on format
2. Map to Framer style structure:
   - Colors → Color Styles
   - Typography → Text Styles
   - Spacing → Variables (if supported) or documentation
3. Apply merge strategy
4. Update existing styles or create new ones
5. Report conflicts if any

---

## Supporting Tools

### 5. `get_project_context`

Get current project structure for informed design decisions.

```python
@tool
def get_project_context() -> ProjectContext:
    """Returns current project structure, styles, and components."""
```

### 6. `preview_design`

Generate a preview without committing changes.

```python
@tool
def preview_design(
    design_spec: dict,   # Design specification
) -> PreviewResult:
    """Generates a preview image of proposed design changes."""
```

### 7. `apply_style`

Apply styles to existing nodes.

```python
@tool
def apply_style(
    node_ids: list[str],
    styles: dict,
) -> StyleResult:
    """Applies styles to one or more existing nodes."""
```

### 8. `insert_component`

Insert an existing component into the canvas.

```python
@tool
def insert_component(
    component_id: str,
    parent_id: str = None,
    position: dict = None,
    props: dict = None,
) -> InsertResult:
    """Inserts a component instance onto the canvas."""
```

---

## Bridge Layer

The bridge handles WebSocket communication with the Framer plugin.

### Connection Flow

```
1. User opens Framer MCP plugin → Gets session secret
2. User configures MCP server with secret
3. MCP server connects to wss://mcp.unframer.co
4. Server sends commands, receives responses
```

### Message Protocol

```python
class FramerBridge:
    async def connect(self, session_secret: str):
        """Establish WebSocket connection."""

    async def send_command(self, tool: str, params: dict) -> dict:
        """Send command and await response."""

    async def batch_commands(self, commands: list[dict]) -> list[dict]:
        """Send multiple commands efficiently."""
```

### Existing Plugin Commands

The bridge wraps these existing Framer MCP plugin capabilities:

| Command | Description | Used By |
|---------|-------------|---------|
| `getProjectStructure` | XML of project | `get_project_context` |
| `createCodeFile` | Create TSX file | `create_component` |
| `updateCodeFile` | Update TSX file | `create_component` |
| `insertComponent` | Add to canvas | `insert_component` |
| `updateNode` | Modify node XML | `create_layout`, `apply_style` |
| `createColorStyle` | Add color style | `sync_tokens` |
| `createTextStyle` | Add text style | `sync_tokens` |
| `getSelection` | Current selection | `get_project_context` |

---

## Implementation Plan

### Phase 1: Foundation
- [ ] Python MCP server skeleton (stdio transport)
- [ ] WebSocket bridge to Framer plugin
- [ ] Basic tool: `get_project_context`
- [ ] Basic tool: `insert_component`

### Phase 2: Component Creation
- [ ] `create_component` with React code
- [ ] Property controls generation
- [ ] Code validation

### Phase 3: Layout Generation
- [ ] `create_layout` from description
- [ ] Layout parser (NL → structure)
- [ ] Style presets

### Phase 4: Full Design
- [ ] `generate_design` orchestration
- [ ] Section decomposition
- [ ] Multi-section coordination

### Phase 5: Token Sync
- [ ] `sync_tokens` with format detection
- [ ] Figma token format support
- [ ] Style Dictionary support
- [ ] Tailwind token support

---

## Configuration

```json
// ~/.config/claude-code/mcp.json
{
    "mcpServers": {
        "framer": {
            "command": "python",
            "args": ["-m", "framer_mcp"],
            "env": {
                "FRAMER_SESSION_SECRET": "<from-plugin>"
            }
        }
    }
}
```

---

## Dependencies

```toml
[project]
name = "framer-mcp"
dependencies = [
    "mcp>=1.0.0",           # Anthropic MCP SDK
    "websockets>=12.0",      # WebSocket client
    "pydantic>=2.0",         # Data validation
]
```

---

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `ConnectionError` | Plugin not open | Prompt user to open Framer MCP plugin |
| `TimeoutError` | 5s limit exceeded | Break into smaller operations |
| `ValidationError` | Invalid React code | Return syntax errors with line numbers |
| `StyleConflict` | Token name collision | Use merge_strategy or rename |

---

## Example Workflow

```
User: Create a pricing section with 3 tiers

Claude:
1. Calls get_project_context() to understand existing styles
2. Calls generate_design() with pricing prompt + project context
3. MCP server:
   - Decomposes into: container frame + 3 pricing cards
   - Creates PricingCard component (create_component)
   - Creates layout (create_layout)
   - Inserts 3 instances with different props (insert_component x3)
4. Returns node IDs and preview
```
