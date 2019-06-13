# frozen_string_literal: true

class Incident < Hanami::Entity
  def acknowledged?
    !acknowledgers.empty?
  end

  def resolved?
    !resolver.nil?
  end
end
