# Specifies how to respond to requests meeting particular criteria.
class Rule < ActiveRecord::Base
  has_many :hits, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :precedence, numericality: {only_integer: true}
  validates :method_pattern, presence: true
  validates :path_pattern, presence: true
  validates :response_status, numericality: {only_integer: true}
  validates :delay, numericality: {only_integer: true}
  validate :response_headers_parseable

  # Ensure pattern fields are valid regexes.
  validates_each :method_pattern, :path_pattern do |record, attribtue, value|
    begin
      Regexp.new value
    rescue RegexpError => error
      record.errors.add attribute, 'must be a valid regex'
    end
  end

  # Ensure the response headers can be parsed.
  def response_headers_parseable
    response_headers_hash
  rescue HeaderParseError => error
    errors.add :response_headers, " could not be parsed: #{error.message}"
  end

  # Trying to override one of the headers Rails normally sets
  # appears to require using the same casing it uses.
  NORMALIZED_HEADERS = {
    'date' => 'Date',
    'connection' => 'Connection',
    'content-length' => 'Content-Length',
    'x-ua-compatiable' => 'X-Ua-Compatible',
    'x-runtime' => 'X-Runtime',
    'server' => 'Server',
    'etag' => 'ETag',
    'content-type' => 'Content-Type',
    'cache-control' => 'Cache-Control'
  }

  # Return the regular expression that HTTP methods must match.
  def method_regex
    Regexp.new method_pattern, 'i'
  end

  # Return the regular expression that paths must match.
  def path_regex
    Regexp.new path_pattern, 'i'
  end

  # Parse user-supplied raw headers into a hash.
  def response_headers_hash
    return {} unless response_headers
    result = {}
    prev = nil
    response_headers.each_line do |line|
      next if line.blank?
      if line[0..0].blank?
        raise HeaderParseError.new('Leading whitespace on first header line') unless prev
        prev << line.lstrip
      else
        key, value = line.split(':', 2)
        raise HeaderParseError.new('Missing header name') if key.blank?
        key = NORMALIZED_HEADERS[key.downcase] || key
        prev = value.lstrip!
        result[key] = prev
      end
    end
    result
  end

  class HeaderParseError < StandardError
  end
end
