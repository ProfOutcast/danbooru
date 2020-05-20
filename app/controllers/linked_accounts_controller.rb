class LinkedAccountsController < ApplicationController
  respond_to :html, :xml, :json

  def new
    oauth = Oauth2Client.new(params[:site], redirect_uri: callback_linked_accounts_url)
    redirect_to oauth.authorization_url(user: CurrentUser.user)
  end

  def index
    @linked_accounts = authorize LinkedAccount.visible(CurrentUser.user).paginated_search(params)
    respond_with(@linked_accounts)
  end

  def callback
    LinkedAccountService.link_account(user: CurrentUser.user, code: params[:code], state: params[:state])
    redirect_back fallback_location: settings_path, notice: "Account linked"
  end
end
