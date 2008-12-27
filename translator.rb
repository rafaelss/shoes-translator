Shoes.setup do
   gem 'rest-client'
   gem 'json'
end

require 'cgi'
require 'rest_client'
require 'json'

Shoes.app :width => 230, :height => 330, :resizable => false, :title => 'Google Translator' do
    stack :margin => 10 do
        para 'Text to translate'
        @word = edit_line
        button 'Go' do
            @result.text = 'translating...'
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
    stack :margin => 10 do
        para 'Result'
        @result = edit_box
    end
    stack :margin => 10 do
        button 'Pronunciation' do
            debug("checking #{@word.text}.mp3")
            unless File.exists?(File.dirname(__FILE__) + "/#{@word.text}.mp3")
                debug("downloading #{@word.text}.mp3")
                download "http://howjsay.com/mp3/#{@word.text}.mp3", :save => "#{@word.text}.mp3" do
                    @v = video "#{@word.text}.mp3"
                end
            else
                @v = video "#{@word.text}.mp3"
            end
            debug("playing #{@word.text}.mp3")
            v.play
        end
    end
end
