namespace :projects do
  task :jsonify_terms => :environment do
    puts "Started jsonifying project terms"

    count = 0
    Project
    .where("terms = '{}'")
    .where.not(project_termsx: nil)
    .find_each do |project|
      project.terms = instance_eval(project.project_termsx.to_s).as_json["term"]
      project.save
      count += 1
      puts count if count % 100 == 0
    end
    puts "Finished jsonifying project terms"
  end

  # task :fix_project_terms => :environment do
  #   puts "Started fixing project terms"

  #   ActiveRecord::Base.connection.execute %q[
  #     UPDATE projects
  #     SET project_terms = project_termsx
  #     WHERE project_terms SIMILAR TO '"%' AND project_termsx SIMILAR TO '{%'
  #   ]

  #   puts "Finished fixing project terms"
  # end

  task :fix_nih_spending_cats => :environment do
    puts "Started fixing project spending cats"

    ActiveRecord::Base.connection.execute %q[
      UPDATE projects
      SET nih_spending_cats = REPLACE(nih_spending_cats, ':category=>', '"category":')
      WHERE nih_spending_cats SIMILAR TO '\{:category=>%'
    ]

    puts "Finished fixing project spending cats"
  end

  task :jsonify_spending_cats => :environment do
    puts "Started jsonifying spending cats"

    count = 0
    Project
    .where("project_terms = 'null' OR project_terms IS NULL")
    .where.not(project_termsx: nil)
    .find_each do |project|
      project.project_terms = instance_eval(project.project_termsx.to_s).to_json
      project.save
      count += 1
      puts count if count % 100 == 0
    end

    puts "Finished jsonifying spending cats"
  end

  task :fix_award_notice_dates => :environment do
    puts "Started fixing award notice dates. For example: 2999/01/01"

    count = 0
    Project
    .where("award_notice_date > ?", 10.years.from_now) #
    .find_each do |project|
      project.award_notice_date = nil
      project.save
      project.__elasticsearch__.index_document
      count += 1
      puts count if count % 100 == 0
    end

    puts "Finished fixing award notice dates"
  end

  task :fix => [:jsonify_terms, :fix_project_terms, :fix_nih_spending_cats, :jsonify_spending_cats]
end
