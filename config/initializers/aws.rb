AWS.config(
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
)

BUCKET_NAME =  AWS::S3.new.buckets[ENV['BUCKET_NAME']]
