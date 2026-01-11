# Docker Run

Provide commands to build and run the app via Docker and Makefile targets.

Checklist:
- Prefer `make docker-build` / `make docker-up` / `make docker-down` if present.
- Otherwise use `docker compose build` and `docker compose up`.
- Include how to view logs and how to enter a container (`docker compose exec <service> sh`).

Keep it short and command-focused.
