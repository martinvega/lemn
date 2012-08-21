jQuery ($)->
  $('input.calendar:not(.hasDatepicker)').live 'focus', ->
    if $(this).data('time')
      $(this).datetimepicker(showOn: 'both').focus()
    else if $(this).data('year')
      $(this).datepicker({showOn: 'both', changeYear: true, changeMonth: true, yearRange: "c-90:c"}).focus()
    else
      $(this).datepicker({showOn: 'both'}).focus()
