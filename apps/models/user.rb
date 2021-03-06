class User < ActiveRecord::Base
    has_many :games
    has_many :levels, through: :games

    def attempts
        self.games.order(:user_id)
    end

    def attempts_by_level
        arrLevel = [1,2,3,4,5,6,7,8,9,10]
        att_array = []
        arrLevel.each do |level| 
            att_array << self.games.where(level_id: level)
        end
        att_array
    end

    def completions
        attempts.where("completion_time > 0")
    end

    def completions_by_level
        arrLevel = [1,2,3,4,5,6,7,8,9,10]
        comp_array = []
        arrLevel.each do |level|
           x = self.games.where(level_id: level) 
           comp_array << x.select {|time| time.completion_time != nil}
        end
        comp_array
    end

    def success_rate
        puts
        puts "              #{(completions.count.to_f / attempts.count.to_f) * 100.0}"
    end

    def highest_level
        if nil == self.games.order(:level_id).last
            return 1
        else
            x = self.games.where("completion_time > 0").order(:level_id).last
        end
        x.level_id + 1
    end

    def fastest_completions

        arrLevel = [1,2,3,4,5,6,7,8,9,10]
        fc = []
        arrLevel.each do |level| 
            fc << self.games.where(level_id: level).order(:completion_time).first
        end

        fc.length.times do |i|
            puts
            if fc[i] != nil
                if nil != fc[i].completion_time
                    puts "  Level #{i+1}: #{fc[i].completion_time}s"
                elsif nil == fc[i].completion_time
                    puts "  Level #{i+1}: Level incompleted"
                end
            end
        end

    end
end