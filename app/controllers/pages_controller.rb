
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :test_components]

  def home
  end

  def test_components
  end

  def transaction_history
  end

  def savings
  end

  def breakdown
  end
end
