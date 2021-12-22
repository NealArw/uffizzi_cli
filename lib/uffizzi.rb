# frozen_string_literal: true

require 'uffizzi/shell'

module Uffizzi
 class Error < StandardError; end

  class << self
    def ui
      @ui ||= Uffizzi::UI::Shell.new
    end
  end
end
