module Service
  module PermissionUtils
    extend self
    ACTION_MAPS = {
      'new' => 'create',
      'edit' => 'update',
      'show' => 'show',
      'index' => 'read'
    }

    def convert_action_name(action_name)
      action_name = action_name.to_s.strip
      action_name = ACTION_MAPS[action_name] || action_name
      # action_name.sub(/^(new|create|update|edit|download|destroy|save)_/, '')
      action_name.sub(/^new_/, 'create_').sub(/^edit_/, 'update_')
    end

    def convert_controller_name(controller_name)
      controller_name.to_s
    end

    def need_check_permission(controller_name)
      controller_name = controller_name.to_s.strip
      controller_name =~ /^api\/admin/ && !(controller_name =~ /^api\/admin\/v1\/commons/) && !(controller_name =~ /^api\/admin\/v1\/searchs/)
    end
  end
end

