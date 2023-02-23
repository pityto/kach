namespace :permissions do
  task init: :environment do
    permissions = Permission.all.pluck(:controller, :action)
    old_count = permissions.length
    puts '----------------------------'
    puts "原记录: #{old_count}"
    puts '----------------------------'
    #筛选需要控制权限的控制器和方法
    Rails.application.routes.routes.each do |route|
      controller = Service::PermissionUtils.convert_controller_name(route.defaults[:controller])
      action = Service::PermissionUtils.convert_action_name(route.defaults[:action])
      puts action
      puts controller
      puts Service::PermissionUtils.need_check_permission(controller)
      if action.present? && Service::PermissionUtils.need_check_permission(controller)
        permission = permissions.select { |record| record[0] == controller && record[1] == action }
        if permission.blank?
          new_permission = Permission.create(controller: controller, action: action)
          permissions << [new_permission.controller, new_permission.action]
          puts "新增: #{new_permission.controller} #{new_permission.action}"
        end
      end
    end
    #给每个控制器添加一个manage权限
    Permission.all.group(:controller).pluck(:controller).each do |controller|
      next if controller == 'api/admin/v1/commons'
      permission = permissions.select { |record| record[0] == controller && record[1] == 'manage' }
      if permission.blank?
        new_permission = Permission.create(controller: controller, action: 'manage')
        permissions << [new_permission.controller, new_permission.action]
        puts "新增: #{new_permission.controller} manage"
      end
    end
    puts '----------------------------'
    puts "新增记录: #{permissions.length - old_count}"
    puts '----------------------------'
    puts '----------------------------'
    puts "现记录: #{permissions.length}"
    puts '----------------------------'
  end
end

