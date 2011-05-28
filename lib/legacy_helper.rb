def clean_address(addr)
  return addr if addr.blank?
  addr = addr.gsub(/\s+/,' ')
  addr = addr.strip
  addr = addr.gsub('.','')
  addr = addr.gsub(',','')
  addr = addr.gsub(/ nw /i,' NW ')
  addr = addr.gsub(/ sw /i,' SW ')
  addr = addr.gsub(/ se /i,' SE ')
  addr = addr.gsub(/ ne /i,' NE ')
  addr = addr.gsub(/ e /i,' E ')
  addr = addr.gsub(/ w /i,' W ')
  addr = addr.gsub(/ n /i,' N ')
  if addr == 'NWPP' || addr == '1430 SW Braodway'
    addr = '1430 SW Broadway' 
  end
  addr = addr + ("_" * (5 - addr.size)) if addr.size < 5
  addr
end

# Format in: 10/13/1998 14:30:00
def fix_up_date(x)
  if x.present?
    if x =~ / /
      d, ti = x.split(' ')
    else
      d = x
    end

    m, d, y = d.split('/').map{|i| if i.length == 1 then "0#{i}" else i end}
    #puts m, d, y
    if ti.nil? || ti == '0:00:00' 
      "#{y}-#{m}-#{d}"
    else
      "#{y}-#{m}-#{d} #{ti}"
    end
  else
    x
  end
end
