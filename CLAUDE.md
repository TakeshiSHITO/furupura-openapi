# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the Furupura OpenAPI specification repository that defines API contracts for three contexts:

- **Shop API** (`contexts/shop/`): For shop owners
- **User API** (`contexts/user/`): For end users
- **Admin API** (`contexts/admin/`): For platform administrators

Published documentation: https://takeshishito.github.io/furupura-openapi/

## Essential Commands

```bash
# Development (most common)
pnpm run dev         # Build and serve API documentation locally at http://localhost:8080

# Validation & Linting
pnpm run validate    # Validate all OpenAPI specifications
pnpm run lint        # Check formatting with Prettier
pnpm run lint:fix    # Auto-fix formatting issues

# Build & Bundle
pnpm run bundle      # Bundle YAML files into single files
pnpm run build       # Generate HTML documentation
pnpm run clean       # Clear cache and build artifacts (use when changes aren't reflected)

# Testing a single API context
pnpm run validate:shop   # Validate shop API only
pnpm run validate:user   # Validate user API only
pnpm run validate:admin  # Validate admin API only
```

## Architecture

The repository follows a multi-context OpenAPI structure:

1. **Context Separation**: Each API context (shop/user/admin) has its own directory with:
   - `openapi.yaml`: Main specification file with paths references
   - `paths/`: Individual endpoint definitions
   - `schemas/`: Data model definitions

2. **Reference Pattern**: Uses relative `$ref` paths (never absolute):

   ```yaml
   $ref: '../schemas/user.yaml#/User'  # ✅ Correct
   $ref: '/shared/schemas/common.yaml#/Error'  # ❌ Wrong
   ```

3. **Shared Resources**: Common schemas and parameters in `shared/` directory

4. **Build Process**:
   - Redocly bundles individual YAML files into `bundled/` directory
   - HTML documentation generated in `docs/` for GitHub Pages deployment

## Git Workflow

Pre-commit hooks (via Husky) automatically:

1. Validate OpenAPI specifications
2. Format code with Prettier
3. Validate commit messages with Commitlint
4. Auto-add any files modified by linters

Commit message format: `<type>: <subject>`

- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`

## Key Configuration Files

- `redocly.yaml`: OpenAPI linting rules and API definitions
- `portal.yaml`: Portal page OpenAPI specification
- `commitlint.config.js`: Commit message validation rules
- `.nvmrc`: Node.js version (v20)
