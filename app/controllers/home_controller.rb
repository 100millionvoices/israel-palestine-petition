class HomeController < ApplicationController
  def index
    @signature_count = Signature.confirmed.count
  end
end
