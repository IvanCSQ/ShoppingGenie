class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home

  end

  def submit_expense
    prompt = params[:prompt]
    @response = AiService.new(prompt).call
    redirect_to show_expense_path(response: @response)
  end

  def show_expense
    @response = params[:response]
  end
end
