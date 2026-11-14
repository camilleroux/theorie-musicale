# /llms.txt: a Markdown map of the site for AI assistants (https://llmstxt.org)
class LlmsController < ApplicationController
  def show
    @chords = Chord.includes(:symbols).order(:id)
    @scales = Scale.includes(:modes).order(:id)
    expires_in 1.hour, public: true
    render formats: :text, content_type: 'text/plain'
  end
end
