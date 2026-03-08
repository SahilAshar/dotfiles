---
name: readability
description: 'Apply readability heuristics to code. Use when reviewing code for clarity, identifying confusing patterns, suggesting simplifications, or when asked about code comprehension, function complexity, variable naming, or repeated patterns.'
---

# Readability Code Review Skill

This skill teaches agents to identify readability issues in code using heuristic-based analysis. It's based on the principle that **good code is easy to read**.

## When to Use This Skill

Use this skill when:
- Reviewing code for clarity and comprehension
- Someone asks "is this code readable?" or "does this make sense?"
- Identifying areas where readers get confused
- Suggesting simplifications without citing design patterns
- Looking for opportunities to reduce cognitive load

## Core Readability Heuristics

Apply these four heuristics systematically when reviewing code:

### 1. Function Comprehension Check

**Signal**: If you have to reread a function multiple times to understand it.

**What to Look For**:
- Functions that require 2+ reads to grasp their purpose
- Nested logic that forces mental stack management
- Functions doing multiple unrelated things
- Unclear flow of execution

**Example Feedback**:
```
I had to reread this function 3 times to understand it handles both validation 
AND database updates AND email sending. Consider splitting into separate functions 
with single, clear purposes.
```

### 2. Method Distinction Check

**Signal**: Getting confused about which method you're in or what each similar method does.

**What to Look For**:
- Multiple methods with similar names doing slightly different things
- Methods that look alike but have subtle behavioral differences
- No clear distinction in method responsibilities

**Example Feedback**:
```
I'm getting confused between `processUserData()` and `handleUserData()` — 
their names suggest overlapping purposes. Can we make their distinct 
responsibilities more obvious through naming or consolidation?
```

### 3. Variable Clarity Check

**Signal**: Being surprised by how a variable is used or what it contains.

**What to Look For**:
- Variable names that don't match their actual usage
- Variables with scope larger than necessary
- Variables that change meaning mid-function
- Generic names like `data`, `temp`, `result` used for specific purposes

**Example Feedback**:
```
The variable `data` is used as user account information, but the name doesn't 
convey that specificity. When I saw `data.email` on line 45, I had to backtrack 
to understand what `data` represents. Consider `userAccount` or `accountData`.
```

### 4. Pattern Recognition Check

**Signal**: Seeing the same code pattern repeated in multiple places without a unifying structure.

**What to Look For**:
- Similar code blocks across multiple classes/functions
- Repeated logic without abstraction
- Copy-pasted code with minor variations
- No explicit indication that these are intentionally the same pattern

**Example Feedback**:
```
I notice this field extraction pattern appears in 3 different classes:
- UserAuditInfo.add()
- TripAuditInfo.add()  
- LocationAuditInfo.add()

Each does nearly identical map population. Consider introducing an `Auditable` 
interface to make this pattern explicit and reduce the places it needs updating.
```

## Application Process

When reviewing code with this skill:

1. **Read naturally** - Don't try to be smart, just read the code normally
2. **Note your reactions** - Where did you pause? What surprised you? What required rereading?
3. **Match to heuristics** - Connect each friction point to one of the four heuristics
4. **Provide specific feedback** - Point to exact lines/sections and explain the friction

## Example Code Reviews

### Example 1: Repeated Pattern Without Structure

**Code**:
```java
public class AuditInfo {
  private Map<String, String> fields = new HashMap<>();

  public void addUserInfo(User user) {
    fields.put("name", user.getName());
    fields.put("userId", user.getId());
  }
  
  public void addTripInfo(Trip trip) {
    fields.put("tripId", trip.getId());
    fields.put("tripStartTime", trip.getStartTime().toString());
    fields.put("tripEndTime", trip.getEndTime().toString());
    fields.put("tripDestination", trip.getDestinationId());
  }
  
  public void addLocationInfo(Location location) {
    fields.put("locationId", location.getId());
  }
}
```

**Review Using Heuristic #4** (Pattern Recognition):
```
**Friction Point**: The three `add*Info` methods caught my attention. They look 
like they're doing roughly the same thing (adding fields to a map), but there's 
nothing in the code to enforce that pattern. This made me read each one carefully 
to check for differences — that's reader friction.

**Suggestion**: Can we make the pattern more explicit? All three methods are 
extracting audit fields from domain objects.

**Example Refactor**:
```java
public interface Auditable {
  Map<String, String> getAuditInfo();
}

public class AuditInfo {
  private Map<String, String> fields = new HashMap<>();
  
  public void add(Auditable auditable) {
    fields.putAll(auditable.getAuditInfo());
  }
}

// User, Trip, and Location implement Auditable
```

This eliminates the reader friction — now it's clear these are all the same 
operation, and `AuditInfo` doesn't need to know about specific types.
```

### Example 2: Variable Scope Confusion

**Code**:
```python
def process_orders(orders):
    data = []
    for order in orders:
        data.append(order.id)
    
    data = calculate_totals(data)
    
    for i in range(len(data)):
        data[i] = apply_discount(data[i])
    
    return data
```

**Review Using Heuristic #3** (Variable Clarity):
```
**Friction Point**: The variable `data` changes meaning three times in this 
function. First it's a list of order IDs, then it becomes totals, then discounted 
totals. Each time I see `data`, I have to track which transformation we're on.

**Suggestion**: Use distinct variable names that reflect the actual data at each 
stage:

```python
def process_orders(orders):
    order_ids = [order.id for order in orders]
    totals = calculate_totals(order_ids)
    discounted_totals = [apply_discount(total) for total in totals]
    return discounted_totals
```

Now each variable tells me exactly what it contains without backtracking.
```

## Feedback Format Guidelines

When providing readability feedback:

**DO**:
- ✅ Point to specific lines/sections
- ✅ Explain your reading experience ("I got confused...", "I had to reread...")
- ✅ Ask questions when uncertain ("Can we make this more distinct?")
- ✅ Provide concrete examples when helpful
- ✅ Note what reads well, not just problems

**DON'T**:
- ❌ Cite design patterns unless they emerge naturally from readability concerns
- ❌ Make it about "best practices" — readability IS the practice
- ❌ Be prescriptive — collaborate, don't dictate solutions
- ❌ Review for bugs or performance (unless they impact readability)
- ❌ Focus only on problems — acknowledge clear, readable code too

## Response Structure

Use this structure for readability reviews:

```markdown
## Readability Review

### Major Friction Points
[Significant areas where reading was difficult]

### Minor Improvements  
[Small clarity wins that would help]

### What Reads Well
[Code that was immediately clear and well-structured]

### Summary
[Overall readability assessment and key takeaways]
```

## Tone and Collaboration

- **Be humble**: "I'm confused here" not "This is confusing"
- **Be specific**: Exact lines/functions, not vague areas
- **Be collaborative**: Suggest possibilities, don't prescribe solutions
- **Be encouraging**: Readability review works at all experience levels
- **Admit ignorance**: "I don't understand this" is valuable feedback

## Integration with Code Review Workflows

This skill works best when:
- Applied before pushing code to PR
- Used alongside functional testing
- Focused on reader experience rather than correctness
- Part of iterative refinement, not one-shot criticism

## Remember

Good code review isn't about encyclopedic knowledge of patterns. It's about honest 
reactions to the reading experience. When readers encounter friction, that's an 
opportunity for collaborative improvement — and that's what this skill helps identify.