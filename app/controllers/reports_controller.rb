class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @memory_used = memory_in_mb
  end

  def search
  end


  def result
    @start_time = Time.now
    @search = params[:search]
    @email = params[:email]
    CompileReportJob.perform_later(@search, @email)
    redirect_to reports_write_email_path
  end

  def import
  end

  def upload
    csv_upload = params[:file]
    MakeReportJob.perform_later(csv_upload.path)
  end

  def write_email
  end

  def send_email
  end



  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end





# SELECT
# FROM assemblies AS a
#   INNER JOIN sequences AS s On a.id = s.assembly_id
#   INNER JOIN genes AS g ON s.id = g.sequence_id
#   INNER JOIN hits AS h ON g.id = h.subject_id AND h.subject_type = "Gene"
# WHERE a.name LIKE "%?%"
#   OR g.dna LIKE "%?%"
#   OR h.match_gene_name LIKE "%?%";
