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

# Copied from ActiveSupport
unless :to_proc.respond_to?(:to_proc)
  class Symbol
    # Turns the symbol into a simple proc, which is especially useful for enumerations. Examples:
    #
    #   # The same as people.collect { |p| p.name }
    #   people.collect(&:name)
    #
    #   # The same as people.select { |p| p.manager? }.collect { |p| p.salary }
    #   people.select(&:manager?).collect(&:salary)
    def to_proc
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end
