-- Windmill superadmin bootstrap
-- Executed after windmill-server is healthy.

-- 1. Admins workspace
INSERT INTO workspace (id, name, owner, deleted, created_at, updated_at)
VALUES ('admins', 'admins', '{{sullaEmail}}', false, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 2. Superadmin user
INSERT INTO usr (email, username, is_super_admin, created_at, updated_at, login_type)
VALUES ('{{sullaEmail}}', 'admin', true, NOW(), NOW(), 'password')
ON CONFLICT (email) DO NOTHING;

-- 3. Password (replace with real Argon2 hash of your desired password)
INSERT INTO password (email, password_hash, created_at)
VALUES ('{{sullaEmail}}', '{{sullaServicePassword|argon2}}', NOW())
ON CONFLICT (email) DO NOTHING;

-- 4. Default group + membership
INSERT INTO group_ (workspace_id, name, created_at)
VALUES ('admins', 'all', NOW())
ON CONFLICT DO NOTHING;

INSERT INTO usr_to_group (workspace_id, "group_", usr, created_at)
VALUES ('admins', 'all', '{{sullaEmail}}', NOW())
ON CONFLICT DO NOTHING;
