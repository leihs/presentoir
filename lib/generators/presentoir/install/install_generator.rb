module Presentoir
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_application_presenter
        template 'application_presenter.rb', 'app/presenters/application_presenter.rb'
      end
      def copy_application_record_presenter
        template 'application_record_presenter.rb', 'app/presenters/application_record_presenter.rb'
      end
    end
  end
end
