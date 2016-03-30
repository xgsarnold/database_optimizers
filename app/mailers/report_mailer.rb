class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.search_results.subject
  #
  def search_results(email, link)
    @greeting = "Hello, follow the link to find the report requested from the Umbrella Organization. #{link}"

    mail to: email, subject: "The report you requested."
  end
end
