ProductsController.class_eval do
  caches_action :google_merchant, :expires_in => 1.hour

  def google_merchant
    @products = Product.active
  end
end
