module HTML2Slim
  class Converter
    def to_s
      @slim
    end
  end

  class HTMLConverterNokogiri < Converter
    require 'nokogiri'
    require_relative 'nokogiri_monkeypatches'

    def initialize(html)
      @slim = Nokogiri::XML::DocumentFragment.parse(html).to_slim
    end
  end

  class HTMLConverterHpricot < Converter
    require 'hpricot'
    require_relative 'hpricot_monkeypatches'

    def initialize(html)
      @slim = Hpricot(html).to_slim
    end
  end

  class ERBConverter < Converter
    def initialize(file)
      # open.read makes it works for files & IO
      erb = File.exists?(file) ? open(file).read : file

      erb.gsub!(/<%(.+?)\s*\{\s*(\|.+?\|)?\s*%>/){ %(<%#{$1} do #{$2}%>) }

      # while, case, if, for and blocks...
      erb.gsub!(/<%(-\s+)?(\s*while .+?|\s*case .+?|\s*if .+?|\s*for .+?|.+?do\s*(\|.+?\|)?\s*)-?%>/){ %(<ruby code="#{$2.gsub(/"/, '&quot;')}">) }
      # else
      erb.gsub!(/<%-?\s*else\s*-?%>/, %(</ruby><ruby code="else">))
      # elsif
      erb.gsub!(/<%-?\s*(elsif .+?)\s*-?%>/){ %(</ruby><ruby code="#{$1}">) }
      # when
      erb.gsub!(/<%-?\s*(when .+?)\s*-?%>/){ %(</ruby><ruby code="#{$1}">) }
      erb.gsub!(/<%\s*(end|}|end\s+-)\s*%>/, %(</ruby>))
      erb.gsub!(/<%(.+?)\s*%>/){ %(<ruby code="#{$1.gsub(/"/, '&quot;')}"></ruby>) }
      @slim ||= HTMLConverterNokogiri.new(erb).to_s
    end
  end
end
