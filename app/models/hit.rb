# Records a request that matched a rule.
# A portion of the Rack request env, including HTTP headers,
# is stored in env.
class Hit < ActiveRecord::Base
  belongs_to :rule

  validates :env, presence: true

  serialize :env, Hash
end