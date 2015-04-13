Date::DATE_FORMATS[:friendly] = lambda { |date| date.strftime("%B #{date.day.ordinalize} %Y") }
Date::DATE_FORMATS[:short_friendly] = lambda { |date| date.strftime("%b #{date.day}") }

Time::DATE_FORMATS[:friendly] = lambda { |date| date.strftime("%B #{date.day.ordinalize} %Y") }
Time::DATE_FORMATS[:short_friendly] = lambda { |date| date.strftime("%b #{date.day}") }