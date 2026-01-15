---
paths: **/ai/**/*.ts, **/workers/**/*.ts, **/services/**/*.ts, **/hooks/**/*.ts
---

# Cloudflare Workers AI

## Rule

Use `messages` + `response_format` for JSON. M2M100 for translation. `temperature: 0.2` for classification. Llama 3.3 70B for validated JSON mode.

## Models

| Task | Model | Notes |
|------|-------|-------|
| **Validation/Classification** | `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | Best JSON mode, 82% MMLU |
| Text Gen (simple) | `@cf/meta/llama-3.1-8b-instruct-fp8-fast` | Fast, 73% MMLU |
| Embeddings | `@cf/baai/bge-m3` | Multilingual, 1024-dim |
| Translation | `@cf/meta/m2m100-1.2b` | NOT LLMs, bypass proper nouns |

**JSON Mode Support** (Confirmed):
- ✅ Llama 3.1/3.3 (all sizes)
- ✅ Hermes 2 Pro Mistral 7B
- ❓ Mistral Small 3.1 24B (undocumented)

## JSON Mode

```typescript
await env.AI.run('@cf/meta/llama-3.3-70b-instruct-fp8-fast', {
  messages: [{ role: 'system', content: systemPrompt }, { role: 'user', content: userPrompt }],
  response_format: {
    type: 'json_schema',
    json_schema: { name: 'Result', schema: { type: 'object', properties: {...}, required: [...] } }
  },
  temperature: 0.2,
  max_tokens: 256
})
// response.response is OBJECT (not string) in JSON mode!
```

## Validation Prompts (Research-Backed)

| Pattern | Effect |
|---------|--------|
| Explicit allowlist | Reduces false negatives |
| "AUTOMATICALLY VALID" | Counter-acts LLM skepticism |
| Simple user prompt | Prevents over-scrutiny |
| Threshold 0.4 | Fewer pending reviews |

## Constraints

| ❌ | ✅ |
|---|---|
| `{ prompt: "..." }` | `{ messages: [...] }` |
| `stream: true` + JSON | Non-streaming |
| Ask for step-by-step reasoning | Simple "classify this" |
| Mistral for JSON | Llama for JSON |
| LLM for translation | M2M100 + proper noun bypass |

## Embeddings

```typescript
const vector = (await env.AI.run('@cf/baai/bge-m3', { text })).data[0]
```
