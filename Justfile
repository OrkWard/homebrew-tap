# Copy .env.example to .env and fill it in.
set dotenv-load
set dotenv-required

# Update a formula, publish its bottle and commit once: just bump selever v1.1.0
bump formula tag revision="":
    ./scripts/bump.fish {{ quote(formula) }} {{ quote(tag) }} {{ quote(revision) }}
