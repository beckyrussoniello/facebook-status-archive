module FormatRtf
require '/home/becky/PORTFOLIO/status-archive/vendor/plugins/rtf-extensions/rtf/utf8'
require '/home/becky/PORTFOLIO/status-archive/vendor/plugins/rtf-extensions/rtf/hyperlink'

# This module takes a set of statuses and uses the ruby-rtf plugin to create an RTF document 
# which displays them.  The resulting document has a header, a separate "paragraph" for each
# status (which displays the date, time, and status message), and a link to archive-fb.com at 
# the end.  The finished document is returned to the controller.

# DEFINE STYLES FOR RTF IN A HASH CALLED '@styles'
    @styles = {}
    @styles['HEADER'] = RTF::CharacterStyle.new
    @styles['HEADER'].font_size = 38
    @styles['HEADER'].bold = true
    @styles['DATETIME'] = RTF::CharacterStyle.new
    @styles['DATETIME'].bold = true
    @styles['DATETIME'].font = RTF::Font.new(RTF::Font::MODERN, 'Courier New')
    @styles['DATETIME'].font_size = 25
    @styles['MESSAGE'] = RTF::CharacterStyle.new
    @styles['MESSAGE'].font_size = 32

# FORMAT DOCUMENT (the module's primary method)
  def FormatRtf.format(user, apicall_statuses)
    # initialize the RTF document
    status_archive = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Arial'))
    # format the header
    FormatRtf.format_header(status_archive, user)

    # for each status, write a paragraph with the date, time, and status message.
    for status in apicall_statuses
      status_archive.paragraph() do |p|
        FormatRtf.write_datetime(p, status)
        FormatRtf.write_message(p, status)
      end
    end
    # add link to the end of the document
    FormatRtf.add_link(status_archive)
    # return the finished document to the controller
    return status_archive
  end

# FORMAT HEADER
  def FormatRtf.format_header(document, user)
    # use styles for header
    document.paragraph(@styles['HEADER']) do |h|
        # include the user's first and last name in the header
        h << "Status Archive for " + user.first_name.upcase + " " + user.last_name.upcase
        # follow with a line break
        h.line_break
     end 
  end

# WRITE DATETIME
  def FormatRtf.write_datetime(p, status)
    # use styles for 'datetime'
    p.apply(@styles['DATETIME']) do |n1|
      n1 << status.datetime_string
      n1.line_break
    end

  end

# WRITE MESSAGE
  def FormatRtf.write_message(p, status)
     # use styles for message
     p.apply(@styles['MESSAGE']) do |n2|
          n2 << status.message
          n2.line_break
          n2.line_break
        end
  end

# ADD WEBSITE LINK AT THE END OF THE DOCUMENT
  def FormatRtf.add_link(document)
    document.line_break
    document << "Download your statuses at "
    document.hyperlink('http://archive-fb.com', 'http://archive-fb.com')
    document << "!"
  end


end
