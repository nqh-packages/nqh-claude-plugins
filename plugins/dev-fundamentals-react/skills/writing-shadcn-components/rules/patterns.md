---
paths: **/src/components/**/*.tsx
---

# shadcn/ui Component Patterns

## Component Location

| Type | Location | When |
|------|----------|------|
| Primitives | `packages/hui/src/components/primitives/` | shadcn/ui base |
| Shared | `packages/hui/src/components/` | 3+ apps |
| App-specific | `apps/{app}/src/components/` | 1-2 apps |

## Variants

| Component | Variant | Use |
|-----------|---------|-----|
| Button | Default/Outline/Ghost/Destructive | Primary/Secondary/Tertiary/Delete |
| Badge | Default/Outline | Active/Tags |
| Card | Basic/Interactive | Container/Clickable |
| Alert | Default/Destructive | Info/Error |

## Common Patterns

```tsx
// Input + validation
<div className="relative">
  <Input className="pr-9" />
  <CheckCircle2 className="absolute right-3 top-2.5 h-4 w-4 text-green-600" />
</div>

// Stat card
<Card>
  <CardHeader className="flex flex-row justify-between pb-2">
    <CardTitle className="text-sm">Total</CardTitle>
    <DollarSign className="h-4 w-4 text-muted-foreground" />
  </CardHeader>
  <CardContent>
    <div className="text-2xl font-bold">$45,231</div>
    <p className="text-xs text-muted-foreground">+20.1%</p>
  </CardContent>
</Card>

// Form
<div className="max-w-sm space-y-4">
  <div className="space-y-2">
    <Label>Email</Label>
    <Input />
  </div>
  <Button className="w-full">Submit</Button>
</div>
```
