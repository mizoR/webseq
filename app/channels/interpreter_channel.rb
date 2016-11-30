require 'base64'

class InterpreterChannel < ApplicationCable::Channel
  include ActionView::Helpers::TextHelper

  def subscribed
    stream_from stream_token
  end

  def unsubscribed
  end

  def interpret(params)
    script = params.fetch('script')
    cache_key = "views/sequence_image_#{OpenSSL::Digest::SHA256::hexdigest(script)}"

    src = Rails.cache.fetch(cache_key) do
      sequence = Sequence.new(script: script)
      sequence.save!

      'data:image/png;base64,' + Base64.encode64(sequence.binary)
    end

    ActionCable.server.broadcast stream_token, src: src
  rescue PlantUML::Error => e
    err = simple_format(e.message)
    ActionCable.server.broadcast stream_token, err: err
  end

  def stream_token
    "interpreter_channel_#{params['access_token']}"
  end
end
