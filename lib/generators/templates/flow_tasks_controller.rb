class FlowTasksController < ApplicationController
  before_filter :load_flow_task, :only => [:show, :destroy, :run]
  
  def index
    @flow_tasks = FlowTask.order("id desc").paginate(:page => params[:page])
  end
  
  def show
    respond_to do |format|
      format.html
      format.json { render :json => @flow_task.as_json(:include => [:inputs, :outputs]) }
    end
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
    respond_to do |format|
      if @flow_task.save
        format.html do
          redirect_to run_flow_task_path(@flow_task)
        end
        format.json { render :json => @flow_task }
      else
        msg = "Failed to save task: " + @flow_task.errors.full_messages.to_sentence
        format.html do
          flash[:error] = msg
          redirect_back_or_default('/')
        end
        format.json do
          render :json => {:error => msg}, :status => :unprocessable_entity
        end
      end
    end
  end
  
  def run
    delayed_progress(request.path) do
      @job = Delayed::Job.enqueue(@flow_task)
    end
    respond_to do |format|
      format.html
      format.json do
        status = case @status
        when "done" then :success
        when "error" then :unprocessable_entity
        else
          202
        end
        render :json => @flow_task.as_json(:include => [:inputs, :outputs]), :status => status
      end
    end
  end
  
  def destroy
    @flow_task.destroy
    flash[:notice] = "Flow task destroyed"
    redirect_to flow_tasks_path
  end
  
  private
  
  def load_flow_task
    return true if @flow_task = FlowTask.find_by_id(params[:id])
    flash[:error] = "That task doesn't exist"
    redirect_to flow_tasks_path
    false
  end
  
  # Encapsulates common pattern for actions that start a bg task get called 
  # repeatedly to check progress
  # Key is required, and a block that assigns a new Delayed::Job to @job
  def delayed_progress(key)
    @tries = params[:tries].to_i
    if @tries > 20
      @status = @error
      @error_msg = "This is taking forever.  Please try again later."
      return
    end
    @job_id = Rails.cache.read(key)
    @job = Delayed::Job.find_by_id(@job_id)
    if @job_id
      if @job && @job.failed_at
        @status = "error"
        @error_msg = @job.last_error
      elsif @job
        @status = "working"
      else
        @status = "done"
        Rails.cache.delete(key)
      end
    else
      @status = "start"
      yield
      Rails.cache.write(key, @job.id)
    end
  end
  
end
