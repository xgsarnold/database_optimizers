class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.search_results.subject
  #
  def search_results(email, path)
    @greeting = "Hello, attached is the report requested from the Umbrella Organization"

    attachments['report.csv'] = File.read(path)
    mail to: email, subject: "The report you requested."
  end
end
