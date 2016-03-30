require 'csv'

class CompileReportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    results = []
    @search = args[0]
    @email = args[1]
    @search.split(" ").each do |w|
      q = "%#{w}%"
      results += Hit.where("match_gene_name LIKE ?", q)
      results += Hit.where(subject: Gene.joins(sequence: :assembly).where("genes.dna LIKE ? OR sequences.dna LIKE ? OR assemblies.name LIKE ?", q, q, q))
    end
    @hits = results.uniq

    file_path = Rails.root.join("tmp", "report#{rand(10000)}.csv")
    CSV.open(file_path, "w") do |csv|
      csv << ["Matching Gene Name", "Matching Gene DNA", "Percent Similarity"]
      @hits.each do |hit|
        csv << [hit.match_gene_name, hit.match_gene_dna.first(100), hit.percent_similarity]
      end
    end

    AWS.config(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )

    s3 =  AWS::S3.new

    bucket = s3.buckets[ENV['BUCKET_NAME']]

    obj = bucket.objects["report_#{Time.now}"]

    obj.write(
      file: file_path,
      acl: :public_read
    )

    ReportMailer.search_results(@email, obj.public_url).deliver_now
  end
end
