host = ENV["SSH_CLIENT"] ? ENV["SSH_CLIENT"].match(/\A([^\s]*)/)[1] : nil
BetterErrors::Middleware.allow_ip! host if [:development, :test].member?(Rails.env.to_sym) && host