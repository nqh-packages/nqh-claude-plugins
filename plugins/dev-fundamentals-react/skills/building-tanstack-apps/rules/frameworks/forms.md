---
paths: **/src/components/**/*.tsx
---

# TanStack Forms

## React 19 Actions

```tsx
import { useActionState } from 'react'

function ContactForm() {
  const [state, submitAction, isPending] = useActionState(
    async (previousState, formData) => {
      const name = formData.get('name')
      const email = formData.get('email')

      try {
        await sendEmail({ name, email })
        return { success: true, message: 'Email sent!' }
      } catch (error) {
        return { success: false, message: 'Failed' }
      }
    },
    { success: false, message: '' }
  )

  return (
    <form action={submitAction}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button disabled={isPending}>
        {isPending ? 'Sending...' : 'Send'}
      </button>
      {state.message && <p>{state.message}</p>}
    </form>
  )
}
```

## Optimistic Updates

```tsx
import { useOptimistic } from 'react'

function TodoList({ todos }) {
  const [optimisticTodos, addOptimisticTodo] = useOptimistic(
    todos,
    (state, newTodo) => [...state, newTodo]
  )

  async function addTodo(formData) {
    const title = formData.get('title')
    const tempTodo = { id: crypto.randomUUID(), title, completed: false }

    addOptimisticTodo(tempTodo) // Optimistic update
    await createTodo(title) // Server sync
  }

  return (
    <div>
      {optimisticTodos.map(todo => (
        <div key={todo.id}>{todo.title}</div>
      ))}
      <form action={addTodo}>
        <input name="title" />
        <button>Add</button>
      </form>
    </div>
  )
}
```

## shadcn/ui Form Pattern

```tsx
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

function LoginForm() {
  return (
    <form className="space-y-4 max-w-sm">
      <div className="space-y-2">
        <Label htmlFor="email">Email</Label>
        <Input id="email" type="email" placeholder="you@example.com" />
      </div>
      <div className="space-y-2">
        <Label htmlFor="password">Password</Label>
        <Input id="password" type="password" />
      </div>
      <Button type="submit" className="w-full">Sign In</Button>
    </form>
  )
}
```

## DO / DON'T

| DO | DON'T |
|----|-------|
| `useActionState` for forms | Manual state + fetch |
| `useOptimistic` for immediate UI | Wait for server response |
| `formData.get('name')` | Controlled inputs for simple forms |
| shadcn/ui components | Custom form primitives |
