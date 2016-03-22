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


# When attempting to consolidate queires in, for example, the search action,
# it may be useful to use .includes methods like one of the following:
# @assembly = Assembly.where(name: params[:search])
# @gene = Gene.where(dna: params[:search])
# @hit = Hit.where(match_gene_name: params[:search])
# @assembly = Assembly.includes([:genes, :hits])
