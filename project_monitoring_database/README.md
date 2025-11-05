# Project Monitoring Database

Primary PostgreSQL database for the UPSTDC Project Monitoring System.

Defaults (as configured by startup.sh):
- Port: 5001
- Database: myapp
- User: appuser
- Password: dbuser123

Quick start
1) Initialize and seed
   ./startup.sh
   - Applies schema files in schema/*.sql (lexical order: 001_*, 010_*, … 099_*)
   - Applies development seed from seed/seed_dev.sql

2) Connection info
   - A helper command is written to db_connection.txt, e.g.:
     psql postgresql://appuser:dbuser123@localhost:5001/myapp
   - JDBC for Spring backend:
     DB_URL=jdbc:postgresql://localhost:5001/myapp
     DB_USERNAME=appuser
     DB_PASSWORD=dbuser123

3) Visualizer helper
   - Env exports saved to db_visualizer/postgres.env

Integration with backend
- Backend profile:
  - dev: uses H2 in-memory (see backend application-dev.properties)
  - prod/custom (default when not 'dev'): expects PostgreSQL via env
- Required env for backend (prod/custom):
  - DB_URL=jdbc:postgresql://localhost:5001/myapp
  - DB_USERNAME=appuser
  - DB_PASSWORD=dbuser123
  - JWT_SECRET=change-me
  - STORAGE_DIR=./storage (optional; defaults)
  - CORS_ALLOWED_ORIGINS=http://localhost:3000

Seeds and admin login
- The seed_dev.sql populates base RBAC and an admin account.
- Typical local credentials:
  Email: admin@example.com
  Password: Admin@123
  (Confirm in seed/seed_dev.sql in case of changes.)

Notes
- Re-running startup.sh is idempotent for user/db creation and will re-apply schema files; take care in non-dev environments.
- For adding new migrations, create a new file in schema/ with a higher numeric prefix (e.g., 060_new_feature.sql).
- Keep seed_dev.sql development-only.
