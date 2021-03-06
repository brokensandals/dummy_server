class RulesController < ApplicationController
  # GET /rules
  def index
    @rules = Rule.order('precedence')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /rules/1
  def show
    @rule = Rule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /rules/new
  def new
    @rule = Rule.new precedence: 5,
                     method_pattern: '.*',
                     path_pattern: '^/.*$',
                     response_status: 200,
                     delay: 0

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /rules/1/edit
  def edit
    @rule = Rule.find(params[:id])
  end

  # POST /rules
  def create
    @rule = Rule.new(params[:rule])

    respond_to do |format|
      if @rule.save
        format.html { redirect_to @rule, notice: 'Rule was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /rules/1
  def update
    @rule = Rule.find(params[:id])

    respond_to do |format|
      if @rule.update_attributes(params[:rule])
        format.html { redirect_to @rule, notice: 'Rule was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /rules/1
  def destroy
    @rule = Rule.find(params[:id])
    @rule.destroy

    respond_to do |format|
      format.html { redirect_to rules_url }
    end
  end

  # POST /rules/1/clear
  # Can pass 'referrer' param to control redirect.
  def clear
    @rule = Rule.find(params[:id])
    @rule.hits.destroy_all

    respond_to do |format|
      format.html { redirect_to params[:referrer] || @rule }
    end
  end

  # /*
  def hit
    rule = Rule.order(:precedence).detect do |rule|
      request.method =~ rule.method_regex and request.path_info =~ rule.path_regex
    end

    if rule
      rule.hits.create env: env_hash,
                       body: request.raw_post
      sleep rule.delay if rule.delay > 0
      response.status = rule.response_status
      headers.merge! rule.response_headers_hash
      response.body = rule.response_text
      render text: response.body
    else
      raise ActionController::RoutingError.new('No matching route or rule')
    end
  end

private

  # Return a hash of the headers, with some dull ones filtered out.
  def env_hash
    hash = {}
    request.env.each do |key, value|
      hash[key] = value if key =~ /^(HTTP|REQUEST|REMOTE).*/
    end
    puts hash.to_s
    hash
  end
end
