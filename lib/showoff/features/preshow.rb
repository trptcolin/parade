module ShowOff
  module Preshow
    def self.included(server)

      server.get "/preshow" do
        Dir.glob("#{settings.presentation_directory}/preshow/*").map { |path| File.basename(path) }.to_json
      end

    end
  end
end