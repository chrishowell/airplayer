require 'ruby-progressbar'

module AirPlayer
  class Controller

    def initialize(options = { device: nil, progress: true })
      @device      = Device.get(options[:device])
      @player      = nil
      @progressbar = nil
      @progress = options[:progress]
    end

    def play(media)
      puts " Source: #{media.path}"
      puts "  Title: #{media.title}"
      puts " Device: #{@device.name} (Resolution: #{@device.info.resolution})"

      @player = @device.play(media.path)

      if (@progress)
        @progressbar = ProgressBar.create(format: '   %a |%b%i| %p%% %t')
        @player.progress -> playback {
          @progressbar.title    = 'Streaming'
          @progressbar.progress = playback.percent if playback.percent
        }
      end

      @player.wait
    end

    def stop 
      if @player
        @player.stop
      end

      if @progressbar
        @progressbar.title = 'Complete'
        @progressbar.finish
      end
    end

    def pause
      if @player
        @player.pause
      end

      if @progressbar
        @progressbar.title = 'Paused'
        @progressbar.finish
      end
    end

    def resume
      if @player
        @player.resume
      end

      if @progressbar
        @progressbar.title = 'Streaming'
      end
    end
  end
end
