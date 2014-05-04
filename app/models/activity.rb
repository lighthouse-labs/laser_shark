class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, format: { with: /\A(w\dd\d)|(w\de\d)\z/ }

  scope :chronological, -> { order(:start_time) }
  scope :for_day, -> (day) { where(day: day) }

  after_create :update_instructions_from_gist

  def update_instructions_from_gist
    if self.gist_url?
      github = Github.new
      gist = github.gists.get '99deb315bd062252d182'
      if readme = gist.files['README.md'].try(:content)
        self.instructions = readme
        self.save
      end
    end
  end

end
