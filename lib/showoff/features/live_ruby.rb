module ShowOff

  module LiveRuby

    def self.included(server)
      server.get '/eval_ruby' do
        eval_ruby(params[:code])
      end
    end

    def eval_ruby(code)
      eval(code).to_s
    rescue => exception
      exception.message
    end
  end

end