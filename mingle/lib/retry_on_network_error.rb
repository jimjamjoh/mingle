#  Copyright 2020 ThoughtWorks, Inc.
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

module RetryOnNetworkError
  NETWORK_EXCEPTIONS = [Timeout::Error, Errno::ECONNREFUSED, Errno::ECONNRESET, HTTParty::ResponseError, EOFError, Net::HTTPBadResponse, Net::ProtocolError]

  def with_retry(&block)
    interval = Rails.env.test? ? 0 : lambda { |tries| (tries + 1) * (tries + 1) }
    retryable({:on => NETWORK_EXCEPTIONS, :tries => 4, :sleep => interval }, &block)
  end

  def log_failed_try_on_exception(url, data, type, tries, exception)
    Rails.logger.warn %Q{
      Failed with #{exception.message} while:
        #{type} => #{url}
          {data.to_json unless type == "POST"}

        backtrace:\n\n#{exception.backtrace.join("\n")}
    } if exception
  end
end