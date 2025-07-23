-- Optional: Idempotent seed script for development/demo purposes

-- Create a demo user if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE username = 'demo'
    ) THEN
        INSERT INTO users (username, email, password_hash, display_name)
        VALUES (
            'demo',
            'demo@example.com',
            '$2b$12$abcdefghijkdummyhashhere', -- bcrypt hash placeholder, REPLACE!
            'Demo User'
        );
    END IF;
END
$$;

-- Insert a few demo tasks if not already present
DO $$
DECLARE
    demo_user_id INTEGER;
BEGIN
    SELECT id INTO demo_user_id FROM users WHERE username = 'demo' LIMIT 1;
    IF demo_user_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM tasks WHERE user_id = demo_user_id) THEN
            INSERT INTO tasks (user_id, title, description, due_date, completed, priority, category)
            VALUES
                (demo_user_id, 'Buy groceries', 'Milk, Bread, Eggs', NOW() + interval '1 day', FALSE, 0, 'Personal'),
                (demo_user_id, 'Team meeting', 'Discuss project status', NOW() + interval '2 days', FALSE, 1, 'Work'),
                (demo_user_id, 'Read a book', 'Finish reading novel', NULL, FALSE, 0, 'Personal');
        END IF;
    END IF;
END
$$;
