class Recording < ActiveRecord::Base

  belongs_to :presenter, :class => User
  belongs_to :cohort
  belongs_to :activity
  belongs_to :program

  validates :program, presence: true
  validate :ensure_program_has_recordings_bucket, if: :program

  def s3_url
    @s3_url ||= Recording.s3_presigner.presigned_url(
        :get_object,
        bucket: program.recordings_bucket,
        key: s3_object_key,
        # Link expires after an hour
        expires_in: 3600
    )
  end

  def self.s3_presigner
    @@s3_presigner ||= Aws::S3::Presigner.new(
        client: s3_client
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

    def ensure_program_has_recordings_bucket
      unless program.recordings_bucket
        errors.add :program, 'associated program must specify recordings bucket'
      end
    end

    def s3_object_key
      f = cohort.program.recordings_folder
      s = f ? f + '/' : ''
      s + file_name
    end

end
