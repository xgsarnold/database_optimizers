class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @memory_used = memory_in_mb
  end

  def search
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @memory_used = memory_in_mb
  end

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end



def seach

# SELECT
# FROM assemblies AS a
#   INNER JOIN sequences AS s On a.id = s.assembly_id
#   INNER JOIN genes AS g ON s.id = g.sequence_id
#   INNER JOIN hits AS h ON g.id = h.subject_id AND h.subject_type = "Gene"
# WHERE a.name LIKE "%?%"
#   OR g.dna LIKE "%?%"
#   OR h.match_gene_name LIKE "%?%";

  @hits = Hit.joins("JOIN genes ON genes.id = hits.subject_id AND hits.subject_type = 'Gene'")
      .joins("JOIN sequences ON sequences.id = genes.sequence_id")
      .joins("JOIN assemblies ON assemblies.id = sequences.assembly_id")
      .where("assemblies.name LIKE '%?%' OR genes.dna LIKE '%?%' OR hits.match_gene_name LIKE '%?%'",
      params[:search], params[:search], params[:search])

  @search = params[:search]
  @assembly = Assembly.includes([{:genes => dna, :hits => match_gene_name}])
