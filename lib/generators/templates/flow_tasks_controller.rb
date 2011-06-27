class FlowTasksController < ApplicationController
  before_filter :load_flow_task, :only => [:show, :destroy, :run]
  
  def index
    @flow_tasks = FlowTask.order("id desc").paginate(:page => params[:page])
  end
  
  def show
  end
  
  def new
    klass = params[:type].camlize.constantize rescue FlowTask
    @flow_task = klass.new
  end
  
  def create
    class_name = params.keys.detect{|k| k =~ /flow_task/}
    klass = class_name.camelize.constantize rescue FlowTask
    @flow_task = klass.new(params[class_name])
    @flow_task.user = current_user
    if @flow_task.save
      flash[:notice] = "Flow task created"
      redirect_to run_flow_task_path(@flow_task)
    else
      render :new
    end
  end
  
  def run
    delayed_progress(request.path) do
      @job = Delayed::Job.enqueue(@flow_task)
    end
  end
  
  def destroy
    @flow_task.destroy
    flash[:notice] = "Flow task destroyed"
    redirect_to_back_or(flow_tasks_path)
  end
  
  private
  
  def load_flow_task
    return true if @flow_task = FlowTask.find_by_id(params[:id])
    flash[:error] = "That task doesn't exist"
    redirect_to_back_or(flow_tasks_path)
    false
  end
  
end
