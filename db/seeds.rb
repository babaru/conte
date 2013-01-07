# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
sys_admin = User.create(email: 'admin@sptida.com', password: '123456', password_confirmation: '123456')
sys_admin_role = Role.create(name: 'sys_admin')
sys_admin.roles << sys_admin_role