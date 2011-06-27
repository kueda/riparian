ActiveRecord::Schema.define(:version => 0) do
  create_table "flow_task_resources", :force => true do |t|
    t.integer  "flow_task_id"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end
  
  create_table "flow_tasks", :force => true do |t|
    t.string   "type"
    t.string   "options"
    t.string   "command"
    t.string   "error"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "user_id"
    t.string   "redirect_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
