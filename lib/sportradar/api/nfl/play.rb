module Sportradar
  module Api
    class Nfl::Play < Data
      attr_accessor :response, :id, :sequence, :reference, :clock, :home_points, :away_points, :type, :play_clock, :wall_clock, :start_situation, :end_situation, :description, :alt_description, :statistics, :score, :scoring_play, :team_id, :player_id

      def initialize(data)
        @response = data
        @alt_description = data["alt_description"]
        @away_points = data["away_points"]
        @clock = data["clock"]
        @description = data["description"]
        @end_situation = Sportradar::Api::Nfl::Situation.new data["end_situation"] if data["end_situation"]
        @team_id = end_situation.team_id if end_situation
        @home_points = data["home_points"]
        @id = data["id"]
        @play_clock = data["play_clock"]
        @reference = data["reference"]
        @score = data["score"]
        @scoring_play = data["scoring_play"]
        @sequence = data["sequence"]
        @start_situation = Sportradar::Api::Nfl::Situation.new data["start_situation"] if data["start_situation"]
        @statistics = OpenStruct.new data["statistics"] if data["statistics"] # TODO Implement statistics?
        @type = data["type"]
        @wall_clock = data["wall_clock"]
      end

      def player_id
        @player_id ||= begin
          if @statistics
            play_stats = @statistics.penalty || @statistics.rush || @statistics.return || @statistics.receive
            if play_stats
              @player_id = play_stats.is_a? Hash ? play_stats.dig('player', 'id') : play_stats.dig(0, 'player', 'id')
            end
          end
        end
      end

    end
  end
end
