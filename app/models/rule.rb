# Specifies how to respond to requests meeting particular criteria.
class Rule < ActiveRecord::Base
  has_many :hits, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :precedence, numericality: {only_integer: true}
  validates :method_pattern, presence: true
  validates :path_pattern, presence: true
  validates :response_status, numericality: {only_integer: true}

  # Ensure pattern fields are valid regexes.
  validates_each :method_pattern, :path_pattern do |record, attribtue, value|
    begin
      Regexp.new value
    rescue RegexpError => error
      record.errors.add attribute, 'must be a valid regex'
    end
  end

  # Return the regular expression that HTTP methods must match.
  def method_regex
    Regexp.new method_pattern, 'i'
  end

  # Return the regular expression that paths must match.
  def path_regex
    Regexp.new path_pattern, 'i'
  end
end
