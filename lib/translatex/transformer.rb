# class that does the actual transformation of the xml
# via xslt

module Translatex

  class Transformer

    def initialize(xml, xslt)
      @xml = Nokogiri::XML(xml)
      @xslt = Nokogiri::XSLT(xslt)
    end

    def transform(xslt_params = [])
      @xslt.transform(@xml, xslt_params)
    end

  end

end