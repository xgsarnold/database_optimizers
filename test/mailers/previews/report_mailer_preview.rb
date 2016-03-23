# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/report_mailer/search_results
  def search_results
    ReportMailer.search_results
  end

end
