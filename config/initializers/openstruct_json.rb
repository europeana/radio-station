# Europeana::API returns `OpenStruct` instances, but serializing these to JSON
# adds other internal attributes not wanted.
#
# This extension prevents that.
require 'ostruct'

class OpenStruct
  def as_json(options = nil)
    @table.as_json(options)
  end
end
