# Note: For production only, so these ENV keys are not needed in .env on your local machine

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'] || 'x', # required
    :aws_secret_access_key  => ENV['AWS_SECRET_KEY'] || 'y', # required
    :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    :host                   => 's3.amazonaws.com',           # optional, defaults to nil
    :endpoint               => 'https://s3.amazonaws.com'    # optional, defaults to nil
  }
  config.fog_directory  = ENV['S3_BUCKET'] || 'z'            # required
  # config.fog_public   = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
