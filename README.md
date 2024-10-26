-- جدول الأدوار
create table roles (
  id serial primary key,
  role_name text unique,
  description text
);

insert into roles (role_name, description) values
('admin', 'Administrator with full access'),
('user', 'Regular user with limited access');

-- جدول الملفات الشخصية
create table profiles (
  id uuid references auth.users on delete cascade,
  username text,
  useremail text,
  avatar_url text,
  role_id int references roles(id) default 2,
  updated_at timestamp with time zone default timezone('utc', now())
);

create policy "Admins can access all profiles" 
on profiles
for select
using (
  exists(select 1 from roles where id = profiles.role_id and role_name = 'admin')
);

create policy "Users can access their own profile" 
on profiles
for select
using (auth.uid() = profiles.id);


