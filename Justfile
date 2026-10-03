# Copy .env.example to .env and fill it in.
set dotenv-load
set dotenv-required

default:
    @just --list

# Point a git-sourced formula at a new upstream tag: just bump selever v1.1.0
bump formula tag revision="":
    ./scripts/bump.fish {{ formula }} {{ tag }} {{ revision }}

# Build, publish and commit a bottle: just bottle selever
bottle formula:
    ./scripts/bottle.fish {{ formula }}

# List what the store currently serves.
bottles:
    mc ls "$BOTTLE_TARGET"
