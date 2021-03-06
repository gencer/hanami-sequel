module Hanami
  module Sequel
    module CLI
      class Create < Hanami::CLI::Command
        def call(**options)
          Command.create
        end
      end
    end

    module Command
      def self.create
        env = Hanami::Environment.new
        if env.environment == 'production'
          raise 'Command unavailable in the production environment.'
        end

        db_url = ENV.fetch('DATABASE_URL')
        db_conn, _, db_name = db_url.rpartition('/')

        require 'sequel'

        db = ::Sequel.connect("#{db_conn}/postgres",
                              loggers: Logger.new($stdout))
        db.run("CREATE DATABASE #{db_name}")
      end
    end
  end
end

Hanami::CLI.register 'sequel create', Hanami::Sequel::CLI::Create
