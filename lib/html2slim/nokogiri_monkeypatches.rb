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
    attrs_copy = attributes.clone
    if self.name == "ruby"
      if self.attrs_copy["code"].value.strip[0] == "="
        return r += self.attrs_copy["code"].strip
      else
        return r += "- " + self.attrs_copy["code"].strip
      end
    end

    r += self.name unless self.name == 'div' and (self.has_attribute?('id') || self.has_attribute?('class'))
    r += "##{self['id']}" if self.has_attribute?('id')
    attrs_copy.delete('id')
    r += ".#{self['class'].split(/\s+/).join('.')}" if self.has_attribute?('class')
    attrs_copy.delete('class')
    r += "[#{attributes_as_html(attrs_copy)}]" unless attributes_as_html(attrs_copy).empty?
    r
  end

  def to_slim(lvl=0)
    if respond_to?(:children) and children
      return %(#{self.slim(lvl)}\n#{children.map { |x| x.to_slim(lvl+1) }.select{|e| !e.nil? }.join("\n")})
    else
      self.slim(lvl)
    end
  end

  def attributes_as_html(attributes_copy)
    unless attributes_copy == {}
      attributes_copy.map do |aname, aval|
        " #{aname}" +
          (aval.value ? "=#{html_quote aval.value}" : "")
      end.join.strip
    else
      ''
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
