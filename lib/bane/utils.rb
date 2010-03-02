module Bane

  module Utils
    def self.random_string
      (1..rand(26)).map{|i| ('a'..'z').to_a[rand(26)]}.join
    end
  end

end