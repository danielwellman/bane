# frozen_string_literal: true

module Bane

  class BehaviorMaker
    def initialize(makeables)
      @makeables = makeables
    end

    def create(behavior_names, starting_port, host)
      behavior_names
        .map { |behavior| makeables.fetch(behavior) { raise UnknownBehaviorError.new(behavior) } }
        .map.with_index { |maker, index| maker.make(starting_port + index, host) }
    end

    def create_all(starting_port, host)
      makeables.sort.map.with_index { |name_maker_pair, index| name_maker_pair.last.make(starting_port + index, host) }
    end

    private

    attr_reader :makeables
  end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

  class ResponderMaker
    def initialize(responder)
      @responer = responder
    end

    def make(port, host)
      Behaviors::Servers::ResponderServer.new(port, @responer.new, host)
    end
  end

end