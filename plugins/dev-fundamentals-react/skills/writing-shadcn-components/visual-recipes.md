# Visual Recipes: Building Common UIs

Step-by-step guides for composing frequently-used UI components with shadcn/ui.

---

## Recipe 1: User Profile Card

**What it creates:** Avatar + name/role + bio + action button

### Step 1: Start with Card wrapper
```tsx
<Card className="w-full max-w-md">
```

**Why this matters:** `max-w-md` (448px) is ideal for profile cards - wide enough for content, narrow enough to feel focused.

---

### Step 2: Add header with Avatar + text stack
```tsx
<CardHeader>
  <div className="flex items-center gap-4">
    <Avatar>
      <AvatarImage src={user.avatar} />
      <AvatarFallback>{user.initials}</AvatarFallback>
    </Avatar>
    <div>
      <CardTitle className="text-base">{user.name}</CardTitle>
      <CardDescription>{user.role}</CardDescription>
    </div>
  </div>
</CardHeader>
```

**Visual details:**
- `flex items-center gap-4`: Horizontal layout with 16px spacing between avatar and text
- `text-base` on CardTitle: Makes name smaller than default (more appropriate for profile cards)
- Avatar handles fallback automatically (shows initials if image fails)

---

### Step 3: Add bio in content
```tsx
<CardContent>
  <p className="text-sm text-muted-foreground">{user.bio}</p>
</CardContent>
```

**Visual hierarchy:** `text-sm text-muted-foreground` makes bio secondary to name/role.

---

### Step 4: Add action button in footer
```tsx
<CardFooter>
  <Button className="w-full">View Profile</Button>
</CardFooter>
</Card>
```

**Result:** Professional user profile card with proper spacing and visual hierarchy.

**Full code:**
```tsx
<Card className="w-full max-w-md">
  <CardHeader>
    <div className="flex items-center gap-4">
      <Avatar>
        <AvatarImage src={user.avatar} />
        <AvatarFallback>{user.initials}</AvatarFallback>
      </Avatar>
      <div>
        <CardTitle className="text-base">{user.name}</CardTitle>
        <CardDescription>{user.role}</CardDescription>
      </div>
    </div>
  </CardHeader>
  <CardContent>
    <p className="text-sm text-muted-foreground">{user.bio}</p>
  </CardContent>
  <CardFooter>
    <Button className="w-full">View Profile</Button>
  </CardFooter>
</Card>
```

---

## Recipe 2: Notification List Item

**What it creates:** Icon + title/message + timestamp + status badge

### Step 1: Create container with hover effect
```tsx
<div className="flex items-start gap-4 rounded-lg border p-4 transition-colors hover:bg-accent">
```

**Why this works:**
- `items-start` aligns items to top (important when text wraps)
- `gap-4` gives breathing room between icon and content
- `hover:bg-accent` shows interactivity

---

### Step 2: Add status icon
```tsx
<div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10">
  <Bell className="h-5 w-5 text-primary" />
</div>
```

**Visual pattern:**
- Fixed size container (`h-10 w-10`) prevents layout shift
- `bg-primary/10` creates subtle colored circle
- Icon sized at `h-5 w-5` for proper proportion

---

### Step 3: Add content stack (title + message + time)
```tsx
<div className="flex-1 space-y-1">
  <div className="flex items-center justify-between">
    <p className="font-medium">New message from Sarah</p>
    <Badge variant="default">New</Badge>
  </div>
  <p className="text-sm text-muted-foreground">
    Hey! I wanted to follow up on our conversation...
  </p>
  <p className="text-xs text-muted-foreground">2 minutes ago</p>
</div>
```

**Visual hierarchy:**
- `flex-1` makes content take remaining space
- `space-y-1` tightly groups related text
- `justify-between` pushes badge to right
- Font sizes decrease: `font-medium` → `text-sm` → `text-xs`

---

### Step 4: Close the container
```tsx
</div>
```

**Result:** Interactive notification item with proper alignment and visual feedback.

**Full code:**
```tsx
<div className="flex items-start gap-4 rounded-lg border p-4 transition-colors hover:bg-accent">
  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10">
    <Bell className="h-5 w-5 text-primary" />
  </div>
  <div className="flex-1 space-y-1">
    <div className="flex items-center justify-between">
      <p className="font-medium">New message from Sarah</p>
      <Badge variant="default">New</Badge>
    </div>
    <p className="text-sm text-muted-foreground">
      Hey! I wanted to follow up on our conversation...
    </p>
    <p className="text-xs text-muted-foreground">2 minutes ago</p>
  </div>
</div>
```

---

## Recipe 3: Stat Dashboard Card

**What it creates:** Metric card with label, value, change indicator, and icon

### Step 1: Start with Card
```tsx
<Card>
```

---

### Step 2: Create header with icon in top-right
```tsx
<CardHeader className="flex flex-row items-center justify-between pb-2">
  <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
  <DollarSign className="h-4 w-4 text-muted-foreground" />
</CardHeader>
```

**Visual pattern:**
- `flex-row items-center justify-between`: Horizontal layout with title left, icon right
- `pb-2`: Reduced bottom padding for tighter spacing
- `text-sm font-medium` on title: Smaller, understated label
- Icon uses `text-muted-foreground` for subtlety

---

### Step 3: Add main stat value
```tsx
<CardContent>
  <div className="text-2xl font-bold">$45,231.89</div>
```

**Why `text-2xl font-bold`:** Large, bold text creates focal point - this is what user should see first.

---

### Step 4: Add change indicator with color coding
```tsx
  <p className="text-xs text-muted-foreground">
    <span className="text-green-600">↑ 20.1%</span> from last month
  </p>
</CardContent>
</Card>
```

**Visual hierarchy:**
- `text-xs text-muted-foreground`: Small, secondary text
- Inline `span` with `text-green-600` highlights the change percentage
- Arrow symbol (↑/↓) provides visual direction

---

**Result:** Professional stat card with clear visual hierarchy.

**Full code:**
```tsx
<Card>
  <CardHeader className="flex flex-row items-center justify-between pb-2">
    <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
    <DollarSign className="h-4 w-4 text-muted-foreground" />
  </CardHeader>
  <CardContent>
    <div className="text-2xl font-bold">$45,231.89</div>
    <p className="text-xs text-muted-foreground">
      <span className="text-green-600">↑ 20.1%</span> from last month
    </p>
  </CardContent>
</Card>
```

**Variations:**
- Red for negative: `text-red-600` with ↓ arrow
- Orange for warning: `text-orange-600` with ⚠ symbol
- Multiple stats: Wrap in `grid grid-cols-2 gap-4`

---

## Recipe 4: Login Form with Social Auth

**What it creates:** Email/password form → divider → social login button → signup link

### Step 1: Container with width constraint
```tsx
<div className="w-full max-w-sm">
```

**Why `max-w-sm` (384px):** Standard width for login forms - wide enough for comfortable typing, narrow enough to feel focused.

---

### Step 2: Credential fields
```tsx
<div className="space-y-4">
  <div className="space-y-2">
    <Label htmlFor="email">Email</Label>
    <Input id="email" placeholder="you@example.com" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="password">Password</Label>
    <Input id="password" type="password" />
  </div>
  <Button className="w-full">Sign In</Button>
</div>
```

**Spacing logic:**
- `space-y-4`: Between field groups (email group, password group, button)
- `space-y-2`: Within each field group (label + input)
- `w-full` on button: Full-width buttons are standard for forms

---

### Step 3: Visual divider with text
```tsx
<div className="mt-4 flex items-center">
  <Separator className="flex-1" />
  <p className="mx-4 text-sm text-muted-foreground">OR</p>
  <Separator className="flex-1" />
</div>
```

**Visual pattern:**
- `flex-1` on separators: Makes them stretch to fill space
- `mx-4` on text: Creates balanced spacing around "OR"
- `text-sm text-muted-foreground`: Makes divider text secondary

---

### Step 4: Social auth button
```tsx
<Button className="mt-4 w-full" variant="outline">
  Sign in with Google
</Button>
```

**Why `variant="outline"`:** Visual hierarchy - primary action is "Sign In", social is secondary.

---

### Step 5: Helper link
```tsx
<p className="mt-4 text-center text-sm text-muted-foreground">
  Don't have an account?{" "}
  <a href="#" className="font-medium text-primary">
    Sign up
  </a>
</p>
</div>
```

**Result:** Complete login form with clear visual flow.

**Full code:**
```tsx
<div className="w-full max-w-sm">
  <div className="space-y-4">
    <div className="space-y-2">
      <Label htmlFor="email">Email</Label>
      <Input id="email" placeholder="you@example.com" />
    </div>
    <div className="space-y-2">
      <Label htmlFor="password">Password</Label>
      <Input id="password" type="password" />
    </div>
    <Button className="w-full">Sign In</Button>
  </div>

  <div className="mt-4 flex items-center">
    <Separator className="flex-1" />
    <p className="mx-4 text-sm text-muted-foreground">OR</p>
    <Separator className="flex-1" />
  </div>

  <Button className="mt-4 w-full" variant="outline">
    Sign in with Google
  </Button>

  <p className="mt-4 text-center text-sm text-muted-foreground">
    Don't have an account?{" "}
    <a href="#" className="font-medium text-primary">
      Sign up
    </a>
  </p>
</div>
```

---

## Recipe 5: Settings Panel with Sections

**What it creates:** Multi-section settings form with headers, descriptions, and fields

### Step 1: Container with appropriate width
```tsx
<div className="w-full max-w-2xl space-y-8">
```

**Why `max-w-2xl` (672px):** Settings forms need more width than login forms - accommodates longer descriptions and side-by-side fields.

---

### Step 2: Section header
```tsx
<div>
  <h2 className="text-2xl font-bold">Profile</h2>
  <p className="text-muted-foreground">
    This is how others will see you on the site.
  </p>
  <Separator className="my-6" />
```

**Visual structure:**
- `text-2xl font-bold`: Clear section heading
- `text-muted-foreground` on description: Secondary explanatory text
- `my-6` on separator: Strong visual break (24px top/bottom)

---

### Step 3: Form fields with descriptions
```tsx
  <div className="space-y-8">
    <div className="space-y-2">
      <Label>Username</Label>
      <Input placeholder="shadcn" />
      <p className="text-sm text-muted-foreground">
        This is your public display name.
      </p>
    </div>

    <div className="space-y-2">
      <Label>Bio</Label>
      <Textarea
        placeholder="Tell us a little bit about yourself"
        className="resize-none"
      />
      <p className="text-sm text-muted-foreground">
        You can @mention other users and organizations.
      </p>
    </div>
  </div>
```

**Spacing hierarchy:**
- `space-y-8` between field groups: Shows fields are separate concerns
- `space-y-2` within each group: Keeps label, input, description together
- `resize-none` on Textarea: Prevents layout breakage

---

### Step 4: Action button
```tsx
  <Button className="mt-8">Update profile</Button>
</div>
</div>
```

**Why `mt-8`:** Separates submit button from fields - makes it feel like a distinct action.

---

**Result:** Professional settings panel with clear sections and descriptions.

**Full code:**
```tsx
<div className="w-full max-w-2xl space-y-8">
  <div>
    <h2 className="text-2xl font-bold">Profile</h2>
    <p className="text-muted-foreground">
      This is how others will see you on the site.
    </p>
    <Separator className="my-6" />

    <div className="space-y-8">
      <div className="space-y-2">
        <Label>Username</Label>
        <Input placeholder="shadcn" />
        <p className="text-sm text-muted-foreground">
          This is your public display name.
        </p>
      </div>

      <div className="space-y-2">
        <Label>Bio</Label>
        <Textarea
          placeholder="Tell us a little bit about yourself"
          className="resize-none"
        />
        <p className="text-sm text-muted-foreground">
          You can @mention other users and organizations.
        </p>
      </div>
    </div>

    <Button className="mt-8">Update profile</Button>
  </div>
</div>
```

**Add more sections:** Repeat the section pattern (header → separator → fields → button).

---

## Recipe 6: Data Table with Actions

**What it creates:** Table with name, status badges, and action dropdown per row

### Step 1: Table structure
```tsx
<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Name</TableHead>
      <TableHead>Status</TableHead>
      <TableHead className="text-right">Actions</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
```

**Visual pattern:** `text-right` on actions column aligns dropdowns to the right edge.

---

### Step 2: Row with badge
```tsx
{users.map((user) => (
  <TableRow key={user.id}>
    <TableCell className="font-medium">{user.name}</TableCell>
    <TableCell>
      <Badge variant={user.isActive ? 'default' : 'secondary'}>
        {user.isActive ? 'Active' : 'Inactive'}
      </Badge>
    </TableCell>
```

**Visual hierarchy:**
- `font-medium` on first column: Makes names stand out (primary identifier)
- Dynamic badge variant: Visual coding of status

---

### Step 3: Action dropdown
```tsx
    <TableCell className="text-right">
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon">
            <MoreVertical className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuItem>
            <Edit className="mr-2 h-4 w-4" />
            Edit
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem className="text-destructive">
            <Trash className="mr-2 h-4 w-4" />
            Delete
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </TableCell>
  </TableRow>
))}
  </TableBody>
</Table>
```

**Visual pattern:**
- `align="end"` on dropdown: Aligns menu to right edge of trigger
- Separator before destructive action: Visual warning
- `text-destructive` on delete: Color codes dangerous action

---

**Result:** Clean data table with status indicators and row actions.

**Full code:**
```tsx
<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Name</TableHead>
      <TableHead>Status</TableHead>
      <TableHead className="text-right">Actions</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    {users.map((user) => (
      <TableRow key={user.id}>
        <TableCell className="font-medium">{user.name}</TableCell>
        <TableCell>
          <Badge variant={user.isActive ? 'default' : 'secondary'}>
            {user.isActive ? 'Active' : 'Inactive'}
          </Badge>
        </TableCell>
        <TableCell className="text-right">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreVertical className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem>
                <Edit className="mr-2 h-4 w-4" />
                Edit
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem className="text-destructive">
                <Trash className="mr-2 h-4 w-4" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

---

## Recipe 7: Search Interface with Filters

**What it creates:** Search input + filter dropdown + results grid

### Step 1: Search bar with icon
```tsx
<div className="space-y-6">
  <div className="relative">
    <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
    <Input className="pl-9" placeholder="Search projects..." />
  </div>
```

**Visual pattern:**
- Icon at `left-3 top-2.5`: Standard position for left icons
- `pl-9` on input: Makes room for icon (36px)

---

### Step 2: Filter controls
```tsx
  <div className="flex items-center justify-between">
    <div className="flex gap-2">
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="outline" className="gap-2">
            <Filter className="h-4 w-4" />
            Status
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuItem>All</DropdownMenuItem>
          <DropdownMenuItem>Active</DropdownMenuItem>
          <DropdownMenuItem>Completed</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
    <p className="text-sm text-muted-foreground">
      {results.length} results
    </p>
  </div>
```

**Layout logic:**
- `justify-between`: Spreads filters (left) and count (right)
- `gap-2` between filter buttons
- Count uses `text-sm text-muted-foreground`

---

### Step 3: Results grid
```tsx
  <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
    {results.map((item) => (
      <Card key={item.id} className="cursor-pointer transition-colors hover:bg-accent">
        <CardHeader>
          <CardTitle>{item.name}</CardTitle>
          <CardDescription>{item.description}</CardDescription>
        </CardHeader>
        <CardContent>
          <Badge variant="outline">{item.category}</Badge>
        </CardContent>
      </Card>
    ))}
  </div>
</div>
```

**Responsive grid:**
- Default: 1 column (mobile)
- `md:grid-cols-2`: 2 columns on tablet
- `lg:grid-cols-3`: 3 columns on desktop
- `gap-4`: Consistent spacing between cards

---

**Result:** Complete search interface with filters and responsive results.

**Full code:**
```tsx
<div className="space-y-6">
  <div className="relative">
    <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
    <Input className="pl-9" placeholder="Search projects..." />
  </div>

  <div className="flex items-center justify-between">
    <div className="flex gap-2">
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="outline" className="gap-2">
            <Filter className="h-4 w-4" />
            Status
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuItem>All</DropdownMenuItem>
          <DropdownMenuItem>Active</DropdownMenuItem>
          <DropdownMenuItem>Completed</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
    <p className="text-sm text-muted-foreground">
      {results.length} results
    </p>
  </div>

  <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
    {results.map((item) => (
      <Card key={item.id} className="cursor-pointer transition-colors hover:bg-accent">
        <CardHeader>
          <CardTitle>{item.name}</CardTitle>
          <CardDescription>{item.description}</CardDescription>
        </CardHeader>
        <CardContent>
          <Badge variant="outline">{item.category}</Badge>
        </CardContent>
      </Card>
    ))}
  </div>
</div>
```

---

## Common Visual Patterns Across Recipes

### Spacing Consistency
- **Between sections**: `space-y-8` or `gap-8` (32px)
- **Between groups**: `space-y-4` or `gap-4` (16px)
- **Within groups**: `space-y-2` or `gap-2` (8px)

### Text Hierarchy
- **Primary**: `font-bold` or `font-medium`
- **Secondary**: `text-muted-foreground`
- **Captions**: `text-sm text-muted-foreground`

### Layout Patterns
- **Horizontal flex**: `flex items-center gap-4`
- **Vertical stack**: `flex flex-col space-y-2`
- **Space between**: `flex justify-between items-center`

### Width Constraints
- **Login forms**: `max-w-sm` (384px)
- **Settings**: `max-w-2xl` (672px)
- **Cards**: `max-w-md` (448px)

These patterns create consistency across your application and match user expectations from modern web UIs.
