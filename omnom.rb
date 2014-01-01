require 'nemah'
require 'sinatra'
require 'slim'

if development?
  require 'byebug'
  require 'sinatra/reloader'
end

get '/' do
  get_or_default_params

  slim :index
end

post '/' do
  get_or_default_params
  @need = calculate_need_for

  slim :index
end

private

[:weight, :gender, :feedability, :walk, :trot_and_canter, :days_per_week].each do |attribute|
  define_method(attribute) { instance_variable_get("@#{attribute}") }
end

def get_or_default_params
  @weight = params[:weight].to_i
  @gender = params[:gender] || ''
  @feedability = params[:feedability] || ''
  @walk = params[:walk].to_i
  @trot_and_canter = params[:trot_and_canter].to_i
  @days_per_week = params[:days_per_week].to_i
end

def calculate_need_for
  workload = Nemah::Workload.new(walk: walk, trot_and_canter: trot_and_canter, days_per_week: days_per_week)
  horse = Nemah::Horse.new(weight: weight, gender: gender.to_sym, feedability: feedability.to_sym, workload: workload)
  need = Nemah::Need.new(horse)
end

module Nemah
  module SpecificNeed
    class AbstractNeed
      def to_s
        "#{min} #{unit}"
      end
    end
  end
end
