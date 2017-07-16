# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  self.responder = ApplicationResponder
  respond_to :html

  # method overload for url helper
  def default_url_options
    { locale: set_locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || extract_from_header || I18n.default_locale
  end

  def extract_from_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
