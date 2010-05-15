class String
  unless "".respond_to?(:each_char)
    # copied from jcode in Ruby 1.8.6
    def each_char
      if block_given?
        scan(/./m) do |x|
          yield x
        end
      else
        scan(/./m)
      end
    end
  end

  unless "".respond_to?(:lines)
    require "enumerator"

    alias_method :lines, :to_a
  end
end
