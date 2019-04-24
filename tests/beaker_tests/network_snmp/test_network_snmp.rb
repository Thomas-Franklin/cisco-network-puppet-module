###############################################################################
# Copyright (c) 2017-2018 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
#
# See README-develop-beaker-scripts.md (Section: Test Script Variable Reference)
# for information regarding:
#  - test script general prequisites
#  - command return codes
#  - A description of the 'tests' hash and its usage
#
###############################################################################
require File.expand_path('../../lib/utilitylib.rb', __FILE__)

# Test hash top-level keys
tests = {
  agent:         agent,
  master:        master,
  resource_name: 'network_snmp',
  ensurable:     false,
}

# Skip -ALL- tests if a top-level platform/os key exludes this platform
skip_unless_supported(tests)

# Test hash test cases
tests[:unset] = {
  desc:           '1.1 Unset Properties',
  title_pattern:  'default',
  manifest_props: {
    enable:   true,
    contact:  'unset',
    location: 'unset',
  },
  code:           [0, 2],
}

#
# Set Properties
#
tests[:set] = {
  desc:           '2.1 Set Properties',
  title_pattern:  'default',
  manifest_props: {
    enable:   true,
    contact:  'SysAdmin',
    location: 'UK',
  },
}

def cleanup(agent)
  test_set(agent, 'no snmp-server contact')
  test_set(agent, 'no snmp-server location')
end

#################################################################
# TEST CASE EXECUTION
#################################################################
test_name "TestCase :: #{tests[:resource_name]}" do
  teardown { cleanup(agent) }
  cleanup(agent)

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 1. Set Property Testing")
  test_harness_run(tests, :set)

  # # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 2. Unset Property Testing")
  test_harness_run(tests, :unset)
end
logger.info("TestCase :: #{tests[:resource_name]} :: End")