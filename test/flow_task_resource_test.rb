require 'test_helper'

class FlowTaskResourceTest < ActiveSupport::TestCase
  load_schema

  def test_flow_task_resource_has_extra
    ft = FlowTask.new
    ft.inputs.build(:extra => "foo")
    ft.save
    ft.reload
    puts "ft.inputs.first.extra: #{ft.inputs.first.extra}"
    assert_equal "foo", ft.inputs.first.extra
  end

  def test_flow_task_resource_has_serialized_extra
    ft = FlowTask.new
    ft.inputs.build(:extra => ["foo"])
    ft.save
    ft.reload
    puts "ft.inputs.first.extra: #{ft.inputs.first.extra}"
    assert_equal "foo", ft.inputs.first.extra.first
  end
end