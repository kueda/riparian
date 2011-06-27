module FlowTasksHelper
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