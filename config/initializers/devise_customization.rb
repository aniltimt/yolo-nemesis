module Devise
  module Models
    module Validatable

      def password_required?
        !persisted? || !password.nil?
      end

    end
  end
end
