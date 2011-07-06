class FlowTaskResource < ActiveRecord::Base
  belongs_to :flow_task
  belongs_to :resource, :polymorphic => true
  has_attached_file :file,
    :path => Riparian.config.flow_task_resource_file_path
    :url => Riparian.config.flow_task_resource_file_url
end
