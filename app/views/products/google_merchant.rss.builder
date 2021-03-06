xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title Spree::GoogleMerchant::Config[:google_merchant_title]
    xml.description Spree::GoogleMerchant::Config[:google_merchant_description]

    production_domain = Spree::GoogleMerchant::Config[:production_domain]
    xml.link production_domain

    @products.each do |product|
      brand = ""

      if product.taxons.any?
        product.taxons.each do |taxon|
          if taxon.taxonomy
            if taxon.taxonomy.name == "Marche"
              brand = taxon
              brand = brand.parent until brand.parent.parent.nil?
            end
          end
        end
      end

      brand = brand.name if brand.is_a?(Taxon)

      xml.item do
        xml.id product.id.to_s
        xml.title product.name.capitalize
        xml.description CGI.escapeHTML(product.description) if product.description
        xml.link production_domain + 'products/' + product.permalink
        xml.tag! "g:mpn", product.sku.to_s
        xml.tag! "g:availability", product.visible? ? "in stock" : "out of stock"
        xml.tag! "g:id", product.id.to_s
        xml.tag! "g:price", product_price(product, { :format_as_currency => false })
        xml.tag! "g:condition", "new"
        xml.tag! "g:image_link", production_domain.sub(/\/$/, '') + product.images.first.attachment.url(:original) unless product.images.empty?
        xml.tag! "g:brand", brand
      end
    end
  end
end
