
if Rails.env.development?

  Activity.where.not(section_id: nil).delete_all # remote prep activities
  Prep.delete_all # remove prep sections

  repo = ContentRepository.create! github_username: 'lighthouse-labs', github_repo: '2016-web-curriculum-activities'

  default_activity_attributes = { 
    remote_content: true, 
    content_repository: repo, 
    duration: 15
  }

  prep_content = {
    'Prep Module 1' => [
      {
        name: 'What is the Web?',
        content_file_path: 'data/Prep Module 1/00__What Is The Web__Module Outline.md',
        duration: 15,
      }
    ]
  }

  i = 1
  prep_content.each do |section_name, activities|
    section =  Prep.create! name: section_name, order: i
    i += 1

    activities.each do |activity_attributes|
      section.activities.create! default_activity_attributes.merge(activity_attributes)
    end
  end

  # s2 = Prep.create! name: 'Prep Module 2', order: 2
  # s3 = Prep.create! name: 'Prep Module 3', order: 3
  # s4 = Prep.create! name: 'Prep Module 4', order: 4
  # s5 = Prep.create! name: 'Prep Module 5', order: 5



end