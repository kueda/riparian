class FlowTaskInput < FlowTaskResource
  belongs_to :flow_task, :inverse_of => :inputs
end
