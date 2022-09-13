require 'homebus/options'
require 'homebus-gpsd/version'

class HomebusGpsd::Options < Homebus::Options
  def app_options(op)
  end   

  def version
    HomebusGpsd::VERSION
  end

  def name
    'homebus-gpsd'
  end
end
