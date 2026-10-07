class IntervalsController < ApplicationController
  before_action :find_key, :only => [:show, :piano]

  def index
    @intervals = Interval.all.sort
  end

  def show
    interval = find_interval(params[:id]) or raise ActionController::RoutingError, 'Not Found'
    # Links in the wild use other cases ("5j", "6m-sixte+majeure") or encodings: redirect them to the canonical URL
    if params[:id] != interval.to_param
      return redirect_to (@key ? key_interval_url(@key, interval) : interval_url(interval)), status: :moved_permanently
    end

    @interval = Interval.new_from_symbol(interval.symbol, true)
    @interval = @interval.in_key_of(@key) if @key
  end

  def piano
    interval = find_interval(params[:id]) or raise ActionController::RoutingError, 'Not Found'
    interval = Interval.new_from_symbol(interval.symbol, true)
    interval = interval.in_key_of(@key) if @key

    expires_in 1.month, public: true
    render plain: PianoDiagram.new(interval.keys).to_svg(title: helpers.piano_diagram_alt(interval)), content_type: 'image/svg+xml'
  end

  protected

  # The name is trusted over the symbol, which loses its meaning once lowercased (m/M)
  def find_interval(slug)
    symbol, name = slug.split('-', 2)
    name = CGI.unescape(name.to_s).downcase
    Interval.all.find { |i| i.long_name.downcase == name } || Interval.all.find { |i| i.symbol == symbol }
  end

  def find_key
    if params[:key_id]
      @key = Key[params[:key_id]]
    end
  end
end
