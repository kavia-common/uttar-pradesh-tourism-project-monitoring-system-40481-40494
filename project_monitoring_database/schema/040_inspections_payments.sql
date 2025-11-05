-- 040_inspections_payments.sql
-- Inspections and payments

CREATE TABLE IF NOT EXISTS inspections (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    milestone_id BIGINT NULL,
    inspector_id BIGINT NULL, -- ref users
    inspection_date DATE,
    notes TEXT,
    status TEXT, -- scheduled, completed, issues_found
    latitude NUMERIC(9,6) CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMERIC(9,6) CHECK (longitude BETWEEN -180 AND 180),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_inspections_updated_at
BEFORE UPDATE ON inspections
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS inspection_photos (
    id BIGSERIAL PRIMARY KEY,
    inspection_id BIGINT NOT NULL,
    caption TEXT,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    mime_type TEXT,
    size_bytes BIGINT,
    checksum TEXT,
    taken_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_inspection_photos_updated_at
BEFORE UPDATE ON inspection_photos
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    contractor_id BIGINT NULL,
    amount NUMERIC(14,2) NOT NULL,
    payment_date DATE,
    payment_mode TEXT, -- NEFT, RTGS, CHEQUE
    status TEXT, -- pending, processed, failed
    remarks TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_payments_updated_at
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS invoices (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    contractor_id BIGINT NULL,
    invoice_no TEXT NOT NULL,
    invoice_date DATE,
    amount NUMERIC(14,2) NOT NULL,
    status TEXT, -- submitted, approved, rejected, paid
    file_path TEXT,
    file_name TEXT,
    mime_type TEXT,
    size_bytes BIGINT,
    checksum TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_invoices_updated_at
BEFORE UPDATE ON invoices
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
