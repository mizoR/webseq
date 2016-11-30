class SequencesController < ApplicationController
  def show
    @sequence = Sequence.new
  end
end
