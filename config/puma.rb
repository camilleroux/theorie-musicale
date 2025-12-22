# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# You can control the number of workers using ENV["WEB_CONCURRENCY"]. You
# should only set this value when you want to run 2 or more workers. The
# default is already 1.
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default is set to 3 threads as it's deemed a good balance between
# throughput and latency. The default thread count should be considered
# an upper bound. Free Puma workers are often "quicker" than busy Puma workers
# and you should try to maximize how much time workers spend being free.
#
# If you're using a Solid* adapter or any other adapter that relies on
# Active Job to perform background work, you should make sure Active Job
# concurrency is at least as high as your max thread count. The default
# Active Job concurrency is 3, which is the same as the default Puma thread
# count.
#
# If you're also using Solid Cable, you should make sure that your Puma thread
# count is at least 1 less than your Active Job concurrency. This is because
# Solid Cable uses an async Active Job to handle connections, and if your
# Active Job concurrency is too low, Solid Cable may deadlock.
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
