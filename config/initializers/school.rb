WEEKS                = (ENV['WEEKS'] || 8).to_i
DAYS_PER_WEEK        = (ENV['DAYS_PER_WEEK'] || 5).to_i
WEEKENDS             = ENV['WEEKENDS'] ? ENV['WEEKENDS'] == 'true' : false
CURRICULUM_UNLOCKING = ENV['CURRICULUM_UNLOCKING']
WEEKDAYS             = ENV['WEEKDAYS'].to_s.split(',') # eg: monday,wednesday
DAY_FEEDBACK_AFTER   = (ENV['DAY_FEEDBACK_AFTER'] || 64_800).to_i # seconds since beginning of day