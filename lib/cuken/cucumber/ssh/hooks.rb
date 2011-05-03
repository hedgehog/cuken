#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
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
#
Before('@ssh_local') do
  @aruba_io_wait_seconds.nil? || @aruba_io_wait_seconds < 0.3 ? @aruba_io_wait_seconds = 0.3 : @aruba_io_wait_seconds
end

Before('@ssh_remote') do
  @aruba_io_wait_seconds.nil? || @aruba_io_wait_seconds < 1 ? @aruba_io_wait_seconds = 1 : @aruba_io_wait_seconds
end

Before('@ssh_pigeon') do
  @aruba_io_wait_seconds.nil? || @aruba_io_wait_seconds < 3 ? @aruba_io_wait_seconds = 3 : @aruba_io_wait_seconds
end

Before('@ssh_dodo') do
  @aruba_io_wait_seconds.nil? || @aruba_io_wait_seconds < 10 ? @aruba_io_wait_seconds = 10 : @aruba_io_wait_seconds
end
