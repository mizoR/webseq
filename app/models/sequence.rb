class Sequence < ActiveHash::Base
  attr_reader :binary

  field :script

  def save!
    image = PlantUML.run(script)

    @binary = File.binread(image.path)
  ensure
    image.close! if image
  end
end
