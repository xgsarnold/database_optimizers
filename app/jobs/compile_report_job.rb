class CompileReportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
     results = []
     @search.split(" ").each do |w|
       q = "%#{w}%"
       results += Hit.where("match_gene_name LIKE ?", q)
       results += Hit.where(subject: Gene.joins(sequence: :assembly).where("genes.dna LIKE ? OR sequences.dna LIKE ? OR assemblies.name LIKE ?", q, q, q))
     end
     @hits = results.uniq

    csv_export = CSV.generate do |csv|
      csv << ["Matching Gene Name", "Matching Gene DNA", "Percent Similarity"]
      @hits.each do |hit|
        csv << [hit.match_gene_name, hit.match_gene_dna, hit.percent_similarity]
      end
    end

    send_data csv_export,
    :type => 'text/csv; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=reports.csv"
  end
end
