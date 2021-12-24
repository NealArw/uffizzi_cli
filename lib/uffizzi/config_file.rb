# frozen_string_literal: true

require 'json'
require 'fileutils'

module Uffizzi
  class ConfigFile
    CONFIG_PATH = "#{Dir.home}/.uffizzi/config.json"

    class << self
      def create(account_id, cookie, hostname)
        write(prepare_config_data(account_id, cookie, hostname))
      end

      def delete
        File.delete(CONFIG_PATH) if exists?
      end

      def exists?
        File.exist?(CONFIG_PATH)
      end

      def read_option(option)
        data = read
        return nil if data.nil?

        puts "The option #{option} doesn't exist in config file" if data[option].nil?
        data[option]
      end

      def option_exists?(option)
        data = read
        return false if data.nil?

        data.key?(option)
      end

      def write_option(key, value)
        write({}) unless exists?
        data = read
        return nil if data.nil?

        data[key] = value
        write(data.to_json)
      end

      def delete_option(key)
        data = read
        return nil if data.nil?

        new_data = data.except(key)
        write(new_data.to_json)
      end

      def rewrite_cookie(cookie)
        write_option(:cookie, cookie)
      end

      def list
        data = read
        return nil if data.nil?

        data.each do |property, value|
          puts "#{property} - #{value}"
        end
      end

      private

      def read
        JSON.parse(File.read(CONFIG_PATH), symbolize_names: true)
      rescue Errno::ENOENT => e
        puts e
      rescue JSON::ParserError
        puts 'Config file is in incorrect format'
      end

      def write(data)
        file = create_file
        file.write(data)
        file.close
      end

      def prepare_config_data(account_id, cookie, hostname)
        data = {
          account_id: account_id,
          hostname: hostname,
          cookie: cookie,
        }

        data.to_json
      end

      def create_file
        dir = File.dirname(CONFIG_PATH)

        unless File.directory?(dir)
          FileUtils.mkdir_p(dir)
        end

        File.new(CONFIG_PATH, 'w')
      end
    end
  end
end
