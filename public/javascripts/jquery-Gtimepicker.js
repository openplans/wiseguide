// original here: http://plugins.jquery.com/project/GTimePikr
// modified to
//  slide to 5 minute increments
//  no default value
//  when parsing value to indicate slider location, specify base 10, or else octal parse bug

(function ($) {
    $.fn.timePkr = function (i) {
        var j = {
            'ampm': true,
            'background-color': 'blue'
        };
        return this.each(function () {
            if (i) {
                $.extend(j, i)
            }
            if (!$('#timePkr').length) {
                var h = '<div class=\"ui-widget-content ui-widget \" style=\"display:none; width:247px; height:155px; z-index: 9999;\" id=\"timePkr\">' + '<input type=\"hidden\" id=\"timePkr_timeID\" />' + '<table width=\"230\">' + '<tr><td align=\"center\" colspan=\"2\" id=\"timePkr_tmpTime\"></td></tr>' + '<tr><td width=\"60px\">Hours </td><td><div id=\"timePkr_hrs\"></div></td></tr>' + '<tr><td width=\"60px;\">Mins  </td><td><div id=\"timePkr_mins\"></div></td></tr>' + '<tr><td align=\"center\" colspan=\"2\"><input type=\"radio\" checked=\"checked\" name=\"amPm\" value=\"AM\" /> AM &nbsp;' + '<input type=\"radio\" name=\"amPm\" value=\"PM\" /> PM</td></tr>' + '<tr><td></td><td align=\"right\" ><div id=\"timePkr_done\" style=\"color:#2779AA;  width:85px; height:30px; \" ></div></td></tr>' + '</table>' + '</div>';
                $('body').append(h);
                $('#timePkr_done').button({
                    label: 'Done'
                })
            }
            // if ( $(this).val() == "" ) $(this).val('08:00 AM');
            $("#timePkr_hrs").slider({
                value: 0,
                min: 1,
                max: 12,
                step: 1,
                slide: function (a, b) {
                    var c = $('#timePkr_timeID').val();
                    var d = '' + $('#' + c).val();
                    var e = '';
                    var f = b.value;
                    if (f < 10) e = '0' + b.value;
                    else e = '' + b.value;
                    e = e + d.substr(2);
                    $('#' + c).val(e);
                    $('#timePkr_tmpTime').html(e)
                }
            });
            $("#timePkr_mins").slider({
                min: 0,
                max: 55,
                step: 5,
                slide: function (a, b) {
                    var c = $('#timePkr_timeID').val();
                    var d = '' + $('#' + c).val();
                    var e = '';
                    var f = b.value;
                    if (f < 10) e = '0' + b.value;
                    else e = '' + b.value;
                    var g = '' + d.substr(0, 3) + e + d.substr(5, 3);
                    $('#' + c).val(g);
                    $('#timePkr_tmpTime').html(g)
                }
            });
            $(this).click(function () {
                $('#timePkr_timeID').val($(this).attr('id'));
                var a = $(this).offset();
                $('#timePkr_tmpTime').html($(this).val());
                var b = $(this).val();
                $("#timePkr_mins").slider("value", parseInt(b.substr(3, 2), 10));
                $("#timePkr_hrs").slider("value", parseInt(b.substr(0, 2), 10));
                $('input[value=\"' + b.substr(6, 2) + '\"]').attr('checked', 'checked');
                $('#timePkr').css({
                    position: 'absolute',
                    top: a.top - 4,
                    left: a.left,
                    padding: '2px',
                    opacity: 1.0
                }).appendTo("body").fadeIn(200)
            });
            $('input[name="amPm"]').change(function () {
                var a = $('#timePkr_timeID').val();
                var b = '' + $('#' + a).val();
                $('#' + a).val(b.substr(0, 6) + '' + $(this).val());
                $('#timePkr_tmpTime').html(b.substr(0, 6) + '' + $(this).val())
            });
            $('#timePkr_done').click(function () {
                $('#timePkr').hide()
            })
        })
    }
})(jQuery);