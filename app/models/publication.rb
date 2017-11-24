class Publication < ActiveRecord::Base
  include Indexable

  belongs_to :exporter_file
  has_and_belongs_to_many :authors, class_name: 'Person'
  has_many :project_publications, primary_key: :pmid, foreign_key: :pmid
  has_many :projects, through: :project_publications

  PUB_DATE_DICTIONARY = {
    /(1st Quarter|1st Quart|First Quarter)/  => "Jan 1",
    /(2nd Quarter|2nd Quart|Second Quarter)/ => "Apr 1",
    /(3rd Quarter|3d Quart|Third Quarter)/   => "Jul 1",
    /(4th Quarter|4th Quart|Fourth Quarter)/ => "Oct 1",
    /(Autumn|Fall)/ => "Sep 22",
    /(Summer|SUM)/ => "Jun 22",
    /Spring/ => "Mar 22",
    /Winter/ => "Dec 22"
  }

  def  core_project_num
    project_publications.pluck(:project_number)
  end

  def author_name
    author_list.to_s.gsub('<![CDATA[','').gsub(']]>','').split(';').map(&:strip)
  end

  def min_pub_date
    return nil unless pub_date

    string = pub_date.split(/(\-|\/)/).first.squish

    PUB_DATE_DICTIONARY.each do |k, v|
      string.gsub!(k, v)
    end

    string = string.gsub(' ', '/') if string =~ /\d{4} \d{1,2}/

    if string.size == 4
      Date.new(string.to_i, 1, 1)
    else
      begin
        Date.parse(string)
      rescue Exception => e
        passed = false
        puts "Cannot parse #{string}"
        nil
      end
    end
  end

  def self.pub_date_string_for_debug
    self.uniq.pluck(:pub_date)
        .reject(&:blank?)
        .map{ |d| d.split(/(\-|\/)/).first.squish }
        .map{ |d| d.split(' ').select{ |s| s=~ /\D/ } }
        .map{ |a| a.join(' ') }
        .reject(&:blank?)
        .uniq
        .sort
  end

  def self.dictionary_test
    passed = true

    pub_date_string_for_debug.map do |string|
      PUB_DATE_DICTIONARY.each do |k, v|
        string.gsub!(k, v)
      end

      string = "2010 #{string}"

      begin
        Date.parse(string)
      rescue Exception => e
        passed = false
        puts "Cannot parse #{string}"
      end
    end

    puts "OK" if passed
  end

  def as_indexed_json(options={})
    as_json except: [
              :author_list,
              :updated_at,
              :created_at
            ],
            methods:[
              :author_name,
              :core_project_num,
              :min_pub_date
            ]
  end
end
