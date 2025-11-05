-- 099_indexes_constraints.sql
-- Constraints, foreign keys, indexes, and cascades

-- RBAC relationships
ALTER TABLE role_permissions
    ADD CONSTRAINT fk_role_permissions_role
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE role_permissions
    ADD CONSTRAINT fk_role_permissions_permission
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_role
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE audit_log
    ADD CONSTRAINT fk_audit_log_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Projects relationships
ALTER TABLE project_documents
    ADD CONSTRAINT fk_project_documents_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE project_documents
    ADD CONSTRAINT fk_project_documents_uploaded_by
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE project_locations
    ADD CONSTRAINT fk_project_locations_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE project_milestones
    ADD CONSTRAINT fk_project_milestones_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE project_funds
    ADD CONSTRAINT fk_project_funds_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Tenders and contractors relationships
ALTER TABLE contractor_documents
    ADD CONSTRAINT fk_contractor_documents_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tenders
    ADD CONSTRAINT fk_tenders_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tender_bids
    ADD CONSTRAINT fk_tender_bids_tender
    FOREIGN KEY (tender_id) REFERENCES tenders(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tender_bids
    ADD CONSTRAINT fk_tender_bids_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE contract_awards
    ADD CONSTRAINT fk_contract_awards_tender
    FOREIGN KEY (tender_id) REFERENCES tenders(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE contract_awards
    ADD CONSTRAINT fk_contract_awards_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Inspections and payments relationships
ALTER TABLE inspections
    ADD CONSTRAINT fk_inspections_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE inspections
    ADD CONSTRAINT fk_inspections_milestone
    FOREIGN KEY (milestone_id) REFERENCES project_milestones(id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE inspections
    ADD CONSTRAINT fk_inspections_inspector
    FOREIGN KEY (inspector_id) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE inspection_photos
    ADD CONSTRAINT fk_inspection_photos_inspection
    FOREIGN KEY (inspection_id) REFERENCES inspections(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE payments
    ADD CONSTRAINT fk_payments_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE payments
    ADD CONSTRAINT fk_payments_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE invoices
    ADD CONSTRAINT fk_invoices_project
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE invoices
    ADD CONSTRAINT fk_invoices_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Reports relationships
ALTER TABLE report_params
    ADD CONSTRAINT fk_report_params_report
    FOREIGN KEY (report_id) REFERENCES report_definitions(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Useful indexes
CREATE INDEX IF NOT EXISTS idx_users_username ON users (username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);

CREATE INDEX IF NOT EXISTS idx_projects_code ON projects (code);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects (status);

CREATE INDEX IF NOT EXISTS idx_project_locations_project ON project_locations (project_id);
CREATE INDEX IF NOT EXISTS idx_project_milestones_project ON project_milestones (project_id);
CREATE INDEX IF NOT EXISTS idx_project_funds_project ON project_funds (project_id);

CREATE INDEX IF NOT EXISTS idx_tenders_project ON tenders (project_id);
CREATE INDEX IF NOT EXISTS idx_tender_bids_tender ON tender_bids (tender_id);
CREATE INDEX IF NOT EXISTS idx_contract_awards_tender ON contract_awards (tender_id);

CREATE INDEX IF NOT EXISTS idx_inspections_project ON inspections (project_id);
CREATE INDEX IF NOT EXISTS idx_inspection_photos_inspection ON inspection_photos (inspection_id);
CREATE INDEX IF NOT EXISTS idx_payments_project ON payments (project_id);
CREATE INDEX IF NOT EXISTS idx_invoices_project ON invoices (project_id);

-- Uniqueness constraints
ALTER TABLE invoices
    ADD CONSTRAINT uq_invoices_invoice_no UNIQUE (invoice_no);
