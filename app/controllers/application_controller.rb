class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def auth_token
    @auth_token ||= OAUTH_CONSUMER_TOKEN
  end

  def client
    @client ||= EvernoteOAuth::Client.new :token => auth_token, :sandbox => SANDBOX
  end

  def user_store
    @user_store ||= client.user_store
  end

  def note_store
    @note_store ||= client.note_store
  end

  def notebooks
    @notebooks ||= note_store.listNotebooks auth_token
  end
end
