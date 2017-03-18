require 'grape'
require_relative 'record_collection'

module RecordDemoAPI
  class API < Grape::API
    format :json

    helpers do
      def record_collection
        file_path = "#{Dir.pwd}/data/output.txt"
        if File.exist?(file_path)
          @record_collection ||= RecordCollection.new(file_path)
        else
          @record_collection ||= RecordCollection.new
        end
      end
    end

    resource :records do
      desc 'Create a record from a pipe or comma delimited string'
      post do
        record_text = params[:record]
        success = record_collection.add_record(record_text)
        if !success
          error!(
            'Record must be a comma or pipe delimited string of four elements',
            400
          )
        else
          record_collection.save
          record_collection.display_records('none')
        end
      end

      desc 'Returns records sorted by birthdate in ascending order'
      get :birthdate do
        record_collection.display_records('date of birth')
      end

      desc 'Returns records sorted by last name in descending order'
      get :name do
        record_collection.display_records('last name')
      end
    end
  end
end
