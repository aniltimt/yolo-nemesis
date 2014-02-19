Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, "301860719826303", "76183d671e874849c8573270b9705008", {:display => 'touch', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  else
    provider :facebook, "166085116805762", "ebf9bc8d9c590a9b73114452db90ae30", {:display => 'touch', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  end

  provider :twitter, "wyhKTIpU0ozDfhSHm7lmQ", "tHLmujgL2QjZ6RAciM4SHC8QX2i3RsHkMfNsC7cmf8", {:display => 'touch', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
