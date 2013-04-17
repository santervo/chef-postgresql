#
# Cookbook Name:: postgresql
# Recipe:: pg_user
#

users = []

if node['postgresql'].attribute?('users')
  users = node["postgresql"]["users"]
end

begin
  data_bag('postgresql_users').each do |item|
    users << data_bag_item('postgresql_users', item)
  end
rescue
  Chef::Log.info "Could not load data bag 'postgresql_users'"
end

users.each do |user|
  pg_user user["username"] do
    privileges :superuser => user["superuser"], :createdb => user["createdb"], :login => user["login"]
    password user["password"]
  end
end
