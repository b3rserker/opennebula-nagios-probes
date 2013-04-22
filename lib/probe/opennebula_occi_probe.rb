###########################################################################
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##    http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
###########################################################################

require 'nagios-probe'
require 'occi/client'

#
class OpenNebulaOcciProbe < Nagios::Probe

  attr_writer :logger

  #
  def check_crit

    @logger.info "Checking for basic connectivity at " + @opts.protocol.to_s + "://" + @opts.hostname + ":" + @opts.port.to_s + @opts.path

    connection = Occi::Client.new(
        :host     => @opts.hostname,
        :port     => @opts.port,
        :scheme   => @opts.protocol,
        :user     => @opts.username,
        :password => @opts.password
    )

    begin
      # make a few simple queries just to be sure that the service is running
      connection.network.all
      connection.compute.all
      connection.storage.all
    rescue Exception => e
      @logger.error "Failed to check connectivity: " + e.message
      return true
    end

    false
  end

  #
  def check_warn

    @logger.info "Checking for resource availability at " + @opts.protocol.to_s + "://" + @opts.hostname + ":" + @opts.port.to_s + @opts.path

    # there is nothing to test in this stage
    if @opts.network.nil? && @opts.storage.nil? && @opts.compute.nil?
      @logger.info "There are no resources to check, for details on how to specify resources see --help"
      return false
    end

    connection = Occi::Client.new(
        :host     => @opts.hostname,
        :port     => @opts.port,
        :scheme   => @opts.protocol,
        :user     => @opts.username,
        :password => @opts.password
    )

    begin
      # iterate over given resources
      unless @opts.network.nil?
        @logger.info "Looking for networks: " + @opts.network.inspect
        result = @opts.network.collect {|id| connection.network.find id }
        @logger.debug result
      end

      unless @opts.compute.nil?
        @logger.info "Looking for compute instances: " + @opts.compute.inspect
        result = @opts.compute.collect {|id| connection.compute.find id }
        @logger.debug result
      end

      unless @opts.storage.nil?
        @logger.info "Looking for storage volumes: " + @opts.storage.inspect
        result = @opts.storage.collect {|id| connection.storage.find id }
        @logger.debug result
      end
    rescue Exception => e
      @logger.error "Failed to check resource availability: " + e.message
      return true
    end

    false
  end

  #
  def crit_message
    "Failed to establish connection with the remote server"
  end

  #
  def warn_message
    "Failed to query specified remote resources"
  end

  #
  def ok_message
    "Remote resources successfully queried"
  end
end
