require 'nokogiri'


module Nokogiri::SlimCommon
  def to_slim
    if respond_to?(:children) and children
      good_children = children.map { |x| x.to_slim }.select{|e| !e.nil?}
      good_children.select{|x| x.strip != ''}.join("\n")
    else
      nil
    end
  end
end

class Nokogiri::HTML::Document
  include Nokogiri::SlimCommon
end

class Nokogiri::HTML::DocumentFragment
  include Nokogiri::SlimCommon
end

class Nokogiri::XML::DTD
  def to_slim(lvl=0)
    nil
  end
end

class Nokogiri::XML::Element
  def slim(lvl=0)
    r = ('  ' * lvl)
    attrs_copy = attributes.clone
    if self.name == "ruby"
      if attrs_copy["code"].value.strip[0] == "="
        return r += attrs_copy["code"].value.strip
      else
        return r += "- " + attrs_copy["code"].value.strip
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
      good_children = children.map { |x| x.to_slim(lvl+1) }.select{|e| !e.nil? }.select{|e| e.strip != ''}
      if good_children.size > 0
        children_part = "\n#{good_children.join("\n")}"
      else
        children_part = ""
      end

      return %(#{self.slim(lvl)}#{children_part})
    else
      self.slim(lvl)
    end
  end

  def attributes_as_html(attributes_copy)
    unless attributes_copy == {}
      attributes_copy.map do |aname, aval|
        " #{aname}" +
          (aval.value ? "=#{html_quote(aval.value)}" : "")
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
    ('  ' * lvl) + %(| #{to_s.gsub(/\s+/, ' ').rstrip})
  end
end

class Nokogiri::XML::Comment
  def to_slim(lvl=0)
    return nil if text.strip.empty?
    ('  ' * lvl) + %Q(/! #{text.gsub(/\s+/, ' ').rstrip})
  end
end
