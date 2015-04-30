class Recording < ActiveRecord::Base

  belongs_to :presenter, :class => User
  belongs_to :cohort
  belongs_to :activity

  def s3_url
    @s3_url ||= Aws::S3::Presigner.new(client: Recording.s3_client).presigned_url(
        :get_object,
        bucket: cohort.program.recordings_bucket,
        key: s3_object_key,
        # Link expires after an hour
        expires_in: 3600
    )
  end

  def self.s3_client
    @@s3_client ||= Aws::S3::Client.new(
        region: ENV['REC_AWS_REGION'],
        access_key_id: ENV['REC_AWS_ACCESS_KEY'],
        secret_access_key: ENV['REC_AWS_SECRET_KEY']
    )
  end

  private

    def s3_object_key
      f = cohort.program.recordings_folder
      s = f ? f + '/' : ''
      s + file_name
    end

end
