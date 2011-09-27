# Riparian

Riparian is a partial workflow system built with Delayed Job and Paperclip. It
consists of Flow Tasks, which are tasks to be performed by Delayed Job, and
Flow Task Resources, which constitute input and output data of the tasks. Flow
Task Resources can have an attached file, or a polymorphic relationship to an
ActiveRecord resource.

To make your own tasks, subclass FlowTask and implement the run method. Tasks
will be executed whenever Delayed Job gets to them.

If you need to alter Paperclip's path and url settings, you can add a
riparian.yml file to your config folder with the following settings:

    flow_task_resource_file_path: paperclip/interpolation/string
    flow_task_resource_file_url: paperclip/interpolation/string

Similarly you can set the max and min file sizes in bytes for file 
attachments:

    flow_task_resource_file_size_greater_than: 1 # Default: 1 byte
    flow_task_resource_file_size_less_than: 1024 # Default: 10 megabytes


# Example

    # generate controller, helper, and migration
    rails generate riparian
    
    # subclass FlowTask
    class MyTask < FlowTask
      def run
        open(inputs.first.file.path) do |f|
          txt = f.read
          txt.gsub! 'foo', 'bar'
          Tempfile.open('bar') do |tf|
            tf.write(txt)
            outputs.create(:file => tf)
          end
        end
      end
    end

Start POSTing stuff to /flow_tasks!
