require 'test_helper'

class FlowTaskResourceTest < ActiveSupport::TestCase
  load_schema

  def test_flow_task_resource_has_extra
    ft = FlowTask.new
    ft.inputs.build(:extra => "foo")
    ft.save
    ft.reload
    assert_equal "foo", ft.inputs.first.extra
  end

  def test_flow_task_resource_has_serialized_extra
    ft = FlowTask.new
    ft.inputs.build(:extra => ["foo"])
    ft.save
    ft.reload
    assert_equal "foo", ft.inputs.first.extra.first
  end

  def test_file_url
    ft = FlowTask.new
    ftr = ft.outputs.build
    assert_blank ftr.file_url
  end
end
