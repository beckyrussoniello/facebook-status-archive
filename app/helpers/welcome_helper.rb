module WelcomeHelper

def toggler
  # Update the page by toggling the element "hiddendiv".
  render :update do |page|
    page["hiddendiv"].toggle
    # The text of the link which triggered this method 
    # switches back and forth between "+ choose dates"
    # and "- hide" depending on whether the div is currently
    # being displayed.
    page << "if($('toggler').innerHTML == '+ choose dates'){"
    page <<   "$('toggler').innerHTML = '- hide';"
    page << "}else{"
    page <<   "$('toggler').innerHTML = '+ choose dates';"
    page << "};return false;"
  end
end

end
