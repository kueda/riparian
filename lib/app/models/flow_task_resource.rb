class FlowTaskResource < ActiveRecord::Base
  belongs_to :flow_task
  belongs_to :resource, :polymorphic => true
  has_attached_file :file,
    :path => ":rails_root/public/system/:class/:id/:filename",
    :url => "/system/:class/:id/:filename"
  validates_attachment_size :file, :greater_than => 1.byte
end
