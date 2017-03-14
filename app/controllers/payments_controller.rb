class PaymentsController < ApplicationController
  before_action: :create_order, only: [:index]
  def index
  end

  def create_order
  end
end
