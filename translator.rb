Shoes.setup do
  gem 'rest-client'
  gem 'json'
end

require 'cgi'
require 'rest_client'
require 'json'

Shoes.app :width => 260, :height => 270, :resizable => false, :title => 'Shoes Translator' do
  stack :margin => 10 do
    @word = edit_line('', :width => 225)
  end

  flow :margin => 10 do
    button 'Translate' do
      @result.text = 'translating...'
      Thread.start do
        word = CGI.escape(@word.text)
        response = RestClient.get "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=#{word}&langpair=en%7Cpt", :referer => 'http://rafaelss.com/'
        json = JSON.parse(response)
        status = json['responseStatus']
        if status == 200
          @result.text = json['responseData']['translatedText']
        else
          @result.text = "#{responseStatus} error to translate #{@word.text}"
        end
      end
    end

    button 'Pronunciation' do
      file = File.expand_path(File.dirname(__FILE__) + "/#{@word.text}.mp3")
      if !File.exists?(file)
        @result.text = 'downloading...'
        download "http://howjsay.com/mp3/#{@word.text}.mp3", :save => file do
          @result.text = ''
          play(file)
        end
      else
        play(file)
      end
    end
  end

  stack :margin => 15 do
    @result = edit_box('', :width => 227)
  end

  def play(file)
    flow :top => 0, :left => 0, :height => 1 do
      @v = video(file)
      Thread.start do
        sleep(0.1)
        @v.play
      end
    end
  end
end