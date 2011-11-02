module CUI8Tracks
  class CLI
    def self.execute(stdout, arguments=[])

      puts CUI8Tracks::BANNER

      pit = Pit.get('8tracks_login', :require => {
          'username' => 'username',
          'password' => 'password',
        })

      session = CUI8Tracks::Session.new
      session.load_config(ARGV)
      session.authorize(pit['username'], pit['password'])
      session.start_input_thread
      session.play

    end

    def self.open_browser(url)
      case RUBY_PLATFORM.downcase
      when /linux/
        [['x-www-browser'], ['firefox'], ['xdg-open'], ['w3m', '-X']]
      when /darwin/
        [['open']]
      when /mswin(?!ce)|mingw|bccwin/
        [['start']]
      else
        [['xdg-open'], ['firefox'], ['w3m', '-X']]
      end.find do |cmd|
        system *(cmd.dup << url)
        $?.exitstatus != 127
      end or puts url
    end
  end
end
