class MakeReportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    CSV.open(args[0], headers: true) do |c|
      c.each do |l|
        a = Assembly.find_by(name: l["Assembly Name"])
        unless a
          a = Assembly.create(name: l["Assembly Name"], run_on: Date.today)
        end
        s = Sequence.find_by(dna: l["Sequence"])
        unless s
          s = Sequence.create(assembly_id: a.id, dna: l["Sequence"], quality: l["Sequence Quality"])
        end
        g = Gene.find_by(dna: l["Gene"])
        unless g
          g = Gene.create(sequence_id: s.id, dna: l["Gene"], starting_position: l["Gene Starting Position"], direction: l["Gene Direction"])
        end
        Hit.create(subject_id: g.id, subject_type: "Gene", match_gene_name: l["Hit Name"], match_gene_dna: l["Hit Sequence"], percent_similarity: l["Hit Similarity"])
      end
    end
  end
end
