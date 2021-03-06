#
# Copyright 2015 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'egon'
require 'fog'

module Actions
  module Fusor
    module Deployment
      module OpenStack
        # Create the Openstack Compute Resource in Foreman
        class CreateCr < Actions::Fusor::FusorBaseAction
          def humanized_name
            _('Create the Openstack Compute Resource in Foreman')
          end

          def plan(deployment)
            super(deployment)
            plan_self(deployment_id: deployment.id)
          end

          def run
            ::Fusor.log.debug '====== Openstack Compute Resource run method ======'
            retries = 5
            begin
              deployment = ::Fusor::Deployment.find(input[:deployment_id])
              cr = { "name" => "#{deployment.label}-RHOS",
                     "location_ids" => ["", Location.where(:name => "Default Location").first.id],
                     "url" => "https://#{deployment.openstack_deployment.overcloud_hostname}:13000/v2.0/tokens",
                     "provider" => "Foreman::Model::Openstack", "user" => 'admin',
                     "password" => deployment.openstack_deployment.overcloud_password,
                     "organization_ids" => [deployment.organization_id], "tenant" => deployment.label }
              ::Foreman::Model::Openstack.create(cr)
            rescue
              if retries > 0
                retries -= 1
                sleep 30
                retry
              else
                raise
              end
            end
            ::Fusor.log.debug '=== Leaving Openstack Compute Resource run method ==='
          end
        end
      end
    end
  end
end
