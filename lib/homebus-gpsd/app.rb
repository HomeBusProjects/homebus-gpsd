require 'homebus'
require 'dotenv/load'

require 'time'

class HomebusGpsd::App < Homebus::App
  DDC = 'org.experimental.homebus.gps-stats'

  def initialize(options)
    @options = options
    super
  end

  def setup!
    @host = ENV['GPSD_HOST']
    @port = ENV['GPSD_PORT']

    @device = Homebus::Device.new name: 'Homebus gpsd stats',
                                  model: 'gpsd',
                                  manufacturer: '',
                                  serial_number: ''

    _start_gps
  end

  # {"class":"DEVICES","devices":[{"class":"DEVICE","path":"/dev/ttyACM0","driver":"u-blox","subtype":"SW 1.00 (59842),HW 00070000","subtype1":"PROTVER 14.00,GPS;SBAS;GLO;QZSS","activated":"2022-09-10T03:40:24.071Z","flags":1,"native":1,"bps":9600,"parity":"N","stopbits":1,"cycle":1.00,"mincycle":0.02}]}
  def _start_gps
    @gps = TCPSocket.new(@host, @port)
    line = @gps.gets

    if @options[:verbose]
      puts '>>> first line from gpsd:'
      pp line
    end

    @gps.puts '?WATCH={"enable":true}'
    devices_line = @gps.gets
    if @options[:verbose]
      puts '>>> first response to WATCH (should be devices):'
      pp devices_line
    end

    watch_line = @gps.gets
    if @options[:verbose]
      puts '>>> second response to WATCH (should be WATCH):'
      pp watch_line
    end
  end

  def _query_gps
    @gps.puts '?POLL;'
    answer = @gps.gets

    if @options[:verbose]
      puts '>>> response to POLL:'
      pp answer
    end

    data = JSON.parse(answer, symbolize_names: true)
    if @options[:verbose]
      puts '>>> response to POLL as JSON:'
      pp data
    end

    reported_time = Time.parse(data[:tpv][0][:time]).to_f*1000
    diff_time = (Time.now.to_f*1000 - reported_time)/1000
    
    payload = {
      number_of_satellites: data[:sky][0][:satellites].select { |x| x[:used] }.length,
      diff_time: diff_time
    }
  end

  def work!
    results = _query_gps

    return unless results

    if options[:verbose]
      puts '>>> payload:'
      pp payload
    end

    @device.publish! DDC, payload
    sleep update_interval
  end

  def update_interval
    60 * 60
  end

  def name
    'homebus-gpsd'
  end

  def consumes
    []
  end

  def publishes
    [ DDC ]
  end

  def devices
    [ @device ]
  end
end
