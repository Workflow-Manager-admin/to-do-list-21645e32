# To-Do List Database Container

This container manages the PostgreSQL database for the multi-container To-Do List application.

## Schema Overview

- **users:** Stores user accounts (authentication, profile)
- **tasks:** Each user's to-do tasks; linked to user; designed for scalability, basic team support

## Table Structure

### users
- id (PK), username (unique), email (unique), password_hash, created_at, updated_at, is_active
- Optional: display_name, avatar_url

### tasks
- id (PK), user_id (FK -> users), title, description, due_date, completed, created_at, updated_at, priority, category, assigned_to (optional, for future sharing)

## Indexes & Security

- Indexed on email, username, user_id, completed, due_date, and more for fast search/filter.
- All user and task relations enforced via foreign keys (`ON DELETE CASCADE`), preventing orphaned data.
- Designed to be accessed ONLY via Backend API for full RBAC and auditing.

## Initialization/Usage

1. **Running the DB for development:**
   - Use `startup.sh` in this folder to initialize/run PostgreSQL and set up the database, users, and permissions.
2. **Schema Initialization:**
   - After the DB is running, apply the schema:
     ```sh
     psql -h localhost -U appuser -d myapp -p 5000 -f init.sql
     ```
   - Credentials/connection string in `db_connection.txt`.

3. **Integration**
   - The BackendAPIServer connects using environment variables as shown in `db_visualizer/postgres.env`.

4. **Security Best Practices**
   - Password hashes only (no plaintext).
   - Use strong passwords for appuser.
   - All access via Backend API.

5. **Extending Schema**
   - To add teams/organizations: add an orgs table and org_id FK to users/tasks.
   - The schema is written for easy migration/extension.

## ER Diagram

```
users       1 ----< tasks
```

## Notes

- No data is included by default.
- Use the Backend API or psql to add test users/tasks.

