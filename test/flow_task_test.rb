require 'test_helper'

class FlowTaskTest < ActiveSupport::TestCase
  load_schema
  
  def test_flow_task
    assert_kind_of FlowTask, FlowTask.new
  end
end
