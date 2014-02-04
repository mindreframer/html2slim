require 'nokogiri'

class Nokogiri::HTML::Document
  def to_slim
    if respond_to?(:children) and children
      children.map { |x| x.to_slim }.select{|e| !e.nil? }.join("\n")
    else
      ''
    end
  end
end


class Nokogiri::HTML::DocumentFragment
  def to_slim
    if respond_to?(:children) and children
      children.map { |x| x.to_slim }.select{|e| !e.nil? }.join("\n")
    else
      ''
    end
  end
end

class Nokogiri::XML::DTD
  def to_slim(lvl=0)
    ""
  end
end

class Nokogiri::XML::Element

  def slim(lvl=0)
    r = ('  ' * lvl)
    if self.name == "ruby"
      if self.attributes["code"].value.strip[0] == "="
        return r += self.attributes["code"].strip
      else
        return r += "- " + self.attributes["code"].strip
      end
    end

    r += self.name unless self.name == 'div' and (self.has_attribute?('id') || self.has_attribute?('class'))
    r += "##{self['id']}" if self.has_attribute?('id')
    self.remove_attribute('id')
    r += ".#{self['class'].split(/\s+/).join('.')}" if self.has_attribute?('class')
    self.remove_attribute('class')
    r += "[#{attributes_as_html.to_s.strip}]" unless attributes_as_html.to_s.strip.empty?
    r
  end
  def to_slim(lvl=0)
    if respond_to?(:children) and children
      return %(#{self.slim(lvl)}\n#{children.map { |x| x.to_slim(lvl+1) }.select{|e| !e.nil? }.join("\n")})
    else
      self.slim(lvl)
    end
  end

  def attributes_as_html
    "xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\""
  end

  def attributes_as_html
    unless attributes == {}
      attributes.map do |aname, aval|
        " #{aname}" +
          (aval.value ? "=#{html_quote aval.value}" : "")
      end.join
    end
  end

  def html_quote(str)
    "\"" + str.gsub('"', '\\"') + "\""
  end

end


class Nokogiri::XML::Text
  def to_slim(lvl=0)
    return nil if to_s.strip.empty?
    ('  ' * lvl) + %(| #{to_s.gsub(/\s+/, ' ')})
  end
end

#Hpricot::XHTMLTransitional.tagset[:ruby] = [:code]
# raise Hpricot::XHTMLTransitional.tagset.inspect
# class Hpricot::BogusETag
#   def to_slim(lvl=0)
#     nil
#   end
# end

# class Hpricot::Text
#   def to_slim(lvl=0)
#     return nil if to_s.strip.empty?
#     ('  ' * lvl) + %(| #{to_s.gsub(/\s+/, ' ')})
#   end
# end

# class Hpricot::Comment
#   def to_slim(lvl=0)
#     nil
#   end
# end

# class Hpricot::DocType
#   def to_slim(lvl=0)
#     if self.to_s.include? "xml"
#       self.to_s.include?("iso-8859-1") ? "doctype xml ISO-88591" : "doctype xml"
#     elsif self.to_s.include? "XHTML" or self.to_s.include? "HTML 4.01"
#       available_versions = Regexp.union ["Basic", "1.1", "strict", "Frameset", "Mobile", "Transitional"]
#       version = self.to_s.match(available_versions).to_s.downcase
#       "doctype #{version}"
#     else
#       "doctype html"
#     end
#   end
# end

# class Hpricot::Elem
#   def slim(lvl=0)
#     r = ('  ' * lvl)
#     if self.name == "ruby"
#       if self.attributes["code"].strip[0] == "="
#         return r += self.attributes["code"].strip
#       else
#         return r += "- " + self.attributes["code"].strip
#       end
#     end

#     r += self.name unless self.name == 'div' and (self.has_attribute?('id') || self.has_attribute?('class'))
#     r += "##{self['id']}" if self.has_attribute?('id')
#     self.remove_attribute('id')
#     r += ".#{self['class'].split(/\s+/).join('.')}" if self.has_attribute?('class')
#     self.remove_attribute('class')
#     r += "[#{attributes_as_html.to_s.strip}]" unless attributes_as_html.to_s.strip.empty?
#     r
#   end
#   def to_slim(lvl=0)
#     if respond_to?(:children) and children
#       return %(#{self.slim(lvl)}\n#{children.map { |x| x.to_slim(lvl+1) }.select{|e| !e.nil? }.join("\n")})
#     else
#       self.slim(lvl)
#     end
#   end
# end

# class Hpricot::Doc
#   def to_slim
#     if respond_to?(:children) and children
#       children.map { |x| x.to_slim }.select{|e| !e.nil? }.join("\n")
#     else
#       ''
#     end
#   end
# end