module UsersHelper

# THREE MOST RECENT APICALLS - 
  # Loops through the user's past apicalls to collect the
  # most recent three.
  def three_most_recent_apicalls(user)
    @i = 0 
    recent_history = []
    history = sorted_history(user)
    for apicall in history do
      recent_history << apicall
      if @i == 2
        break
      end
      @i += 1
    end
    return recent_history
  end

# SORTED HISTORY - 
  # Sorts the user's past Apicalls with the most recent first.
  def sorted_history(user)
    return (user.apicalls.sort do |a,b| b.created_at <=> a.created_at end)
  end

# PLURALIZE STATUSES - 
  def pluralize_statuses(apicall) 
     if apicall.statuses.size == 1
       statuses = " status" 
     else 
       statuses = " statuses" 
     end  
     return statuses 
  end

# FIND ACTION - 
  # Determines which action to link to, based on the
  # apicall's output_format.
  def find_action(apicall)
    if apicall[:output_format] == "Rich Text" 
      action = "rtf" 
    elsif apicall[:output_format] == "HTML" 
      action = "show" 
    end 
    return action
  end

# ATTRIBUTE EMPTY? - 
  # If the attribute is nil or contains an empty String, it is
  # considered empty.
  def attribute_empty?(apicall, field)
    if (apicall[field.to_sym].nil? || apicall[field.to_sym].length < 1)
      return true
    else
      return false
    end
  end
end
