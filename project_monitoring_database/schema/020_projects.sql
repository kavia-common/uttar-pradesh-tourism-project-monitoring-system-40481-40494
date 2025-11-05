-- 020_projects.sql
-- Projects core schema

CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    department TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT, -- e.g., planned, ongoing, completed, on_hold
    estimated_cost NUMERIC(14,2),
    actual_cost NUMERIC(14,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Project file metadata (documents)
CREATE TABLE IF NOT EXISTS project_documents (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    category TEXT, -- e.g., DPR, Drawing, Approval, Photo
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    mime_type TEXT,
    size_bytes BIGINT,
    checksum TEXT,
    uploaded_by BIGINT NULL,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_project_documents_updated_at
BEFORE UPDATE ON project_documents
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Project locations (geo-tagged)
CREATE TABLE IF NOT EXISTS project_locations (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name TEXT,
    address TEXT,
    latitude NUMERIC(9,6) CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMERIC(9,6) CHECK (longitude BETWEEN -180 AND 180),
    captured_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_project_locations_updated_at
BEFORE UPDATE ON project_locations
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Project milestones
CREATE TABLE IF NOT EXISTS project_milestones (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    due_date DATE,
    completed_date DATE,
    status TEXT, -- planned, in_progress, completed, delayed
    progress_percent NUMERIC(5,2) CHECK (progress_percent BETWEEN 0 AND 100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_project_milestones_updated_at
BEFORE UPDATE ON project_milestones
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Project funds
CREATE TABLE IF NOT EXISTS project_funds (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    fund_source TEXT, -- e.g., State, Central, CSR
    amount_allocated NUMERIC(14,2) NOT NULL DEFAULT 0,
    amount_released NUMERIC(14,2) NOT NULL DEFAULT 0,
    amount_utilized NUMERIC(14,2) NOT NULL DEFAULT 0,
    remarks TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_project_funds_updated_at
BEFORE UPDATE ON project_funds
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
