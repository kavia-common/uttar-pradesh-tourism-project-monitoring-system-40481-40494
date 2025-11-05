-- seed_dev.sql
-- Minimal demo data for roles, admin user, sample project, and related records

-- Permissions
INSERT INTO permissions (code, name, description)
VALUES 
('USER_MANAGE', 'User Management', 'Manage users and roles'),
('PROJECT_MANAGE', 'Project Management', 'Create and update projects'),
('TENDER_MANAGE', 'Tender Management', 'Manage tenders and bids'),
('PAYMENT_MANAGE', 'Payment Management', 'Manage payments and invoices'),
('REPORT_VIEW', 'Report View', 'View and run reports')
ON CONFLICT (code) DO NOTHING;

-- Roles
INSERT INTO roles (code, name, description)
VALUES 
('ADMIN', 'Administrator', 'Full system access'),
('PM', 'Project Manager', 'Manage projects and milestones'),
('VIEWER', 'Viewer', 'Read-only access')
ON CONFLICT (code) DO NOTHING;

-- Map role-permissions (basic set)
WITH rp AS (
  SELECT r.id AS role_id, p.id AS permission_id, r.code AS rcode, p.code AS pcode
  FROM roles r CROSS JOIN permissions p
)
INSERT INTO role_permissions (role_id, permission_id, created_by)
SELECT role_id, permission_id, 'seed'
FROM rp
WHERE (rcode = 'ADMIN')
   OR (rcode = 'PM' AND pcode IN ('PROJECT_MANAGE','TENDER_MANAGE','REPORT_VIEW'))
   OR (rcode = 'VIEWER' AND pcode IN ('REPORT_VIEW'))
ON CONFLICT DO NOTHING;

-- Admin user placeholder (password hash is a placeholder string, backend should set real password)
INSERT INTO users (username, full_name, email, password_hash, is_active, created_by)
VALUES ('admin', 'System Admin', 'admin@example.com', crypt('admin123', gen_salt('bf')), TRUE, 'seed')
ON CONFLICT (username) DO NOTHING;

-- Assign ADMIN role to admin
INSERT INTO user_roles (user_id, role_id, created_by)
SELECT u.id, r.id, 'seed'
FROM users u, roles r
WHERE u.username = 'admin' AND r.code = 'ADMIN'
ON CONFLICT DO NOTHING;

-- Sample project
INSERT INTO projects (code, name, description, department, start_date, status, estimated_cost, created_by)
VALUES ('PRJ-001', 'Tourist Rest House Renovation', 'Renovation of rest house at Lucknow', 'UPSTDC', CURRENT_DATE - INTERVAL '60 days', 'ongoing', 5000000.00, 'seed')
ON CONFLICT (code) DO NOTHING;

-- Project location
INSERT INTO project_locations (project_id, name, address, latitude, longitude, created_by)
SELECT p.id, 'Lucknow Rest House', 'Hazratganj, Lucknow', 26.846708, 80.946159, 'seed'
FROM projects p WHERE p.code = 'PRJ-001'
ON CONFLICT DO NOTHING;

-- Milestone
INSERT INTO project_milestones (project_id, name, description, due_date, status, progress_percent, created_by)
SELECT p.id, 'Phase 1', 'Initial structural repairs', CURRENT_DATE + INTERVAL '30 days', 'in_progress', 40.00, 'seed'
FROM projects p WHERE p.code = 'PRJ-001'
ON CONFLICT DO NOTHING;

-- Funds
INSERT INTO project_funds (project_id, fund_source, amount_allocated, amount_released, amount_utilized, remarks, created_by)
SELECT p.id, 'State', 3000000.00, 1500000.00, 1200000.00, 'Initial allocation and release', 'seed'
FROM projects p WHERE p.code = 'PRJ-001'
ON CONFLICT DO NOTHING;

-- Contractor
INSERT INTO contractors (name, email, phone, address, rating, created_by)
VALUES ('ABC Contractors Pvt Ltd', 'contact@abccon.in', '9876543210', 'Gomti Nagar, Lucknow', 4.20, 'seed')
ON CONFLICT (name) DO NOTHING;

-- Tender
INSERT INTO tenders (project_id, title, description, tender_no, publish_date, bid_deadline, status, created_by)
SELECT p.id, 'Civil Works Package', 'Renovation works', 'TND-2024-001', CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '20 days', 'open', 'seed'
FROM projects p WHERE p.code = 'PRJ-001'
ON CONFLICT (tender_no) DO NOTHING;

-- Bid
INSERT INTO tender_bids (tender_id, contractor_id, bid_amount, bid_date, status, remarks, created_by)
SELECT t.id, c.id, 4800000.00, CURRENT_DATE - INTERVAL '2 days', 'submitted', 'Competitive bid', 'seed'
FROM tenders t, contractors c
WHERE t.tender_no = 'TND-2024-001' AND c.name = 'ABC Contractors Pvt Ltd'
ON CONFLICT DO NOTHING;

-- Inspection
INSERT INTO inspections (project_id, milestone_id, inspector_id, inspection_date, notes, status, latitude, longitude, created_by)
SELECT p.id, m.id, u.id, CURRENT_DATE - INTERVAL '1 day', 'Site visited, work progressing.', 'completed', 26.846700, 80.946150, 'seed'
FROM projects p
JOIN project_milestones m ON m.project_id = p.id
JOIN users u ON u.username = 'admin'
WHERE p.code = 'PRJ-001'
ON CONFLICT DO NOTHING;

-- Payment
INSERT INTO payments (project_id, contractor_id, amount, payment_date, payment_mode, status, remarks, created_by)
SELECT p.id, c.id, 500000.00, CURRENT_DATE, 'NEFT', 'processed', 'Advance release', 'seed'
FROM projects p, contractors c
WHERE p.code = 'PRJ-001' AND c.name = 'ABC Contractors Pvt Ltd'
ON CONFLICT DO NOTHING;

-- Invoice
INSERT INTO invoices (project_id, contractor_id, invoice_no, invoice_date, amount, status, created_by)
SELECT p.id, c.id, 'INV-2024-0001', CURRENT_DATE - INTERVAL '3 days', 750000.00, 'submitted', 'seed'
FROM projects p, contractors c
WHERE p.code = 'PRJ-001' AND c.name = 'ABC Contractors Pvt Ltd'
ON CONFLICT (invoice_no) DO NOTHING;

-- Reports
INSERT INTO report_definitions (code, name, description, query, created_by)
VALUES (
  'PRJ_STATUS',
  'Project Status Summary',
  'List projects with status and progress',
  'SELECT p.code, p.name, p.status, COALESCE(AVG(m.progress_percent),0) as avg_progress
   FROM projects p
   LEFT JOIN project_milestones m ON m.project_id = p.id
   GROUP BY p.code, p.name, p.status
   ORDER BY p.name',
  'seed'
)
ON CONFLICT (code) DO NOTHING;

INSERT INTO report_params (report_id, name, data_type, required, default_value, created_by)
SELECT r.id, 'status', 'string', FALSE, NULL, 'seed'
FROM report_definitions r WHERE r.code = 'PRJ_STATUS'
ON CONFLICT DO NOTHING;
