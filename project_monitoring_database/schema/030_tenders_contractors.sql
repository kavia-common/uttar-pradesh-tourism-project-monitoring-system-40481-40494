-- 030_tenders_contractors.sql
-- Tenders and contractor related schema

CREATE TABLE IF NOT EXISTS contractors (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email email,
    phone TEXT,
    address TEXT,
    gstin TEXT,
    pan TEXT,
    rating NUMERIC(3,2) CHECK (rating BETWEEN 0 AND 5),
    blacklisted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_contractors_updated_at
BEFORE UPDATE ON contractors
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS contractor_documents (
    id BIGSERIAL PRIMARY KEY,
    contractor_id BIGINT NOT NULL,
    category TEXT, -- e.g., Registration, PAN, GST, WorkOrder
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
CREATE TRIGGER trg_contractor_documents_updated_at
BEFORE UPDATE ON contractor_documents
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS tenders (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    tender_no TEXT,
    publish_date DATE,
    bid_deadline DATE,
    status TEXT, -- open, closed, awarded, cancelled
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TRIGGER trg_tenders_updated_at
BEFORE UPDATE ON tenders
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS tender_bids (
    id BIGSERIAL PRIMARY KEY,
    tender_id BIGINT NOT NULL,
    contractor_id BIGINT NOT NULL,
    bid_amount NUMERIC(14,2) NOT NULL,
    bid_date DATE,
    status TEXT, -- submitted, shortlisted, rejected, accepted
    remarks TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL
);
CREATE TRIGGER trg_tender_bids_updated_at
BEFORE UPDATE ON tender_bids
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS contract_awards (
    id BIGSERIAL PRIMARY KEY,
    tender_id BIGINT NOT NULL,
    contractor_id BIGINT NOT NULL,
    award_date DATE,
    contract_value NUMERIC(14,2),
    contract_no TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT, -- active, completed, terminated
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by TEXT NULL,
    updated_by TEXT NULL
);
CREATE TRIGGER trg_contract_awards_updated_at
BEFORE UPDATE ON contract_awards
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
