class FlowTaskOutput < FlowTaskResource
  belongs_to :flow_task, :inverse_of => :outputs
end
