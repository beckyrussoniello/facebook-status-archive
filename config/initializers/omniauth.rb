Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, Facebook::APP_ID, Facebook::SECRET,
		scope: 'read_stream'
end
