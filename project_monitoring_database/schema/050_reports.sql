-- 050_reports.sql
-- Report definitions and parameters

CREATE TABLE IF NOT EXISTS report_definitions (
    id BIGSERIAL PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    query TEXT NOT NULL, -- parameterized SQL to be executed by backend safely
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL
);
CREATE TRIGGER trg_report_definitions_updated_at
BEFORE UPDATE ON report_definitions
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS report_params (
    id BIGSERIAL PRIMARY KEY,
    report_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    data_type TEXT NOT NULL, -- string, number, date, enum
    required BOOLEAN DEFAULT FALSE,
    default_value TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL
);
CREATE TRIGGER trg_report_params_updated_at
BEFORE UPDATE ON report_params
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
