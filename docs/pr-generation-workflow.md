# PR Generation and Custom Prompts Workflow

This document explains how GitHub Copilot can create and manage pull requests, and how custom prompt templates work in this repository.

## PR Generation with GitHub Copilot

### Overview

GitHub Copilot can create, update, and manage pull requests directly through its interface. This capability is available through the `/delegate` command in Copilot Chat.

### How It Works

1. **Creating PRs**: When you use `/delegate` or similar commands, Copilot can:
   - Create a new branch for your changes
   - Make code modifications
   - Commit changes with descriptive messages
   - Push to GitHub and create a pull request
   - Add a PR title and description automatically

2. **Updating PRs**: Copilot can also update existing PRs by:
   - Adding new commits to the PR branch
   - Updating the PR description
   - Responding to review feedback

3. **PR Context**: Copilot has access to:
   - Repository structure and code
   - Git history and branches
   - Existing issues and pull requests
   - GitHub Actions workflows

## Custom Prompt Templates

### What Are Prompt Templates?

Prompt templates are markdown files in `.github/prompts/` that define custom slash commands for Copilot Chat. They provide structured instructions for specific tasks.

### How Slash Commands Work

1. **Location**: Templates live in `.github/prompts/*.prompt.md`
2. **Discovery**: Copilot CLI automatically loads these templates
3. **Invocation**: Use `/command-name` in Copilot Chat to run a template
4. **Metadata**: Each template has frontmatter defining:
   - `name`: The command name (e.g., `/plan`, `/implement`)
   - `description`: What the command does
   - `argument-hint`: Optional parameters the command accepts

### Available Templates in This Repo

- **`/plan`** — Create a high-level implementation plan
- **`/implement`** — Execute code changes based on a plan
- **`/test`** — Generate and run tests
- **`/deploy`** — Deploy changes and verify installation
- **`/generate`** — Generate repo-specific prompt templates

### Template Structure

Each template follows this pattern:

```markdown
---
name: command-name
description: What this command does
argument-hint: "[optional parameters]"
---

# Instructions

Detailed instructions for the AI to follow...

## Goal

What the command should accomplish

## Inputs

What information is needed

## Steps

1. Step-by-step instructions
2. ...

## Output

What the command should produce
```

### Using Templates

1. **Install**: Run `./install.sh` to sync templates
2. **Invoke**: Use `/command-name` in Copilot Chat
3. **Parameters**: Some commands accept optional parameters (shown in hints)
4. **Update**: After editing templates, rerun `./install.sh`

## Prompt Templates vs Custom Agents

### When to Use Prompt Templates

Use prompt templates for:
- **Predefined workflows**: Standard tasks like plan, implement, test, deploy
- **Slash command integration**: When you want `/command-name` syntax
- **Simple instructions**: Straightforward tasks with clear steps
- **Repository-specific**: Tasks tailored to your repo's structure

**Pros**:
- Easy to create and modify (just markdown)
- Automatically available as slash commands
- No special configuration needed
- Version controlled with your repo

**Cons**:
- Limited to single prompt-response pattern
- Less flexibility than full agents
- No persistent state between invocations

### When to Use Custom Agents

Use custom agents for:
- **Complex workflows**: Multi-step processes with branching logic
- **New invocation patterns**: Beyond standard slash commands
- **Stateful interactions**: Tasks requiring memory across invocations
- **Advanced capabilities**: Custom tools or external integrations
- **Rich behaviors**: More sophisticated than prompt-response

**Pros**:
- Full control over agent behavior
- Can define custom tools and capabilities
- Support for complex state management
- More powerful than simple templates

**Cons**:
- More complex to create and maintain
- Require custom agent framework setup
- Live in `~/.copilot/agents` (separate from repo)
- Invoked via `/agent` command

### Migration Considerations

If you're thinking of converting prompt templates to custom agents:

1. **Keep templates for standard workflows**: Plan, implement, test, deploy are well-suited to templates
2. **Create agents for new capabilities**: Build custom agents for specialized tasks not covered by templates
3. **Hybrid approach**: Use both—templates for common tasks, agents for complex ones
4. **Generator agent**: Consider a "generation agent" that creates repo-specific custom agents

## Best Practices

### For Prompt Templates

1. **Keep instructions clear**: Write explicit, step-by-step instructions
2. **Reference repo files**: Point to specific files like `install.sh`, `.zshrc`
3. **Include examples**: Show expected output format
4. **Test regularly**: Rerun templates after changes to verify behavior
5. **Update installer**: Run `./install.sh` after editing templates

### For Custom Agents

1. **Define clear purpose**: Each agent should have one well-defined role
2. **Document capabilities**: Explain what tools and data the agent can access
3. **Version control**: Consider versioning agent definitions
4. **Test thoroughly**: Agents are more complex, so test carefully
5. **Share selectively**: Agents in `~/.copilot/agents` are user-specific

## Troubleshooting

### Slash Commands Not Working

- **Solution**: Rerun `./install.sh` to sync templates
- **Check**: Verify files exist in `.github/prompts/`
- **Restart**: Restart Copilot Chat or your editor

### Templates Not Updating

- **Solution**: Always run `./install.sh` after editing templates
- **Check**: Confirm the installer completed successfully
- **Verify**: Check symlink in VS Code user prompts directory

### Parameter Confusion

- **Remember**: `argument-hint` is just a UI hint, not enforcement
- **Optional**: Most template parameters are optional
- **Context**: Copilot infers parameters from conversation context

## Additional Resources

- [README](../README.md) — Repository overview and quick start
- [docs/prompts.md](prompts.md) — Detailed prompt installation guide
- [.github/prompts/](.github/prompts/) — Example prompt templates for this repo
- [github/.github/prompts/](github/.github/prompts/) — Canonical template source
