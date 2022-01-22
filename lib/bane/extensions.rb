# frozen_string_literal: true

unless Class.respond_to?(:unqualified_name)
  class Class
    def unqualified_name
      self.name.split("::").last
    end
  end
end
