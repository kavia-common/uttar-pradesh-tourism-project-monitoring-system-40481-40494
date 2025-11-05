# Migrations

This folder is reserved if a future process needs to copy or compile SQL migrations separately.
Currently, startup.sh applies files in schema/ in lexical order (e.g., 001_*, 010_*, ... 099_*).
