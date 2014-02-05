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
