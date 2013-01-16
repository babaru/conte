# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

super_admin_role = Role.create(name: 'SuperAdmin')
supervisor_role = Role.create(name: 'Supervisor')
editor_role = Role.create(name: 'Editor')

super_admin = User.create(email: 'admin@sptida.com', password: '123456', password_confirmation: '123456')
super_admin.roles << super_admin_role
super_admin.save!

supervisor = User.create(email: 'su@sptida.com', password: '123456', password_confirmation: '123456')
supervisor.roles << supervisor_role
supervisor.save!

editor = User.create(email: 'editor@sptida.com', password: '123456', password_confirmation: '123456')
editor.roles << editor_role
editor.save!