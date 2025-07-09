# frozen_string_literal: true

class FaqComponent < ViewComponent::Base
  def initialize(q:, a:)
    @q = q
    @a = a
  end
end
