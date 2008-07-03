require 'rest_client'
require 'json'
require 'cgi'

Shoes.app :width => 230, :height => 290, :resizable => false, :title => 'Google Translator' do
    stack :margin => 10 do
        para 'Text to translate'
        @word = edit_line
        button 'Go' do
            word = CGI.escape(@word.text)
            response = RestClient.get "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=#{word}&langpair=en%7Cpt"
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
end


