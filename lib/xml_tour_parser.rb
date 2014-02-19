class XmlTourParser
  def initialize(xml)
    @xml = ActiveSupport::XmlMini.parse(xml)
  end
  
  def accept(visitor)
    p @xml
    visitor.visit(@xml)
  end
end
