module ReviewsHelper
  def server_public_key(path = "~/.ssh/id_rsa.pub")
    `cat #{path}`
  end

  # very basic output for now
  # this needs a serious refactor
  def display_diff_summary(diff_summary)
    disp_text = ""
    disp_text += "<div class='codeblock'><table class='diff_summary'>"
    diff_summary.lines.each do |line|
      # determine if it generally adds or removes lines
      plusses = line.scan("+").size
      minuses = line.scan("-").size
      if plusses > minuses
        div_class = "added_code"
      elsif minuses > plusses
        div_class = "removed_code"
      else
        div_class = "unchanged_code"
      end
      # create the row
      disp_text += "<tr>"
      # depending on whether there is a pipe, add two cells or 1 wide cell
      parts = line.split("|")
      if parts.length == 2
        disp_text += "<td><div class='#{div_class}'>#{parts[0]}</div></td><td><div class='#{div_class}'>#{parts[1]}</div></td>"
      else
        disp_text += "<td colspan='2'>#{parts[0]}</td>"
      end
      disp_text += "</tr>"
    end
    disp_text += "</table></div>"
    return disp_text.html_safe
  end

  def display_diff(diff_text)
    disp_text = ""
    started = false
    diff_text.each_line  do |line|
      if line.match("diff --git")
        if started
          disp_text += "</pre></div>"
        else
          started = true
        end
        disp_text += "<div class='codeblock'><pre>"
      end
      # if the line starts with whitespace
      line.gsub!(/\n/, "")
      if line.match(/^\s*-/) && !line.match(/---/)
        disp_text += "<div class='removed_code'>" + html_escape(line) + "</div>"
      elsif line.match(/^\s*\+/) && !line.match(/\+\+\+/)
        disp_text += "<div class='added_code'>" + html_escape(line) + "</div>"
      else
        disp_text += "<div class='unchanged_code'>" + html_escape(line) + "</div>"
      end
    end
    disp_text += "</pre></div>"
    return disp_text.html_safe
  end
end
