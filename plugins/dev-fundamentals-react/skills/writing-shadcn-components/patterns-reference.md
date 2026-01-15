# shadcn/ui Pattern Reference

Comprehensive catalog of visual composition patterns extracted from 1,436 production examples.

**How to use this reference:**
- Ctrl+F to search for specific patterns (e.g., "validation", "hover", "badge")
- Patterns organized by UI type (forms, cards, navigation, etc.)
- Each pattern shows JSX structure + visual measurements + when to use

---

## 1. FORM LAYOUTS & VISUAL HIERARCHY

### Login Form with Visual Divider

**What it looks like**: Classic auth form with credential fields → separator → social login buttons

```tsx
<div className="w-full max-w-sm">
  {/* Credential Section */}
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

  {/* Visual Divider */}
  <div className="mt-4 flex items-center">
    <Separator className="flex-1" />
    <p className="mx-4 text-sm text-muted-foreground">OR</p>
    <Separator className="flex-1" />
  </div>

  {/* Social Auth */}
  <Button className="mt-4 w-full" variant="outline">
    Sign in with Google
  </Button>

  {/* Helper Link */}
  <p className="mt-4 text-center text-sm text-muted-foreground">
    Don't have an account?{" "}
    <a href="#" className="font-medium text-primary">
      Sign up
    </a>
  </p>
</div>
```

**Visual Elements**:
- `max-w-sm` constrains form to 384px
- `space-y-4` between field groups, `space-y-2` within groups
- Separator + text creates clear section break
- Helper text uses `text-muted-foreground` for hierarchy
- Inline link gets `text-primary` for affordance

**Variations**:
- Replace social button with multiple providers in horizontal stack
- Add "Forgot password?" link aligned right
- Include terms checkbox before submit button

---

### Settings Form with Section Headers

**What it looks like**: Long form broken into sections with header → separator → fields pattern

```tsx
<div className="w-full max-w-2xl space-y-8">
  {/* Profile Section */}
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

**Visual Hierarchy**:
- `max-w-2xl` (672px) allows more breathing room
- `Separator` with `my-6` creates strong visual break
- `space-y-8` between field groups shows stronger relationship
- Description text: `text-sm text-muted-foreground`
- Submit button separated with `mt-8`

**When to use**: Settings pages, profile editors, multi-section forms

---

### Multi-Step Form Progress Indicators

**Pattern 1: Numeric Steps with Lines**

```tsx
<div className="mb-6 flex items-center">
  <div className={cn(
    "flex size-8 items-center justify-center rounded-full",
    step >= 1 ? "bg-primary text-primary-foreground" : "bg-muted"
  )}>
    1
  </div>
  <div className="flex-1 border-t-2 border-muted" />
  <div className={cn(
    "flex size-8 items-center justify-center rounded-full",
    step >= 2 ? "bg-primary text-primary-foreground" : "bg-muted"
  )}>
    2
  </div>
  <div className="flex-1 border-t-2 border-muted" />
  <div className={cn(
    "flex size-8 items-center justify-center rounded-full",
    step >= 3 ? "bg-primary text-primary-foreground" : "bg-muted"
  )}>
    3
  </div>
</div>
```

**Pattern 2: Segmented Progress Bar**

```tsx
<div className="mb-6 flex gap-1">
  <div className={cn(
    "h-2 flex-1 rounded-l-full",
    step >= 1 ? "bg-primary" : "bg-muted"
  )} />
  <div className={cn(
    "h-2 flex-1",
    step >= 2 ? "bg-primary" : "bg-muted"
  )} />
  <div className={cn(
    "h-2 flex-1 rounded-r-full",
    step >= 3 ? "bg-primary" : "bg-muted"
  )} />
</div>
```

**Pattern 3: Step Labels with Background Fill**

```tsx
<div className="mb-6 flex">
  <div className={cn(
    "flex h-10 flex-1 items-center justify-center rounded-l-md",
    step >= 1 ? "bg-primary text-primary-foreground" : "bg-muted"
  )}>
    Shipping
  </div>
  <div className={cn(
    "flex h-10 flex-1 items-center justify-center rounded-r-md",
    step >= 2 ? "bg-primary text-primary-foreground" : "bg-muted"
  )}>
    Payment
  </div>
</div>
```

**Visual Decision Making**:
- **Numeric circles**: Best for 3-5 steps, shows clear progression
- **Segmented bar**: Best for 2-3 steps, minimalist look
- **Labeled boxes**: Best for 2-4 steps with short labels

---

### Grid Layout for Related Fields

**What it looks like**: Two-column layout for name/email, full-width for long content

```tsx
<div className="space-y-6">
  {/* Two-Column Row */}
  <div className="grid grid-cols-2 gap-6">
    <div className="space-y-2">
      <Label>Name</Label>
      <Input placeholder="Your Name" />
    </div>
    <div className="space-y-2">
      <Label>Email</Label>
      <Input placeholder="your.email@example.com" />
    </div>
  </div>

  {/* Full-Width Field */}
  <div className="space-y-2">
    <Label>Subject</Label>
    <Input placeholder="Subject of your message" />
  </div>

  {/* Full-Width Textarea */}
  <div className="space-y-2">
    <Label>Message</Label>
    <Textarea placeholder="Your message..." className="resize-none" />
  </div>

  <Button>Send Message</Button>
</div>
```

**Composition Rule**:
- Short, related fields → `grid grid-cols-2 gap-6`
- Long content (subject, message) → full-width
- `resize-none` prevents layout breakage

---

## 2. INPUT VISUAL PATTERNS

### Input with Icon

**Left Icon** (common for email, search):

```tsx
<div className="relative">
  <Mail className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
  <Input className="pl-9" placeholder="you@example.com" />
</div>
```

**Right Icon** (common for validation state):

```tsx
<div className="relative">
  <Input className="pr-9" placeholder="Email" />
  <CheckCircle2 className="absolute right-3 top-2.5 h-4 w-4 text-green-600" />
</div>
```

**Key Measurements**:
- Icon position: `left-3 top-2.5` (12px, 10px)
- Icon size: `h-4 w-4` (16px)
- Input padding: `pl-9` (36px) when icon left, `pr-9` when icon right
- Icon color: `text-muted-foreground` for passive, semantic color for active

---

### Validation State Visual Coding

**Error State**:

```tsx
<div className="space-y-2">
  <Label>Email</Label>
  <div className="relative">
    <Input className="border-destructive" placeholder="you@example.com" />
    <AlertCircle className="absolute right-3 top-2.5 h-4 w-4 text-destructive" />
  </div>
  <p className="text-sm text-destructive">Invalid email address</p>
</div>
```

**Success State**:

```tsx
<div className="relative">
  <Input className="border-green-600" />
  <CheckCircle2 className="absolute right-3 top-2.5 h-4 w-4 text-green-600" />
</div>
```

**Warning State**:

```tsx
<div className="relative">
  <Input className="border-orange-600" />
  <AlertTriangle className="absolute right-3 top-2.5 h-4 w-4 text-orange-600" />
</div>
<p className="text-sm text-orange-600">Weak password</p>
```

**Visual Hierarchy**:
- Border color = Icon color = Message color (consistency)
- Success often omits message (visual confirmation sufficient)
- Error/warning always show message

---

### Input Group Patterns

**Currency Input**:

```tsx
<div className="flex items-center rounded-md border focus-within:ring-2">
  <span className="px-3 text-sm text-muted-foreground">$</span>
  <Input className="border-0 focus-visible:ring-0" placeholder="0.00" />
  <span className="px-3 text-sm text-muted-foreground">USD</span>
</div>
```

**Search with Button**:

```tsx
<div className="flex items-center rounded-md border focus-within:ring-2">
  <Input className="border-0 focus-visible:ring-0" placeholder="Search..." />
  <Button variant="ghost" size="icon" className="rounded-l-none">
    <Search className="h-4 w-4" />
  </Button>
</div>
```

**URL Input with Protocol**:

```tsx
<div className="flex items-center rounded-md border focus-within:ring-2">
  <span className="px-3 text-sm text-muted-foreground">https://</span>
  <Input className="border-0 focus-visible:ring-0" placeholder="example.com" />
</div>
```

**Visual Trick**:
- Outer `div` gets border and focus ring
- Inner `Input` has `border-0 focus-visible:ring-0` to prevent double borders

---

### Password Visibility Toggle

```tsx
<div className="relative">
  <Input
    type={showPassword ? "text" : "password"}
    className="pr-10"
  />
  <button
    type="button"
    onClick={() => setShowPassword(!showPassword)}
    className="absolute right-3 top-2.5"
  >
    {showPassword ? (
      <EyeOff className="h-4 w-4 text-muted-foreground" />
    ) : (
      <Eye className="h-4 w-4 text-muted-foreground" />
    )}
  </button>
</div>
```

**Visual Elements**:
- `pr-10` prevents text from overlapping button
- Icon swaps on toggle (Eye ↔ EyeOff)
- `text-muted-foreground` for passive appearance
- Button positioned like validation icon

---

### Real-Time Validation Checklist

**What it looks like**: Password requirements that check off as user types

```tsx
<div className="space-y-2">
  <Label>Password</Label>
  <Input type="password" value={password} />

  <div className="space-y-1 text-sm">
    <div className={cn(
      "flex items-center gap-2",
      password.length >= 8 ? "text-green-600" : "text-muted-foreground"
    )}>
      {password.length >= 8 ? (
        <CheckCircle2 className="h-4 w-4" />
      ) : (
        <Circle className="h-4 w-4" />
      )}
      <span>At least 8 characters</span>
    </div>

    <div className={cn(
      "flex items-center gap-2",
      /[A-Z]/.test(password) ? "text-green-600" : "text-muted-foreground"
    )}>
      {/[A-Z]/.test(password) ? (
        <CheckCircle2 className="h-4 w-4" />
      ) : (
        <Circle className="h-4 w-4" />
      )}
      <span>One uppercase letter</span>
    </div>
  </div>
</div>
```

**Visual Transition**:
- Unmet: `Circle` icon + `text-muted-foreground`
- Met: `CheckCircle2` icon + `text-green-600`
- Progressive disclosure as user types

---

## 3. BUTTON COMPOSITION PATTERNS

### Button with Icons

**Left Icon** (action initiator):

```tsx
<Button className="gap-2">
  <Mail className="h-4 w-4" />
  Send Email
</Button>
```

**Right Icon** (direction/continuation):

```tsx
<Button className="gap-2">
  Continue
  <ArrowRight className="h-4 w-4" />
</Button>
```

**Icon Only**:

```tsx
<Button size="icon">
  <Settings className="h-4 w-4" />
  <span className="sr-only">Open settings</span>
</Button>
```

**Sizing Consistency**:
- `gap-2` for text-icon spacing
- `h-4 w-4` standardizes all button icons
- `size="icon"` for square/circular icon-only buttons
- `sr-only` for accessibility on icon-only

---

### Button with Badge

**Notification Button**:

```tsx
<Button variant="outline" className="gap-2">
  <Bell className="h-4 w-4" />
  Notifications
  <Badge variant="destructive" className="ml-auto">3</Badge>
</Button>
```

**Alternative - Inline Count**:

```tsx
<Button variant="ghost" className="gap-2">
  Messages
  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary text-xs text-primary-foreground">
    12
  </span>
</Button>
```

**Visual Trick**:
- Badge uses semantic color (destructive for urgency)
- `ml-auto` pushes badge to far right
- Circular count: `h-5 w-5` with `flex items-center justify-center`

---

### Button with Keyboard Shortcut

```tsx
<Button variant="outline" className="justify-between gap-4">
  <span className="flex items-center gap-2">
    <Save className="h-4 w-4" />
    Save
  </span>
  <kbd className="pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground">
    ⌘S
  </kbd>
</Button>
```

**Visual Hierarchy**:
- `justify-between` spreads content
- `gap-4` between action and shortcut
- `kbd` element styled as keyboard key
- Action (left) vs shortcut (right) creates clear visual balance

---

### Button Groups

**Horizontal Group** (toolbar style):

```tsx
<div className="inline-flex rounded-md shadow-sm" role="group">
  <Button variant="outline" className="rounded-r-none">
    <AlignLeft className="h-4 w-4" />
  </Button>
  <Button variant="outline" className="rounded-none border-l-0">
    <AlignCenter className="h-4 w-4" />
  </Button>
  <Button variant="outline" className="rounded-l-none border-l-0">
    <AlignRight className="h-4 w-4" />
  </Button>
</div>
```

**Vertical Group**:

```tsx
<div className="inline-flex flex-col">
  <Button variant="outline" className="rounded-b-none">Edit</Button>
  <Button variant="outline" className="rounded-none border-t-0">Duplicate</Button>
  <Button variant="destructive" className="rounded-t-none border-t-0">Delete</Button>
</div>
```

**Visual Technique**:
- Remove rounded corners on adjacent sides
- Remove border on touching edges (`border-l-0`, `border-t-0`)
- Last button can have different variant

---

### Loading State Button

```tsx
<Button disabled={loading}>
  {loading ? (
    <>
      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
      Please wait...
    </>
  ) : (
    'Submit'
  )}
</Button>
```

**Visual States**:
- `Loader2` with `animate-spin` shows activity
- `mr-2` spaces icon from text
- Text changes to indicate wait state
- `disabled` reduces opacity automatically

---

## 4. CHECKBOX & SELECTION PATTERNS

### Checkbox with Multi-Line Label

```tsx
<div className="flex items-start space-x-2">
  <Checkbox id="marketing" className="mt-1" />
  <div className="space-y-1">
    <Label htmlFor="marketing" className="cursor-pointer">
      Marketing emails
    </Label>
    <p className="text-sm text-muted-foreground">
      Receive emails about new products, features, and updates.
    </p>
  </div>
</div>
```

**Visual Alignment**:
- `items-start` aligns checkbox to top
- `mt-1` on checkbox centers it with label baseline
- `space-y-1` between label and description
- Description: `text-sm text-muted-foreground`

---

### Horizontal Checkbox List

```tsx
<div className="flex flex-wrap gap-4">
  {['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) => (
    <div key={day} className="flex items-center space-x-2">
      <Checkbox id={day} />
      <Label htmlFor={day} className="cursor-pointer">{day}</Label>
    </div>
  ))}
</div>
```

**When to use**: Day selection, feature toggles, filter options (5-7 items max)

---

### Right-Aligned Checkbox (Settings Style)

```tsx
<div className="space-y-3">
  {settings.map((setting) => (
    <div key={setting.id} className="flex items-center justify-between rounded-md border p-4">
      <Label htmlFor={setting.id}>{setting.label}</Label>
      <Checkbox id={setting.id} />
    </div>
  ))}
</div>
```

**Visual Pattern**:
- `justify-between` pushes elements apart
- `rounded-md border p-4` creates tappable area
- Good for: notification settings, mobile-style toggles

---

### Nested Checkbox (Parent-Child)

```tsx
<div className="space-y-3">
  <div className="flex items-center space-x-2">
    <Checkbox
      id="select-all"
      checked={allChecked ? true : someChecked ? 'indeterminate' : false}
    />
    <Label htmlFor="select-all" className="font-semibold">
      Select all features
    </Label>
  </div>

  <div className="ml-6 space-y-2">
    <div className="flex items-center space-x-2">
      <Checkbox id="analytics" />
      <Label htmlFor="analytics">Analytics dashboard</Label>
    </div>
    <div className="flex items-center space-x-2">
      <Checkbox id="reporting" />
      <Label htmlFor="reporting">Advanced reporting</Label>
    </div>
  </div>
</div>
```

**Visual Hierarchy**:
- Parent uses `font-semibold` for visual weight
- `ml-6` indents children to show hierarchy
- `checked='indeterminate'` shows partial selection (mixed state)

---

## 5. BADGE COMPOSITION PATTERNS

### Badge Variants by Use Case

**Status Indicators**:

```tsx
<Badge variant="default">Active</Badge>
<Badge variant="secondary">Pending</Badge>
<Badge variant="destructive">Failed</Badge>
<Badge variant="outline">Draft</Badge>
```

**With Icons (Left)**:

```tsx
<Badge variant="secondary">
  <Star className="mr-1 size-3" />
  Featured
</Badge>
```

**With Icons (Right)**:

```tsx
<Badge variant="default">
  New
  <Sparkles className="ml-1 size-3" />
</Badge>
```

**Visual Hierarchy**:
- `default`: Highest importance (new items, active status)
- `destructive`: Errors, critical status
- `secondary`: Neutral states, less urgent
- `outline`: Minimal emphasis, tags

---

### Circular Count Badges

**High Priority** (notification dot):

```tsx
<div className="relative">
  <Bell className="h-6 w-6" />
  <Badge
    variant="destructive"
    className="absolute -right-1 -top-1 flex size-5 items-center justify-center rounded-full p-0"
  >
    3
  </Badge>
</div>
```

**Neutral Count**:

```tsx
<Badge
  variant="secondary"
  className="flex size-6 items-center justify-center rounded-full p-0"
>
  12
</Badge>
```

**Sizing**:
- `size-5` (20px) for small notification dots
- `size-6` (24px) for standalone counts
- `p-0` removes default padding
- `flex items-center justify-center` centers number

---

### Badge with Link

```tsx
<div className="flex flex-wrap gap-2">
  {categories.map((cat) => (
    <Badge variant="outline" key={cat.slug}>
      <a href={`/categories/${cat.slug}`} className="hover:underline">
        {cat.name}
      </a>
    </Badge>
  ))}
</div>
```

**Visual Elements**:
- Badge acts as visual container
- Link inside for semantic HTML
- `hover:underline` shows interactivity
- `outline` variant for lower visual weight in lists

---

### Removable Tag Badge

```tsx
<div className="flex flex-wrap gap-2">
  {tags.map((tag, index) => (
    <Badge variant="secondary" key={index} className="gap-1.5">
      {tag}
      <button
        type="button"
        onClick={() => removeTag(index)}
        className="rounded-sm hover:bg-secondary-foreground/20"
      >
        <X className="h-3 w-3" />
      </button>
    </Badge>
  ))}
</div>
```

**Visual Details**:
- `gap-1.5` between text and close button
- Button has hover state for affordance
- `X` icon sized at `h-3 w-3` for proportion

---

### Badge Color Coding System

```tsx
{/* Build Status */}
{status === 'success' && (
  <Badge variant="default">
    <CheckCircle2 className="mr-1 size-3" />
    Build Passed
  </Badge>
)}

{status === 'failed' && (
  <Badge variant="destructive">
    <XCircle className="mr-1 size-3" />
    Build Failed
  </Badge>
)}

{status === 'pending' && (
  <Badge variant="secondary">
    <Clock className="mr-1 size-3" />
    In Progress
  </Badge>
)}

{/* User Presence */}
<Badge variant="outline" className="gap-1.5">
  {user.name}
  {user.isOnline && (
    <span className="size-2 rounded-full bg-green-500" />
  )}
</Badge>
```

**Composition Rule**:
- Icon + color = redundant encoding (accessibility)
- Online dot: direct color (`bg-green-500`)
- Consistent icon sizing (`mr-1 size-3`)

---

## 6. CARD COMPOSITION PATTERNS

### Basic Card Structure

```tsx
<Card className="w-full max-w-md">
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
    <CardDescription>Card description or subtitle</CardDescription>
  </CardHeader>
  <CardContent>
    <p>Main content goes here.</p>
  </CardContent>
  <CardFooter className="flex justify-between">
    <Button variant="outline">Cancel</Button>
    <Button>Confirm</Button>
  </CardFooter>
</Card>
```

**Anatomy**:
- `CardHeader` groups title and description
- `CardDescription` uses muted color automatically
- `CardContent` has consistent padding
- `CardFooter` often uses `flex justify-between`

---

### Stat Card with Icon

```tsx
<Card>
  <CardHeader className="flex flex-row items-center justify-between pb-2">
    <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
    <DollarSign className="h-4 w-4 text-muted-foreground" />
  </CardHeader>
  <CardContent>
    <div className="text-2xl font-bold">$45,231.89</div>
    <p className="text-xs text-muted-foreground">
      +20.1% from last month
    </p>
  </CardContent>
</Card>
```

**Visual Hierarchy**:
- Header: `flex-row items-center justify-between` for icon placement
- Icon: `text-muted-foreground` for subtlety
- Main stat: `text-2xl font-bold`
- Change indicator: `text-xs text-muted-foreground`

---

### Card with Avatar

```tsx
<Card>
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
</Card>
```

**Visual Layout**:
- `flex items-center gap-4` aligns avatar and text
- `text-base` on title (smaller than default CardTitle)
- Avatar component handles fallback initials

---

### Interactive Card (Hover Effect)

```tsx
<Card className="cursor-pointer transition-colors hover:bg-accent">
  <CardHeader>
    <CardTitle>Project Name</CardTitle>
    <CardDescription>Last updated 2 hours ago</CardDescription>
  </CardHeader>
  <CardContent>
    <div className="flex items-center gap-2">
      <Badge variant="outline">In Progress</Badge>
      <Badge variant="secondary">3 tasks</Badge>
    </div>
  </CardContent>
</Card>
```

**Visual Affordance**:
- `cursor-pointer` shows interactivity
- `transition-colors hover:bg-accent` subtle background change
- Badges provide metadata at a glance
- No footer when entire card is clickable

---

## 7. NAVIGATION & TAB PATTERNS

### Horizontal Tabs

```tsx
<Tabs defaultValue="overview" className="w-full">
  <TabsList className="grid w-full grid-cols-3">
    <TabsTrigger value="overview">Overview</TabsTrigger>
    <TabsTrigger value="analytics">Analytics</TabsTrigger>
    <TabsTrigger value="reports">Reports</TabsTrigger>
  </TabsList>
  <TabsContent value="overview">
    <Card>
      <CardHeader>
        <CardTitle>Overview</CardTitle>
      </CardHeader>
      <CardContent>
        {/* Content */}
      </CardContent>
    </Card>
  </TabsContent>
</Tabs>
```

**Visual Layout**:
- `grid grid-cols-3` evenly distributes tabs
- Each `TabsContent` often wrapped in `Card`
- Consistent structure across all tabs

---

### Tabs with Icons and Badges

```tsx
<TabsList>
  <TabsTrigger value="inbox" className="gap-2">
    <Inbox className="h-4 w-4" />
    Inbox
    <Badge variant="destructive" className="ml-auto">12</Badge>
  </TabsTrigger>
  <TabsTrigger value="sent" className="gap-2">
    <Send className="h-4 w-4" />
    Sent
  </TabsTrigger>
</TabsList>
```

**Visual Elements**:
- `gap-2` spaces icon, text, and badge
- `ml-auto` pushes badge to far right
- Badge color indicates urgency

---

### Vertical Tabs (Sidebar Style)

```tsx
<div className="flex">
  <TabsList className="flex-col h-auto space-y-1 p-2">
    <TabsTrigger value="account" className="justify-start">
      Account
    </TabsTrigger>
    <TabsTrigger value="security" className="justify-start">
      Security
    </TabsTrigger>
  </TabsList>

  <div className="flex-1 p-6">
    <TabsContent value="account">
      {/* Account settings */}
    </TabsContent>
  </div>
</div>
```

**Visual Layout**:
- `flex-col` changes tab orientation
- `justify-start` left-aligns tab text
- Content area gets `flex-1` to fill space

---

## 8. DROPDOWN & MENU PATTERNS

### Action Menu (Context Menu)

```tsx
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
    <DropdownMenuItem>
      <Copy className="mr-2 h-4 w-4" />
      Duplicate
    </DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem className="text-destructive">
      <Trash className="mr-2 h-4 w-4" />
      Delete
    </DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

**Visual Pattern**:
- Trigger: `MoreVertical` in ghost button
- `align="end"` for right alignment
- Icons: `mr-2 h-4 w-4` standard spacing
- Separator before destructive action
- `text-destructive` for delete option

---

### Profile Menu

```tsx
<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="ghost" className="relative h-10 w-10 rounded-full">
      <Avatar>
        <AvatarImage src={user.avatar} />
        <AvatarFallback>{user.initials}</AvatarFallback>
      </Avatar>
    </Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent align="end" className="w-56">
    <DropdownMenuLabel className="font-normal">
      <div className="flex flex-col space-y-1">
        <p className="text-sm font-medium">{user.name}</p>
        <p className="text-xs text-muted-foreground">{user.email}</p>
      </div>
    </DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuItem>
      <User className="mr-2 h-4 w-4" />
      Profile
    </DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem>
      <LogOut className="mr-2 h-4 w-4" />
      Log out
    </DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

**Visual Details**:
- `w-56` on content for consistent width
- Label shows user info (name + email)
- `flex-col space-y-1` for stacked text
- Separators group related actions

---

## 9. ALERT & NOTIFICATION PATTERNS

### Inline Alerts

```tsx
{/* Info */}
<Alert variant="default">
  <Info className="h-4 w-4" />
  <AlertTitle>Heads up!</AlertTitle>
  <AlertDescription>
    You can add components using the CLI.
  </AlertDescription>
</Alert>

{/* Success */}
<Alert className="border-green-600">
  <CheckCircle2 className="h-4 w-4" />
  <AlertTitle>Success</AlertTitle>
  <AlertDescription>
    Your changes have been saved.
  </AlertDescription>
</Alert>

{/* Error */}
<Alert variant="destructive">
  <AlertCircle className="h-4 w-4" />
  <AlertTitle>Error</AlertTitle>
  <AlertDescription>
    Your session has expired.
  </AlertDescription>
</Alert>
```

**Visual Coding**:
- Icon indicates type
- Border color reinforces meaning
- Title + description pattern

---

### Alert with Actions

```tsx
<Alert className="flex items-start justify-between">
  <div className="flex gap-3">
    <AlertCircle className="h-4 w-4" />
    <div>
      <AlertTitle>Update Available</AlertTitle>
      <AlertDescription>
        A new version is available.
      </AlertDescription>
    </div>
  </div>
  <div className="flex gap-2">
    <Button size="sm" variant="outline">Later</Button>
    <Button size="sm">Update Now</Button>
  </div>
</Alert>
```

**Visual Layout**:
- `justify-between` separates content and actions
- `size="sm"` for proportional buttons
- Primary/secondary button pairing

---

## 10. TABLE DISPLAY PATTERNS

### Basic Data Table

```tsx
<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Name</TableHead>
      <TableHead>Email</TableHead>
      <TableHead className="text-right">Actions</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    {users.map((user) => (
      <TableRow key={user.id}>
        <TableCell className="font-medium">{user.name}</TableCell>
        <TableCell>{user.email}</TableCell>
        <TableCell className="text-right">
          <Button variant="ghost" size="sm">Edit</Button>
        </TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

**Visual Hierarchy**:
- `font-medium` on first column for emphasis
- `text-right` for action column alignment

---

### Striped Table

```tsx
<TableBody>
  {items.map((item, index) => (
    <TableRow
      key={item.id}
      className={index % 2 === 0 ? "bg-muted/50" : ""}
    >
      {/* cells */}
    </TableRow>
  ))}
</TableBody>
```

**Visual Effect**:
- `bg-muted/50` on even rows
- `/50` opacity for subtle striping

---

### Table with Status Badges

```tsx
<Table>
  <TableBody>
    {orders.map((order) => (
      <TableRow key={order.id}>
        <TableCell className="font-mono">{order.id}</TableCell>
        <TableCell>{order.customer}</TableCell>
        <TableCell>
          <Badge variant={
            order.status === 'completed' ? 'default' :
            order.status === 'pending' ? 'secondary' :
            'destructive'
          }>
            {order.status}
          </Badge>
        </TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

**Visual Elements**:
- `font-mono` for IDs
- Badge variant based on status
- Color coding provides instant feedback

---

## KEY COMPOSITION PRINCIPLES

### Spacing Hierarchy
- Between sections: `space-y-8` or `gap-8`
- Between groups: `space-y-4` or `gap-4`
- Within groups: `space-y-2` or `gap-2`
- Between inline elements: `gap-1.5` or `gap-2`

### Width Constraints
- Forms: `max-w-sm` (384px) to `max-w-2xl` (672px)
- Cards: `max-w-md` (448px) to `max-w-lg` (512px)
- Dialogs: `sm:max-w-[425px]`
- Content: `max-w-prose` (65ch)

### Icon Sizing
- Inline: `h-3 w-3` or `size-3`
- Standard: `h-4 w-4` or `size-4`
- Medium: `h-5 w-5` or `size-5`
- Large: `h-6 w-6` or `size-6`

### Text Hierarchy
- Heading: `text-2xl font-bold`
- Subheading: `text-lg font-medium`
- Body: default
- Description: `text-sm text-muted-foreground`
- Caption: `text-xs text-muted-foreground`

### Color Semantic Mapping
- Primary: `bg-primary` / `text-primary`
- Destructive: `bg-destructive` / `text-destructive`
- Success: `bg-green-600` / `text-green-600`
- Warning: `bg-orange-600` / `text-orange-600`
- Neutral: `bg-secondary` / `text-secondary-foreground`
- Muted: `bg-muted` / `text-muted-foreground`

### Layout Patterns
- Horizontal flex: `flex items-center gap-2`
- Vertical stack: `flex flex-col space-y-2`
- Two-column: `grid grid-cols-2 gap-4`
- Space between: `flex justify-between items-center`

### Border & Rounding
- Cards/containers: `rounded-lg border`
- Buttons/badges: `rounded-md`
- Pills/tags: `rounded-full`
- Avatar: `rounded-full`

---

## WHEN TO USE WHICH COMPONENT

### Buttons
- **Default**: Primary action (1 per screen)
- **Outline**: Secondary actions
- **Ghost**: Tertiary actions, icon-only
- **Destructive**: Delete, remove, cancel

### Badges
- **Default**: New items, active status
- **Secondary**: Neutral states, categories
- **Destructive**: Errors, alerts
- **Outline**: Tags, filters (low emphasis)

### Cards
- **Basic**: Content containers
- **With header/footer**: Actionable content
- **Interactive**: Clickable items (hover)
- **Stat**: Metrics display
