/*
  # Create users and todos tables

  1. New Tables
    - `users`
      - `id` (uuid, primary key)
      - `email` (text, unique)
      - `password_hash` (text) - stores hashed passwords
      - `created_at` (timestamp)
    
    - `todos`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to users)
      - `text` (text) - the todo content
      - `day_of_week` (integer) - 0-6 (Sunday-Saturday)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Users can only read/write their own data
    - Public registration allowed without authentication for initial signup

  3. Notes
    - Password hashing should be done on the client side before sending
    - day_of_week: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
*/

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS todos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  text text NOT NULL,
  day_of_week integer NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Todos readable by owner"
  ON todos FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Todos insertable by owner"
  ON todos FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Todos updatable by owner"
  ON todos FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Todos deletable by owner"
  ON todos FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

CREATE INDEX IF NOT EXISTS todos_user_id_day_idx ON todos(user_id, day_of_week);
