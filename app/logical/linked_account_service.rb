module LinkedAccountService
  module_function

  def link_account(user:, code:, state:)
    oauth = Oauth2Client.from_state!(state, user)
    token = oauth.access_token(code)

    account_id, account_data = get_account_data(oauth.site, token["access_token"])
    LinkedAccount.create!(user: user, site: oauth.site, api_key: token, account_id: account_id, account_data: account_data)
  end

  def get_account_data(site, access_token)
    case site
    when :discord
      response = http.headers(Authorization: "Bearer #{access_token}").get("https://discord.com/api/users/@me")
      account_data = response.parse
      account_id = account_data["id"]
    when :deviantart
      response = http.headers(Authorization: "Bearer #{access_token}").get("https://www.deviantart.com/api/v1/oauth2/user/whoami?expand=user.details,user.geo,user.profile,user.stats")
      account_data = response.parse
      account_id = account_data["userid"]
    end

    [account_id, account_data]
  end

  def http
    @http ||= Danbooru::Http.new
  end
end
