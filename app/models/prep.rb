class Prep < Section 

  def self.evaluate_rating(data)
    total_tests = data[:test_passes] + data[:test_failures]

    # TODO: Change formal to what KV wants!
    # => Percentage of tests passed - 10% for every lint mistake
    ((data[:test_passes] / total_tests.to_f) - (0.1 * data[:lint_results])) * 3
  end

end