module ReviewsHelper
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
